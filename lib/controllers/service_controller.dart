import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'permission_controller.dart';

export 'package:image_picker/image_picker.dart';

class ServiceController {
  final picker = ImagePicker();

  Future<File?> pickImage(ImageSource source, BuildContext context, {int imageQuality = 25}) async {
    XFile? pickedFile;
    bool permission = false;
    if (source == ImageSource.camera) {
      permission = await Get.find<PermissionController>().getPermission(Permission.camera, context);
    } else {
      permission = await Get.find<PermissionController>().getPermission(Platform.isAndroid ? Permission.storage : Permission.photos, context);
    }
    if (permission) {
      pickedFile = await picker.pickImage(source: source, imageQuality: imageQuality);
    } else {
      Fluttertoast.showToast(msg: "User Denied Permission");
    }

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<List<XFile>> getMultiImage() async {
    final pickedFile = await picker.pickMultiImage(imageQuality: 25);
    return pickedFile;
  }

  Future<DateTime> selectDate(context, {DateTime? startData, DateTime? endDate}) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: startData ?? DateTime.now().add(const Duration(minutes: 1)),
      lastDate: endDate ??
          DateTime.now().add(
            const Duration(days: 60),
          ),
    );
    return pickedDate!;
  }

  Future<String?> selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay == null) {
      return null;
    } else {
      return DateFormat('HH:mm')
          // ignore: use_build_context_synchronously
          .format(DateFormat("h:mm a").parse(timeOfDay.format(context)));
    }
  }

  Future<File?> pickFile(BuildContext? context) async {
    bool permission = false;
    if (Platform.isAndroid) {
      permission = true;
    } else {
      permission = await Get.find<PermissionController>().getPermission(Permission.manageExternalStorage, context);
    }
    File? file;
    if (permission) {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        file = File(result.files.single.path!);
        return file;
      } else {
        Fluttertoast.showToast(msg: "User canceled the picker");
      }
    }
    return file;
  }
}
