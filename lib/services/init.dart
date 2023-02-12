import 'dart:developer';

import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/chat_controller.dart';
import '../controllers/firebase_controller.dart';
import '../controllers/permission_controller.dart';

class Init {
  // getBaseUrl() async {
  //   ApiCalls calls = ApiCalls();
  //   await calls.apiCallWithResponseGet('https://fishcary.com/fishcary/api/link2.php?for=true').then((value) {
  //     log(value.toString());
  //     AppConstants().setBaseUrl = jsonDecode(value)['link'];
  //     log(AppConstants().getBaseUrl, name: 'BASE');
  //   });
  // }

  initialize() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.lazyPut<SharedPreferences>(() => sharedPreferences);

    try {
      // Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.baseUrl, sharedPreferences: Get.find()));
      // Get.lazyPut(() => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

      Get.lazyPut(() => PermissionController());
      Get.lazyPut(() => FirebaseController());
      Get.lazyPut(() => ChatController());
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT initialize()");
    }
  }
}
