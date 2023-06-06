import 'package:flutter/material.dart';

/// {@template base_config}
/// The config with the properties of the progress bar
/// {@endtemplate}
class BaseConfig {
  /// {@macro base_config}
  BaseConfig({
    required this.segments,
    required this.values,
    required this.color,
    this.colors,
    this.backgroundColor,
    this.gradient,
    this.gradients,
    this.backgroundGradient,
    required this.backgroundOpacity,
    required this.thickness,
    this.size,
    required this.spacing,
    required this.radius,
    this.insideRadius,
    required this.startAngle,
  });

  /// {@macro config_segments}
  final List<num> segments;

  /// {@macro config_values}
  final List<double> values;

  /// {@macro config_color}
  final Color color;

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
  final double backgroundOpacity;

  /// {@macro config_thickness}
  final double thickness;

  /// {@macro config_size}
  final Size? size;

  /// {@macro config_spacing}
  final double spacing;

  /// {@macro config_radius}
  final BorderRadius radius;

  /// {@macro config_insideRadius}
  final BorderRadius? insideRadius;

  /// {@macro start_angle}
  final double startAngle;
}
