import 'dart:developer';

import 'package:chat_firebase/controllers/firebase_controller.dart';
import 'package:chat_firebase/data/models/response/user_model.dart';
import 'package:chat_firebase/services/extensions.dart';
import 'package:chat_firebase/services/get_animated_dialog.dart';
import 'package:chat_firebase/services/route_helper.dart';
import 'package:chat_firebase/views/base/custom_image.dart';
import 'package:chat_firebase/views/base/image_gallery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/chat_controller.dart';
import '../../../../services/constants.dart';
import '../../../../services/enums/dialog_transition.dart';
import '../home_screen/conversation_screen.dart';

class GroupChatsTab extends StatefulWidget {
  const GroupChatsTab({Key? key}) : super(key: key);

  @override
  State<GroupChatsTab> createState() => _GroupChatsTabState();
}

class _GroupChatsTabState extends State<GroupChatsTab> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: Get.find<FirebaseController>().getMyChats(FireStoreConstants.pathMessageCollection, _limit, _textSearch),
            builder: (context, snapshot) {
              log("${snapshot.data?.docs}");

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              var chats = snapshot.data?.docs;
              if (chats != null) {
                chats.sort(
                    (b, a) => ((a.data() as Map<String, dynamic>)['updated_at'] as int).compareTo(((b.data() as Map<String, dynamic>)['updated_at'] as int)));
                return ListView.builder(
                  itemCount: chats.length,
                  padding: const EdgeInsets.all(10.0),
                  itemBuilder: (context, index) {
                    Map<String, dynamic> data = chats[index].data()! as Map<String, dynamic>;
                    // log("${data}");
                    // log("${data['participants']}");
                    List<UserModel> peers = [];
                    for (Map<String, dynamic> element in (data['participants'] as List<dynamic>)) {
                      // log("${element['name']} ${element['phone_number']}");
                      if (element['phone_number'] != Get.find<FirebaseController>().userData.number) {
                        UserModel userModel = UserModel.fromJson(element);
                        peers.add(userModel);
                      }
                    }
                    Map<String, dynamic> groupData = {};
                    if (data['chat_type'] == 'group') {
                      groupData.addAll({
                        'chat_type': 'group',
                        'group_name': data['group_name'],
                        'group_id': data['group_id'],
                      });
                    } else {
                      groupData = {
                        'chat_type': 'single',
                      };
                    }
                    return SingleChatWidget(peers: peers, updatedAt: data['updated_at'], groupData: groupData);
                  },
                );
              }
              return const SizedBox.shrink();
            }),
      ),
    );
  }
}

class SingleChatWidget extends StatelessWidget {
  final List<UserModel> peers;
  final Map<String, dynamic> groupData;
  final dynamic updatedAt;

  const SingleChatWidget({Key? key, required this.peers, this.updatedAt, required this.groupData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // log('${groupData}');
    String? chatMessage;
    String? chatTitle;
    String? imageUrl;
    if (groupData['chat_type'] == 'group') {
      chatMessage = groupData['group_name'] ?? "Available";
      chatTitle = groupData['group_name'] ?? "Unknown Group";
      // imageUrl = 'peer.profilePhoto';
    } else {
      chatMessage = peers.first.status ?? "Available";
      chatTitle = peers.first.name ?? "Unknown User";
      imageUrl = peers.first.profilePhoto;
    }

    Color? seenStatusColor = Colors.blue;
    // log('$updatedAt');
    return GestureDetector(
      onTap: () {
        log('HRER');
        if (groupData['chat_type'] == 'group') {
          Get.find<ChatController>().groupChatId = groupData['group_id'];
        }
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailPage(peers: peers, groupName: groupData['group_name'])));
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                if (groupData['chat_type'] != 'group') {
                  ShowDialog().getAnimatedDialog(
                    context: context,
                    child: Dialog(
                      child: GestureDetector(
                        onTap: () {
                          if (imageUrl.isValid) {
                            Navigator.push(context, getCustomRoute(child: ImageGallery(images: [imageUrl!])));
                          }
                        },
                        child: CustomImage(
                          height: size.width * .8,
                          width: size.width * .8,
                          path: imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    transitionType: DialogTransition.center,
                  );
                }
                // showDialog(
                //   context: context,
                //   builder: (context) {
                //     return Dialog(
                //       child: CustomImage(
                //         height: size.width * .8,
                //         width: size.width * .8,
                //         path: imageUrl!,
                //         fit: BoxFit.cover,
                //       ),
                //     );
                //   },
                // );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(45)),
                child: Builder(builder: (context) {
                  if (groupData['chat_type'] == 'group') {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                      ),
                      child: Center(
                        child: Text(
                          chatTitle.getIfValid.capitalize.initials,
                          style: const TextStyle(
                            fontSize: 12.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                    //   var images = <String>[];
                    //   for (var element in peers) {
                    //     if (element.profilePhoto.isValid) {
                    //       images.add(element.profilePhoto!);
                    //     }
                    //   }
                    //   return GroupProfilePictureWidget(
                    //     images: images,
                    //   );
                  }
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
            ),
            Expanded(
              child: ListTile(
                title: Text(
                  chatTitle.getIfValid,
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
                        chatMessage.getIfValid,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ]),
                trailing: Column(
                  children: [
                    if (updatedAt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(DateTime.fromMillisecondsSinceEpoch(updatedAt).getTimeIfTodayV2),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
