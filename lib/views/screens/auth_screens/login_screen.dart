import 'dart:developer';

import 'package:chat_firebase/services/input_decoration.dart';
import 'package:chat_firebase/services/route_helper.dart';
import 'package:chat_firebase/services/theme.dart';
import 'package:chat_firebase/views/base/common_button.dart';
import 'package:chat_firebase/views/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    log('$size');
    return Scaffold(
      /*appBar: const CustomAppBar(
        title: "Login",
      ),*/
      body: Builder(builder: (context) {
        if (Device.screenType == ScreenType.mobile) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              children: [
                const Spacer(),
                const LoginImage(),
                const Spacer(),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Chat App Login",
                    style: Theme.of(context).textTheme.headline4!.copyWith(color: CustomTheme.textSecondary, fontSize: 20.sp),
                  ),
                ),
                const Spacer(),
                TextField(
                  decoration: CustomDecoration.inputDecoration(
                    hint: 'Email id',
                    label: 'Email id',
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: CustomDecoration.inputDecoration(
                    hint: 'Password',
                    label: 'Password',
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: size.width * .6,
                  child: CustomButton(
                    type: ButtonType.primary,
                    onTap: () {
                      Navigator.pushReplacement(context, getCustomRoute(child: const Dashboard()));
                    },
                    title: "Login",
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
        } else if (Device.screenType == ScreenType.tablet) {
          return Column(
            children: [
              const LoginImage(),
              Center(
                child: Text(
                  "Chat App",
                  style: Theme.of(context).textTheme.headline3!.copyWith(color: CustomTheme.textSecondary),
                ),
              ),
            ],
          );
        } else {
          return Column(
            children: [
              const LoginImage(),
              Center(
                child: Text(
                  "Chat App",
                  style: Theme.of(context).textTheme.headline3!.copyWith(color: CustomTheme.textSecondary),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

class LoginImage extends StatelessWidget {
  const LoginImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = 0;
    double width = 0;
    if (Device.screenType == ScreenType.mobile) {
      height = size.height * .2;
      width = size.width * .8;
    }
    if (Device.screenType == ScreenType.tablet) {
      height = size.height * .2;
      width = size.width * .8;
    }
    if (Device.screenType == ScreenType.desktop) {
      height = size.height * .2;
      width = size.width * .8;
    }
    return CustomAssetImage(
      path: Assets.imagesChat,
      height: height,
      width: width,
    );
  }
}
