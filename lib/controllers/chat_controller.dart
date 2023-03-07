import 'dart:developer';

import 'package:chat_firebase/controllers/firebase_controller.dart';
import 'package:chat_firebase/services/date_formatters_and_converters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';

import '../data/models/response/message_chat.dart';
import '../data/models/response/user_model.dart';
import '../services/constants.dart';

class ChatController extends GetxController implements GetxService {
  List<QueryDocumentSnapshot> listMessage = [];
  late String currentUserId;
  String groupChatId = "";
  int limit = 100;
  int _limitIncrement = 20;

  List<UserModel> usersToCreateGroup = [];
  static const String selectUser = 'select_user';
  toggleUser(UserModel userModel) {
    if (usersToCreateGroup.where((element) => element.uid == userModel.uid).isNotEmpty) {
      usersToCreateGroup.removeWhere((element) => element.uid == userModel.uid);
    } else {
      usersToCreateGroup.add(userModel);
    }
    update([selectUser]);
    log("${usersToCreateGroup}");
  }

  bool isSelected(UserModel userModel) {
    return usersToCreateGroup.where((element) => element.uid == userModel.uid).isNotEmpty;
  }

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
    // updateUserDataInChat();
    return FirebaseFirestore.instance
        .collection(FireStoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        // .orderBy(FireStoreConstants.timestamp, descending: false)
        // .limit(limit)
        .snapshots();
  }

  void onSendMessage({required String content, required int type, required List<UserModel> peer}) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      sendMessage(content, type, groupChatId, currentUserId, peer);
      if (listScrollController.hasClients) {
        listScrollController.animateTo(listScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  Future updateUserDataInChat(List<UserModel> peer, {String? groupChatId}) async {
    try {
      // log("${'documentReference'}", name: "updateUserDataInChat");
      DocumentReference documentReference =
          FirebaseFirestore.instance.collection(FireStoreConstants.pathMessageCollection).doc(groupChatId ?? this.groupChatId);

      // log("${documentReference}", name: "updateUserDataInChat");
      Map<String, dynamic>? data;
      await documentReference.get().then((value) async {
        data = value.data() as Map<String, dynamic>?;
        if (data != null) {
          if (data!.containsKey('participants')) {
            for (int i = 0; i < (data!['participants'] as List).length; i++) {
              var element = (data!['participants'] as List)[i];
              if (element['number'] == Get.find<FirebaseController>().userData.number) {
                (data!['participants'] as List)[i] = Get.find<FirebaseController>().userData.toJson();
              }
            }
          } else {
            data!.addAll({
              "participants": [Get.find<FirebaseController>().userData.toJson(), ...peer.map((e) => e.toJson()).toList()],
              "users": [Get.find<FirebaseController>().userData.number, ...peer.map((e) => e.number).toList()],
            });
          }
          if (data!.containsKey('updated_at')) {
            data!['updated_at'] = getDateTime().millisecondsSinceEpoch;
          } else {
            data!.addAll({'updated_at': getDateTime().millisecondsSinceEpoch});
          }
          if (data != null) {
            await FirebaseFirestore.instance.runTransaction((transaction) async {
              transaction.update(
                documentReference,
                data!,
              );
            });
          }
        } else {
          data = {
            "participants": [Get.find<FirebaseController>().userData.toJson(), ...peer.map((e) => e.toJson()).toList()],
            "users": [Get.find<FirebaseController>().userData.number, ...peer.map((e) => e.number).toList()],
            'updated_at': getDateTime().millisecondsSinceEpoch
          };
          if (data != null) {
            await FirebaseFirestore.instance.runTransaction((transaction) async {
              transaction.set(
                documentReference,
                data!,
              );
            });
          }
        }
        log("${data}", name: "updateUserDataInChat");
      });
    } catch (error) {
      log("$error");
    }
  }

  void sendMessage(String content, int type, String groupChatId, String currentUserId, List<UserModel> peer) {
    updateUserDataInChat(peer);
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(FireStoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    // updateUserDataInChat();
    var reference = FirebaseFirestore.instance.collection(FireStoreConstants.pathUserCollection).doc(FirebaseAuth.instance.currentUser!.phoneNumber);
    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      from: Get.find<FirebaseController>().userData.number,
      idTo: groupChatId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    var message = messageChat.toJson();

    message[FireStoreConstants.from] = reference;

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        message,
      );
    });
  }
}
