import 'dart:async';
import 'dart:developer';

import 'package:chat_firebase/controllers/firebase_controller.dart';
import 'package:chat_firebase/services/extensions.dart';
import 'package:chat_firebase/services/input_decoration.dart';
import 'package:chat_firebase/services/route_helper.dart';
import 'package:chat_firebase/views/base/common_button.dart';
import 'package:chat_firebase/views/base/custom_appbar.dart';
import 'package:chat_firebase/views/base/custom_image.dart';
import 'package:chat_firebase/views/screens/dashboard/dashboard_screen.dart';
import 'package:chat_firebase/views/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/state_manager.dart';

import '../../../services/constants.dart';
import '../../base/image_picker_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    Timer.run(() async {
      await Get.find<FirebaseController>().getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        fontColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                Get.find<FirebaseController>().firebaseAuth.signOut();
                Navigator.pushAndRemoveUntil(context, getCustomRoute(child: const SplashScreen()), (route) => false);
              },
              icon: const Icon(Icons.logout)),
        ],
      ),
      body: GetBuilder<FirebaseController>(builder: (firebaseController) {
        return SizedBox(
          width: size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Stack(
                  children: [
                    CircleAvatar(
                      radius: size.width * .2,
                      backgroundColor: Colors.white,
                      child: Builder(builder: (context) {
                        if (firebaseController.userData.profilePhoto.isValid) {
                          return CustomImage(path: firebaseController.userData.profilePhoto!);
                        }
                        return const CustomAssetImage(
                          path: Assets.imagesUserPlaceholder,
                        );
                      }),
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
                            firebaseController.avatarImageFile = file;
                            firebaseController.uploadFile(ImageUploadType.profile);
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
                                    (firebaseController.userData.name ?? 'Your Name').capitalizeFirstOfEach,
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
                                    builder: (context) => const UpdateNameSheet(),
                                  ).then((value) {
                                    log("$value");
                                    if (value is String) {
                                      log(value);
                                      firebaseController.updateUserName(name: value);
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
                            "This is not your username or pin. This name will be visible to your contacts.",
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Icon(
                        Icons.info_outline,
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "About",
                                    style: context.textTheme.bodySmall!.copyWith(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    firebaseController.userData.status ?? "Available",
                                    style: context.textTheme.bodySmall!.copyWith(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w400,
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
                                    builder: (context) => const UpdateStatusSheet(),
                                  ).then((value) {
                                    log("$value");
                                    if (value is String) {
                                      log(value);
                                      firebaseController.updateUserStatus(status: value);
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
                          const Divider(
                            thickness: .2,
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: Icon(
                        Icons.phone,
                        color: Color(0XFF8395a0),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phone",
                            style: context.textTheme.bodySmall!.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            firebaseController.userData.number.getIfValid,
                            style: context.textTheme.bodySmall!.copyWith(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (!Navigator.canPop(context))
                  CustomButton(
                    type: ButtonType.primary,
                    onTap: () {
                      Navigator.pushReplacement(context, getCustomRoute(child: const Dashboard()));
                    },
                    title: "Continue",
                  ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class UpdateNameSheet extends StatefulWidget {
  const UpdateNameSheet({Key? key}) : super(key: key);

  @override
  State<UpdateNameSheet> createState() => _UpdateNameSheetState();
}

class _UpdateNameSheetState extends State<UpdateNameSheet> {
  final TextEditingController name = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 30 + context.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: name,
            decoration: CustomDecoration.inputDecoration(
              label: "Name",
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  type: ButtonType.secondary,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  title: "Cancel",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  type: ButtonType.primary,
                  onTap: () {
                    Navigator.pop(context, name.text);
                  },
                  title: "Save",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UpdateStatusSheet extends StatefulWidget {
  const UpdateStatusSheet({Key? key}) : super(key: key);

  @override
  State<UpdateStatusSheet> createState() => _UpdateStatusSheetState();
}

class _UpdateStatusSheetState extends State<UpdateStatusSheet> {
  final TextEditingController status = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 10, 30, 30 + context.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: status,
            decoration: CustomDecoration.inputDecoration(
              label: "Status",
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  type: ButtonType.secondary,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  title: "Cancel",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomButton(
                  type: ButtonType.primary,
                  onTap: () {
                    Navigator.pop(context, status.text);
                  },
                  title: "Save",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
