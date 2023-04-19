// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../components/constants/firestore_constants.dart';

class MessageData {
  final String idFrom;
  final String nameFrom;
  final String avatarFrom;
  final String idTo;
  final String nameTo;
  final String avatarTo;
  final String lastTimestamp;
  final String lastContent;
  final int typeContent;

  const MessageData({
    required this.idFrom,
    required this.nameFrom,
    required this.avatarFrom,
    required this.idTo,
    required this.nameTo,
    required this.avatarTo,
    required this.lastTimestamp,
    required this.lastContent,
    required this.typeContent,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.nameFrom: nameFrom,
      FirestoreConstants.avatarFrom: avatarFrom,
      FirestoreConstants.idTo: idTo,
      FirestoreConstants.nameTo: nameTo,
      FirestoreConstants.avatarTo: avatarTo,
      FirestoreConstants.lastTimestamp: lastTimestamp,
      FirestoreConstants.lastContent: lastContent,
      FirestoreConstants.typeContent: typeContent,
    };
  }

  factory MessageData.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FirestoreConstants.idFrom);
    String nameFrom = doc.get(FirestoreConstants.nameFrom);
    String avatarFrom = doc.get(FirestoreConstants.avatarFrom);
    String idTo = doc.get(FirestoreConstants.idTo);
    String nameTo = doc.get(FirestoreConstants.nameTo);
    String avatarTo = doc.get(FirestoreConstants.avatarTo);
    String lastTimestamp = doc.get(FirestoreConstants.lastTimestamp);
    String lastContent = doc.get(FirestoreConstants.lastContent);
    int typeContent = doc.get(FirestoreConstants.typeContent);
    return MessageData(
        idFrom: idFrom,
        nameFrom: nameFrom,
        avatarFrom: avatarFrom,
        idTo: idTo,
        nameTo: nameTo,
        avatarTo: avatarTo,
        lastTimestamp: lastTimestamp,
        lastContent: lastContent,
        typeContent: typeContent);
  }
}

class MessageChat {
  final String idFrom;
  final String timestamp;
  final String content;
  final int type;

  const MessageChat({
    required this.idFrom,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: this.idFrom,
      FirestoreConstants.timestamp: this.timestamp,
      FirestoreConstants.content: this.content,
      FirestoreConstants.type: this.type,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FirestoreConstants.idFrom);
    String timestamp = doc.get(FirestoreConstants.timestamp);
    String content = doc.get(FirestoreConstants.content);
    int type = doc.get(FirestoreConstants.type);
    return MessageChat(
        idFrom: idFrom, timestamp: timestamp, content: content, type: type);
  }
}


// class MessageChat {
//   final String idFrom;
//   final String idTo;
//   final String timestamp;
//   final String content;
//   final int type;

//   const MessageChat({
//     required this.idFrom,
//     required this.idTo,
//     required this.timestamp,
//     required this.content,
//     required this.type,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       FirestoreConstants.idFrom: this.idFrom,
//       FirestoreConstants.idTo: this.idTo,
//       FirestoreConstants.timestamp: this.timestamp,
//       FirestoreConstants.content: this.content,
//       FirestoreConstants.type: this.type,
//     };
//   }

//   factory MessageChat.fromDocument(DocumentSnapshot doc) {
//     String idFrom = doc.get(FirestoreConstants.idFrom);
//     String idTo = doc.get(FirestoreConstants.idTo);
//     String timestamp = doc.get(FirestoreConstants.timestamp);
//     String content = doc.get(FirestoreConstants.content);
//     int type = doc.get(FirestoreConstants.type);
//     return MessageChat(idFrom: idFrom, idTo: idTo, timestamp: timestamp, content: content, type: type);
//   }
// }
