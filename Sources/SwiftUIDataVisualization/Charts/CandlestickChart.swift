import Charts
import SwiftUI

/// Open, high, low and close values per period, as used for prices.
///
/// ```swift
/// CandlestickChart(Candle.aggregate(trades, interval: 3_600))
///     .frame(height: 260)
/// ```
///
/// Each candle has a thin wick from the low to the high and a body from the open to the close,
/// in the palette's ``ChartPalette/positive`` color when the period closed at or above its open
/// and ``ChartPalette/negative`` otherwise. Bodies are 60% as wide as the usual gap between
/// candles, so minute, hourly and daily candles all read well without configuration. Candles
/// that are not ``Candle/isValid`` are left out, and the value axis fits the data instead of
/// starting at zero.
public struct CandlestickChart: View {
    private let candles: [Candle]

    @Environment(\.chartPalette) private var palette

    /// The share of the gap between candles that a body fills.
    nonisolated static let bodyWidthFraction = 0.6

    /// Creates a candlestick chart of `candles`, given in any order.
    public init(_ candles: [Candle]) {
        self.candles = candles
    }

    public var body: some View {
        let valid = candles.filter(\.isValid)
        let halfWidth = Self.bodyHalfWidth(for: valid)
        Chart(valid) { candle in
            let color = candle.isRising ? palette.positive : palette.negative
            RuleMark(
                x: .value("Date", candle.date),
                yStart: .value("Low", candle.low),
                yEnd: .value("High", candle.high)
            )
            .foregroundStyle(color)
            RectangleMark(
                xStart: .value("Date", candle.date.addingTimeInterval(-halfWidth)),
                xEnd: .value("Date", candle.date.addingTimeInterval(halfWidth)),
                yStart: .value("Open", candle.open),
                yEnd: .value("Close", candle.close)
            )
            .foregroundStyle(color)
            .accessibilityLabel(candle.date.formatted(date: .abbreviated, time: .shortened))
            .accessibilityValue(Self.describe(candle))
        }
        .chartYScale(domain: .automatic(includesZero: false))
    }

    /// Half the width of a body, in seconds: ``bodyWidthFraction`` of the median gap between
    /// consecutive candles, or of one day when there are fewer than two distinct dates.
    nonisolated static func bodyHalfWidth(for candles: [Candle]) -> TimeInterval {
        let times = candles.map(\.date.timeIntervalSinceReferenceDate).sorted()
        let gaps = zip(times, times.dropFirst()).map { $1 - $0 }.filter { $0 > 0 && $0.isFinite }.sorted()
        let typicalGap = gaps.isEmpty ? 86_400 : gaps[gaps.count / 2]
        return typicalGap * bodyWidthFraction / 2
    }

    /// The candle's values as VoiceOver reads them.
    nonisolated static func describe(_ candle: Candle) -> String {
        let format = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(0...4))
        return "open \(candle.open.formatted(format)), high \(candle.high.formatted(format)), "
            + "low \(candle.low.formatted(format)), close \(candle.close.formatted(format))"
    }
}
