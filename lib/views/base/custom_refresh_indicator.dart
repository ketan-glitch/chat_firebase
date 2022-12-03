import 'package:custom_refresh_indicator/custom_refresh_indicator.dart' show CustomRefreshIndicator, IndicatorController;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomRefresh extends StatefulWidget {
  final Widget child;
  final Function onRefresh;
  final Widget? loadingWidget;
  final double? indicatorHeight;
  final Color? backgroundColor;

  const CustomRefresh({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.loadingWidget,
    this.indicatorHeight,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<CustomRefresh> createState() => _CustomRefreshState();
}

class _CustomRefreshState extends State<CustomRefresh> with SingleTickerProviderStateMixin {
  double _indicatorSize = 70.0;
  ScrollDirection prevScrollDirection = ScrollDirection.idle;

  @override
  void initState() {
    super.initState();
    _indicatorSize = widget.indicatorHeight ?? 70;
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: _indicatorSize,
      onRefresh: () async {
        await widget.onRefresh();
      },
      child: widget.child,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? _) {
                prevScrollDirection = controller.scrollingDirection;
                final containerHeight = controller.value * _indicatorSize;
                return Container(
                  alignment: Alignment.center,
                  height: containerHeight,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? Colors.white,
                  ),
                  child: widget.loadingWidget ??
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                );
              },
            ),
            AnimatedBuilder(
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(
                    0.0,
                    controller.value * _indicatorSize,
                  ),
                  child: child,
                );
              },
              animation: controller,
            ),
          ],
        );
      },
    );
  }
}
