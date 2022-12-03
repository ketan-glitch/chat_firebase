import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

Route getCustomRoute({
  required Widget child,
  bool fullscreenDialog = false,
  bool animate = true,
  PageTransitionType type = PageTransitionType.rightToLeft,
}) {
  if (animate) {
    return PageTransition(
      type: type,
      duration: const Duration(milliseconds: 500),
      reverseDuration: const Duration(milliseconds: 400),
      child: child,
    );
  }
  return MaterialPageRoute(
    fullscreenDialog: fullscreenDialog,
    builder: (BuildContext context) {
      return child;
    },
  );
}
