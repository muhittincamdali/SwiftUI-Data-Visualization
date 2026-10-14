import Foundation

/// An ordinary least-squares line through a set of points, the trend line of a
/// ``ScatterChart``.
///
/// ```swift
/// if let fit = LinearRegression(points: points) {
///     print("y = \(fit.slope)x + \(fit.intercept), r² = \(fit.rSquared)")
/// }
/// ```
public struct LinearRegression: Hashable, Sendable {
    /// How much y changes per unit of x.
    public let slope: Double
    /// The value of y where the line crosses x = 0.
    public let intercept: Double
    /// The coefficient of determination: the share of the variance in y that the line explains,
    /// from 0 (none) to 1 (all points on the line). When every y is the same, the horizontal
    /// line fits exactly and the value is 1.
    public let rSquared: Double

    /// Fits a line to `points`, or returns `nil` when fewer than two points are finite or all
    /// of them share one x value (the line would be vertical).
    public init?(points: [PlotPoint]) {
        let finite = points.filter { $0.x.isFinite && $0.y.isFinite }
        guard finite.count >= 2 else { return nil }
        let count = Double(finite.count)
        let meanX = finite.reduce(0) { $0 + $1.x } / count
        let meanY = finite.reduce(0) { $0 + $1.y } / count
        var sumXY = 0.0
        var sumXX = 0.0
        var sumYY = 0.0
        for point in finite {
            let dx = point.x - meanX
            let dy = point.y - meanY
            sumXY += dx * dy
            sumXX += dx * dx
            sumYY += dy * dy
        }
        guard sumXX > 0 else { return nil }
        slope = sumXY / sumXX
        intercept = meanY - slope * meanX
        rSquared = sumYY > 0 ? min((sumXY * sumXY) / (sumXX * sumYY), 1) : 1
    }

    /// The y value the line predicts at `x`.
    public func predict(_ x: Double) -> Double {
        intercept + slope * x
    }
}

/// Moving averages that smooth a series, such as the average line of a ``TimeSeriesChart``.
public enum MovingAverage {
    /// The mean of each value and the `window - 1` values before it.
    ///
    /// The result has one element per input value; the first `window - 1` are `nil` because
    /// their window is not full yet. A window below 1 counts as 1. Runs in O(n) with a running
    /// sum, which is recomputed every `window` steps to keep rounding errors from adding up.
    public static func simple(_ values: [Double], window: Int) -> [Double?] {
        let window = max(window, 1)
        var result: [Double?] = Array(repeating: nil, count: values.count)
        guard values.count >= window else { return result }
        var sum = values[0..<window].reduce(0, +)
        result[window - 1] = sum / Double(window)
        for index in window..<values.count {
            if index.isMultiple(of: window) {
                sum = values[(index - window + 1)...index].reduce(0, +)
            } else {
                sum += values[index] - values[index - window]
            }
            result[index] = sum / Double(window)
        }
        return result
    }

    /// An exponential moving average: each output is `smoothing × value + (1 − smoothing) ×
    /// previous output`, starting from the first value.
    ///
    /// `smoothing` is clamped to `0...1`; higher values follow the data more closely. A common
    /// choice for an N-period average is `2 / (N + 1)`.
    public static func exponential(_ values: [Double], smoothing: Double) -> [Double] {
        guard let first = values.first else { return [] }
        let alpha = smoothing.isNaN ? 1 : min(max(smoothing, 0), 1)
        var result = [first]
        result.reserveCapacity(values.count)
        for value in values.dropFirst() {
            result.append(alpha * value + (1 - alpha) * result[result.count - 1])
        }
        return result
    }
}
