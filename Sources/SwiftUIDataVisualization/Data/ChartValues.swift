import Foundation

/// The values the charts draw.
///
/// Swift Charts stops the process when a numeric axis spans more than about 1.6e308 or reaches
/// below about -1.5e308, both finite values: rounding the axis outward overflows, and the result
/// is converted to `Int`. The value a chart passes to a mark is therefore kept within
/// ``supported``, a range eight times narrower than the first one that fails. Only the drawn
/// position is limited; accessibility labels, readouts and printed values keep the original
/// value.
enum ChartValues {
    /// The smallest and the largest value a mark is drawn at.
    static let supported = -1e307...1e307

    /// `value` moved into ``supported``. Values that are not finite are left out before this is
    /// called.
    static func clamped(_ value: Double) -> Double {
        min(max(value, supported.lowerBound), supported.upperBound)
    }
}
