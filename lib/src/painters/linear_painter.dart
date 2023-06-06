import 'dart:math';

import 'package:flutter/material.dart';
import 'package:segmented_progress_bar/src/models/config.dart';
import 'package:segmented_progress_bar/src/utils/paint_utils.dart';

/// {@template linear_painter}
/// A painter that draws a linear progress bar which is segmented into
/// multiple pieces of varying length. Each of these segments can have different
/// lengths and different progress values defined by [_segments] and [_values]
/// respectively.
/// {@endtemplate}
class LinearProgressBarPainter extends CustomPainter {
  /// {@macro linear_painter}
  LinearProgressBarPainter({
    required this.config,
  });

  /// {@macro base_config}
  final BaseConfig config;
  List<num> get _segments => config.segments;
  List<double> get _values => config.values;
  Color get _color => config.color;
  List<Color>? get _colors => config.colors;
  Color? get _backgroundColor => config.backgroundColor;
  Gradient? get _gradient => config.gradient;
  List<Gradient>? get _gradients => config.gradients;
  Gradient? get _backgroundGradient => config.backgroundGradient;
  double get _backgroundOpacity => config.backgroundOpacity;
  double get _thickness => config.thickness;
  double get _spacing => config.spacing;
  BorderRadius get _radius => config.radius;
  BorderRadius? get _insideRadius => config.insideRadius;

  late num _totalFractions;
  late double _height;
  late double _width;
  num _nextOffset = 0;

  final bool _showGrid = false;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    const LinearProgressIndicator();
    _height = size.height;
    _width = size.width;
    _totalFractions = _segments.fold(0, (p, e) => p + e);

    drawLinearProgress(canvas);

    // For debuging purposes
    if (_showGrid) {
      canvas
        ..drawLine(Offset(0, _height / 2), Offset(_width, _height / 2), Paint())
        ..drawLine(
          Offset(_width / 2, -_height),
          Offset(_width / 2, _height * 2),
          Paint(),
        );
    }
  }

  /// {@template paint_bar}
  /// Creates a paint that can be used to paint paths for the given segment
  /// with a [value] color
  /// {@endtemplate}
  Paint paintBar(Color value, {bool isBg = false}) => Paint()
    ..color = value.withOpacity(isBg ? _backgroundOpacity : 1)
    ..style = PaintingStyle.fill;

  /// {@template paint_gradient_bar}
  /// Creates a paint that can be used to paint paths for the given segment
  /// with a [value] gradient
  /// {@endtemplate}
  Paint paintGradientBar(Gradient value, Rect bounds, {bool isBg = false}) {
    final grad =
        PaintUtils.getGradientWithOpacity(value, isBg ? _backgroundOpacity : 1);
    return Paint()
      ..shader = grad.createShader(bounds)
      ..style = PaintingStyle.fill;
  }

  /// Draws all the required linear segments for the progress bar
  void drawLinearProgress(Canvas canvas) {
    final paths = List<Path>.generate(_segments.length, makeBar);
    _nextOffset = 0;
    final pathBgs = List<Path>.generate(
      _segments.length,
      (index) => makeBar(index, isBg: true),
    );

    final onePaint = Paint()
      ..color = _color
      ..style = PaintingStyle.fill;
    final onePaintBg = Paint()
      ..color = (_backgroundColor ?? _color).withOpacity(_backgroundOpacity)
      ..style = PaintingStyle.fill;

    // When multiple colors are used
    final paints = _colors?.map(paintBar).toList();
    final paintBgs = _colors
        ?.map((e) => paintBar(_backgroundColor ?? e, isBg: true))
        .toList();

    // For single gradient
    final onePaintGrad = _gradient == null
        ? null
        : List.generate(
            _segments.length,
            (index) => paintGradientBar(
              _gradient!,
              pathBgs[index].getBounds(),
            ),
          );
    final onePaintGradBg = _gradient == null
        ? null
        : List.generate(
            _segments.length,
            (index) => paintGradientBar(
              _backgroundGradient ?? _gradient!,
              pathBgs[index].getBounds(),
              isBg: true,
            ),
          );

    // When multiple gradients are used
    final paintGrads = _gradients == null
        ? null
        : List.generate(
            _gradients!.length,
            (index) => paintGradientBar(
              _gradients![index],
              pathBgs[index].getBounds(),
            ),
          );
    final paintGradBgs = _gradients == null
        ? null
        : List.generate(
            _gradients!.length,
            (index) => paintGradientBar(
              _backgroundGradient ?? _gradients![index],
              pathBgs[index].getBounds(),
              isBg: true,
            ),
          );
    for (var i = 0; i < paths.length; i++) {
      // Draw backgrounds
      // Priority for painting background is
      // bgGradient > bgColor > Gradients > Gradient > Colors > Color
      canvas
        ..drawPath(
          pathBgs[i],
          _backgroundGradient != null && (onePaintGradBg != null)
              ? onePaintGradBg[i]
              : _backgroundColor != null
                  ? onePaintBg
                  : paintGradBgs != null
                      ? paintGradBgs[i]
                      : onePaintGradBg != null
                          ? onePaintGradBg[i]
                          : paintBgs != null
                              ? paintBgs[i]
                              : onePaintBg,
        )

        // Draw progress bars
        // Priority for painting progress bar is
        // Gradients > Gradient > Colors > Color

        // Paints the entire length of background bar but displays only the
        // progress region bounded by [paths]
        ..save()
        ..clipPath(paths[i])
        ..drawPath(
          pathBgs[i],
          paintGrads != null
              ? paintGrads[i]
              : onePaintGrad != null
                  ? onePaintGrad[i]
                  : paints != null
                      ? paints[i]
                      : onePaint,
        )
        ..restore();
    }
  }

  /// {@template make_segment}
  /// Draws a segment that will be of a fractional length dictated by
  /// [_segments] provided. If it is not the background then it will cover only
  /// upto the required fraction from [_values]
  /// {@endtemplate}
  Path makeBar(int index, {bool isBg = false}) {
    final isFirst = index == 0;
    final isLast = index == _segments.length - 1;
    final totalSpacing = _spacing * (_values.length - 1);
    final left = _nextOffset.toDouble();
    final segment = _segments[index];
    final fraction = segment / _totalFractions * (_width - totalSpacing);
    final progress = max(0.0, min(1, _values[index])) * fraction;
    final right = isBg ? fraction : progress;
    final top = _height / 2 - _thickness / 2;
    final bottom = _height / 2 + _thickness / 2;
    _nextOffset += fraction + _spacing;

    final computedRadius = _insideRadius == null
        ? _radius
        : BorderRadius.only(
            topLeft: isFirst ? _radius.topLeft : _insideRadius!.topLeft,
            bottomLeft:
                isFirst ? _radius.bottomLeft : _insideRadius!.bottomLeft,
            topRight: isLast ? _radius.topRight : _insideRadius!.topRight,
            bottomRight:
                isLast ? _radius.bottomRight : _insideRadius!.bottomRight,
          );

    return Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(left, top, right, bottom),
          topLeft: computedRadius.topLeft,
          topRight: computedRadius.topRight,
          bottomLeft: computedRadius.bottomLeft,
          bottomRight: computedRadius.bottomRight,
        ),
      );
  }
}
