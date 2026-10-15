import Foundation
import SwiftUI
import Testing
@testable import SwiftUIDataVisualization

/// Swift Charts traps on a numeric axis that spans more than about 1.6e308 or reaches below about
/// -1.5e308, although every value is finite; each of these value sets stopped the test process
/// before the charts kept their marks within ChartValues.supported.
@MainActor
@Suite("Extreme inputs: values")
struct ValueExtremeTests {
    nonisolated private static let huge = Double.greatestFiniteMagnitude

    nonisolated private static let valueSets: [[Double]] = [
        [-huge, 5],
        [-1.6e308, 5],
        [1.7e308, -1],
        [-huge, huge],
        [8e307, -8e307, 0],
        [huge, huge / 2, 1],
        [-huge],
    ]

    @Test func clampingKeepsOrdinaryValuesAndLimitsExtremeOnes() {
        #expect(ChartValues.clamped(-3.5) == -3.5)
        #expect(ChartValues.clamped(1e300) == 1e300)
        #expect(ChartValues.clamped(Self.huge) == ChartValues.supported.upperBound)
        #expect(ChartValues.clamped(-Self.huge) == ChartValues.supported.lowerBound)
    }

    @Test func histogramBarsStayWithinTheSupportedValues() {
        let histogram = Histogram(values: [-Self.huge, 0, Self.huge], binning: .count(3))
        for bin in histogram.bins {
            let bar = HistogramChart.barRange(for: bin)
            #expect(ChartValues.supported.contains(bar.lowerBound) && ChartValues.supported.contains(bar.upperBound))
            #expect(bar.lowerBound <= bar.upperBound)
        }
    }

    @Test func boxPlotAxisStaysWithinTheSupportedValues() throws {
        let summary = try #require(BoxPlotSummary(values: [-Self.huge, 0, Self.huge]))
        #expect(BoxPlotChart.valueDomain([summary]) == ChartValues.supported)
    }

    @Test(arguments: valueSets)
    func chartsOfExtremeValuesRender(_ values: [Double]) throws {
        for (name, view) in Self.charts(of: values) {
            let image = try #require(ImageRenderer(content: view.frame(width: 200, height: 120)).cgImage, "\(name)")
            #expect(image.width == 200, "\(name)")
        }
    }

    /// Every chart, given `values` in the role that sets its value axis.
    private static func charts(of values: [Double]) -> [(String, AnyView)] {
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let series = TimeSeries(name: "A", values: values, start: start, interval: 60)
        let indexed = values.enumerated().map { (index: Double($0.offset), value: $0.element) }
        return [
            ("time series", AnyView(TimeSeriesChart(series, style: .area, movingAverageWindow: 2))),
            ("scatter, y", AnyView(ScatterChart(indexed.map { PlotPoint(x: $0.index, y: $0.value) }, showsTrendLine: true))),
            ("scatter, x", AnyView(ScatterChart(indexed.map { PlotPoint(x: $0.value, y: $0.index) }, showsTrendLine: true))),
            ("histogram", AnyView(HistogramChart(values: values))),
            ("box plot", AnyView(BoxPlotChart([.init(name: "A", values: values)]))),
            ("heatmap", AnyView(HeatmapChart(indexed.map { HeatmapCell(column: "c\($0.index)", row: "r", value: $0.value) }, showsValues: true))),
            ("candlestick", AnyView(CandlestickChart(indexed.map {
                Candle(date: start.addingTimeInterval($0.index * 86_400), open: $0.value, high: $0.value, low: $0.value, close: $0.value)
            }))),
            ("waterfall", AnyView(WaterfallChart(indexed.map { WaterfallStep("s\($0.index)", $0.value) } + [.total("Total")]))),
            ("radar", AnyView(RadarChart(axes: ["a", "b", "c"], series: [.init(name: "A", values: values)]))),
            ("treemap", AnyView(TreemapChart(values.map { TreemapItem("i", value: $0) }))),
            ("live ticker", AnyView(LiveTickerChart(values: values))),
        ]
    }
}
