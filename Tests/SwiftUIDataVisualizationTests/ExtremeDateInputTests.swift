import Foundation
import SwiftUI
import Testing
@testable import SwiftUIDataVisualization

/// Swift Charts traps on a date axis that reaches about 1e19 seconds; 1e18 still draws.
@MainActor
@Suite("Extreme inputs: dates")
struct DateExtremeTests {
    nonisolated private static let unsupportedTimes: [TimeInterval] = [1e20, -1e20, 1e300, -1e300, 1e19]

    private func date(_ seconds: TimeInterval) -> Date {
        Date(timeIntervalSinceReferenceDate: seconds)
    }

    @Test func timeSeriesKeepsOnlySupportedDates() {
        let series = TimeSeries(name: "A", points: [
            .init(date: .distantFuture, value: 3),
            .init(date: date(1e20), value: 9),
            .init(date: .distantPast, value: 1),
            .init(date: date(-1e300), value: 9),
            .init(date: date(1e11), value: 9),
            .init(date: date(0), value: 2),
        ])
        #expect(series.points.map(\.value) == [1, 2, 3])
    }

    @Test(arguments: unsupportedTimes)
    func candlesWithUnsupportedDatesAreNotValid(_ seconds: TimeInterval) {
        #expect(!Candle(date: date(seconds), open: 1, high: 2, low: 0, close: 1).isValid)
        #expect(Candle(date: .distantFuture, open: 1, high: 2, low: 0, close: 1).isValid)
    }

    @Test func aggregateSkipsTicksWithUnsupportedDates() {
        let ticks = Self.unsupportedTimes.map { TimeSeriesPoint(date: date($0), value: 50) }
            + [TimeSeriesPoint(date: date(10), value: 1)]
        let candles = Candle.aggregate(ticks, interval: 60)
        #expect(candles.map(\.close) == [1])
        #expect(candles[0].high == 1)
    }

    @Test func periodsThatWouldStartOutsideTheSupportedDatesStartAtTheTick() {
        // floor(-5 / 1e300) × 1e300 is -1e300, far before the year 1.
        let candles = Candle.aggregate([.init(date: date(-5), value: 1), .init(date: date(5), value: 2)], interval: 1e300)
        #expect(candles.map(\.date) == [date(-5), date(0)])
        #expect(candles.allSatisfy { $0.isValid })
    }

    @Test func scrollWindowLengthIsCapped() throws {
        let series = TimeSeries(name: "A", values: [1, 2], start: date(0), interval: 60)
        let plotted = TimeSeriesChart.plottedSeries([series], movingAverageWindow: nil, maximumPointsPerSeries: 10)
        let window = try #require(TimeSeriesChart.scrollWindow(for: plotted, visibleDuration: 1e20))
        #expect(window.length == ChartDates.longestDuration)
        #expect(ChartDates.contains(window.start))
        #expect(TimeSeriesChart.scrollWindow(for: plotted, visibleDuration: 3_600)?.length == 3_600)
    }

    @Test func chartsWithUnsupportedDatesRender() throws {
        let farSeries = TimeSeries(name: "Far", values: [1, 2], start: date(1e20), interval: 60)
        let normalSeries = TimeSeries(name: "Near", values: [1, 2, 3], start: date(0), interval: 60)
        let edges = TimeSeries(name: "Edges", points: [.init(date: .distantPast, value: 1), .init(date: .distantFuture, value: 2)])
        let views: [AnyView] = [
            AnyView(TimeSeriesChart(farSeries)),
            AnyView(TimeSeriesChart(normalSeries, visibleDuration: 1e20)),
            AnyView(TimeSeriesChart(normalSeries, selection: .constant(date(1e20)))),
            AnyView(TimeSeriesChart(edges)),
            AnyView(CandlestickChart([Candle(date: date(1e300), open: 1, high: 2, low: 0, close: 1)])),
            AnyView(CandlestickChart([
                Candle(date: .distantPast, open: 1, high: 2, low: 0, close: 1),
                Candle(date: .distantFuture, open: 1, high: 2, low: 0, close: 2),
            ])),
        ]
        for view in views {
            let image = try #require(ImageRenderer(content: view.frame(width: 200, height: 120)).cgImage)
            #expect(image.width == 200)
        }
    }
}
