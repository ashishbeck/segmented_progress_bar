import 'dart:math';
import 'dart:ui';

/// {@template math_utils}
/// Basic mathematical functions to determine offsets and angles
/// {@endtemplate}
class MathUtils {
  /// {@macro math_utils}
  MathUtils._();

  /// Returns the offset for the position where the [path] was started from
  static Offset findFirstPosition(Path path) {
    try {
      final firstMetric = path.computeMetrics().toList().first;
      final tangent = firstMetric.getTangentForOffset(0);
      return tangent!.position;
    } catch (e) {
      return Offset.zero;
    }
  }

  /// Returns the offset for the position where the [path] was last drawn on
  static Offset findLastPosition(Path path) {
    try {
      final lastMetric = path.computeMetrics().toList().last;
      final tangent = lastMetric.getTangentForOffset(lastMetric.length + 1);
      // print('last pos is ${tangent!.position}');
      return tangent!.position;
    } catch (e) {
      return Offset.zero;
    }
  }

  /// Returns the offset for a point towards the center of a circle from any
  /// given point in the circle
  static Offset unitsTowardsCenter(Offset point, Offset center, double units) {
    final x1 = point.dx;
    final x2 = center.dx;
    final y1 = point.dy;
    final y2 = center.dy;
    final x = x1 + units * (x2 - x1) / sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
    final y = y1 + units * (y2 - y1) / sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
    return Offset(x, y);
  }

  /// Converts the distance along the circle (arc) into angle in degrees
  static double distanceToAngle(double distance, double radius) {
    // arc = (angle/360) * 2 * pi * r
    // angle = (arc * 360)/2*pi*r
    return (distance * 360) / (2 * pi * radius);
  }

  /// The amount of radians needed to orient the object at a point in circle
  /// to face towards the center
  static double angleTowardCenter(Offset point, Offset center) {
    // angle = tan^-1((y_center - y_object)/(x_center - x_object))
    final angle = atan((center.dy - point.dy) / (center.dx - point.dx));
    return angle;
  }
}
