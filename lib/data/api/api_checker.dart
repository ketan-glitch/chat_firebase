import 'dart:developer';

import 'package:flutter_template/views/screens/splash_screen/splash_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../main.dart';
import '../../services/route_helper.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      log('here 401');
      Get.find<AuthController>().clearSharedData();
      navigatorKey.currentState!.pushAndRemoveUntil(getCustomRoute(child: const SplashScreen()), (route) => false);
    } else if (response.statusCode == 429) {
      Get.find<AuthController>().clearSharedData();
      navigatorKey.currentState!.pushAndRemoveUntil(getCustomRoute(child: const SplashScreen()), (route) => false);
      log('here 401');
    } else {
      log('${response.statusText} : ${response.body ?? ''}');
      if (response.statusText!.contains('Too many connections')) {
        Fluttertoast.showToast(msg: 'Too many connections');
      } else {
        Fluttertoast.showToast(msg: '${response.statusText} ');
      }
    }
  }
}
