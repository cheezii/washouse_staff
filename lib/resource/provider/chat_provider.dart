import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/constants/firestore_constants.dart';
import '../model/chat_message.dart';
import '../model/chat_user.dart';

class ChatProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  ChatProvider(
      {required this.firebaseFirestore,
      required this.prefs,
      required this.firebaseStorage});

  String? getPref(String key) {
    return prefs.getString(key);
  }

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateDataFirestore(
      String docPath, Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  // Stream<QuerySnapshot> getStreamFireStore(String pathCollection, int limit,
  //     String? textSearch, String currrentUserId) {
  //   if (textSearch?.isNotEmpty == true) {
  //     return firebaseFirestore
  //         .collection(pathCollection)
  //         .doc(currrentUserId)
  //         .collection(currrentUserId)
  //         .limit(limit)
  //         .where(FirestoreConstants.name, isEqualTo: textSearch!)
  //         .snapshots();
  //   } else {
  //     return firebaseFirestore
  //         .collection(pathCollection)
  //         .doc(currrentUserId)
  //         .collection(currrentUserId)
  //         .limit(limit)
  //         .snapshots();
  //   }
  // }

  Stream<QuerySnapshot> getStreamFireStore(
      String? textSearch, String currentId) {
    if (textSearch?.isNotEmpty == true) {
      return firebaseFirestore
          .collection(FirestoreConstants.pathMessageCollection)
          .where(FirestoreConstants.idFrom, isEqualTo: currentId)
          .where(FirestoreConstants.nameTo, arrayContains: textSearch)
          .snapshots();
    } else {
      return firebaseFirestore
          .collection(FirestoreConstants.pathMessageCollection)
          .where(FirestoreConstants.idFrom, isEqualTo: currentId)
          .snapshots();
    }
  }

  Stream<QuerySnapshot> getListStream(String currentId) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        //.where(FirestoreConstants.idFrom, isEqualTo: currentId)
        .where(FirestoreConstants.idTo, isEqualTo: currentId)
        .snapshots();
  }
  // Future getListStream(String currentId) async {
  //   var result = await FirebaseFirestore.instance
  //       .collection(FirestoreConstants.pathMessageCollection)
  //       .withConverter(
  //           fromFirestore: ((snapshot, _) =>
  //               MessageData.fromDocument(snapshot)),
  //           toFirestore: (MessageData msg, options) => msg.toJson())
  //       .where(FirestoreConstants.idFrom, isEqualTo: currentId)
  //       .where(FirestoreConstants.idTo, isEqualTo: currentId)
  //       .get();
  //   return result;
  //}

  Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection('msglist')
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection('msglist')
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }

  // void sendMessage(String content, int type, String groupChatId,
  //     String currentUserId, String peerId) {
  //   DocumentReference documentReference = firebaseFirestore
  //       .collection(FirestoreConstants.pathMessageCollection)
  //       .doc(groupChatId)
  //       .collection(groupChatId)
  //       .doc(DateTime.now().millisecondsSinceEpoch.toString());

  //   MessageChat messageChat = MessageChat(
  //     idFrom: currentUserId,
  //     idTo: peerId,
  //     timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
  //     content: content,
  //     type: type,
  //   );

  //   FirebaseFirestore.instance.runTransaction((transaction) async {
  //     transaction.set(
  //       documentReference,
  //       messageChat.toJson(),
  //     );
  //   });
  // }

  // void createChatList(String currrentUserId, String peerId, String name,
  //     String photoUrl, String recentMessage, String timestamp, int type) {
  //   DocumentReference documentReference = firebaseFirestore
  //       .collection(FirestoreConstants.pathListChatCollection)
  //       .doc(currrentUserId)
  //       .collection(currrentUserId)
  //       .doc(peerId);

  //   ChatUser chatUser = ChatUser(
  //     id: peerId,
  //     name: name,
  //     recentMessage: recentMessage,
  //     timestamp: timestamp,
  //     photoUrl: photoUrl,
  //     type: type,
  //   );

  //   FirebaseFirestore.instance.runTransaction((transaction) async {
  //     transaction.set(
  //       documentReference,
  //       chatUser.toJson(),
  //     );
  //   });
  // }

  void createChatList(
      String groupId,
      String currentId,
      String peerId,
      String name,
      String photoUrl,
      String recentMessage,
      String timestamp,
      int type) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathListChatCollection)
        .doc(groupId)
        .collection(groupId)
        .doc(currentId);

    // ChatUser chatUser = ChatUser(
    //   peerId: peerId,
    //   name: name,
    //   recentMessage: recentMessage,
    //   timestamp: timestamp,
    //   photoUrl: photoUrl,
    //   type: type,
    // );

    GroupChat groupChat = GroupChat(
      currentId: currentId,
      peerId: peerId,
      name: name,
      recentMessage: recentMessage,
      timestamp: timestamp,
      photoUrl: photoUrl,
      type: type,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        groupChat.toJson(),
      );
    });
  }
}

class TypeMessage {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
