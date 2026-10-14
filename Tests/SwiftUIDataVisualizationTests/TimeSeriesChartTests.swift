import Foundation
import Testing
@testable import SwiftUIDataVisualization

@Suite("Time series chart")
struct TimeSeriesChartTests {
    private let start = Date(timeIntervalSinceReferenceDate: 0)

    @Test func longSeriesAreDownsampledToTheLimit() {
        let series = TimeSeries(name: "Load", values: (0..<10_000).map { sin(Double($0) / 50) }, start: start, interval: 60)
        let plotted = TimeSeriesChart.plottedSeries([series], movingAverageWindow: nil, maximumPointsPerSeries: 500)
        #expect(plotted[0].points.count == 500)
        #expect(plotted[0].points.first == series.points.first)
        #expect(plotted[0].points.last == series.points.last)
    }

    @Test func shortSeriesKeepEveryFinitePoint() {
        let series = TimeSeries(name: "A", values: [1, .nan, 3, .infinity, 5], start: start, interval: 1)
        let plotted = TimeSeriesChart.plottedSeries([series], movingAverageWindow: nil, maximumPointsPerSeries: 1_000)
        #expect(plotted[0].points.map(\.value) == [1, 3, 5])
        #expect(plotted[0].average.isEmpty)
    }

    @Test func movingAverageIsDatedAtTheEndOfEachWindow() {
        let series = TimeSeries(name: "A", values: [2, 4, 6, 8], start: start, interval: 10)
        let plotted = TimeSeriesChart.plottedSeries([series], movingAverageWindow: 2, maximumPointsPerSeries: 1_000)
        #expect(plotted[0].average.map(\.value) == [3, 5, 7])
        #expect(plotted[0].average.map(\.date) == Array(series.points.dropFirst().map(\.date)))
    }

    @Test(arguments: [Int.min, -1, 0, 1])
    func pointLimitsBelowTwoKeepTheEnds(_ limit: Int) {
        let series = TimeSeries(name: "A", values: [1, 9, 2, 8], start: start, interval: 1)
        let plotted = TimeSeriesChart.plottedSeries([series], movingAverageWindow: nil, maximumPointsPerSeries: limit)
        #expect(plotted[0].points.map(\.value) == [1, 8])
    }

    @Test func windowsBelowTwoDrawNoAverage() {
        let series = TimeSeries(name: "A", values: [1, 2, 3], start: start, interval: 1)
        #expect(TimeSeriesChart.plottedSeries([series], movingAverageWindow: 1, maximumPointsPerSeries: 10)[0].average.isEmpty)
        #expect(TimeSeriesChart.plottedSeries([series], movingAverageWindow: .min, maximumPointsPerSeries: 10)[0].average.isEmpty)
    }

    @Test func readoutUsesTheNearestDrawnPoint() {
        let series = TimeSeries(name: "A", values: [10, 20, 30], start: start, interval: 100)
        let plotted = TimeSeriesChart.plottedSeries([series], movingAverageWindow: nil, maximumPointsPerSeries: 10)[0]
        #expect(plotted.nearestPoint(to: start.addingTimeInterval(140))?.value == 20)
        #expect(plotted.nearestPoint(to: start.addingTimeInterval(1_000))?.value == 30)
    }
}
