import Accessibility
import Foundation
import SwiftUI

/// Describes a chart's data for VoiceOver's Audio Graphs, which play a series as rising and
/// falling tones and read out its values.
///
/// Swift Charts builds this description by itself. The charts in this package that draw without
/// it (``RadarChart`` and ``LiveTickerChart`` with `Canvas`, ``TreemapChart`` with plain views)
/// attach one of these, and you can do the same for a chart of your own:
///
/// ```swift
/// MyGauge(values: weekly)
///     .accessibilityChartDescriptor(AudioGraphDescriptor(
///         title: "Weekly load",
///         categories: ["Mon", "Tue", "Wed"],
///         series: [.init(name: "Load", values: weekly)]
///     ))
/// ```
public struct AudioGraphDescriptor: AXChartDescriptorRepresentable {
    /// One series of values, in the order of the categories.
    public struct Series: Hashable, Sendable {
        /// The name VoiceOver reads for the series.
        public var name: String
        /// One value per category, or per position when there are no categories.
        public var values: [Double]

        /// Creates a series.
        public init(name: String, values: [Double]) {
            self.name = name
            self.values = values
        }
    }

    /// The chart title.
    public var title: String
    /// A sentence VoiceOver reads before the data, such as the trend.
    public var summary: String?
    /// The name of the horizontal axis.
    public var xAxisTitle: String
    /// Category names for the horizontal axis; `nil` numbers the values from 1.
    public var categories: [String]?
    /// The name of the value axis.
    public var valueAxisTitle: String
    /// The data.
    public var series: [Series]

    /// Creates a description.
    public init(
        title: String,
        summary: String? = nil,
        xAxisTitle: String = "Category",
        categories: [String]? = nil,
        valueAxisTitle: String = "Value",
        series: [Series]
    ) {
        self.title = title
        self.summary = summary
        self.xAxisTitle = xAxisTitle
        self.categories = categories
        self.valueAxisTitle = valueAxisTitle
        self.series = series
    }

    /// The range the value axis covers: the smallest to the largest finite value, widened by one
    /// unit on each side when they are equal, or `0...1` without data.
    public var valueRange: ClosedRange<Double> {
        let finite = series.flatMap(\.values).filter(\.isFinite)
        guard let low = finite.min(), let high = finite.max() else { return 0...1 }
        return low < high ? low...high : (low - 1)...(high + 1)
    }

    /// Builds the descriptor VoiceOver reads: a categorical x axis when ``categories`` is set,
    /// otherwise positions numbered from 1, and a value axis over ``valueRange``.
    public func makeChartDescriptor() -> AXChartDescriptor {
        let valueAxis = AXNumericDataAxisDescriptor(
            title: valueAxisTitle,
            range: valueRange,
            gridlinePositions: [],
            valueDescriptionProvider: Self.describe
        )

        let xAxis: any AXDataAxisDescriptor
        let dataSeries: [AXDataSeriesDescriptor]
        if let categories {
            xAxis = AXCategoricalDataAxisDescriptor(title: xAxisTitle, categoryOrder: categories)
            dataSeries = series.map { series in
                let points = zip(categories, series.values)
                    .filter { $0.1.isFinite }
                    .map { AXDataPoint(x: $0.0, y: $0.1) }
                return AXDataSeriesDescriptor(name: series.name, isContinuous: false, dataPoints: points)
            }
        } else {
            let longest = max(series.map(\.values.count).max() ?? 1, 1)
            xAxis = AXNumericDataAxisDescriptor(
                title: xAxisTitle,
                range: 1...Double(max(longest, 2)),
                gridlinePositions: [],
                valueDescriptionProvider: { $0.formatted(.number.precision(.fractionLength(0))) }
            )
            dataSeries = series.map { series in
                let points = series.values.enumerated()
                    .filter { $0.element.isFinite }
                    .map { AXDataPoint(x: Double($0.offset + 1), y: $0.element) }
                return AXDataSeriesDescriptor(name: series.name, isContinuous: true, dataPoints: points)
            }
        }

        return AXChartDescriptor(
            title: title,
            summary: summary,
            xAxis: xAxis,
            yAxis: valueAxis,
            additionalAxes: [],
            series: dataSeries
        )
    }

    /// How VoiceOver reads a value: up to two decimals in the user's locale.
    @Sendable static func describe(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(0...2)))
    }
}
