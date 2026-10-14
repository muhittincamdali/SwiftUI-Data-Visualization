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
public struct NiceScale: Hashable, Sendable {
    /// The first tick, at or below the smallest value.
    public let lowerBound: Double
    /// The last tick, at or above the largest value.
    public let upperBound: Double
    /// The distance between ticks: 1, 2 or 5 times a power of ten.
    public let step: Double

    /// Creates a scale that covers `lower...upper` with about `desiredTickCount` ticks.
    ///
    /// The bounds may be passed in either order. When they are equal, the scale is built for a
    /// range one unit wide, centered on the value. `desiredTickCount` below 2 counts as 2.
    /// Non-finite bounds give the scale `0...1`.
    public init(lower: Double, upper: Double, desiredTickCount: Int = 5) {
        guard lower.isFinite, upper.isFinite else {
            self.init(lowerBound: 0, upperBound: 1, step: 1)
            return
        }
        var low = min(lower, upper)
        var high = max(lower, upper)
        if low == high {
            low -= 0.5
            high += 0.5
        }
        let intervals = Double(max(desiredTickCount, 2) - 1)
        let range = Self.niceNumber(high - low, rounded: false)
        let step = Self.niceNumber(range / intervals, rounded: true)
        self.init(
            lowerBound: (low / step).rounded(.down) * step,
            upperBound: (high / step).rounded(.up) * step,
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
        let count = Int(((upperBound - lowerBound) / step).rounded()) + 1
        let decimals = max(0, -Int((log10(step)).rounded(.down)))
        let factor = pow(10, Double(decimals))
        return (0..<count).map { index in
            let raw = lowerBound + Double(index) * step
            return (raw * factor).rounded() / factor
        }
    }

    /// A number close to `value` whose mantissa is 1, 2, 5 or 10.
    ///
    /// `rounded` picks the closest such number; otherwise the result is the smallest one that is
    /// not below `value`.
    static func niceNumber(_ value: Double, rounded: Bool) -> Double {
        guard value > 0 else { return 1 }
        let exponent = log10(value).rounded(.down)
        let magnitude = pow(10, exponent)
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
        return niceFraction * magnitude
    }
}
