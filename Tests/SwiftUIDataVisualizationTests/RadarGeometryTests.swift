import CoreGraphics
import Testing
@testable import SwiftUIDataVisualization

@Suite("Radar geometry")
struct RadarGeometryTests {
    private let center = CGPoint(x: 100, y: 100)

    private func isClose(_ lhs: CGPoint, _ rhs: CGPoint) -> Bool {
        abs(lhs.x - rhs.x) < 1e-9 && abs(lhs.y - rhs.y) < 1e-9
    }

    @Test func firstAxisPointsUpAndTheRestFollowClockwise() {
        let corners = RadarGeometry.polygon(values: [10, 10, 10, 10], maximum: 10, center: center, radius: 50)
        #expect(isClose(corners[0], CGPoint(x: 100, y: 50)))   // up
        #expect(isClose(corners[1], CGPoint(x: 150, y: 100)))  // right
        #expect(isClose(corners[2], CGPoint(x: 100, y: 150)))  // down
        #expect(isClose(corners[3], CGPoint(x: 50, y: 100)))   // left
    }

    @Test func valuesScaleLinearlyFromTheCenter() {
        let half = RadarGeometry.point(value: 5, maximum: 10, axis: 1, axisCount: 4, center: center, radius: 50)
        #expect(isClose(half, CGPoint(x: 125, y: 100)))
    }

    @Test func valuesAreClampedToTheRange() {
        let over = RadarGeometry.point(value: 30, maximum: 10, axis: 0, axisCount: 3, center: center, radius: 50)
        let under = RadarGeometry.point(value: -4, maximum: 10, axis: 0, axisCount: 3, center: center, radius: 50)
        #expect(isClose(over, CGPoint(x: 100, y: 50)))
        #expect(isClose(under, center))
    }

    @Test func invalidInputGivesTheCenter() {
        #expect(RadarGeometry.point(value: 5, maximum: 0, axis: 0, axisCount: 3, center: center, radius: 50) == center)
        #expect(RadarGeometry.point(value: .nan, maximum: 10, axis: 0, axisCount: 3, center: center, radius: 50) == center)
    }

    @Test func axesAreEvenlySpaced() {
        let count = 5
        let angles = (0..<count).map { RadarGeometry.angle(axis: $0, axisCount: count) }
        for (angle, next) in zip(angles, angles.dropFirst()) {
            #expect(abs(next - angle - 2 * Double.pi / Double(count)) < 1e-12)
        }
    }
}
