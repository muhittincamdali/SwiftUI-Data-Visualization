import CoreGraphics
import Foundation
import SwiftUI
import Testing
@testable import SwiftUIDataVisualization

// Inputs at the edges of Double, Int and Date: each of these used to trap on an Int(_:)
// conversion of nan or infinity, allocate without bound, return nan coordinates, or stop the
// process inside Swift Charts on a date about 1e19 seconds from the reference date.

private let huge = Double.greatestFiniteMagnitude
private let subnormal = Double.leastNonzeroMagnitude

@Suite("Extreme inputs: nice scale")
struct NiceScaleExtremeTests {
    @Test(arguments: [Int.max, 1_000_000, 101])
    func hugeTickCountsAreClamped(_ count: Int) {
        let scale = NiceScale(lower: 0, upper: 100, desiredTickCount: count)
        #expect(scale == NiceScale(lower: 0, upper: 100, desiredTickCount: NiceScale.tickCountRange.upperBound))
        #expect(scale.ticks.count == 101)
    }

    @Test func negativeTickCountsCountAsTwo() {
        #expect(NiceScale(lower: 0, upper: 100, desiredTickCount: .min) == NiceScale(lower: 0, upper: 100, desiredTickCount: 2))
    }

    @Test(arguments: [(-huge, huge), (0, huge), (-huge, 0), (-huge, -huge / 2), (1e308, huge)] as [(Double, Double)])
    func rangesThatOverflowStayFinite(_ bounds: (Double, Double)) {
        let scale = NiceScale(lower: bounds.0, upper: bounds.1)
        #expect(scale.step > 0 && scale.step.isFinite)
        #expect(scale.lowerBound.isFinite && scale.upperBound.isFinite)
        #expect(scale.lowerBound <= bounds.0 && scale.upperBound >= bounds.1)
        let ticks = scale.ticks
        #expect(ticks.count >= 2 && ticks.count <= NiceScale.maximumTickCount)
        #expect(ticks.allSatisfy { $0.isFinite })
        #expect(ticks == ticks.sorted())
    }

    @Test(arguments: [huge, -huge, 1e300, 5])
    func equalExtremeBoundsGetAUsableRange(_ value: Double) {
        let scale = NiceScale(lower: value, upper: value)
        // At ±greatestFiniteMagnitude one bound can only equal the value.
        #expect(scale.lowerBound <= value && scale.upperBound >= value)
        #expect(scale.lowerBound < scale.upperBound)
        #expect(scale.ticks.count >= 2)
        #expect(scale.ticks.allSatisfy { $0.isFinite })
    }

    @Test(arguments: [(0, subnormal), (0, Double.leastNormalMagnitude), (1e-310, 3e-310), (-subnormal, subnormal)] as [(Double, Double)])
    func subnormalRangesStayFiniteAndCoverTheData(_ bounds: (Double, Double)) {
        let scale = NiceScale(lower: bounds.0, upper: bounds.1)
        #expect(scale.step > 0 && scale.step.isFinite)
        #expect(scale.lowerBound <= bounds.0 && scale.upperBound >= bounds.1)
        let ticks = scale.ticks
        #expect(ticks.count >= 2 && ticks.count <= NiceScale.maximumTickCount)
        #expect(ticks.allSatisfy { $0.isFinite })
    }

    @Test func niceNumberNeverOverflowsOrUnderflows() {
        #expect(NiceScale.niceNumber(huge, rounded: false) == huge)
        #expect(NiceScale.niceNumber(.infinity, rounded: true) == 1)
        #expect(NiceScale.niceNumber(.nan, rounded: true) == 1)
        #expect(NiceScale.niceNumber(subnormal, rounded: true) > 0)
    }
}

@Suite("Extreme inputs: histogram")
struct HistogramExtremeTests {
    static let binnings: [Histogram.Binning] = [
        .automatic, .sturges, .freedmanDiaconis, .count(1), .count(7), .count(.max), .width(1), .width(1e-300),
    ]

