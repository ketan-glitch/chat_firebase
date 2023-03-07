// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_firebase/controllers/chat_controller.dart';
import 'package:chat_firebase/services/date_formatters_and_converters.dart';
import 'package:chat_firebase/services/extensions.dart';
import 'package:chat_firebase/views/screens/auth_screens/login_screen.dart';
import 'package:chat_firebase/views/screens/dashboard/dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';

import '../data/models/response/message_chat.dart';
import '../data/models/response/status_model.dart';
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
    QuerySnapshot result = await fireStore.collection(FireStoreConstants.pathUserCollection).where("phone_number", isEqualTo: user.phoneNumber).get();
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
      await fireStore.collection(FireStoreConstants.pathUserCollection).doc(currentUser.phoneNumber).set(user.toJson());
    } catch (error) {
      log("$error");
    }
  }

  Future<void> updateUserName({String? name}) async {
    try {
      var fireStore = FirebaseFirestore.instance;
      UserModel user = userData.copyWith(
        name: name,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await fireStore.collection(FireStoreConstants.pathUserCollection).doc(_firebaseAuth.currentUser!.phoneNumber).set(user.toJson());
      await getUserData();
    } catch (error) {
      log("$error");
    }
  }

  Future<void> updateUserProfilePicture({String? image}) async {
    try {
      var fireStore = FirebaseFirestore.instance;
      UserModel user = userData.copyWith(profilePhoto: image);
      await fireStore.collection(FireStoreConstants.pathUserCollection).doc(_firebaseAuth.currentUser!.phoneNumber).set(user.toJson());
      await getUserData();
    } catch (error) {
      log("$error");
    }
  }

  Future<void> updateUserStatus({String? status}) async {
    try {
      var fireStore = FirebaseFirestore.instance;
      UserModel user = userData.copyWith(status: status);
      await fireStore.collection(FireStoreConstants.pathUserCollection).doc(_firebaseAuth.currentUser!.phoneNumber).set(user.toJson());
      await getUserData();
    } catch (error) {
      log("$error");
    }
  }

  late UserModel userData;
  Future<void> getUserData() async {
    if (_firebaseAuth.currentUser == null) return;
    try {
      var fireStore = FirebaseFirestore.instance;
      var userData = fireStore.collection(FireStoreConstants.pathUserCollection).doc(_firebaseAuth.currentUser!.phoneNumber).snapshots();
      userData.listen((event) {
        // log("${event.data()}", name: "userData");
        this.userData = UserModel.fromJson(event.data()!);
        update();
      });
      await Future.delayed(const Duration(seconds: 1));
    } catch (error) {
      log("$error");
    }
  }

  Future<void> handleSignOut(context) async {
    await firebaseAuth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  File? avatarImageFile;
  Future uploadFile(ImageUploadType type, {List<UserModel>? peer, File? file}) async {
    try {
      file ??= avatarImageFile;
      var lastSeparator = file!.path.lastIndexOf(Platform.pathSeparator);
      var newPath = '${file.path.substring(0, lastSeparator + 1)}${type.value}_${getDateTime().millisecondsSinceEpoch}.${file.path.extension}';
      file = await file.rename(newPath);
      String fileName = file.path.fileName;
      log("${file.path} $fileName", name: 'fileName');
      Reference reference = FirebaseStorage.instance.ref().child(fileName);
      log("${reference.name}${reference.fullPath}${reference}", name: 'fileName');
      UploadTask uploadTask = reference.putFile(file);

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
            if (type == ImageUploadType.profile) {
              if (peer == null) {
                await updateUserProfilePicture(image: image);
              }
            } else if (type == ImageUploadType.message) {
              Get.find<ChatController>().onSendMessage(content: image, type: TypeMessage.image, peer: peer!);
            } else if (type == ImageUploadType.messageFile) {
              Get.find<ChatController>().onSendMessage(content: image, type: TypeMessage.file, peer: peer!);
            } else if (type == ImageUploadType.status) {
              uploadStatusUpdate(image);
            }
            /*if (peerId.isNotValid) {
            await updateUserProfilePicture(image: image);
          } else {
            Get.find<ChatController>().onSendMessage(content: image, type: TypeMessage.image, peerId: peerId!);
          }*/
            break;
        }
      });
    } catch (e) {
      log("ERROR AT UPLOAD $e");
    }
  }

  Stream<QuerySnapshot> getStreamFireStore(String pathCollection, int limit) {
    return FirebaseFirestore.instance
        .collection(pathCollection)
        .orderBy('name', descending: false)

        // .where(FireStoreConstants.nickname, isEqualTo: textSearch)
        // .where(FireStoreConstants.phoneNumber, isNotEqualTo: userData.number)
        // .limit(2)
        .snapshots();
  }

  Stream<QuerySnapshot> getMyChats(String pathCollection, int limit, String? textSearch) {
    var reference = FirebaseFirestore.instance.collection(pathCollection).where('users', arrayContains: "${_firebaseAuth.currentUser!.phoneNumber}")
        // .orderBy('updated_at', descending: true)
        ;
    return reference.snapshots();
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath, Map<String, dynamic> dataNeedUpdate) {
    return FirebaseFirestore.instance.collection(collectionPath).doc(docPath).update(dataNeedUpdate);
  }

  List<Map<String, dynamic>> statuses = [];

  getStatusesTest() async {
    Query<Map<String, dynamic>> questionsRef = FirebaseFirestore.instance
        .collection(FireStoreConstants.pathStatusCollection)
        .where('created_at', isGreaterThanOrEqualTo: getDateTime().subtract(const Duration(days: 1)).millisecondsSinceEpoch);

    List<Map<String, dynamic>> statuses = [];
    await questionsRef.get().then((snapshot) async {
      for (var document in snapshot.docs) {
        try {
          log("${document.data()['user']}", name: "LOOP");
          log("${(await document.data()['user'].get()).data()}", name: "LOOP");
          var user = (await document.data()['user'].get()).data();
          var status = document.data();
          status['user'] = user;
          statuses.add(status);
        } catch (error) {
          log("$error", name: "ERROR");
        }
      }
    });
    statuses.forEach((element) {
      log('${jsonEncode(element)}', name: "STATUSES");
    });
    try {
      var data = groupBy(statuses, (Map obj) => obj['user']['phone_number']);

      log('${data}');
      log('${jsonEncode(data)}');

      List<Map<String, dynamic>> statusesV2 = [];
      data.forEach((key, value) {
        statusesV2.add({
          'user': value.first['user'],
          'statuses': value,
        });
      });

      log('$statusesV2', name: "statusesV2");
      this.statuses.clear();
      for (var element in statusesV2) {
        this.statuses.add({
          'user': UserModel.fromJson(element['user']),
          'statuses': statusModelFromJson(jsonEncode(element['statuses'])),
        });
      }
    } catch (error) {
      log('$error', name: "error");
    }
    update();
  }

  Stream<QuerySnapshot> getStatuses() {
    var fireStore = FirebaseFirestore.instance;
    var statuses = fireStore.collection(FireStoreConstants.pathStatusCollection).snapshots();
    // log("${statuses}");
    return statuses;
    // try {
    //
    //   await Future.delayed(const Duration(seconds: 1));
    // } catch (error) {
    //   log("$error");
    // }
  }

  uploadStatusUpdate(String imageUrl) async {
    try {
      var fireStore = FirebaseFirestore.instance;
      StatusModel status = StatusModel(
        image: imageUrl,
        createdAt: getDateTime(),
        updatedAt: getDateTime(),
        user: UserModel(),
      );
      Map<String, dynamic> data = status.toJson();
      var reference = fireStore.collection(FireStoreConstants.pathUserCollection).doc(_firebaseAuth.currentUser!.phoneNumber);
      data['user'] = reference;
      data['seen_by'] = [];

      log("$data");
      await fireStore.collection(FireStoreConstants.pathStatusCollection).doc().set(data);
      await getStatusesTest();
    } catch (error) {
      log("$error");
    }
  }

  Future updateGroupDetails({required String groupName, required String groupChatId}) async {
    DocumentReference documentReference = FirebaseFirestore.instance.collection(FireStoreConstants.pathMessageCollection).doc(groupChatId);
    Map<String, dynamic>? data;
    await documentReference.get().then((value) async {
      data = value.data() as Map<String, dynamic>?;
      if (data != null) {
        if (data!.containsKey('chat_type')) {
          if (data!['chat_type'] == 'group') {
            if (data!.containsKey('group_name')) {
              data!['group_name'] = groupName;
            } else {
              data!.addAll({'group_name': groupName});
            }
          }
        } else {
          data!.addAll({
            'chat_type': 'group',
            'group_name': groupName,
            'group_id': groupChatId,
          });
        }
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          transaction.update(
            documentReference,
            data!,
          );
        });
      } else {
        data = {
          'chat_type': 'group',
          'group_name': groupName,
          'group_id': groupChatId,
        };
      }
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(
          documentReference,
          data!,
        );
      });
    });
  }

  createGroup(String groupName, String groupChatId) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(FireStoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    Get.find<ChatController>().usersToCreateGroup.removeLast();

    await updateGroupDetails(groupName: groupName, groupChatId: groupChatId);

    await Get.find<ChatController>().updateUserDataInChat(Get.find<ChatController>().usersToCreateGroup, groupChatId: groupChatId);

    // var reference = FirebaseFirestore.instance.collection(FireStoreConstants.pathUserCollection).doc(_firebaseAuth.currentUser!.phoneNumber);

    MessageChat messageChat = MessageChat(
      idFrom: groupChatId,
      from: null,
      idTo: groupChatId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: "$groupName is Created by ${Get.find<FirebaseController>().userData.name}",
      type: TypeMessage.text,
    );

    var message = messageChat.toJson();

    // message[FireStoreConstants.from] = reference;

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        message,
      );
    });
  }
}
