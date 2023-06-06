import 'package:flutter/material.dart';
import 'package:segmented_progress_bar/segmented_progress_bar.dart';
import 'package:segmented_progress_bar/src/models/config.dart';
import 'package:segmented_progress_bar/src/painters/circular_painter.dart';
import 'package:segmented_progress_bar/src/painters/linear_painter.dart';

/// {@template linear_segmented_progress_bar}
/// A linear progress bar which is segmented into multiple pieces of varying
/// length. Each of these segments can have different lengths and different
/// progress values defined by [segments] and [values] respectively.
/// {@endtemplate}
class SegmentedProgressBar extends StatelessWidget {
  /// {@macro linear_segmented_progress_bar}
  const SegmentedProgressBar({
    Key? key,
    this.type = SegmentedProgressBarType.linear,
    required this.segments,
    required this.values,
    this.color,
    this.colors,
    this.backgroundColor,
    this.gradient,
    this.gradients,
    this.backgroundGradient,
    this.backgroundOpacity = 0.2,
    this.thickness = 12,
    this.size,
    this.spacing = 4,
    this.radius = const BorderRadius.all(Radius.circular(12)),
    this.insideRadius,
    this.startAngle = 270,
  })  : assert(
          segments.length == values.length,
          'The number of segments should match the number of values',
        ),
        assert(
          (colors ?? segments).length == segments.length,
          'The number of segments should match the number of colors',
        ),
        assert(
          (gradients ?? segments).length == segments.length,
          'The number of segments should match the number of gradients',
        ),
        super(key: key);

  /// {@macro segmented_bar_type}
  final SegmentedProgressBarType type;

  /// {@template config_segments}
  /// A list of numbers that will dictate how the individual segments will be
  /// weighted against each other.
  ///
  /// For example, a value of [1, 2, 1] will create three segments where the
  /// middle segment will be twice as big as the first and last segment
  /// {@endtemplate}
  final List<num> segments;

  /// {@template config_values}
  /// A list of double that accepts values between 0 and 1 which will
  /// represent how much progress each of the corresponding segement has
  /// completed.
  ///
  /// {@template assert_length}
  /// It must match the number of segments.
  /// {@endtemplate}
  /// {@endtemplate}
  final List<double> values;

  /// {@template config_color}
  /// The color to paint the progress bar
  /// {@endtemplate}
  final Color? color;

  /// {@template config_colors}
  /// A list of colors which will be used to paint the individual segments.
  ///
  /// {@macro assert_length}
  /// {@endtemplate}
  final List<Color>? colors;

  /// {@template config_bgColor}
  /// An optional background color to paint the backgrounds of all the segments.
  /// It will override whatever [gradients], [gradient], [color] or [colors]
  /// is set to.
  /// {@endtemplate}
  final Color? backgroundColor;

  /// {@template config_gradient}
  /// The gradient to paint the progress bar. It will override whatever [color]
  /// or [colors] is set to.
  /// {@endtemplate}
  final Gradient? gradient;

  /// {@template config_gradients}
  /// A list of gradient to paint the individual segments. It will override
  /// whatever [gradient], [color] or [colors] is set to.
  ///
  /// {@macro assert_length}
  /// {@endtemplate}
  final List<Gradient>? gradients;

  /// {@template config_bgGradient}
  /// An optional background gradient to paint the backgrounds of all the
  /// segments. It will override whatever [backgroundGradient], [gradients],
  /// [gradient], [color] or [colors] is set to.
  /// {@endtemplate}
  final Gradient? backgroundGradient;

  /// {@template config_bgOpacity}
  /// The opacity for the background color or gradient.
  /// {@endtemplate}
  final double backgroundOpacity;

  /// {@template config_thickness}
  /// The thickness of the progress bar segment.
  /// {@endtemplate}
  final double thickness;

  /// {@template config_size}
  /// The dimensions where the progress bar will be constrained to. If
  /// unspecified, it will take up the entire width of the screen.
  /// {@endtemplate}
  final Size? size;

  /// {@template config_spacing}
  /// The gap between all the segments.
  /// {@endtemplate}
  final double spacing;

  /// {@template config_radius}
  /// The shape of the progress bar is defined by this [BorderRadius] that is
  /// easy to customise.
  /// {@endtemplate}
  final BorderRadius radius;

  /// {@template config_insideRadius}
  /// The shape of the progress bar that are facing towards the inside. It
  /// excludes modifying the outsides of the first and the last segment.
  /// {@endtemplate}
  final BorderRadius? insideRadius;

  /// {@template start_angle}
  /// The angle at which the circular progress bar starts at. Doesn't apply
  /// to the linear type.
  /// {@endtemplate}
  final double startAngle;

  @override
  Widget build(BuildContext context) {
    final config = BaseConfig(
      segments: segments,
      values: values,
      color: color ?? Theme.of(context).primaryColor,
      colors: colors,
      backgroundColor: backgroundColor,
      gradient: gradient,
      gradients: gradients,
      backgroundGradient: backgroundGradient,
      backgroundOpacity: backgroundOpacity,
      thickness: thickness,
      size: size,
      spacing: spacing,
      radius: radius,
      insideRadius: insideRadius,
      startAngle: startAngle,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: size ?? _getSize(constraints),
          painter: _getPainter(config),
        );
      },
    );
  }

  Size _getSize(BoxConstraints constraints) {
    switch (type) {
      case SegmentedProgressBarType.linear:
        return Size(
          constraints.biggest.shortestSide,
          thickness,
        );
      case SegmentedProgressBarType.circular:
        return Size(
          constraints.biggest.shortestSide,
          constraints.biggest.shortestSide,
        );
    }
  }

  CustomPainter _getPainter(BaseConfig config) {
    switch (type) {
      case SegmentedProgressBarType.linear:
        return LinearProgressBarPainter(config: config);
      case SegmentedProgressBarType.circular:
        return CircularProgressBarPainter(config: config);
    }
  }
}
