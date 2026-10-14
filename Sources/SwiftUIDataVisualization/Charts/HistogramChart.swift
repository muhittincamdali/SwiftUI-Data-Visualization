import Charts
import SwiftUI

/// The distribution of a list of values as adjacent bars, one per ``Histogram`` bin.
///
/// ```swift
/// HistogramChart(values: responseTimes, valueLabel: "Response time (ms)")
///     .frame(height: 200)
/// ```
///
/// Each bar spans its bin on the horizontal axis, so uneven or wide ranges read correctly, and
/// its height is the number of values in the bin. A small gap separates the bars.
public struct HistogramChart: View {
    private let histogram: Histogram
    private let valueLabel: String

    @Environment(\.chartPalette) private var palette

    /// The share of each bin's width left empty between neighbouring bars.
    nonisolated static let gapFraction = 0.04

    /// Creates a chart of bins you have already computed.
    public init(_ histogram: Histogram, valueLabel: String = "Value") {
        self.histogram = histogram
        self.valueLabel = valueLabel
    }

    /// Bins `values` with `binning` and charts the result.
    public init(values: [Double], binning: Histogram.Binning = .automatic, valueLabel: String = "Value") {
        self.init(Histogram(values: values, binning: binning), valueLabel: valueLabel)
    }

    public var body: some View {
        Chart(histogram.bins) { bin in
            let bar = Self.barRange(for: bin)
            RectangleMark(
                xStart: .value(valueLabel, bar.lowerBound),
                xEnd: .value(valueLabel, bar.upperBound),
                yStart: .value("Count", 0),
                yEnd: .value("Count", bin.count)
            )
            .foregroundStyle(palette.color(at: 0).gradient)
            .accessibilityLabel(Self.describe(bin))
            .accessibilityValue("\(bin.count)")
        }
        .chartXAxisLabel(valueLabel)
        .chartYAxisLabel("Count")
    }

    /// The horizontal extent of the bar for `bin`, inset by ``gapFraction`` of its width.
    nonisolated static func barRange(for bin: Histogram.Bin) -> ClosedRange<Double> {
        let inset = (bin.upperBound / 2 - bin.lowerBound / 2) * gapFraction
        guard inset.isFinite, inset > 0 else { return bin.lowerBound...bin.upperBound }
        return (bin.lowerBound + inset)...(bin.upperBound - inset)
    }

    /// The bin's range as VoiceOver reads it.
    nonisolated static func describe(_ bin: Histogram.Bin) -> String {
        let format = FloatingPointFormatStyle<Double>.number.precision(.significantDigits(1...6))
        return "\(bin.lowerBound.formatted(format)) to \(bin.upperBound.formatted(format))"
    }
}
