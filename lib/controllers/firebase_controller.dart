// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:chat_firebase/views/screens/auth_screens/login_screen.dart';
import 'package:chat_firebase/views/screens/dashboard/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../data/models/response/user_model.dart';
import '../services/constants.dart';
import '../services/custom_snackbar.dart';
import '../services/route_helper.dart';
import '../views/screens/auth_screens/signup_screen.dart';

class FirebaseController extends GetxController implements GetxService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool _isLoading = false;
  String _message = '';
  late String _verificationId;
  CountryCode? code = const CountryCode(name: 'India', code: 'IN', dialCode: '+91');

  TextEditingController numberController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  bool get isLoading => _isLoading;
  FirebaseAuth get firebaseAuth => _firebaseAuth;

  loadingOff() {
    _isLoading = false;
    update();
  }

  Future<void> verifyPhoneNumber({required BuildContext context}) async {
    _isLoading = true;
    update();
    String number = code!.dialCode;
    number += numberController.text;
    log(number);
    verificationCompleted(PhoneAuthCredential phoneAuthCredential) async {
      try {
        log("${phoneAuthCredential.smsCode}");
        otpController.text = (phoneAuthCredential.smsCode) ?? '';
        update();
        await Future.delayed(const Duration(milliseconds: 500));
        UserCredential userCredential = await _firebaseAuth.signInWithCredential(phoneAuthCredential);
        if (userCredential.user != null) {
          User user = userCredential.user!;
          ScaffoldSnackBar.of(context).show('Phone number automatically verified and user signed in.');
          if (await isNewUser(user)) {
            await addUserToDb(user);
            Navigator.pushAndRemoveUntil(context, getCustomRoute(child: const ProfileScreen()), (route) => false);
          } else {
            Navigator.pushAndRemoveUntil(context, getCustomRoute(child: const Dashboard()), (route) => false);
          }
          // log("$phoneAuthCredential");
        } else {
          ScaffoldSnackBar.of(context).show('Login Failed.');
        }
      } catch (e) {
        log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++', name: "ERROR AT verifyPhoneNumber()");
      }
    }

    verificationFailed(FirebaseAuthException authException) {
      try {
        _message = 'Phone number verification failed. Code: ${authException.code}. '
            'Message: ${authException.message}';
        log(_message);
        _isLoading = false;
        ScaffoldSnackBar.of(context).show(_message);
        update();
      } catch (e) {
        log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++', name: "ERROR AT verifyPhoneNumber()");
      }
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      try {
        // ScaffoldSnackBar.of(context).show('Please check your phone for the verification code.');
        _verificationId = verificationId;
        log(_verificationId, name: 'codeSent');
        _isLoading = false;
        update();
      } catch (e) {
        log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++', name: "ERROR AT codeSent()");
      }
    }

    codeAutoRetrievalTimeout(String verificationId) {
      try {
        _verificationId = verificationId;
        log(_verificationId, name: 'codeAutoRetrievalTimeout');
        _isLoading = false;
        update();
      } catch (e) {
        _isLoading = false;
        update();
        log('++++++++++++++++++++++++++++++++++++++++++++ ${e.toString()} +++++++++++++++++++++++++++++++++++++++++++++',
            name: "ERROR AT codeAutoRetrievalTimeout()");
      }
    }

    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: number,
          timeout: const Duration(seconds: 10),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      _isLoading = false;
      update();
      ScaffoldSnackBar.of(context).show('Failed to Verify Phone Number: $e');
    }
  }

  Future<void> signInWithPhoneNumber(context) async {
    _isLoading = true;
    update();
    try {
      log(_verificationId);
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otpController.text,
      );
      log("${credential.asMap()}");
      var userCredential = (await _firebaseAuth.signInWithCredential(credential));
      final User user = userCredential.user!;
      ScaffoldSnackBar.of(context).show('Successfully signed in with: ${user.phoneNumber}');
      if (await isNewUser(user)) {
        await addUserToDb(user);
        await getUserData();
        Navigator.pushAndRemoveUntil(context, getCustomRoute(child: const ProfileScreen()), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, getCustomRoute(child: const Dashboard()), (route) => false);
      }

      _isLoading = false;
      update();
    } catch (e) {
      log(e.toString(), name: "ERROR AT signInWithPhoneNumber");
      ScaffoldSnackBar.of(context).show('Failed to sign in');
      _isLoading = false;
      update();
    }
  }

  Future<bool> isNewUser(User user) async {
    var fireStore = FirebaseFirestore.instance;
    QuerySnapshot result = await fireStore.collection("users").where("phone_number", isEqualTo: user.phoneNumber).get();
    final List<DocumentSnapshot> docs = result.docs;
    return docs.isEmpty ? true : false;
  }

  Future<void> addUserToDb(User currentUser) async {
    try {
      var fireStore = FirebaseFirestore.instance;
      UserModel user = UserModel(
        uid: currentUser.uid,
        number: currentUser.phoneNumber,
        name: currentUser.displayName,
        profilePhoto: currentUser.photoURL,
      );
      await fireStore.collection("users").doc(currentUser.phoneNumber).set(user.toJson());
    } catch (error) {
      log("$error");
    }
  }

  Future<void> updateUserName({String? name}) async {
    try {
      var fireStore = FirebaseFirestore.instance;
      UserModel user = userData.copyWith(name: name);
      await fireStore.collection("users").doc(_firebaseAuth.currentUser!.phoneNumber).set(user.toJson());
      await getUserData();
    } catch (error) {
      log("$error");
    }
  }

  Future<void> updateUserProfilePicture({String? image}) async {
    try {
      var fireStore = FirebaseFirestore.instance;
      UserModel user = userData.copyWith(profilePhoto: image);
      await fireStore.collection("users").doc(_firebaseAuth.currentUser!.phoneNumber).set(user.toJson());
      await getUserData();
    } catch (error) {
      log("$error");
    }
  }

  Future<void> updateUserStatus({String? status}) async {
    try {
      var fireStore = FirebaseFirestore.instance;
      UserModel user = userData.copyWith(status: status);
      await fireStore.collection("users").doc(_firebaseAuth.currentUser!.phoneNumber).set(user.toJson());
      await getUserData();
    } catch (error) {
      log("$error");
    }
  }

  late UserModel userData;
  Future<void> getUserData() async {
    try {
      var fireStore = FirebaseFirestore.instance;
      var userData = fireStore.collection("users").doc(_firebaseAuth.currentUser!.phoneNumber).snapshots();
      userData.listen((event) {
        log("${event.data()}", name: "userData");
        this.userData = UserModel.fromJson(event.data()!);
        update();
      });
      await Future.delayed(const Duration(seconds: 1));

      // UserModel user = UserModel(
      //   uid: currentUser.uid,
      //   number: currentUser.phoneNumber,
      //   name: currentUser.displayName,
      //   profilePhoto: currentUser.photoURL,
      // );
    } catch (error) {
      log("$error");
    }
  }

