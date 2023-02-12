import 'package:chat_firebase/controllers/firebase_controller.dart';
import 'package:chat_firebase/services/input_decoration.dart';
import 'package:chat_firebase/services/route_helper.dart';
import 'package:chat_firebase/services/theme.dart';
import 'package:chat_firebase/views/base/common_button.dart';
import 'package:chat_firebase/views/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'opt_verification_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // log('$size');
    return Scaffold(
      /*appBar: const CustomAppBar(
        title: "Login",
      ),*/
      body: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const Spacer(),
              const LoginImage(),
              // const Spacer(),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  "Chat App Login",
                  style: Theme.of(context).textTheme.headline4!.copyWith(color: CustomTheme.textSecondary, fontSize: 20.sp),
                ),
              ),
              const SizedBox(height: 20),
              const Spacer(flex: 3),
              GetBuilder<FirebaseController>(builder: (firebaseController) {
                return TextField(
                  controller: firebaseController.numberController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: CustomDecoration.inputDecoration(
                    prefixText: "+91",
                    label: 'Phone Number',
                  ),
                );
              }),
              const SizedBox(height: 20),
              // const Spacer(),
              GetBuilder<FirebaseController>(builder: (firebaseController) {
                return SizedBox(
                  width: size.width * .6,
                  child: CustomButton(
                    type: ButtonType.primary,
                    onTap: () {
                      if (firebaseController.numberController.text.length > 9) {
                        Navigator.pushReplacement(context, getCustomRoute(child: const OtpVerificationScreen()));
                      } else {
                        Fluttertoast.showToast(msg: "Please enter a correct number");
                      }
                    },
                    title: "Send Otp",
                  ),
                );
              }),
              const Spacer(),
            ],
          ),
        );
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
    double height = size.height * .2;
    double width = size.width * .8;

    return CustomAssetImage(
      path: Assets.imagesLogo,
      height: height,
      width: width,
    );
  }
}
