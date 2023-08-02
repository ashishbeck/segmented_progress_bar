import 'package:flutter/material.dart';
import 'package:segmented_progress_bar/segmented_progress_bar.dart';
import 'package:segmented_progress_bar/src/models/config.dart';
import 'package:segmented_progress_bar/src/painters/circular_painter.dart';
import 'package:segmented_progress_bar/src/painters/linear_painter.dart';
import 'package:segmented_progress_bar/src/utils/tweens.dart';

/// {@template linear_segmented_progress_bar}
/// A linear progress bar which is segmented into multiple pieces of varying
/// length. Each of these segments can have different lengths and different
/// progress values defined by [segments] and [values] respectively.
/// {@endtemplate}
class SegmentedProgressBar extends ImplicitlyAnimatedWidget {
  /// {@macro linear_segmented_progress_bar}
  const SegmentedProgressBar({
    required this.segments,
    required this.values,
    super.key,
    this.type = SegmentedProgressBarType.linear,
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
    super.duration = const Duration(milliseconds: 1000),
    super.curve = Curves.easeOutCubic,
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
        );

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
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _SegmentedProgressBarState();
}

class _SegmentedProgressBarState
    extends AnimatedWidgetBaseState<SegmentedProgressBar> {
  List<Tween<double>?>? _values;
  ColorTween? _color;
  List<ColorTween?>? _colors;
  ColorTween? _backgroundColor;
  GradientTween? _gradient;
  List<GradientTween?>? _gradients;
  GradientTween? _backgroundGradient;
  Tween<double>? _backgroundOpacity;
  Tween<double>? _thickness;
  Tween<Size>? _size;
  Tween<double>? _spacing;
  Tween<BorderRadius>? _radius;
  Tween<BorderRadius>? _insideRadius;
  Tween<double>? _startAngle;

  @override
  Widget build(BuildContext context) {
    final config = BaseConfig(
      segments: widget.segments,
      values: _values?.map((e) => e?.evaluate(animation) ?? 0).toList() ??
          widget.values,
      color: _color?.evaluate(animation) ?? Theme.of(context).primaryColor,
      colors: _colors?.map((e) => e!.evaluate(animation)!).toList() ??
          widget.colors,
      backgroundColor: _backgroundColor?.evaluate(animation),
      gradient: _gradient?.evaluate(animation),
      gradients: _gradients?.map((e) => e!.evaluate(animation)).toList() ??
          widget.gradients,
      backgroundGradient: _backgroundGradient?.evaluate(animation),
      backgroundOpacity:
          _backgroundOpacity?.evaluate(animation) ?? widget.backgroundOpacity,
      thickness: _thickness?.evaluate(animation) ?? widget.thickness,
      size: _size?.evaluate(animation),
      spacing: _spacing?.evaluate(animation) ?? widget.spacing,
      radius: _radius?.evaluate(animation) ?? widget.radius,
      insideRadius: _insideRadius?.evaluate(animation),
      startAngle: _startAngle?.evaluate(animation) ?? widget.startAngle,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            CustomPaint(
              size: _size?.evaluate(animation) ?? _getSize(constraints),
              painter: _getPainter(config),
            ),
          ],
        );
      },
    );
  }

  Size _getSize(BoxConstraints constraints) {
    switch (widget.type) {
      case SegmentedProgressBarType.linear:
        return Size(
          constraints.biggest.longestSide,
          _thickness?.evaluate(animation) ?? widget.thickness,
        );
      case SegmentedProgressBarType.circular:
        return Size(
          constraints.biggest.shortestSide,
          constraints.biggest.shortestSide,
        );
    }
  }

  CustomPainter _getPainter(BaseConfig config) {
    switch (widget.type) {
      case SegmentedProgressBarType.linear:
        return LinearProgressBarPainter(config: config);
      case SegmentedProgressBarType.circular:
        return CircularProgressBarPainter(config: config);
    }
  }

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _values ??= List.generate(
      widget.values.length,
      (index) => Tween(
        begin: widget.values[index],
        end: widget.values[index],
      ),
    );
    if (widget.colors != null) {
      _colors ??= List.generate(
        widget.colors!.length,
        (index) => ColorTween(
          begin: widget.colors![index],
          end: widget.colors![index],
        ),
      );
    } else {
      _colors = null;
    }
    if (widget.gradients != null) {
      _gradients ??= List.generate(
        widget.gradients!.length,
        (index) => GradientTween(
          begin: widget.gradients![index],
          end: widget.gradients![index],
        ),
      );
    } else {
      _gradients = null;
    }

    for (var i = 0; i < widget.values.length; i++) {
      visitor(
        _values?[i],
        widget.values[i],
        (dynamic value) => Tween<double>(begin: value as double?),
      ) as Tween<double>?;
      visitor(
        _colors?[i],
        widget.colors?[i],
        (dynamic value) => ColorTween(begin: value as Color?),
      ) as ColorTween?;
      visitor(
        _gradients?[i],
        widget.gradients?[i],
        (dynamic value) => GradientTween(begin: value as Gradient?),
      ) as GradientTween?;
    }
    _color = visitor(
      _color,
      widget.color,
      (dynamic value) => ColorTween(begin: value as Color?),
    ) as ColorTween?;
    _backgroundColor = visitor(
      _backgroundColor,
      widget.backgroundColor,
      (dynamic value) => ColorTween(begin: value as Color?),
    ) as ColorTween?;
    _gradient = visitor(
      _gradient,
      widget.gradient,
      (dynamic value) => GradientTween(begin: value as Gradient?),
    ) as GradientTween?;
    _backgroundGradient = visitor(
      _backgroundGradient,
      widget.backgroundGradient,
      (dynamic value) => GradientTween(begin: value as Gradient?),
    ) as GradientTween?;
    _backgroundOpacity = visitor(
      _backgroundOpacity,
      widget.backgroundOpacity,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;
    _thickness = visitor(
      _thickness,
      widget.thickness,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;
    _size = visitor(
      _size,
      widget.size,
      (dynamic value) => Tween<Size>(begin: value as Size?),
    ) as Tween<Size>?;
    _spacing = visitor(
      _spacing,
      widget.spacing,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;
    _radius = visitor(
      _radius,
      widget.radius,
      (dynamic value) => Tween<BorderRadius>(begin: value as BorderRadius?),
    ) as Tween<BorderRadius>?;
    _insideRadius = visitor(
      _insideRadius,
      widget.insideRadius,
      (dynamic value) => Tween<BorderRadius>(begin: value as BorderRadius?),
    ) as Tween<BorderRadius>?;
    _startAngle = visitor(
      _startAngle,
      widget.startAngle,
      (dynamic value) => Tween<double>(begin: value as double?),
    ) as Tween<double>?;
  }
}
