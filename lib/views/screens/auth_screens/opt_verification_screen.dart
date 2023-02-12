import 'dart:async';

import 'package:chat_firebase/services/extensions.dart';
import 'package:chat_firebase/services/route_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../controllers/firebase_controller.dart';
import '../../base/common_button.dart';
import 'login_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  late StreamController<ErrorAnimationType> errorController;
  late TapGestureRecognizer onTapRecognizer;
  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pushReplacement(context, getCustomRoute(child: const LoginScreen()));
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    Timer.run(() {
      Get.find<FirebaseController>().verifyPhoneNumber(context: context);
    });
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 65),
            Text(
              "Verification Code",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 22.0,
                  ),
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.grey.shade600,
                    ),
                children: [
                  TextSpan(
                    text: "We have sent the verification\ncode to ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.grey.shade600,
                          fontSize: 14.0,
                        ),
                  ),
                  TextSpan(
                    text: "+91${Get.find<FirebaseController>().numberController.text.obscureText}. ",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.grey.shade900,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                  ),
                  TextSpan(
                    text: "Change phone number?",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.0,
                        ),
                    recognizer: onTapRecognizer,
                  ),
                ],
              ),
            ),
            GetBuilder<FirebaseController>(builder: (firebaseController) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: PinCodeTextField(
                  length: 6,
                  autoDisposeControllers: false,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  keyboardType: TextInputType.visiblePassword,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 60,
                    activeFillColor: Colors.grey.shade200,
                    activeColor: Colors.grey.shade200,
                    inactiveColor: Colors.grey.shade200,
                    inactiveFillColor: Colors.grey.shade200,
                    selectedFillColor: Colors.grey.shade200,
                    selectedColor: Colors.grey.shade200,
                  ),
                  cursorColor: Colors.grey.shade400,
                  cursorHeight: 22,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: true,
                  errorAnimationController: errorController,
                  controller: firebaseController.otpController,
                  onCompleted: (v) {
                    if (kDebugMode) {
                      print("Completed");
                    }
                  },
                  onChanged: (value) {
                    // print(value);
                    // setState(() {
                    //   currentText = value;
                    // });
                  },
                  beforeTextPaste: (text) {
                    if (kDebugMode) {
                      print("Allowing to paste $text");
                    }
                    //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                    //but you can show anything you want here, like your pop up saying wrong paste format or etc
                    return true;
                  },
                  appContext: context,
                ),
              );
            }),
            const Spacer(flex: 20),
            GetBuilder<FirebaseController>(builder: (firebaseController) {
              return Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      isLoading: firebaseController.isLoading,
                      type: ButtonType.secondary,
                      onTap: () {},
                      title: "Resend",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      type: ButtonType.primary,
                      onTap: () {
                        if (firebaseController.otpController.text.length > 5) {
                          firebaseController.signInWithPhoneNumber(context);
                        }
                      },
                      title: "Confirm",
                    ),
                  ),
                ],
              );
            }),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
