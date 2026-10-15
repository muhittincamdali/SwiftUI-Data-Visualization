import Foundation

/// Round axis bounds and tick marks for a range of values.
///
/// Uses Paul Heckbert's "nice numbers" method (Graphics Gems, 1990): the tick step is 1, 2 or 5
/// times a power of ten, and the bounds are the multiples of that step just outside the data.
///
/// ```swift
/// let scale = NiceScale(lower: 3, upper: 97, desiredTickCount: 6)
/// scale.ticks // [0, 20, 40, 60, 80, 100]
/// ```
///
/// Any input gives a usable scale: the tick count is limited to ``tickCountRange``, ranges wider
/// than `Double` can hold and ranges of subnormal width are computed in a rescaled space, and
/// ``ticks`` never holds more than ``maximumTickCount`` values or a value that is not finite.
public struct NiceScale: Hashable, Sendable {
    /// The first tick, at or below the smallest value.
    public let lowerBound: Double
    /// The last tick, at or above the largest value.
    public let upperBound: Double
    /// The distance between ticks: 1, 2 or 5 times a power of ten.
    public let step: Double

    /// The tick counts the initializer accepts; other counts are clamped to this range.
    public static let tickCountRange = 2...100

    /// The most values ``ticks`` returns.
    public static let maximumTickCount = 1_000

    /// The scale used when the bounds are not finite.
    static let unit = NiceScale(lowerBound: 0, upperBound: 1, step: 1)

    /// Spans above this are computed in a space 10¹⁰ times smaller, so `high - low` and the
    /// step cannot overflow to infinity.
    private static let largeSpan = 1e300
    /// Spans below this are computed in a space 10²⁰ times larger, so the power of ten in
    /// ``niceNumber(_:rounded:)`` does not underflow to zero.
    private static let smallSpan = 1e-290
    /// The largest step of the form 1, 2 or 5 times a power of ten that `Double` holds; used
    /// when the nice step for a span near `Double.greatestFiniteMagnitude` overflows.
    private static let largestStep = 1e308

    /// Creates a scale that covers `lower...upper` with about `desiredTickCount` ticks.
    ///
    /// The bounds may be passed in either order. When they are equal, the scale is built around
    /// the value with a margin of a tenth of its magnitude (at least 0.5) on each side.
    /// `desiredTickCount` is clamped to ``tickCountRange``. Non-finite bounds give the scale
    /// `0...1`.
    public init(lower: Double, upper: Double, desiredTickCount: Int = 5) {
        guard lower.isFinite, upper.isFinite else {
            self = .unit
            return
        }
        var low = min(lower, upper)
        var high = max(lower, upper)
        if low == high {
            let margin = max(0.5, abs(low) / 10)
            low = max(low - margin, -.greatestFiniteMagnitude)
            high = min(high + margin, .greatestFiniteMagnitude)
        }
        let tickCount = min(max(desiredTickCount, Self.tickCountRange.lowerBound), Self.tickCountRange.upperBound)
        let intervals = Double(tickCount - 1)

        // Scaling by a power of ten keeps the step a 1, 2 or 5 multiple of a power of ten.
        let span = high - low
        let scale: Double
        if !span.isFinite || span > Self.largeSpan {
            scale = 1e-10
        } else if span < Self.smallSpan {
            scale = 1e20
        } else {
            scale = 1
        }
        let range = Self.niceNumber(high * scale - low * scale, rounded: false)
        var step = Self.niceNumber(range / intervals, rounded: true) / scale
        // A step below the smallest subnormal rounds to zero; the smallest step there is
        // still covers the data.
        if step == 0 { step = .leastNonzeroMagnitude }
        // With two or three ticks over a span near 1e308 the nice step (2e308 or 5e308) does
        // not fit in a Double.
        if step == .infinity { step = Self.largestStep }
        guard step > 0, step.isFinite else {
            self = .unit
            return
        }
        // A bound whose quotient by the step underflows to zero lands on zero, inside the data
        // (-1e-300 next to 1e31 gave a lower bound of -0.0); it moves out by one step. At the
        // edge of Double's range the outward bound can overflow; it is clamped to the largest
        // finite value, which still covers the data.
        var lowerBound = (low / step).rounded(.down) * step
        if lowerBound > low { lowerBound -= step }
        var upperBound = (high / step).rounded(.up) * step
        if upperBound < high { upperBound += step }
        self.init(
            lowerBound: max(lowerBound, -.greatestFiniteMagnitude),
            upperBound: min(upperBound, .greatestFiniteMagnitude),
            step: step
        )
    }

    private init(lowerBound: Double, upperBound: Double, step: Double) {
        self.lowerBound = lowerBound
        self.upperBound = upperBound
        self.step = step
    }

    /// The tick values from ``lowerBound`` to ``upperBound``.
    ///
    /// Each tick is computed as `lowerBound + index * step` and rounded to the step's decimal
    /// places, so the values do not drift (no `0.30000000000000004`).
    public var ticks: [Double] {
        guard step > 0, step.isFinite, lowerBound.isFinite, upperBound.isFinite, lowerBound <= upperBound else {
            return []
        }
        // Dividing each bound first keeps the difference finite for the widest scales.
        let intervals = (upperBound / step - lowerBound / step).rounded()
        guard intervals.isFinite, intervals >= 0 else { return [] }
        let count = Int(min(intervals, Double(Self.maximumTickCount - 1))) + 1
        let decimals = -Int(log10(step).rounded(.down))
        // 10^22 is the largest power of ten a Double holds exactly; smaller steps skip rounding.
        let factor = (1...22).contains(decimals) ? pow(10, Double(decimals)) : nil
        return (0..<count).map { index in
            let raw = min(lowerBound + Double(index) * step, upperBound)
            guard let factor else { return raw }
            let rounded = (raw * factor).rounded() / factor
            return rounded.isFinite ? rounded : raw
        }
    }

    /// A number close to `value` whose mantissa is 1, 2, 5 or 10.
    ///
    /// `rounded` picks the closest such number; otherwise the result is the smallest one that is
    /// not below `value`. Values that are not positive and finite give 1; when the power of ten
    /// underflows or the result would overflow, `value` itself is returned.
    static func niceNumber(_ value: Double, rounded: Bool) -> Double {
        guard value > 0, value.isFinite else { return 1 }
        let exponent = log10(value).rounded(.down)
        let magnitude = pow(10, exponent)
        guard magnitude > 0, magnitude.isFinite else { return value }
        let fraction = value / magnitude
        let niceFraction: Double
        if rounded {
            switch fraction {
            case ..<1.5: niceFraction = 1
            case ..<3: niceFraction = 2
            case ..<7: niceFraction = 5
            default: niceFraction = 10
            }
        } else {
            switch fraction {
            case ...1: niceFraction = 1
            case ...2: niceFraction = 2
            case ...5: niceFraction = 5
            default: niceFraction = 10
            }
        }
        let nice = niceFraction * magnitude
        return nice.isFinite ? nice : value
    }
}
