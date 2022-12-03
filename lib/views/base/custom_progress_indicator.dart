import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  const CustomProgressIndicator({Key? key, this.isMini = false, this.color}) : super(key: key);

  final bool isMini;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isMini ? 25 : null,
      width: isMini ? 25 : null,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(color ?? Theme.of(context).primaryColor),
      ),
    );
  }
}
