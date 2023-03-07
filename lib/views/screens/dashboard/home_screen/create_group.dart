import 'dart:developer';

import 'package:chat_firebase/controllers/firebase_controller.dart';
import 'package:chat_firebase/services/extensions.dart';
import 'package:chat_firebase/views/base/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';

import '../../../../controllers/chat_controller.dart';
import '../../../../data/models/response/user_model.dart';
import '../../../../services/input_decoration.dart';
import '../../../base/animation/scale_animation.dart';
import '../../../base/custom_image.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  TextEditingController _groupName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBar(
        title: "New Group",
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_groupName.text.isValid) {
            String id = '';

            Get.find<ChatController>().usersToCreateGroup.add(Get.find<FirebaseController>().userData);
            id = Get.find<ChatController>()
                .usersToCreateGroup
                .map((e) => e.number)
                .toList()
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '')
                .replaceAll(' ', '')
                .replaceAll(',', '-');
            log(id);
            Get.find<FirebaseController>().createGroup(_groupName.text, id);
            Navigator.pop(context);
            Navigator.pop(context);
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return ChatDetailPage(peer: peer);
            // }));
          } else {
            Fluttertoast.showToast(msg: "Please enter a valid name");
          }
        },
        child: const Icon(Icons.check),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade400,
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _groupName,
                    decoration: CustomDecoration.inputDecoration(
                      label: "Type group subject here",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Participants: 1"),
            GetBuilder<ChatController>(
                id: ChatController.selectUser,
                builder: (chatController) {
                  return SizedBox(
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
                  );
                }),
          ],
        ),
      ),
    );
  }
}
