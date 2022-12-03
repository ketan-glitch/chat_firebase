
import 'package:flutter/material.dart';

import '../../main.dart';

showSnackBar({required String content, SnackBarAction? snackBarAction}){
  snackBarKey.currentState!
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(content),
        duration: const Duration(milliseconds: 5000),
        margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        action: snackBarAction,
      ),
    );
}