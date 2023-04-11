import 'dart:developer';

import 'package:chat_firebase/services/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../controllers/chat_controller.dart';
import '../../../../controllers/firebase_controller.dart';
import '../../../../services/constants.dart';
import '../../../../services/enums/dialog_transition.dart';
import '../../../../services/get_animated_dialog.dart';
import '../../../../services/route_helper.dart';
import '../../../base/custom_image.dart';
import '../../../base/image_gallery.dart';
import '../../../base/image_picker_sheet.dart';
import '../../auth_screens/signup_screen.dart';

class UpdateGroupDetailsDialog extends StatelessWidget {
  const UpdateGroupDetailsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(FireStoreConstants.pathMessageCollection)
              .where('group_id', isEqualTo: Get.find<ChatController>().groupChatId)
              // .doc(Get.find<ChatController>().groupChatId)
              // .collection(Get.find<ChatController>().groupChatId)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // log(jsonEncode(snapshot.data!.docs.first.data() as Map));
            if (snapshot.hasError || !snapshot.hasData) {
              return Container();
            }
            Map<String, dynamic> groupDate = snapshot.data!.docs.first.data() as Map<String, dynamic>;
            var group = GroupModel.fromJson(groupDate);
            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Update Group Details',
                    style: GoogleFonts.montserrat(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          ShowDialog().getAnimatedDialog(
                            context: context,
                            child: Dialog(
                              child: GestureDetector(
                                onTap: () {
                                  if (group.image.isValid) {
                                    Navigator.push(context, getCustomRoute(child: ImageGallery(images: [group.image!])));
                                  }
                                },
                                child: CustomImage(
                                  height: size.width * .8,
                                  width: size.width * .8,
                                  path: group.image.getIfValid,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            transitionType: DialogTransition.center,
                          );
                        },
                        child: CircleAvatar(
                          radius: size.width * .2,
                          backgroundColor: Colors.white,
                          child: Builder(builder: (context) {
                            if (group.image.isValid) {
                              return CustomImage(path: group.image!);
                            }
                            return const CustomAssetImage(
                              path: Assets.imagesUserPlaceholder,
                            );
                          }),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          minWidth: 50,
                          padding: EdgeInsets.zero,
                          onPressed: () async {
                            var file = await getImageBottomSheet(context);
                            if (file != null) {
                              Get.find<FirebaseController>().avatarImageFile = file;
                              Get.find<FirebaseController>().uploadFile(ImageUploadType.groupImage);
                            }
                          },
                          color: context.secondaryColor,
                          shape: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Icon(
                          Icons.person,
                          color: Color(0XFF8395a0),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name",
                                      style: context.textTheme.bodySmall!.copyWith(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      group.name.getIfValid.capitalizeFirstOfEach,
                                      style: context.textTheme.bodySmall!.copyWith(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                                      ),
                                      builder: (context) => UpdateNameSheet(name: group.name),
                                    ).then((value) {
                                      log("$value");
                                      if (value is String) {
                                        log(value);
                                        Get.find<FirebaseController>().updateGroupUserName(name: value, groupId: Get.find<ChatController>().groupChatId);
                                      }
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color(0xFF00736a),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              "This is your Group Name. This name will be visible to your group members.",
                              style: context.textTheme.bodySmall!.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Divider(
                              thickness: .2,
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class GroupModel {
  String? name;
  String? image;
  GroupModel({this.name, this.image});
  GroupModel.fromJson(Map<String, dynamic> json) {
    name = json['group_name'];
    image = json['group_image'];
  }
  Map<String, Object?> toJson() {
    Map<String, dynamic> data = {};
    data.addAll({'group_name': name});
    data.addAll({'group_image': image});
    return data;
  }
}
