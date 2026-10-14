import Foundation

/// Descriptive statistics used by the statistical charts.
///
/// Every function ignores values that are not finite (`nan`, `infinity`) and returns `nil`
/// when no value is left, so an empty data set never turns into a misleading zero.
public enum Statistics {
    /// The arithmetic mean.
    ///
    /// When the plain sum overflows (values near `Double.greatestFiniteMagnitude`), each value
    /// is divided by the count before adding, so the mean stays finite.
    public static func mean(_ values: [Double]) -> Double? {
        let finite = values.filter(\.isFinite)
        guard !finite.isEmpty else { return nil }
        let count = Double(finite.count)
        let sum = finite.reduce(0, +)
        return sum.isFinite ? sum / count : finite.reduce(0) { $0 + $1 / count }
    }

    /// The median, the 0.5 quantile.
    public static func median(_ values: [Double]) -> Double? {
        quantile(values, 0.5)
    }

    /// The `probability` quantile with linear interpolation between the closest ranks.
    ///
    /// This is the method most spreadsheet and statistics tools use by default (Hyndman and
    /// Fan's type 7, Excel's `PERCENTILE.INC`, NumPy's `linear`). `probability` is clamped to
    /// `0...1`, so `0` is the minimum and `1` the maximum.
    public static func quantile(_ values: [Double], _ probability: Double) -> Double? {
        quantile(sorted: values.filter(\.isFinite).sorted(), probability)
    }

    /// The variance. `sample` divides by `n - 1` (the default, for a sample of a larger
    /// population); `false` divides by `n`. A sample variance needs at least two values.
    ///
    /// Returns `nil` as well when the variance is larger than `Double.greatestFiniteMagnitude`
    /// (values near ±1e154 and beyond); ``standardDeviation(_:sample:)`` is still available
    /// then.
    public static func variance(_ values: [Double], sample: Bool = true) -> Double? {
        guard let spread = spread(values, sample: sample) else { return nil }
        let variance = spread.scaledVariance * spread.scale * spread.scale
        return variance.isFinite ? variance : nil
    }

    /// The standard deviation, the square root of ``variance(_:sample:)``. It is computed on
    /// scaled values when the squared deviations overflow, so it stays finite for any finite
    /// input.
    public static func standardDeviation(_ values: [Double], sample: Bool = true) -> Double? {
        spread(values, sample: sample).map { $0.scaledVariance.squareRoot() * $0.scale }
    }

    /// The variance of the finite values after dividing them by `scale`.
    ///
    /// `scale` is 1 unless the sum of squared deviations overflows; then it is the largest
    /// magnitude, so every scaled value lies in `-1...1` and the sum stays finite.
    private static func spread(_ values: [Double], sample: Bool) -> (scale: Double, scaledVariance: Double)? {
        let finite = values.filter(\.isFinite)
        let divisor = Double(finite.count - (sample ? 1 : 0))
        guard divisor > 0 else { return nil }
        let plain = sumOfSquaredDeviations(finite)
        if plain.isFinite { return (1, plain / divisor) }
        let scale = finite.reduce(0) { max($0, abs($1)) }
        return (scale, sumOfSquaredDeviations(finite.map { $0 / scale }) / divisor)
    }

    /// The sum of the squared distances from the mean; 0 for no values.
    private static func sumOfSquaredDeviations(_ values: [Double]) -> Double {
        guard let mean = mean(values) else { return 0 }
        return values.reduce(0) { $0 + ($1 - mean) * ($1 - mean) }
    }

    /// The quantile of values that are already sorted and finite.
    static func quantile(sorted: [Double], _ probability: Double) -> Double? {
        guard !sorted.isEmpty, !probability.isNaN else { return nil }
        let clamped = min(max(probability, 0), 1)
        let position = clamped * Double(sorted.count - 1)
        let lowerIndex = Int(position.rounded(.down))
        let upperIndex = min(lowerIndex + 1, sorted.count - 1)
        let fraction = position - Double(lowerIndex)
        let lower = sorted[lowerIndex]
        let upper = sorted[upperIndex]
        let difference = upper - lower
        // A weighted sum avoids the difference when it overflows (-1e308 and 1e308).
        return difference.isFinite ? lower + fraction * difference : lower * (1 - fraction) + upper * fraction
    }
}

/// The five-number summary and outliers that a box plot draws.
///
/// Quartiles use ``Statistics/quantile(_:_:)``. Whiskers follow Tukey's rule: each reaches the
/// most extreme value that lies within 1.5 interquartile ranges of the box, and the values
/// beyond that are ``outliers``.
public struct BoxPlotSummary: Hashable, Sendable {
    /// The first quartile, the bottom of the box.
    public let firstQuartile: Double
    /// The median, the line inside the box.
    public let median: Double
    /// The third quartile, the top of the box.
    public let thirdQuartile: Double
    /// The end of the lower whisker: the smallest value that is not an outlier.
    public let lowerWhisker: Double
    /// The end of the upper whisker: the largest value that is not an outlier.
    public let upperWhisker: Double
    /// Values more than 1.5 interquartile ranges below the box or above it, in ascending order.
    public let outliers: [Double]

    /// The height of the box, ``thirdQuartile`` minus ``firstQuartile``.
    public var interquartileRange: Double { thirdQuartile - firstQuartile }

    /// The multiple of the interquartile range beyond which a value is an outlier.
    public static let outlierFactor = 1.5

    /// Summarizes `values`, or returns `nil` when there is no finite value.
    public init?(values: [Double]) {
        let sorted = values.filter(\.isFinite).sorted()
        guard
            let firstQuartile = Statistics.quantile(sorted: sorted, 0.25),
            let median = Statistics.quantile(sorted: sorted, 0.5),
            let thirdQuartile = Statistics.quantile(sorted: sorted, 0.75)
        else { return nil }

        let reach = Self.outlierFactor * (thirdQuartile - firstQuartile)
        let lowerFence = firstQuartile - reach
        let upperFence = thirdQuartile + reach
        let inside = sorted.filter { $0 >= lowerFence && $0 <= upperFence }

        self.firstQuartile = firstQuartile
        self.median = median
        self.thirdQuartile = thirdQuartile
        // The quartiles always lie inside the fences, so `inside` is never empty.
        self.lowerWhisker = inside.first ?? firstQuartile
        self.upperWhisker = inside.last ?? thirdQuartile
        self.outliers = sorted.filter { $0 < lowerFence || $0 > upperFence }
    }
}
