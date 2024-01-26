import 'package:flutter/widgets.dart';

class CalenderScaleAnimation extends StatefulWidget {
  final Widget child;
  final bool isScale;
  const CalenderScaleAnimation({super.key, required this.child, required this.isScale});

  @override
  State<CalenderScaleAnimation> createState() => _CalenderScaleAnimationState();
}

class _CalenderScaleAnimationState extends State<CalenderScaleAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  void forward() {
    _controller.forward();
    // _controller.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     _controller.reset();
    //   }
    // });
  }

  @override
  void didUpdateWidget(covariant CalenderScaleAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScale != oldWidget.isScale && widget.isScale) {
      forward();
    }
    if (widget.isScale != oldWidget.isScale && !widget.isScale) {
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: 1 + _controller.value * 0.15,
          child: widget.child,
        );
      },
    );
  }
}
