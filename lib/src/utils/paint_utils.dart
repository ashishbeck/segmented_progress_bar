import 'package:flutter/material.dart';

/// {@template paint_utils}
/// Basic utility functions for paint purposes
/// {@endtemplate}
class PaintUtils {
  /// {@macro paint_utils}
  PaintUtils._();

  /// Adds opacity to the colors of the given gradient
  static Gradient getGradientWithOpacity(Gradient old, double opacity) {
    final colors = old.colors.map((e) => e.withOpacity(opacity)).toList();
    switch (old.runtimeType) {
      case LinearGradient:
        return LinearGradient(
          colors: colors,
          begin: (old as LinearGradient).begin,
          end: old.end,
          stops: old.stops,
          tileMode: old.tileMode,
          transform: old.transform,
        );

      case RadialGradient:
        return RadialGradient(
          colors: colors,
          center: (old as RadialGradient).center,
          radius: old.radius,
          focal: old.focal,
          focalRadius: old.focalRadius,
          stops: old.stops,
          tileMode: old.tileMode,
          transform: old.transform,
        );

      case SweepGradient:
      default:
        return SweepGradient(
          colors: colors,
          center: (old as SweepGradient).center,
          startAngle: old.startAngle,
          endAngle: old.endAngle,
          stops: old.stops,
          tileMode: old.tileMode,
          transform: old.transform,
        );
    }
  }
}
