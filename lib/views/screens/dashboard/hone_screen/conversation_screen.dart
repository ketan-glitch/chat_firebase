import 'dart:developer';

// import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_firebase/controllers/firebase_controller.dart';
import 'package:chat_firebase/services/extensions.dart';
import 'package:chat_firebase/views/screens/auth_screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controllers/chat_controller.dart';
import '../../../../data/models/response/message_chat.dart';
import '../../../../data/models/response/user_model.dart';
import '../../../../services/constants.dart';
import '../../../base/custom_bubble/bubble_special_one.dart';
import '../../../base/custom_image.dart';

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key, required this.peer});
  final UserModel peer;
  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  // final FocusNode focusNode = FocusNode();

  void readLocal() {
    // var auth = Get.find<AuthController>();
    var firebase = Get.find<FirebaseController>();
    var chat = Get.find<ChatController>();
    if (firebase.userData.uid.isValid) {
      chat.currentUserId = firebase.userData.uid!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }
    String peerId = widget.peer.uid!;
    if (chat.currentUserId.compareTo(peerId) > 0) {
      chat.groupChatId = '${chat.currentUserId}-$peerId';
    } else {
      chat.groupChatId = '$peerId-${chat.currentUserId}';
    }

    firebase.updateDataFirestore(
      FireStoreConstants.pathUserCollection,
      firebase.userData.number!,
      {FireStoreConstants.chattingWith: peerId},
    );
  }

  @override
  void initState() {
    super.initState();
    var chat = Get.find<ChatController>();
    chat.listScrollController.addListener(chat.scrollListener);
    readLocal();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff025c4c),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const CircleAvatar(
              backgroundImage: NetworkImage("https://randomuser.me/api/portraits/men/5.jpg"),
              maxRadius: 20,
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.peer.name}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 6 + 13,
                  ),
                  // const Text(
                  //   "Online",
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 13,
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height,
            width: size.width,
            color: const Color(0xFFece7e1),
            child: const CustomAssetImage(
              path: Assets.imagesBgChat,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: size.height,
            width: size.width,
            child: GetBuilder<ChatController>(builder: (chatController) {
              return StreamBuilder<QuerySnapshot>(
                  stream: chatController.getChatStream(chatController.groupChatId, chatController.limit),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    log("${snapshot.data?.docs.length}");
                    if (snapshot.hasData) {
                      chatController.listMessage = snapshot.data!.docs;
                      if (chatController.listMessage.isNotEmpty) {
                        return ListView.builder(
                          controller: chatController.listScrollController,
                          itemCount: snapshot.data?.docs.length,
                          padding: const EdgeInsets.only(top: 10, bottom: 70),
                          // physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            MessageChat messageChat = MessageChat.fromDocument(snapshot.data!.docs[index]);
                            bool isSender = messageChat.idFrom == chatController.currentUserId;
                            return ChatWidgetWithShadow(
                              messageChat: messageChat,
                              isSender: isSender,
                            );
                          },
                        );
                      } else {
                        return const Center(child: Text("No message here yet..."));
                      }
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }
                  });
            }),
          ),
          GetBuilder<ChatController>(
            builder: (chatController) {
              return Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  // height: 70,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xff025c4c),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.attachment,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: TextField(
                          controller: chatController.textEditingController,
                          maxLines: 6,
                          minLines: 1,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Write message...",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(45)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(45)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(45)),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          chatController.onSendMessage(chatController.textEditingController.text, TypeMessage.text, chatController, widget.peer.uid!);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xff025c4c),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class ChatWidgetWithShadow extends StatelessWidget {
  const ChatWidgetWithShadow({Key? key, required this.messageChat, required this.isSender}) : super(key: key);
  final MessageChat messageChat;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          top: 2,
          right: isSender ? 2 : null,
          left: isSender ? null : 2,
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade400],
              ).createShader(bounds);
            },
            child: BubbleSpecialOne(
              isSender: isSender,
              color: isSender ? const Color(0xFFdcf8c7) : Colors.white,
              textStyle: GoogleFonts.montserrat(
                fontSize: 14,
                // color: Colors.white,
              ),
              padding: const EdgeInsets.only(left: 14, right: 14, top: 3, bottom: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (messageChat.type == TypeMessage.image)
                    CustomImage(
                      path: 'path',
                      fit: BoxFit.cover,
                      height: size.height * .2,
                      width: size.width,
                    ),
                  if (messageChat.type == TypeMessage.image) const SizedBox(height: 10),
                  Text(
                    messageChat.content,
                    style: GoogleFonts.montserrat(
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        BubbleSpecialOne(
          isSender: isSender,
          color: isSender ? const Color(0xFFdcf8c7) : Colors.white,
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            // color: Colors.white,
          ),
          padding: const EdgeInsets.only(left: 14, right: 14, top: 3, bottom: 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (messageChat.type == TypeMessage.image)
                CustomImage(
                  path: 'path',
                  fit: BoxFit.cover,
                  height: size.height * .2,
                  width: size.width,
                ),
              if (messageChat.type == TypeMessage.image) const SizedBox(height: 10),
              Text(
                messageChat.content,
                style: GoogleFonts.montserrat(
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
