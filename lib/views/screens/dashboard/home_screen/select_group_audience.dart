import 'dart:developer';

import 'package:chat_firebase/controllers/chat_controller.dart';
import 'package:chat_firebase/services/extensions.dart';
import 'package:chat_firebase/services/route_helper.dart';
import 'package:chat_firebase/views/base/animation/scale_animation.dart';
import 'package:chat_firebase/views/base/custom_appbar.dart';
import 'package:chat_firebase/views/screens/dashboard/home_screen/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';

import '../../../../controllers/firebase_controller.dart';
import '../../../../data/models/response/user_model.dart';
import '../../../../services/constants.dart';
import '../../../base/custom_image.dart';

class SelectGroupAudience extends StatefulWidget {
  const SelectGroupAudience({Key? key}) : super(key: key);

  @override
  State<SelectGroupAudience> createState() => _SelectGroupAudienceState();
}

class _SelectGroupAudienceState extends State<SelectGroupAudience> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Get.find<ChatController>().usersToCreateGroup.clear();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBar(
        title: "New Group",
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (Get.find<ChatController>().usersToCreateGroup.length > 1) {
            Navigator.push(context, getCustomRoute(child: const CreateGroup()));
          } else {
            Fluttertoast.showToast(msg: "Please select at least 2 people");
          }
        },
        child: const Icon(Icons.arrow_forward),
      ),
      body: Column(
        children: [
          GetBuilder<ChatController>(
              id: ChatController.selectUser,
              builder: (chatController) {
                if (chatController.usersToCreateGroup.isEmpty) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    SizedBox(
                      width: size.width,
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: chatController.usersToCreateGroup.length,
                        itemBuilder: (context, int index) {
                          UserModel userModel = chatController.usersToCreateGroup[index];
                          return GestureDetector(
                            onTap: () {
                              chatController.toggleUser(userModel);
                            },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                                  child: CircleAvatar(
                                    radius: 25,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(45)),
                                          child: Builder(builder: (context) {
                                            if (userModel.profilePhoto.isValid) {
                                              return CustomImage(
                                                path: userModel.profilePhoto!,
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
                                        if (chatController.isSelected(userModel))
                                          Positioned(
                                            bottom: -10,
                                            right: -10,
                                            child: CustomScaleAnimation(
                                              duration: const Duration(milliseconds: 200),
                                              child: Card(
                                                color: Colors.grey.shade700,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(2.0),
                                                  child: Icon(
                                                    Icons.clear,
                                                    size: 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                Text(
                                  (userModel.name ?? 'Unknown User').getFirst,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(indent: 30, endIndent: 30, thickness: .2),
                  ],
                );
              }),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: Get.find<FirebaseController>().getStreamFireStore(FireStoreConstants.pathUserCollection, 100),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, int index) {
                      Map<String, dynamic> data = snapshot.data?.docs[index].data()! as Map<String, dynamic>;
                      log("${data}");
                      UserModel userModel = UserModel.fromJson(data);
                      if (userModel.number == Get.find<FirebaseController>().userData.number) {
                        return const SizedBox.shrink();
                      }
                      return GroupCreateSelectableTile(userModel: userModel);
                    },
                  );
                }),
          )
        ],
      ),
    );
  }
}

class GroupCreateSelectableTile extends StatelessWidget {
  const GroupCreateSelectableTile({Key? key, required this.userModel}) : super(key: key);
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    String? chatMessage = userModel.status ?? "Available";
    String? chatTitle = userModel.name ?? "Unknown User";
    String? imageUrl = userModel.profilePhoto;
    return GetBuilder<ChatController>(
        id: ChatController.selectUser,
        builder: (chatController) {
          return GestureDetector(
            onTap: () {
              chatController.toggleUser(userModel);
            },
            child: Row(
              children: [
                Stack(
                  clipBehavior: Clip.none,
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
                    if (chatController.isSelected(userModel))
                      Positioned(
                        bottom: -10,
                        right: -10,
                        child: CustomScaleAnimation(
                          duration: const Duration(milliseconds: 200),
                          child: Card(
                            color: context.primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                            child: const Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      chatTitle,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(left: 6.0),
                      child: Text(
                        chatMessage,
                        style: const TextStyle(overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
