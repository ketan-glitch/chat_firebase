import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../services/constants.dart';

class MessageChat {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  int type;

  MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      FireStoreConstants.idFrom: idFrom,
      FireStoreConstants.idTo: idTo,
      FireStoreConstants.timestamp: timestamp,
      FireStoreConstants.content: content,
      FireStoreConstants.type: type,
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get(FireStoreConstants.idFrom);
    String idTo = doc.get(FireStoreConstants.idTo);
    String timestamp = doc.get(FireStoreConstants.timestamp);
    String content = doc.get(FireStoreConstants.content);
    int type = doc.get(FireStoreConstants.type);
    return MessageChat(idFrom: idFrom, idTo: idTo, timestamp: timestamp, content: content, type: type);
  }
}
