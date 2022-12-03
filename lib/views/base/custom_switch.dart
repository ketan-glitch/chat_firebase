import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '../../services/enums/gender.dart';

class CustomSwitch<T> extends StatefulWidget {
  const CustomSwitch({
    Key? key,
    required this.items,
    required this.onChanged,
    required this.value,
    this.enabled = true,
    this.radius = 8.0,
    this.gradient,

    /// const LinearGradient(
    ///   begin: Alignment.topLeft,
    ///   end: Alignment.bottomRight,
    ///   colors: [
    ///     Color(0xFF941F37),
    ///     Color(0xFF590012),
    ///   ],
    /// )

    this.color,
    this.backgroundColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.duration,
  })  : assert(
          color == null || gradient == null,
          'Cannot provide both a color and a gradient\n',
        ),
        super(key: key);

  final List<T> items;
  final Function(T value) onChanged;
  final bool enabled;
  final double? radius;
  final Gradient? gradient;
  final Color? color;
  final Color? backgroundColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final Duration? duration;
  final T value;

  @override
  State<CustomSwitch<T>> createState() => _CustomSwitchState<T>();
}

class _CustomSwitchState<T> extends State<CustomSwitch<T>> {
  T? _selectedItem1;
  AlignmentGeometry _alignment = const Alignment(-1, 0);

  @override
  void initState() {
    super.initState();
    Timer.run(() {
      setState(() {
        try {
          double x = -1;
          double res = 2 / (widget.items.length - 1);
          _selectedItem1 = widget.value;
          log('${widget.items.indexOf(_selectedItem1 as T)}');
          x += (res * widget.items.indexOf(_selectedItem1 as T));
          _alignment = Alignment(x, 0);
        } catch (e) {
          log('---- ${e.toString()} ----', name: "ERROR AT initState()");
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? const Color(0XFFF1F1F1),
            borderRadius: BorderRadius.circular(widget.radius ?? 8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Stack(
              children: [
                AnimatedAlign(
                  alignment: _alignment,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    height: 30,
                    width: (constraints.maxWidth) / widget.items.length,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.radius ?? 8),
                      color: (widget.color == null && widget.gradient == null) ? Theme.of(context).primaryColor : widget.color,
                      gradient: widget.gradient,
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (int i = 0; i < widget.items.length; i++)
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (widget.enabled) {
                              double x = -1;
                              double res = 2 / (widget.items.length - 1);
                              x += (res * i);
                              _selectedItem1 = widget.items[i];
                              try {
                                widget.onChanged((widget.items[i]));
                              } catch (e) {
                                log('---- ${e.toString()} ----', name: "ERROR AT build()");
                              }
                              _alignment = Alignment(x, 0);
                              setState(() {});
                            }
                          },
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                widget.items[i].runtimeType == Gender ? (widget.items[i] as Gender).value : widget.items[i].toString(),
                                style: Theme.of(context).textTheme.headline2!.copyWith(
                                      color: _selectedItem1 == widget.items[i] ? Colors.white : null,
                                      fontSize: 16.0,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
