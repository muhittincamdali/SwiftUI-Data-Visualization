import Charts
import SwiftUI

/// One box and whiskers per group of values, for comparing distributions side by side.
///
/// ```swift
/// BoxPlotChart([
///     .init(name: "iOS", values: iosLaunchTimes),
///     .init(name: "macOS", values: macLaunchTimes),
/// ], valueLabel: "Launch time (s)")
/// ```
///
/// Each box runs from the first to the third quartile with a line at the median; the whiskers
/// reach the most extreme values within 1.5 interquartile ranges, and the values beyond them are
/// drawn as points. See ``BoxPlotSummary`` for the rules. Groups without a finite value are left
/// out, and values beyond ±1e307 are drawn at that limit.
public struct BoxPlotChart: View {
    /// A named list of values that becomes one box.
    public struct Group: Identifiable, Hashable, Sendable {
        /// The label under the box. Names in one chart should be unique.
        public var name: String
        /// The values to summarize.
        public var values: [Double]

        /// The group name.
        public var id: String { name }

        /// Creates a group.
        public init(name: String, values: [Double]) {
            self.name = name
            self.values = values
        }
    }

    private let groups: [Group]
    private let valueLabel: String

    @Environment(\.chartPalette) private var palette

    /// Creates a box plot of `groups`, in their order.
    public init(_ groups: [Group], valueLabel: String = "Value") {
        self.groups = groups
        self.valueLabel = valueLabel
    }

    public var body: some View {
        let boxes = Self.summaries(of: groups)
        Chart {
            ForEach(Array(boxes.enumerated()), id: \.offset) { index, box in
                let color = palette.color(at: index)
                let summary = box.summary
                // Two whiskers, so neither line shows through the translucent box.
                RuleMark(
                    x: .value("Group", box.name),
                    yStart: .value(valueLabel, ChartValues.clamped(summary.lowerWhisker)),
                    yEnd: .value(valueLabel, ChartValues.clamped(summary.firstQuartile))
                )
                .foregroundStyle(color)
                RuleMark(
                    x: .value("Group", box.name),
                    yStart: .value(valueLabel, ChartValues.clamped(summary.thirdQuartile)),
                    yEnd: .value(valueLabel, ChartValues.clamped(summary.upperWhisker))
                )
                .foregroundStyle(color)
                BarMark(
                    x: .value("Group", box.name),
                    yStart: .value(valueLabel, ChartValues.clamped(summary.firstQuartile)),
                    yEnd: .value(valueLabel, ChartValues.clamped(summary.thirdQuartile)),
                    width: .ratio(0.5)
                )
                .foregroundStyle(color.opacity(0.35))
                .accessibilityLabel(box.name)
                .accessibilityValue(Self.describe(summary))
                RectangleMark(
                    x: .value("Group", box.name),
                    y: .value(valueLabel, ChartValues.clamped(summary.median)),
                    width: .ratio(0.5),
                    height: 2
                )
                .foregroundStyle(color)
                ForEach(Array(summary.outliers.enumerated()), id: \.offset) { _, outlier in
                    PointMark(x: .value("Group", box.name), y: .value(valueLabel, ChartValues.clamped(outlier)))
                        .foregroundStyle(color)
                        .symbolSize(24)
                }
            }
        }
        .chartYAxisLabel(valueLabel)
        .chartYScale(domain: Self.valueDomain(boxes.map(\.summary)))
    }

    /// The value axis: from the lowest to the highest whisker or outlier, rounded outward by
    /// ``NiceScale`` and kept within ``ChartValues/supported``. Bars would otherwise pull the axis
    /// down to zero.
    nonisolated static func valueDomain(_ summaries: [BoxPlotSummary]) -> ClosedRange<Double> {
        let values = summaries.flatMap { [$0.lowerWhisker, $0.upperWhisker] + $0.outliers }
        guard let low = values.min(), let high = values.max() else { return 0...1 }
        let scale = NiceScale(lower: ChartValues.clamped(low), upper: ChartValues.clamped(high))
        return scale.lowerBound...scale.upperBound
    }

    /// The summary of each group that has a finite value, in order.
    nonisolated static func summaries(of groups: [Group]) -> [(name: String, summary: BoxPlotSummary)] {
        groups.compactMap { group in
            BoxPlotSummary(values: group.values).map { (group.name, $0) }
        }
    }

    /// The five numbers as VoiceOver reads them.
    nonisolated static func describe(_ summary: BoxPlotSummary) -> String {
        let format = FloatingPointFormatStyle<Double>.number.precision(.significantDigits(1...6))
        var text = "median \(summary.median.formatted(format)), "
            + "quartiles \(summary.firstQuartile.formatted(format)) to \(summary.thirdQuartile.formatted(format)), "
            + "range \(summary.lowerWhisker.formatted(format)) to \(summary.upperWhisker.formatted(format))"
        switch summary.outliers.count {
        case 0: break
        case 1: text += ", 1 outlier"
        case let count: text += ", \(count) outliers"
        }
        return text
    }
}
