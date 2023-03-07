import 'package:chat_firebase/controllers/firebase_controller.dart';
import 'package:chat_firebase/data/models/response/user_model.dart';
import 'package:chat_firebase/services/extensions.dart';
import 'package:chat_firebase/views/base/custom_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import '../../../../services/constants.dart';
import 'conversation_screen.dart';

class ChatsTab extends StatefulWidget {
  const ChatsTab({Key? key}) : super(key: key);

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  int _limit = 20;
  int _limitIncrement = 20;
  String _textSearch = "";
  final ScrollController listScrollController = ScrollController();

  void scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent && !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: Get.find<FirebaseController>().getStreamFireStore(FireStoreConstants.pathUserCollection, _limit),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                padding: const EdgeInsets.all(10.0),
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = snapshot.data?.docs[index].data()! as Map<String, dynamic>;
                  UserModel userModel = UserModel.fromJson(data);
                  return SingleChatWidget(
                    peer: userModel,
                  );
                },
              );
            }),
      ),
    );
  }
}

class SingleChatWidget extends StatelessWidget {
  final UserModel peer;

  const SingleChatWidget({Key? key, required this.peer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? chatMessage = peer.status ?? "Available";
    String? chatTitle = peer.name ?? "Unknown User";
    Color? seenStatusColor = Colors.blue;
    String? imageUrl = peer.profilePhoto;
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return ChatDetailPage(
            peers: [peer],
          );
        }));
      },
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(45)),
            child: Builder(builder: (context) {
              if (imageUrl.isValid) {
                return CustomImage(
                  path: imageUrl!,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                );
              }
              return const CustomAssetImage(
                path: Assets.imagesUserPlaceholder,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
              );
            }),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                chatTitle,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Row(children: [
                Icon(
                  seenStatusColor == Colors.blue ? Icons.done_all : Icons.done,
                  size: 15,
                  color: seenStatusColor,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(
                      chatMessage,
                      style: const TextStyle(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
