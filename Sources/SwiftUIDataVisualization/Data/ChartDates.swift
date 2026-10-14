import Foundation

/// The dates the charts accept.
///
/// Swift Charts stops the process when a date axis reaches about 1e19 seconds from the
/// reference date, so dates and visible durations are kept within
/// `Date.distantPast...Date.distantFuture` (the years 1 to 4001). That is far wider than any
/// measured data, and it keeps every derived date (candle widths, scroll positions) well away
/// from the limit.
enum ChartDates {
    /// The earliest and the latest date a chart draws.
    static let supported = Date.distantPast...Date.distantFuture

    /// The longest duration a chart shows at once: the length of ``supported``, in seconds.
    static let longestDuration = Date.distantFuture.timeIntervalSince(Date.distantPast)

    /// Whether `date` lies in ``supported``; `false` for a date built from `nan` or infinity.
    static func contains(_ date: Date) -> Bool {
        // Compared as numbers: `ClosedRange.contains` derives `<=` from `<` and would accept
        // `nan`.
        let seconds = date.timeIntervalSinceReferenceDate
        return seconds >= supported.lowerBound.timeIntervalSinceReferenceDate
            && seconds <= supported.upperBound.timeIntervalSinceReferenceDate
    }
}
