import Foundation

/// Reduces a long series to fewer points that keep its visible shape.
///
/// Swift Charts draws every mark it is given, and a line with tens of thousands of points
/// slows down layout and scrolling while adding nothing a screen can show. ``TimeSeriesChart``
/// therefore downsamples each series to ``TimeSeriesChart/defaultMaximumPointsPerSeries``
/// points before drawing it. Use these functions directly for your own charts.
///
/// The algorithm is Largest-Triangle-Three-Buckets (Sveinn Steinarsson, "Downsampling Time
/// Series for Visual Representation", 2013). It keeps the first and the last point, splits the
/// rest into equal buckets and keeps, from each bucket, the point that forms the largest
/// triangle with the previously kept point and the average of the next bucket. Peaks and dips
/// survive, unlike with every-nth-point sampling.
public enum Downsampling {
    /// Downsamples points that are sorted by `x` to at most `threshold` points.
    ///
    /// Returns the input unchanged when it has no more than `threshold` points. A threshold
    /// below 3 keeps only the first and the last point (or the first, for a threshold of 1).
    public static func largestTriangleThreeBuckets(_ points: [PlotPoint], threshold: Int) -> [PlotPoint] {
        selectedIndices(count: points.count, threshold: threshold, x: { points[$0].x }, y: { points[$0].y })
            .map { points[$0] }
    }

    /// Downsamples time series points (sorted by date, as ``TimeSeries`` keeps them) to at most
    /// `threshold` points.
    public static func largestTriangleThreeBuckets(_ points: [TimeSeriesPoint], threshold: Int) -> [TimeSeriesPoint] {
        selectedIndices(
            count: points.count,
            threshold: threshold,
            x: { points[$0].date.timeIntervalSinceReferenceDate },
            y: { points[$0].value }
        )
        .map { points[$0] }
    }

    /// The indices LTTB keeps, in ascending order.
    static func selectedIndices(
        count: Int,
        threshold: Int,
        x: (Int) -> Double,
        y: (Int) -> Double
    ) -> [Int] {
        guard count > threshold else { return Array(0..<count) }
        guard threshold >= 3 else { return threshold <= 0 ? [] : Array([0, count - 1].prefix(threshold)) }

        var selected = [0]
        selected.reserveCapacity(threshold)
        // The first and the last point are kept; the others are spread over the buckets.
        let bucketSize = Double(count - 2) / Double(threshold - 2)
        var previous = 0

        for bucket in 0..<(threshold - 2) {
            let start = Int(Double(bucket) * bucketSize) + 1
            let end = min(Int(Double(bucket + 1) * bucketSize) + 1, count - 1)

            // The average of the next bucket (the last point for the final bucket).
            let nextStart = end
            let nextEnd = min(Int(Double(bucket + 2) * bucketSize) + 1, count)
            var averageX = 0.0
            var averageY = 0.0
            for index in nextStart..<max(nextEnd, nextStart + 1) {
                averageX += x(index)
                averageY += y(index)
            }
            let nextCount = Double(max(nextEnd - nextStart, 1))
            averageX /= nextCount
            averageY /= nextCount

            let previousX = x(previous)
            let previousY = y(previous)
            var largestArea = -1.0
            var chosen = start
            for index in start..<max(end, start + 1) {
                // Twice the triangle area; the factor does not change which point is largest.
                let area = abs(
                    (previousX - averageX) * (y(index) - previousY)
                        - (previousX - x(index)) * (averageY - previousY)
                )
                if area > largestArea {
                    largestArea = area
                    chosen = index
                }
            }
            selected.append(chosen)
            previous = chosen
        }

        selected.append(count - 1)
        return selected
    }
}
