import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@template base_config}
/// The config with the properties of the progress bar
/// {@endtemplate}
@immutable
class BaseConfig {
  /// {@macro base_config}
  const BaseConfig({
    required this.values,
    required this.segments,
    this.color,
    this.backgroundOpacity,
    this.thickness,
    this.spacing,
    this.radius,
    this.startAngle,
    this.colors,
    this.backgroundColor,
    this.gradient,
    this.gradients,
    this.backgroundGradient,
    this.size,
    this.insideRadius,
  });

  /// {@macro config_segments}
  final List<num> segments;

  /// {@macro config_values}
  final List<double> values;

  /// {@macro config_color}
  final Color? color;

  /// {@macro config_colors}
  final List<Color>? colors;

  /// {@macro config_bgColor}
  final Color? backgroundColor;

  /// {@macro config_gradient}
  final Gradient? gradient;

  /// {@macro config_gradients}
  final List<Gradient>? gradients;

  /// {@macro config_bgGradient}
  final Gradient? backgroundGradient;

  /// {@macro config_bgOpacity}
  final double? backgroundOpacity;

  /// {@macro config_thickness}
  final double? thickness;

  /// {@macro config_size}
  final Size? size;

  /// {@macro config_spacing}
  final double? spacing;

  /// {@macro config_radius}
  final BorderRadius? radius;

  /// {@macro config_insideRadius}
  final BorderRadius? insideRadius;

  /// {@macro start_angle}
  final double? startAngle;

  /// copyWith method on the [BaseConfig]
  BaseConfig copyWith({
    List<num>? segments,
    List<double>? values,
    Color? color,
    List<Color>? colors,
    Color? backgroundColor,
    Gradient? gradient,
    List<Gradient>? gradients,
    Gradient? backgroundGradient,
    double? backgroundOpacity,
    double? thickness,
    Size? size,
    double? spacing,
    BorderRadius? radius,
    BorderRadius? insideRadius,
    double? startAngle,
  }) {
    return BaseConfig(
      segments: segments ?? this.segments,
      values: values ?? this.values,
      color: color ?? this.color,
      colors: colors ?? this.colors,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gradient: gradient ?? this.gradient,
      gradients: gradients ?? this.gradients,
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
      thickness: thickness ?? this.thickness,
      size: size ?? this.size,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      insideRadius: insideRadius ?? this.insideRadius,
      startAngle: startAngle ?? this.startAngle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BaseConfig &&
        listEquals(other.segments, segments) &&
        listEquals(other.values, values) &&
        other.color == color &&
        listEquals(other.colors, colors) &&
        other.backgroundColor == backgroundColor &&
        other.gradient == gradient &&
        listEquals(other.gradients, gradients) &&
        other.backgroundGradient == backgroundGradient &&
        other.backgroundOpacity == backgroundOpacity &&
        other.thickness == thickness &&
        other.size == size &&
        other.spacing == spacing &&
        other.radius == radius &&
        other.insideRadius == insideRadius &&
        other.startAngle == startAngle;
  }

  @override
  int get hashCode {
    return segments.hashCode ^
        values.hashCode ^
        color.hashCode ^
        colors.hashCode ^
        backgroundColor.hashCode ^
        gradient.hashCode ^
        gradients.hashCode ^
        backgroundGradient.hashCode ^
        backgroundOpacity.hashCode ^
        thickness.hashCode ^
        size.hashCode ^
        spacing.hashCode ^
        radius.hashCode ^
        insideRadius.hashCode ^
        startAngle.hashCode;
  }
}
