import 'dart:async';
import 'dart:developer';

import 'package:chat_firebase/controllers/firebase_controller.dart';
import 'package:chat_firebase/services/extensions.dart';
import 'package:chat_firebase/services/route_helper.dart';
import 'package:chat_firebase/views/base/custom_image.dart';
import 'package:chat_firebase/views/screens/auth_screens/login_screen.dart';
import 'package:chat_firebase/views/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

import '../auth_screens/signup_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer.run(() {
      log("${Get.find<FirebaseController>().firebaseAuth.currentUser}");
      Future.delayed(const Duration(seconds: 2), () async {
        if (Get.find<FirebaseController>().firebaseAuth.currentUser != null) {
          await Get.find<FirebaseController>().getUserData();
          Future.delayed(const Duration(seconds: 2), () {
            if (Get.find<FirebaseController>().userData.name.isValid) {
              Navigator.pushReplacement(context, getCustomRoute(child: const Dashboard()));
            } else {
              Navigator.pushReplacement(context, getCustomRoute(child: const ProfileScreen()));
            }
          });
        } else {
          Navigator.pushReplacement(context, getCustomRoute(child: const LoginScreen()));
        }
      });
      /*if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<AuthController>().getUserProfileData().then((value) {
          Future.delayed(const Duration(seconds: 2), () {
            if (Get.find<AuthController>().checkUserData()) {
              Navigator.pushReplacement(
                context,
                getMaterialRoute(
                  child: const Dashboard(),
                ),
              );
            } else {
              Navigator.pushReplacement(
                context,
                getMaterialRoute(
                  child: const SignupScreen(),
                ),
              );
            }
          });
        });
      } else {
        Navigator.pushReplacement(
          context,
          getMaterialRoute(
            child: const LoginScreen(),
          ),
        );
      }*/
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    log('$size');
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            CustomAssetImage(
              path: Assets.imagesLogo,
              height: size.height * .3,
              width: size.height * .3,
            ),
            const Spacer(flex: 3),
            Text(
              "Chat App",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 26.0,
                  ),
            ),
            Text(
              "",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
