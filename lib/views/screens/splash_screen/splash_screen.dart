import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_template/views/base/custom_image.dart';

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
      Future.delayed(const Duration(seconds: 2), () {});
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
              "App Title",
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 26.0,
                  ),
            ),
            Text(
              "Subtitle",
              style: Theme.of(context).textTheme.bodyText2,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
