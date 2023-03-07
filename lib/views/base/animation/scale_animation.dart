import 'package:flutter/material.dart';

class CustomScaleAnimation extends StatefulWidget {
  const CustomScaleAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.fastOutSlowIn,
  }) : super(key: key);

  final Widget child;
  final Duration duration;
  final Curve curve;

  @override
  State<CustomScaleAnimation> createState() => _CustomScaleAnimationState();
}

class _CustomScaleAnimationState extends State<CustomScaleAnimation> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: widget.duration,
    vsync: this,
  );
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: widget.curve,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}
