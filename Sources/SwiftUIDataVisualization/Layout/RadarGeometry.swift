import CoreGraphics
import Foundation

/// Where the axes and values of a ``RadarChart`` go.
///
/// Axis 0 points straight up and the others follow clockwise at equal angles, in screen
/// coordinates (y grows downwards).
public enum RadarGeometry {
    /// The angle of an axis in radians, measured from the positive x axis towards positive y.
    /// Axis 0 is at `-π / 2` (up).
    public static func angle(axis: Int, axisCount: Int) -> Double {
        guard axisCount > 0 else { return -Double.pi / 2 }
        return -Double.pi / 2 + 2 * Double.pi * Double(axis) / Double(axisCount)
    }

    /// The point for `value` on an axis, where `0` is the center and `maximum` is `radius` away.
    ///
    /// Values are clamped to `0...maximum`; a `maximum` that is not positive and finite, a value
    /// that is not finite or a radius that is not positive and finite gives the center.
    public static func point(
        value: Double,
        maximum: Double,
        axis: Int,
        axisCount: Int,
        center: CGPoint,
        radius: CGFloat
    ) -> CGPoint {
        guard maximum > 0, maximum.isFinite, value.isFinite, radius > 0, radius.isFinite else { return center }
        let fraction = min(max(value / maximum, 0), 1)
        let angle = angle(axis: axis, axisCount: axisCount)
        let distance = Double(radius) * fraction
        return CGPoint(
            x: Double(center.x) + cos(angle) * distance,
            y: Double(center.y) + sin(angle) * distance
        )
    }

    /// The corners of the polygon that joins `values`, one per axis.
    public static func polygon(values: [Double], maximum: Double, center: CGPoint, radius: CGFloat) -> [CGPoint] {
        values.indices.map { axis in
            point(value: values[axis], maximum: maximum, axis: axis, axisCount: values.count, center: center, radius: radius)
        }
    }
}