    @Test(arguments: binnings)
    func rangesThatOverflowAreCountedCompletely(_ binning: Histogram.Binning) {
        let values = [-huge, -1, 0, 1, huge / 2, huge]
        let histogram = Histogram(values: values, binning: binning)
        #expect(histogram.totalCount == values.count)
        #expect(histogram.bins.count <= Histogram.maximumBinCount)
        #expect(histogram.bins.allSatisfy { $0.lowerBound.isFinite && $0.upperBound.isFinite })
        #expect(histogram.bins.allSatisfy { $0.lowerBound <= $0.upperBound })
        #expect(histogram.bins.first?.lowerBound ?? .nan <= -huge)
        #expect(histogram.bins.last?.upperBound ?? .nan >= huge)
    }

    @Test func tinyWidthOverAWideRangeIsCappedAndReachesTheMaximum() {
        let histogram = Histogram(values: [0, 1e12], binning: .width(1e-10))
        #expect(histogram.bins.count == Histogram.maximumBinCount)
        #expect(histogram.bins.last?.upperBound == 1e12)
        #expect(histogram.bins.last?.count == 1)
        #expect(histogram.totalCount == 2)
    }

    @Test(arguments: [huge, -huge, 1e300])
    func identicalExtremeValuesShareOneNonEmptyBin(_ value: Double) {
        let bins = Histogram(values: [value, value]).bins
        #expect(bins.count == 1)
        #expect(bins[0].lowerBound < bins[0].upperBound)
        #expect(bins[0].count == 2)
    }

    @Test func subnormalRangeIsCounted() {
        let histogram = Histogram(values: [0, subnormal, 2 * subnormal, 3 * subnormal])
        #expect(histogram.totalCount == 4)
        #expect(histogram.bins.allSatisfy { $0.lowerBound.isFinite && $0.upperBound.isFinite })
    }

    @Test func clampedCountNeverTraps() {
        #expect(Histogram.clampedCount(.nan, upTo: 10) == 10)
        #expect(Histogram.clampedCount(.infinity, upTo: 10) == 10)
        #expect(Histogram.clampedCount(-.infinity, upTo: 10) == 1)
        #expect(Histogram.clampedCount(1e300, upTo: 10) == 10)
        #expect(Histogram.clampedCount(3.2, upTo: 10) == 4)
    }
}

@Suite("Extreme inputs: statistics and trends")
struct StatisticsExtremeTests {
    @Test func meanOfHugeValuesDoesNotOverflow() {
        #expect(Statistics.mean([huge, huge]) == huge)
        #expect(Statistics.mean([huge, -huge]) == 0)
    }

    @Test func quantileBetweenOppositeExtremesIsFinite() throws {
        #expect(Statistics.median([-huge, huge]) == 0)
        let upperQuartile = try #require(Statistics.quantile([-huge, huge], 0.75))
        #expect(abs(upperQuartile - huge / 2) <= huge * 1e-15)
    }

    @Test func boxPlotOfExtremeValuesIsFinite() throws {
        let summary = try #require(BoxPlotSummary(values: [-huge, 0, huge]))
        #expect(summary.median == 0)
        #expect(summary.lowerWhisker.isFinite && summary.upperWhisker.isFinite)
    }

    @Test func regressionThatOverflowsGivesNil() {
        #expect(LinearRegression(points: [.init(x: -huge, y: -huge), .init(x: huge, y: huge)]) == nil)
    }

    @Test func regressionOnLargeButSafeValuesStaysExact() throws {
        let fit = try #require(LinearRegression(points: [.init(x: 0, y: 1e150), .init(x: 1e150, y: 3e150)]))
        #expect(abs(fit.slope - 2) < 1e-12)
        #expect(fit.rSquared == 1)
    }

    @Test func simpleAverageSkipsWindowsWithNonFiniteValues() {
        let averages = MovingAverage.simple([1, 2, .nan, 4, 5, 6, .infinity, 8], window: 2)
        #expect(averages == [nil, 1.5, nil, nil, 4.5, 5.5, nil, nil])
    }

