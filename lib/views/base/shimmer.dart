import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({Key? key, required this.child}) : super(key: key);
  final Widget child;
  static const shimmerColorBase = Color(0xFFEBEBF4);
  static const shimmerColorHighlight = Color(0xFFF4F4F4);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: shimmerColorBase,
      highlightColor: shimmerColorHighlight,
      child: child,
    );
  }
}
