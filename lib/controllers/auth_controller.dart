import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../data/api/api_checker.dart';
import '../data/models/contact_number.dart';
import '../data/models/response/response_model.dart';
import '../data/models/response/user_model.dart';
import '../data/repositories/auth_repo.dart';
import '../services/constants.dart';
import '../services/extensions.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool _acceptTerms = true;

  late final number = ContactNumber(number: '', countryCode: '+91');
  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  bool get isLoading => _isLoading;
  bool get acceptTerms => _acceptTerms;

  Future<ResponseModel> login(String? phone, {String? otp}) async {
    ResponseModel responseModel;
    log("response.body.toString()${AppConstants.baseUrl}${AppConstants.loginUri}", name: "login");
    try {
      Response response = await authRepo.login(await authRepo.getDeviceId(), phone: phone, otp: otp);
      /*if(response.body.containsKey('errors')){
        return ResponseModel(false, response.statusText!,response.body['errors']);
      }*/
      log(response.statusCode.toString());
      log(response.body.toString());
      if (response.statusCode == 200) {
        log(response.body.toString());

        if (response.body.containsKey('errors')) {
          _isLoading = false;
          update();
          return ResponseModel(false, response.statusText!, response.body['errors']);
        }
        if (response.body.containsKey('token')) {
          authRepo.saveUserToken(response.body['token'].toString());
        }
        responseModel = ResponseModel(true, '${response.body['msg']}', response.body);
      } else {
        responseModel = ResponseModel(false, response.statusText!);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "CATCH");
      log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++', name: "ERROR AT login()");
    }
    _isLoading = false;
    // update();
    return responseModel;
  }

  Future<ResponseModel> getUserProfileData() async {
    ResponseModel responseModel;
    _isLoading = true;
    try {
      Response response = await authRepo.getUser();
      // log(response.bodyString ?? "NULL", name: "UserModel");
      // log(response.statusCode.toString(), name: "statusCode");
      if (response.statusCode == 200) {
        log(response.bodyString!, name: "UserModel");
        // log(response.statusCode.toString(), name: "statusCode");
        _userModel = userModelFromJson(response.bodyString!);
        authRepo.saveUserId('${_userModel!.user.id}');
        update();
        responseModel = ResponseModel(true, 'success');
      } else {
        ApiChecker.checkApi(response);
        responseModel = ResponseModel(false, "${response.statusText}");
      }
    } catch (e) {
      log('---- ${e.toString()} ----', name: "ERROR AT getUserProfileData()");
      responseModel = ResponseModel(false, "$e");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> updateUserProfile(dynamic data) async {
    _isLoading = true;
    update();
    Response response = await authRepo.updateUserProfile(data);
    log('${response.statusCode}', name: 'statusCode');
    log('${response.body}', name: 'body');
    if (response.statusCode == 200) {
      log('HERE');
      _isLoading = false;
      return ResponseModel(true, 'success');
    } else {
      _isLoading = false;
      update();
      return ResponseModel(false, response.statusText!);
    }
  }

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  void setUserToken(String id) {
    authRepo.saveUserToken(id);
  }

  bool checkUserData() {
    try {
      if (_userModel!.user.name.isValid &&
          _userModel!.user.phone.isValid &&
          _userModel!.user.company.isValid &&
          _userModel!.user.dob.isNotNull &&
          _userModel!.user.gender.isValid) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  bool isAdmin() {
    if (_userModel?.user.isAdmin == '1') {
      return true;
    }
    return false;
  }
}
