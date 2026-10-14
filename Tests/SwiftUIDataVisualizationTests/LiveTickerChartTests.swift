import CoreGraphics
import Testing
@testable import SwiftUIDataVisualization

@Suite("Live ticker chart")
struct LiveTickerChartTests {
    private let size = CGSize(width: 100, height: 50)

    @Test func pointsSpanTheWidthAndHeight() {
        let points = LiveTickerChart.points(for: [0, 5, 10], in: size)
        #expect(points == [CGPoint(x: 0, y: 50), CGPoint(x: 50, y: 25), CGPoint(x: 100, y: 0)])
    }

    @Test func flatSeriesIsDrawnAcrossTheMiddle() {
        #expect(LiveTickerChart.points(for: [7, 7], in: size).map(\.y) == [25, 25])
    }

    @Test func fewerThanTwoValuesDrawNothing() {
        #expect(LiveTickerChart.points(for: [], in: size).isEmpty)
        #expect(LiveTickerChart.points(for: [3], in: size).isEmpty)
    }

    @Test func extremeValuesStayInsideTheCanvas() {
        let huge = Double.greatestFiniteMagnitude
        let points = LiveTickerChart.points(for: [-huge, 0, huge], in: size)
        #expect(points.map(\.y) == [50, 25, 0])
    }
}
