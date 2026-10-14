import Foundation

/// The open, high, low and close values of one period, drawn by ``CandlestickChart``.
public struct Candle: Identifiable, Hashable, Sendable {
    /// The start of the period.
    public var date: Date
    /// The first value of the period.
    public var open: Double
    /// The highest value of the period.
    public var high: Double
    /// The lowest value of the period.
    public var low: Double
    /// The last value of the period.
    public var close: Double

    /// The start of the period; one candle per period.
    public var id: Date { date }

    /// Creates a candle.
    public init(date: Date, open: Double, high: Double, low: Double, close: Double) {
        self.date = date
        self.open = open
        self.high = high
        self.low = low
        self.close = close
    }

    /// Whether the period closed at or above its open.
    public var isRising: Bool { close >= open }

    /// Whether the candle can be drawn: the date lies between `Date.distantPast` and
    /// `Date.distantFuture`, all four values are finite, and the low and the high enclose the
    /// open and the close.
    public var isValid: Bool {
        ChartDates.contains(date)
            && [open, high, low, close].allSatisfy(\.isFinite)
            && low <= min(open, close)
            && high >= max(open, close)
    }

    /// Groups individual measurements (trades, sensor readings) into one candle per `interval`.
    ///
    /// Periods start at multiples of `interval` counted from the reference date (1 January 2001,
    /// UTC), so `interval: 60` gives candles that start on the minute. The ticks may come in any
    /// order; they are sorted by date first, and ticks with equal dates keep their order. Periods
    /// without a tick get no candle. Ticks whose value is not finite, or whose date lies before
    /// `Date.distantPast` or after `Date.distantFuture`, are skipped, and an interval that is not
    /// positive and finite gives no candles.
    ///
    /// ```swift
    /// let minuteCandles = Candle.aggregate(trades, interval: 60)
    /// ```
    public static func aggregate(_ ticks: [TimeSeriesPoint], interval: TimeInterval) -> [Candle] {
        guard interval > 0, interval.isFinite else { return [] }
        let ordered = ticks
            .enumerated()
            .filter { $0.element.value.isFinite && ChartDates.contains($0.element.date) }
            .sorted { ($0.element.date, $0.offset) < ($1.element.date, $1.offset) }
            .map(\.element)

        var candles: [Candle] = []
        for tick in ordered {
            let time = tick.date.timeIntervalSinceReferenceDate
            let start = (time / interval).rounded(.down) * interval
            // An interval so small that the division overflows puts each tick in its own period,
            // and so does one so large that the period would start outside the supported dates.
            let rounded = Date(timeIntervalSinceReferenceDate: start)
            let periodStart = ChartDates.contains(rounded) ? rounded : tick.date
            if let last = candles.last, last.date == periodStart {
                candles[candles.count - 1].high = max(last.high, tick.value)
                candles[candles.count - 1].low = min(last.low, tick.value)
                candles[candles.count - 1].close = tick.value
            } else {
                candles.append(Candle(date: periodStart, open: tick.value, high: tick.value, low: tick.value, close: tick.value))
            }
        }
        return candles
    }
}
