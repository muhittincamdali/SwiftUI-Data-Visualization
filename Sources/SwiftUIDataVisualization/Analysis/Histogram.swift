import Foundation

/// Values counted into equal-width bins, the data behind a ``HistogramChart``.
///
/// Each bin includes its lower bound and excludes its upper bound, except the last bin, which
/// includes both, so the largest value is always counted.
///
/// ```swift
/// let histogram = Histogram(values: responseTimes)            // automatic bin width
/// let deciles = Histogram(values: scores, binning: .width(10)) // 0..<10, 10..<20, …
/// ```
public struct Histogram: Hashable, Sendable {
    /// One bin of a histogram.
    public struct Bin: Identifiable, Hashable, Sendable {
        /// The smallest value the bin counts.
        public let lowerBound: Double
        /// The end of the bin; only the last bin counts a value equal to it.
        public let upperBound: Double
        /// How many values fell into the bin.
        public let count: Int

        public var id: Double { lowerBound }

        /// Creates a bin.
        public init(lowerBound: Double, upperBound: Double, count: Int) {
            self.lowerBound = lowerBound
            self.upperBound = upperBound
            self.count = count
        }
    }

    /// How the bin width is chosen.
    public enum Binning: Hashable, Sendable {
        /// Whichever of ``sturges`` and ``freedmanDiaconis`` gives more bins, as NumPy's `auto`
        /// does: Sturges suits small, roughly normal samples; Freedman–Diaconis is robust to
        /// outliers in large ones. Bin edges are rounded to a 1, 2 or 5 step.
        case automatic
        /// `log2(n) + 1` bins, rounded to a 1, 2 or 5 step.
        case sturges
        /// A bin width of `2 × IQR / ∛n`, rounded to a 1, 2 or 5 step. Falls back to ``sturges``
        /// when the interquartile range is zero.
        case freedmanDiaconis
        /// Exactly this many bins from the smallest to the largest value (at least one).
        case count(Int)
        /// Bins of this width, aligned to multiples of it (`.width(10)` gives `0..<10`,
        /// `10..<20`, …). A width that is not positive and finite counts as ``automatic``.
        case width(Double)
    }

    /// The bins in ascending order, including empty ones between the first and the last.
    public let bins: [Bin]

    /// The number of values that were counted (non-finite values are skipped).
    public var totalCount: Int { bins.reduce(0) { $0 + $1.count } }

    /// The most bins a histogram makes, so a tiny width cannot exhaust memory. Values past the
    /// last of them are counted in it.
    public static let maximumBinCount = 10_000

    /// The most bins the rule-based binnings make on their own.
    static let maximumAutomaticBinCount = 200

    /// Counts `values` into bins chosen by `binning`.
    public init(values: [Double], binning: Binning = .automatic) {
        let finite = values.filter(\.isFinite).sorted()
        guard let minimum = finite.first, let maximum = finite.last else {
            bins = []
            return
        }
        guard minimum < maximum else {
            bins = [Bin(lowerBound: minimum - 0.5, upperBound: minimum + 0.5, count: finite.count)]
            return
        }
        let layout = Self.layout(sorted: finite, binning: binning)
        bins = Self.count(sorted: finite, layout: layout)
    }

    private struct Layout {
        let start: Double
        let step: Double
        let binCount: Int
        /// Decimal places to round edges to when the step has a short decimal form (0.1, 2.5),
        /// so edges do not drift; `nil` for steps such as 10 / 3.
        let decimals: Int?

        func edge(_ index: Int) -> Double {
            let raw = start + Double(index) * step
            guard let decimals else { return raw }
            let factor = pow(10, Double(decimals))
            return (raw * factor).rounded() / factor
        }
    }

    private static func layout(sorted: [Double], binning: Binning) -> Layout {
        let minimum = sorted[0]
        let maximum = sorted[sorted.count - 1]
        let range = maximum - minimum
        switch binning {
        case .count(let count):
            let binCount = min(max(count, 1), maximumBinCount)
            // The edges start at the data minimum, so rounding them to the step would move them.
            return Layout(start: minimum, step: range / Double(binCount), binCount: binCount, decimals: nil)
        case .width(let width) where width > 0 && width.isFinite:
            return alignedLayout(minimum: minimum, maximum: maximum, step: width)
        case .width, .automatic:
            let count = max(sturgesCount(sorted.count), freedmanDiaconisCount(sorted: sorted) ?? 0)
            return niceLayout(minimum: minimum, maximum: maximum, desiredCount: count)
        case .sturges:
            return niceLayout(minimum: minimum, maximum: maximum, desiredCount: sturgesCount(sorted.count))
        case .freedmanDiaconis:
            let count = freedmanDiaconisCount(sorted: sorted) ?? sturgesCount(sorted.count)
            return niceLayout(minimum: minimum, maximum: maximum, desiredCount: count)
        }
    }

    private static func niceLayout(minimum: Double, maximum: Double, desiredCount: Int) -> Layout {
        let count = min(max(desiredCount, 1), maximumAutomaticBinCount)
        let step = NiceScale.niceNumber((maximum - minimum) / Double(count), rounded: true)
        return alignedLayout(minimum: minimum, maximum: maximum, step: step)
    }

    private static func alignedLayout(minimum: Double, maximum: Double, step: Double) -> Layout {
        let decimals = decimalPlaces(of: step)
        var start = (minimum / step).rounded(.down) * step
        if let decimals {
            let factor = pow(10, Double(decimals))
            start = (start * factor).rounded() / factor
        }
        let binCount = min(max(Int(((maximum - start) / step).rounded(.up)), 1), maximumBinCount)
        return Layout(start: start, step: step, binCount: binCount, decimals: decimals)
    }

    /// The fewest decimal places (up to 12) that write `step` exactly, or `nil`.
    static func decimalPlaces(of step: Double) -> Int? {
        for places in 0...12 {
            let scaled = step * pow(10, Double(places))
            if abs(scaled - scaled.rounded()) <= 1e-9 * max(1, abs(scaled)) { return places }
        }
        return nil
    }

    static func sturgesCount(_ sampleSize: Int) -> Int {
        Int(log2(Double(sampleSize)).rounded(.up)) + 1
    }

    /// The bin count for the Freedman–Diaconis width, or `nil` when the IQR is zero.
    static func freedmanDiaconisCount(sorted: [Double]) -> Int? {
        guard
            let firstQuartile = Statistics.quantile(sorted: sorted, 0.25),
            let thirdQuartile = Statistics.quantile(sorted: sorted, 0.75)
        else { return nil }
        let width = 2 * (thirdQuartile - firstQuartile) / cbrt(Double(sorted.count))
        guard width > 0 else { return nil }
        let range = sorted[sorted.count - 1] - sorted[0]
        return Int((range / width).rounded(.up))
    }

    private static func count(sorted: [Double], layout: Layout) -> [Bin] {
        let edges = (0...layout.binCount).map(layout.edge)
        var counts = Array(repeating: 0, count: layout.binCount)
        let last = layout.binCount - 1
        for value in sorted {
            var index = min(max(Int(((value - layout.start) / layout.step).rounded(.down)), 0), last)
            // Division can land just below an edge (0.3 / 0.1 = 2.9999999999999996); the
            // rounded edges decide.
            if index < last, value >= edges[index + 1] { index += 1 }
            if index > 0, value < edges[index] { index -= 1 }
            counts[index] += 1
        }
        return counts.indices.map { index in
            Bin(lowerBound: edges[index], upperBound: edges[index + 1], count: counts[index])
        }
    }
}