/*  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      // 'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<void> signInWithGoogle(context) async {
    _isLoading = true;
    update();
    if (await googleSignIn.isSignedIn()) {
      googleSignIn.signOut();
    }
    try {
      UserCredential userCredential;
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      userCredential = await _firebaseAuth.signInWithCredential(googleAuthCredential);
      // Get.find<AuthController>().email.text = userCredential.user!.email!;
      if (userCredential.user != null) {
        User user = userCredential.user!;
        log("$user");
        Get.find<AuthController>().login(await user.getIdToken()).then((status) async {
          if (status.isSuccess) {
            log('${status.isSuccess}', name: 'isSuccess');
            Navigator.pushAndRemoveUntil(context, getCustomRoute(child: const Dashboard()), (route) => false);
          } else {
            ScaffoldSnackBar.of(context).show(status.message);
            _isLoading = false;
            update();
            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Center(
                  child: Dialog(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomAssetImage(
                            path: Assets.imagesLogo,
                            height: 100,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Failed to sign in",
                            style: GoogleFonts.montserrat(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            type: ButtonType.primary,
                            onTap: () {
                              Navigator.pop(context);
                            },
                            title: "OK",
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        });
      } else {
        log("User not found");
      }
    } catch (e) {
      log(e.toString(), name: "ERROR GOOGLE SIGNIN");
      _isLoading = false;
      update();
    }
  }*/

  Future<void> handleSignOut(context) async {
    await firebaseAuth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  File? avatarImageFile;
  Future uploadFile() async {
    String fileName = avatarImageFile!.path;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(avatarImageFile!);

    // Listen for state changes, errors, and completion of the upload.
    uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress = 100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          log("Upload is $progress% complete.");
          break;
        case TaskState.paused:
          log("Upload is paused.");
          break;
        case TaskState.canceled:
          log("Upload was canceled");
          break;
        case TaskState.error:
          // Handle unsuccessful uploads
          break;
        case TaskState.success:
          String image = await reference.getDownloadURL();
          await updateUserProfilePicture(image: image);
          // Handle successful uploads on complete
          // ...

          break;
      }
    });
  }

  Stream<QuerySnapshot> getStreamFireStore(String pathCollection, int limit, String? textSearch) {
    if (textSearch?.isNotEmpty == true) {
      return FirebaseFirestore.instance.collection(pathCollection).limit(limit).where(FireStoreConstants.nickname, isEqualTo: textSearch).snapshots();
    } else {
      return FirebaseFirestore.instance.collection(pathCollection).limit(limit).snapshots();
    }
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath, Map<String, dynamic> dataNeedUpdate) {
    return FirebaseFirestore.instance.collection(collectionPath).doc(docPath).update(dataNeedUpdate);
  }
}
