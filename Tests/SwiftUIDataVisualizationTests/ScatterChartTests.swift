import Foundation
import Testing
@testable import SwiftUIDataVisualization

@Suite("Scatter chart")
struct ScatterChartTests {
    @Test func trendSegmentSpansTheXRange() throws {
        let points = [PlotPoint(x: 4, y: 9), PlotPoint(x: 1, y: 3), PlotPoint(x: 2, y: 5)]
        let segment = try #require(ScatterChart.trendSegment(for: points))
        #expect(segment.start == PlotPoint(x: 1, y: 3))
        #expect(segment.end == PlotPoint(x: 4, y: 9))
        #expect(segment.fit.slope == 2)
    }

    @Test func noTrendWithoutAFit() {
        #expect(ScatterChart.trendSegment(for: [PlotPoint(x: 1, y: 1)]) == nil)
        #expect(ScatterChart.trendSegment(for: [PlotPoint(x: 2, y: 1), PlotPoint(x: 2, y: 5)]) == nil)
    }

    @Test func trendDescriptionNamesSlopeInterceptAndRSquared() throws {
        let segment = try #require(ScatterChart.trendSegment(for: [PlotPoint(x: 0, y: 1), PlotPoint(x: 1, y: 3)]))
        let text = ScatterChart.describe(segment)
        #expect(text.hasPrefix("Trend line: y = "))
        #expect(text.contains("r squared"))
    }
}