    @Test func simpleAverageOfHugeValuesDoesNotOverflow() {
        #expect(MovingAverage.simple([huge, huge, huge], window: 2) == [nil, huge, huge])
    }

    @Test func exponentialAverageIgnoresNonFiniteValues() {
        #expect(MovingAverage.exponential([.nan, 10, .infinity, 20], smoothing: 0.5) == [nil, 10, 10, 15])
    }
}

@Suite("Extreme inputs: data, streaming and layout")
struct DataExtremeTests {
    @Test func timeSeriesDropsPointsWithoutAFiniteDate() {
        let series = TimeSeries(name: "A", points: [
            .init(date: Date(timeIntervalSinceReferenceDate: 2), value: 2),
            .init(date: Date(timeIntervalSinceReferenceDate: .nan), value: 9),
            .init(date: Date(timeIntervalSinceReferenceDate: .infinity), value: 9),
            .init(date: Date(timeIntervalSinceReferenceDate: 1), value: 1),
        ])
        #expect(series.points.map(\.value) == [1, 2])
    }

    @Test func candlesSkipTicksWithoutAFiniteDate() {
        let candles = Candle.aggregate([
            .init(date: Date(timeIntervalSinceReferenceDate: .nan), value: 50),
            .init(date: Date(timeIntervalSinceReferenceDate: 10), value: 1),
        ], interval: 60)
        #expect(candles.count == 1)
        #expect(candles[0].high == 1)
    }

    @Test func subnormalIntervalGivesOneCandlePerTick() {
        let ticks = (1...3).map { TimeSeriesPoint(date: Date(timeIntervalSinceReferenceDate: Double($0) * 1e10), value: Double($0)) }
        let candles = Candle.aggregate(ticks, interval: subnormal)
        #expect(candles.map(\.close) == [1, 2, 3])
        #expect(candles.allSatisfy { $0.date.timeIntervalSinceReferenceDate.isFinite })
    }

    @Test func ringBufferWithMaximumCapacityDoesNotReserveIt() {
        var buffer = RingBuffer<Double>(capacity: .max)
        buffer.append(contentsOf: [1, 2, 3])
        #expect(buffer.capacity == .max)
        #expect(Array(buffer) == [1, 2, 3])
        #expect(!buffer.isFull)
    }

    @Test func liveSeriesWithMaximumCapacityKeepsWorking() async {
        await MainActor.run {
            let series = LiveSeries(capacity: .max)
            series.append(contentsOf: [3, .nan, 4])
            #expect(series.values == [3, 4])
        }
    }

    @Test func treemapOfHugeValuesFillsTheRectangle() {
        let rect = CGRect(x: 0, y: 0, width: 100, height: 50)
        let tiles = TreemapLayout.squarify([huge, huge, huge / 2], in: rect)
        let area = tiles.reduce(0) { $0 + $1.width * $1.height }
        #expect(abs(area - 5_000) < 1e-6)
        #expect(abs(tiles[0].width * tiles[0].height - 2_000) < 1e-6)
    }

    @Test func treemapInANonFiniteRectangleGivesEmptyTiles() {
        let infinite = CGRect(x: 0, y: 0, width: CGFloat.infinity, height: 10)
        #expect(TreemapLayout.squarify([1, 2], in: infinite).allSatisfy { $0.isEmpty })
        let nanOrigin = CGRect(x: CGFloat.nan, y: 0, width: 10, height: 10)
        #expect(TreemapLayout.squarify([1, 2], in: nanOrigin).allSatisfy { $0 == .zero })
    }

    @Test func radarPointsStayAtTheCenterForInvalidScales() {
        let center = CGPoint(x: 5, y: 5)
        #expect(RadarGeometry.point(value: 1, maximum: .infinity, axis: 0, axisCount: 3, center: center, radius: 10) == center)
        #expect(RadarGeometry.point(value: 1, maximum: 1, axis: 0, axisCount: 3, center: center, radius: .nan) == center)
        #expect(RadarGeometry.point(value: 1, maximum: 1, axis: 0, axisCount: 3, center: center, radius: .infinity) == center)
    }
}

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
