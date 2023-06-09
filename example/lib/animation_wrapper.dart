import 'package:flutter/material.dart';

typedef WidgetBuilder = Widget Function(BuildContext context, double animation);

class AnimationWrapper extends StatefulWidget {
  const AnimationWrapper({
    Key? key,
    required this.builder,
  }) : super(key: key);
  final WidgetBuilder builder;

  @override
  State<AnimationWrapper> createState() => _AnimationWrapperState();
}

class _AnimationWrapperState extends State<AnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  listener() {
    // print(controller.value);
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animation = CurvedAnimation(parent: controller, curve: Curves.linear);
    controller
      ..repeat(reverse: true)
      ..addListener(listener);
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          return widget.builder(context, animation.value);
        });
  }
}
