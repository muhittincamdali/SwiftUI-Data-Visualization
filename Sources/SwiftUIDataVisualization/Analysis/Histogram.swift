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

        /// The lower bound, which no other bin of the histogram shares.
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

    /// The most bins a histogram makes, so a tiny width cannot exhaust memory. When a width
    /// would need more, the last bin is widened to reach the largest value.
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
            let margin = max(0.5, abs(minimum) / 10)
            bins = [Bin(
                lowerBound: max(minimum - margin, -.greatestFiniteMagnitude),
                upperBound: min(minimum + margin, .greatestFiniteMagnitude),
                count: finite.count
            )]
            return
        }
        bins = Self.count(sorted: finite, edges: Self.edges(sorted: finite, binning: binning))
    }

    /// The bin edges for `binning`: ascending, finite, at least two, and from at most the
    /// smallest to at least the largest value.
    private static func edges(sorted: [Double], binning: Binning) -> [Double] {
        let minimum = sorted[0]
        let maximum = sorted[sorted.count - 1]
        switch binning {
        case .count(let count):
            return evenEdges(minimum: minimum, maximum: maximum, binCount: min(max(count, 1), maximumBinCount))
        case .width(let width) where width > 0 && width.isFinite:
            return alignedEdges(minimum: minimum, maximum: maximum, step: width)
        case .width, .automatic:
            let count = max(sturgesCount(sorted.count), freedmanDiaconisCount(sorted: sorted) ?? 0)
            return niceEdges(minimum: minimum, maximum: maximum, desiredCount: count)
        case .sturges:
            return niceEdges(minimum: minimum, maximum: maximum, desiredCount: sturgesCount(sorted.count))
        case .freedmanDiaconis:
            let count = freedmanDiaconisCount(sorted: sorted) ?? sturgesCount(sorted.count)
            return niceEdges(minimum: minimum, maximum: maximum, desiredCount: count)
        }
    }

    /// `binCount` equal bins from `minimum` to `maximum`. Each edge interpolates between the two,
    /// which cannot overflow even when `maximum - minimum` does.
    private static func evenEdges(minimum: Double, maximum: Double, binCount: Int) -> [Double] {
        (0...binCount).map { index in
            if index == 0 { return minimum }
            if index == binCount { return maximum }
            let fraction = Double(index) / Double(binCount)
            return minimum * (1 - fraction) + maximum * fraction
        }
    }

    private static func niceEdges(minimum: Double, maximum: Double, desiredCount: Int) -> [Double] {
        let count = min(max(desiredCount, 1), maximumAutomaticBinCount)
        // Dividing each value first keeps the width finite when the range overflows.
        let step = NiceScale.niceNumber(maximum / Double(count) - minimum / Double(count), rounded: true)
        guard step.isFinite, step > 0 else {
            return evenEdges(minimum: minimum, maximum: maximum, binCount: count)
        }
        return alignedEdges(minimum: minimum, maximum: maximum, step: step)
    }

    /// Edges at multiples of `step`, from the one at or below `minimum` past `maximum`.
    private static func alignedEdges(minimum: Double, maximum: Double, step: Double) -> [Double] {
        let decimals = decimalPlaces(of: step)
        var start = (minimum / step).rounded(.down) * step
        if !start.isFinite || start > minimum { start = minimum }
        if let decimals { start = roundedEdge(start, decimals: decimals, fallback: start) }
        let binCount = clampedCount(maximum / step - start / step, upTo: maximumBinCount)
        var edges = (0...binCount).map { index in
            var raw = start + Double(index) * step
            // index × step can overflow on its own when the edges straddle zero near
            // Double.greatestFiniteMagnitude; counting in steps from start/step does not.
            if !raw.isFinite { raw = (start / step + Double(index)) * step }
            return decimals.map { roundedEdge(raw, decimals: $0, fallback: raw) } ?? raw
        }
        // Too many bins for the width, or an edge past Double's range: the last bin reaches the
        // largest value instead.
        if !(edges[binCount] >= maximum) || !edges[binCount].isFinite {
            edges[binCount] = maximum
        }
        return edges
    }

    private static func roundedEdge(_ value: Double, decimals: Int, fallback: Double) -> Double {
        let factor = pow(10, Double(decimals))
        let rounded = (value * factor).rounded() / factor
        return rounded.isFinite ? rounded : fallback
    }

    /// `value` rounded up to a whole count in `1...limit`, without trapping: `nan` (from an
    /// overflowing range) and values beyond `limit` give `limit`.
    static func clampedCount(_ value: Double, upTo limit: Int) -> Int {
        if value.isNaN { return limit }
        let rounded = value.rounded(.up)
        if rounded <= 1 { return 1 }
        if rounded >= Double(limit) { return limit }
        return Int(rounded)
    }

    /// The fewest decimal places (up to 12) that write `step` exactly, or `nil`.
    ///
    /// A whole number of zero never counts, so a step of `1e-10` needs 10 places instead of
    /// passing as `0` at 0 places. The tolerance only absorbs the rounding error of the scaling.
    static func decimalPlaces(of step: Double) -> Int? {
        for places in 0...12 {
            let scaled = step * pow(10, Double(places))
            let whole = scaled.rounded()
            if whole != 0, abs(scaled - whole) <= 1e-6 { return places }
        }
        return nil
    }

    static func sturgesCount(_ sampleSize: Int) -> Int {
        Int(log2(Double(max(sampleSize, 1))).rounded(.up)) + 1
    }

    /// The bin count for the Freedman–Diaconis width, or `nil` when the IQR is zero.
    static func freedmanDiaconisCount(sorted: [Double]) -> Int? {
        guard
            let firstQuartile = Statistics.quantile(sorted: sorted, 0.25),
            let thirdQuartile = Statistics.quantile(sorted: sorted, 0.75)
        else { return nil }
        let cubeRoot = cbrt(Double(sorted.count))
        let width = 2 * (thirdQuartile / cubeRoot - firstQuartile / cubeRoot)
        guard width > 0 else { return nil }
        let minimum = sorted[0]
        let maximum = sorted[sorted.count - 1]
        return clampedCount(maximum / width - minimum / width, upTo: maximumAutomaticBinCount)
    }

    /// Counts sorted values into the bins between `edges`. A value equal to an edge belongs to
    /// the bin that starts there; the last bin also counts its upper edge.
    private static func count(sorted: [Double], edges: [Double]) -> [Bin] {
        let last = edges.count - 2
        var counts = Array(repeating: 0, count: last + 1)
        var index = 0
        for value in sorted {
            while index < last, value >= edges[index + 1] { index += 1 }
            counts[index] += 1
        }
        return counts.indices.map { index in
            Bin(lowerBound: edges[index], upperBound: edges[index + 1], count: counts[index])
        }
    }
}
