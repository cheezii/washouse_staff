// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/constants/firestore_constants.dart';
class GroupChat {
  String currentId;
  String peerId;
  String name;
  String recentMessage;
  String timestamp;
  String photoUrl;
  int type;
  GroupChat({
    required this.currentId,
    required this.peerId,
    required this.name,
    required this.recentMessage,
    required this.timestamp,
    required this.photoUrl,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.currentId: currentId,
      FirestoreConstants.peerId: peerId,
      FirestoreConstants.name: name,
      FirestoreConstants.photoUrl: photoUrl,
      FirestoreConstants.recentMessage: recentMessage,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.type: type,
    };
  }

  factory GroupChat.fromDocument(DocumentSnapshot doc) {
    String recentMessage = "";
    String timestamp= "";
    String photoUrl = "";
    String name = "";
    String currentId = "";
    int? type;
    // try {
    //   message = doc.get(FirestoreConstants.message);
    // } catch (e) {}
    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    try {
      name = doc.get(FirestoreConstants.name);
    } catch (e) {}
    try {
      recentMessage = doc.get(FirestoreConstants.recentMessage);
    } catch (e) {}
    try {
      timestamp = doc.get(FirestoreConstants.timestamp);
    } catch (e) {}
    try {
      type = doc.get(FirestoreConstants.type);
    } catch (e) {}
    return GroupChat(
      currentId: currentId,
      peerId: doc.id,
      photoUrl: photoUrl,
      name: name,
      recentMessage: recentMessage,
      timestamp: timestamp,
      type: type!
    );
  }

  // ChatUser chatUser;
  // GroupChat({
  //   required this.currentId,
  //   required this.chatUser,
  // });

  // factory GroupChat.fromDocument(DocumentSnapshot doc) => GroupChat(
  //       currentId: doc.id,
  //       chatUser: ChatUser.fromDocument(doc),
  //   );

  //   Map<String, dynamic> toJson() => {
  //       "currentId": currentId,
  //       "chatUser": chatUser.toJson(),
  //   };
}
class ChatUser {
  String peerId;
  String name;
  String recentMessage;
  String timestamp;
  String photoUrl;
  int type;
  ChatUser({
    required this.peerId,
    required this.name,
    required this.recentMessage,
    required this.timestamp,
    required this.photoUrl,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.peerId: peerId,
      FirestoreConstants.name: name,
      FirestoreConstants.photoUrl: photoUrl,
      FirestoreConstants.recentMessage: recentMessage,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.type: type,
    };
  }

  factory ChatUser.fromDocument(DocumentSnapshot doc) {
    String recentMessage = "";
    String timestamp= "";
    String photoUrl = "";
    String name = "";
    int? type;
    // try {
    //   message = doc.get(FirestoreConstants.message);
    // } catch (e) {}
    try {
      photoUrl = doc.get(FirestoreConstants.photoUrl);
    } catch (e) {}
    try {
      name = doc.get(FirestoreConstants.name);
    } catch (e) {}
    try {
      recentMessage = doc.get(FirestoreConstants.recentMessage);
    } catch (e) {}
    try {
      timestamp = doc.get(FirestoreConstants.timestamp);
    } catch (e) {}
    try {
      type = doc.get(FirestoreConstants.type);
    } catch (e) {}
    return ChatUser(
      peerId: doc.id,
      photoUrl: photoUrl,
      name: name,
      recentMessage: recentMessage,
      timestamp: timestamp,
      type: type!
    );
  }
}
