import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';

import '../data/models/response/message_chat.dart';
import '../services/constants.dart';

class ChatController extends GetxController implements GetxService {
  List<QueryDocumentSnapshot> listMessage = [];
  late String currentUserId;
  String groupChatId = "";
  int limit = 100;
  int _limitIncrement = 20;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  scrollListener() {
    if (!listScrollController.hasClients) return;
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        limit <= listMessage.length) {
      limit += _limitIncrement;
      update();
    }
  }

  Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
    return FirebaseFirestore.instance
        .collection(FireStoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FireStoreConstants.timestamp, descending: false)
        .limit(limit)
        .snapshots();
  }

  void onSendMessage(String content, int type, ChatController chatController, peerId) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatController.sendMessage(content, type, groupChatId, currentUserId, peerId);
      if (listScrollController.hasClients) {
        listScrollController.animateTo(listScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  void sendMessage(String content, int type, String groupChatId, String currentUserId, String peerId) {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(FireStoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      idTo: peerId,
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
}
