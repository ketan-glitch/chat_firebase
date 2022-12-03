import 'package:flutter/material.dart';

import 'enums/dialog_transition.dart';

class ShowDialog {
  // Future getAnimatedDialog({
  //   required BuildContext context,
  //   required Widget child,
  //   required bool right,
  // }) async {
  //   return await showGeneralDialog(
  //     context: context,
  //     transitionBuilder: (context, a1, a2, widget) {
  //       final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
  //       return Transform(
  //         transform: Matrix4.translationValues(
  //             (right ? curvedValue : -curvedValue) * 400, 0.0, 0.0),
  //         child: Opacity(
  //           opacity: a1.value,
  //           child: widget,
  //           // child: widget,
  //         ),
  //       );
  //     },
  //     transitionDuration: const Duration(milliseconds: 300),
  //     pageBuilder: (BuildContext context, Animation<double> animation,
  //         Animation<double> secondaryAnimation) {
  //       return child;
  //     },
  //   );
  // }

  Offset dialogTransition(DialogTransition type) {
    switch (type) {
      case DialogTransition.top:
        return const Offset(0.0, -1.0);
      case DialogTransition.bottom:
        return const Offset(0.0, 1.0);
      case DialogTransition.right:
        return const Offset(1.0, 0.0);
      case DialogTransition.left:
        return const Offset(-1.0, 0.0);
      default:
        return const Offset(0.0, 0.0);
    }
  }

  Future getAnimatedDialog({
    required BuildContext context,
    required Widget child,
    required DialogTransition transitionType,
  }) async {
    return await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.8),
      context: context,
      transitionBuilder: (context, a1, a2, widget) {
        Offset begin = dialogTransition(transitionType);
        Offset end = Offset.zero;
        Tween<Offset> tween = Tween(begin: begin, end: end);
        Animation<Offset> offsetAnimation = a1.drive(tween);
        if (transitionType == DialogTransition.center) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: child,
            ),
          );
        } else {
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        }
      },
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return child;
      },
    );
  }

  Future getNormalDialog({
    required BuildContext context,
    required Widget child,
  }) async {
    return await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.8),
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return child;
      },
    );
  }
}
