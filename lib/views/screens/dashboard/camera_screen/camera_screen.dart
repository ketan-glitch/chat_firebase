import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import '../../../../controllers/firebase_controller.dart';
import '../../../../main.dart';
import '../../../../services/constants.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  bool back = true;
  bool flash = true;
  File? file;
  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[back ? 1 : 0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  switchCamera() {
    setState(() {
      back = !back;
    });
    controller = CameraController(cameras[back ? 1 : 0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      controller.setFlashMode(FlashMode.always);
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          if (file == null)
            SizedBox(
              height: size.height - AppBar(bottom: const TabBar(tabs: [])).preferredSize.height - 45,
              child: CameraPreview(controller),
            )
          else
            Image(
              image: FileImage(file!),
            ),
          if (file == null)
            Positioned(
              bottom: 0,
              width: size.width,
              child: Container(
                color: Colors.black54,
                height: size.height * .1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        controller.setFlashMode(flash ? FlashMode.always : FlashMode.off);
                      },
                      icon: const Icon(
                        Icons.flash_on,
                        color: Colors.white,
                      ),
                    ),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(45),
                        onTap: () async {
                          var file = await controller.takePicture();
                          this.file = File(file.path);
                          setState(() {});
                        },
                        child: Ink(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        switchCamera();
                      },
                      icon: const Icon(
                        Icons.cameraswitch,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Positioned(
              bottom: 0,
              width: size.width,
              child: Container(
                color: Colors.black54,
                height: size.height * .1,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(45),
                        onTap: () async {
                          Get.find<FirebaseController>().avatarImageFile = file;
                          await Get.find<FirebaseController>().uploadFile(ImageUploadType.status);
                          file = null;
                          setState(() {});
                        },
                        child: Ink(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            color: Color(0xff025c4c),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
