import 'package:flutter/material.dart';

/// {@template gradient_tween}
/// A tween type for gradients
/// {@endtemplate}
class GradientTween extends Tween<Gradient> {
  /// {@macro gradient_tween}
  GradientTween({super.begin, super.end});

  @override
  Gradient lerp(double t) => Gradient.lerp(begin, end, t)!;
}
