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

    /// Fits a line to `points`, or returns `nil` when fewer than two points are finite, all of
    /// them share one x value (the line would be vertical) or the values are so large that the
    /// sums overflow `Double`.
    public init?(points: [PlotPoint]) {
        let finite = points.filter { $0.x.isFinite && $0.y.isFinite }
        guard finite.count >= 2 else { return nil }
        guard
            let meanX = Statistics.mean(finite.map(\.x)),
            let meanY = Statistics.mean(finite.map(\.y))
        else { return nil }
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
        guard sumXX > 0, sumXX.isFinite, sumXY.isFinite, sumYY.isFinite else { return nil }
        let slope = sumXY / sumXX
        let intercept = meanY - slope * meanX
        // Dividing before multiplying keeps r² finite for large but representable sums.
        let rSquared = sumYY > 0 ? min((sumXY / sumXX) * (sumXY / sumYY), 1) : 1
        guard slope.isFinite, intercept.isFinite, rSquared.isFinite else { return nil }
        self.slope = slope
        self.intercept = intercept
        self.rSquared = rSquared
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
    /// The result has one element per input value. An element is `nil` while its window is not
    /// full yet (the first `window - 1`) and while the window holds a value that is not finite.
    /// A window below 1 counts as 1. Runs in O(n) with a compensated running sum, so a large
    /// value leaving the window does not wipe out the small ones still in it; the sum is also
    /// recomputed every `window` steps. A second running sum of the values divided by the
    /// window gives the mean while the plain sum overflows, so values near
    /// `Double.greatestFiniteMagnitude` keep the O(n) bound.
    public static func simple(_ values: [Double], window: Int) -> [Double?] {
        let window = max(window, 1)
        var result: [Double?] = Array(repeating: nil, count: values.count)
        guard values.count >= window else { return result }
        let divisor = Double(window)
        // The sum of the finite values in the window, the same sum with each value divided by
        // the window, and how many values are not finite.
        var sum = CompensatedSum()
        var scaledSum = CompensatedSum()
        var nonFiniteCount = 0
        for index in values.indices {
            let value = values[index]
            if value.isFinite {
                sum.add(value)
                scaledSum.add(value / divisor)
            } else {
                nonFiniteCount += 1
            }
            if index >= window {
                let leaving = values[index - window]
                if leaving.isFinite {
                    sum.add(-leaving)
                    scaledSum.add(-leaving / divisor)
                } else {
                    nonFiniteCount -= 1
                }
            }
            if index.isMultiple(of: window) {
                sum = CompensatedSum()
                scaledSum = CompensatedSum()
                for value in values[(max(index - window + 1, 0))...index] where value.isFinite {
                    sum.add(value)
                    scaledSum.add(value / divisor)
                }
            }
            guard index >= window - 1, nonFiniteCount == 0 else { continue }
            let mean = sum.value / divisor
            result[index] = mean.isFinite ? mean : scaledSum.value
        }
        return result
    }

    /// An exponential moving average: each output is `smoothing × value + (1 − smoothing) ×
    /// previous output`, starting from the first finite value.
    ///
    /// `smoothing` is clamped to `0...1`; higher values follow the data more closely. A common
    /// choice for an N-period average is `2 / (N + 1)`. Values that are not finite do not move
    /// the average: their output repeats the previous one, and outputs before the first finite
    /// value are `nil`.
    public static func exponential(_ values: [Double], smoothing: Double) -> [Double?] {
        let alpha = smoothing.isNaN ? 1 : min(max(smoothing, 0), 1)
        var result: [Double?] = []
        result.reserveCapacity(values.count)
        var average: Double?
        for value in values {
            if value.isFinite {
                average = average.map { alpha * value + (1 - alpha) * $0 } ?? value
            }
            result.append(average)
        }
        return result
    }
}

/// A running sum with Neumaier's compensation: the low-order part that each addition rounds
/// away is kept in `compensation`. Adding `1e308`, `1` and `-1e308` gives `1` instead of `0`.
/// After an overflow the value is not finite.
struct CompensatedSum {
    private var sum = 0.0
    private var compensation = 0.0

    /// The sum of everything added so far.
    var value: Double { sum + compensation }

    mutating func add(_ term: Double) {
        let total = sum + term
        if abs(sum) >= abs(term) {
            compensation += (sum - total) + term
        } else {
            compensation += (term - total) + sum
        }
        sum = total
    }
}
