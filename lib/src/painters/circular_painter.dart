import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:segmented_progress_bar/src/models/config.dart';
import 'package:segmented_progress_bar/src/utils/math_utils.dart';
import 'package:segmented_progress_bar/src/utils/paint_utils.dart';
import 'package:vector_math/vector_math.dart' as vmath;

/// {@template circular_painter}
/// A painter that draws a circular progress bar which is segmented into
/// multiple pieces of varying length. Each of these segments can have different
/// lengths and different progress values defined by [_segments] and [_values]
/// respectively.
/// {@endtemplate}
class CircularProgressBarPainter extends CustomPainter {
  /// {@macro circular_painter}
  CircularProgressBarPainter({
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
  // ignore: unused_element
  BorderRadius? get _insideRadius =>
      config.insideRadius; // TODO(ashishbeck): Implement this feature
  double get _startAngle => config.startAngle;

  late num _totalFractions;
  late double _height;
  late double _width;
  late Offset _center;
  double _nextOffsetDeg = 0;

  final bool _showGrid = false;
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  @override
  void paint(Canvas canvas, Size size) {
    _height = size.height;
    _width = size.width;
    _center = Offset(_width / 2, _height / 2);
    _totalFractions = _segments.fold(0, (p, e) => p + e);

    final paint = Paint()
      ..color = _color
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.5;
    final paintBg = Paint()
      ..color = (_backgroundColor ?? _color).withOpacity(0.2)
      ..style = PaintingStyle.fill
      ..strokeWidth = 0.5;

    drawCircularProgress(canvas, paintBg, paint);

    // For debuging purposes
    if (_showGrid) {
      canvas
        ..drawRect(
          Rect.fromCenter(
            center: Offset(_center.dx, _spacing / 2),
            width: _spacing,
            height: _spacing,
          ),
          Paint()..color = Colors.red.withOpacity(0.4),
        )
        ..drawRect(
          Rect.fromCenter(
            center: Offset(_center.dx, _height - _spacing / 2),
            width: _spacing,
            height: _spacing,
          ),
          Paint()..color = Colors.red.withOpacity(0.4),
        )
        ..drawRect(
          Rect.fromCenter(
            center: Offset(_spacing / 2, _center.dy),
            width: _spacing,
            height: _spacing,
          ),
          Paint()..color = Colors.red.withOpacity(0.4),
        )
        ..drawRect(
          Rect.fromCenter(
            center: Offset(_width - _spacing / 2, _center.dy),
            width: _spacing,
            height: _spacing,
          ),
          Paint()..color = Colors.red.withOpacity(0.4),
        )
        ..drawLine(Offset(0, _height / 2), Offset(_width, _height / 2), paint)
        ..drawLine(Offset(_width / 2, 0), Offset(_width / 2, _height), paint);
    }
  }

  /// {@macro paint_bar}
  Paint paintBar(Color value, {bool isBg = false}) => Paint()
    ..color = value.withOpacity(isBg ? 0.2 : 1)
    ..style = PaintingStyle.fill;

  /// {@macro paint_gradient_bar}
  Paint paintGradientBar(Gradient value, Rect bounds, {bool isBg = false}) {
    final grad =
        PaintUtils.getGradientWithOpacity(value, isBg ? _backgroundOpacity : 1);
    return Paint()
      ..shader = grad.createShader(bounds)
      ..style = PaintingStyle.fill;
  }

  /// Draws all the required circular segments for the progress bar
  void drawCircularProgress(Canvas canvas, Paint paintBg, Paint paint) {
    final paths = List<Path>.generate(_segments.length, makeArc);
    _nextOffsetDeg = 0;
    final pathBgs = List<Path>.generate(
      _segments.length,
      (index) => makeArc(index, isBg: true),
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

    canvas.saveLayer(
      Rect.fromCenter(center: _center, width: _width, height: _height),
      paint,
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

    drawMask(canvas);

    canvas.restore();
  }

  /// {@macro make_segment}
  Path makeArc(int index, {bool isBg = false}) {
    final r = _center.dx;

    final tipWidthAngle = MathUtils.distanceToAngle(_thickness, r);
    final spacingAngle = MathUtils.distanceToAngle(_spacing, r);
    final additions = (isBg ? tipWidthAngle : 0) + spacingAngle;

    final start = _nextOffsetDeg +
        _startAngle +
        // Need to start behind the background
        (isBg ? tipWidthAngle : -tipWidthAngle) / 2 +
        // Add half the spacing
        spacingAngle / 2;
    final fraction = (_segments[index] / _totalFractions * 360) - additions;
    final progress = max(0.0, min(1, _values[index])) * fraction;
    final sweepAngle = isBg ? fraction : progress;

    final path = Path()
      ..addArc(
        Rect.fromCenter(center: _center, width: _width, height: _height),
        vmath.radians(start),
        vmath.radians(sweepAngle),
      );
    _nextOffsetDeg += fraction + (isBg ? tipWidthAngle : 0) + spacingAngle;

    final firstPos = MathUtils.findFirstPosition(path);
    final lastPos = MathUtils.findLastPosition(path);
    final lastInwardPoint =
        MathUtils.unitsTowardsCenter(lastPos, _center, _thickness);
    final firstInwardPoint =
        MathUtils.unitsTowardsCenter(firstPos, _center, _thickness);
    final lastMidPoint =
        MathUtils.unitsTowardsCenter(lastPos, _center, _thickness / 2);
    final firstMidPoint =
        MathUtils.unitsTowardsCenter(firstPos, _center, _thickness / 2);

    final firstAngle = MathUtils.angleTowardCenter(firstMidPoint, _center);
    final lastAngle = MathUtils.angleTowardCenter(lastMidPoint, _center);
    final firstTip = makeTip(firstMidPoint, firstAngle, index);
    final lastTip = makeTip(lastMidPoint, lastAngle, index);

    path
      ..lineTo(lastInwardPoint.dx, lastInwardPoint.dy)
      ..lineTo(firstInwardPoint.dx, firstInwardPoint.dy)
      ..addPath(lastTip, Offset.zero)
      ..addPath(firstTip, Offset.zero);

    return path;
  }

  /// Draws a square of diamter equal to the thickness that can be rounded
  /// according to the [_radius] provided. It is then rotated and translated in
  /// place to orient correctly towards either the end or beginning of the
  /// progress bar
  Path makeTip(Offset lastMidPoint, double angle, int index) {
    final isNegative = angle.isNegative;
    final alpha = angle + (isNegative ? pi : 0);
    final isBelow = lastMidPoint.dy > _center.dy;
    var tip = Path()
      ..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromCircle(center: Offset.zero, radius: _thickness / 2),
          topLeft: isBelow ? _radius.bottomLeft : _radius.topRight,
          topRight: isBelow ? _radius.topLeft : _radius.bottomRight,
          bottomLeft: isBelow ? _radius.bottomRight : _radius.topLeft,
          bottomRight: isBelow ? _radius.topRight : _radius.bottomLeft,
        ),
      );
    final translateM = Float64List.fromList([
      1, 0, 0, 0,
      //
      0, 1, 0, 0,
      //
      0, 0, 1, 0,
      //
      lastMidPoint.dx, lastMidPoint.dy, 0, 1,
    ]);
    final rotateM = Float64List.fromList([
      cos(alpha), sin(alpha), 0, 0,
      //
      -sin(alpha), cos(alpha), 0, 0,
      //
      0, 0, 1, 0,
      //
      0, 0, 0, 1,
    ]);
    tip = tip.transform(rotateM);
    tip = tip.transform(translateM);
    return tip;
  }

  /// Creates a circle inside the main progress bar which will hide all the
  /// paths that were lazily placed towards the inside of the circle
  void drawMask(Canvas canvas) {
    canvas.drawArc(
      Rect.fromCenter(
        center: _center,
        width: _width - 2 * _thickness,
        height: _height - 2 * _thickness,
      ),
      vmath.radians(0),
      vmath.radians(360),
      false,
      Paint()
        ..style = PaintingStyle.fill
        ..color = Colors.transparent
        ..blendMode = BlendMode.srcOut,
    );
  }
}
