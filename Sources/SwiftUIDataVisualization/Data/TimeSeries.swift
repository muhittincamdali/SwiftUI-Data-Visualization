import Foundation

/// One measurement at a point in time.
public struct TimeSeriesPoint: Hashable, Sendable {
    /// When the value was measured.
    public var date: Date
    /// The measured value.
    public var value: Double

    /// Creates a point.
    public init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}

/// A named sequence of ``TimeSeriesPoint`` values, such as one line in a ``TimeSeriesChart``.
///
/// The initializer sorts the points by date, so charts, downsampling and
/// ``nearestPoint(to:)`` can rely on the order. Points whose date is not a finite time (a `Date`
/// built from `nan` or infinity) are dropped, because they cannot be ordered or placed on an
/// axis.
public struct TimeSeries: Identifiable, Hashable, Sendable {
    /// The series name, shown in the chart legend. It also identifies the series, so names in
    /// one chart should be unique.
    public var name: String
    /// The points, oldest first.
    public private(set) var points: [TimeSeriesPoint]

    public var id: String { name }

    /// Creates a series and sorts its points by date.
    public init(name: String, points: [TimeSeriesPoint]) {
        self.name = name
        self.points = points
            .filter { $0.date.timeIntervalSinceReferenceDate.isFinite }
            .sorted { $0.date < $1.date }
    }

    /// Creates a series from values measured at a fixed interval, starting at `start`.
    ///
    /// ```swift
    /// let steps = TimeSeries(name: "Steps", values: [4_200, 8_100, 6_900],
    ///                        start: .now.addingTimeInterval(-2 * 86_400), interval: 86_400)
    /// ```
    public init(name: String, values: [Double], start: Date, interval: TimeInterval) {
        let points = values.enumerated().map { offset, value in
            TimeSeriesPoint(date: start.addingTimeInterval(Double(offset) * interval), value: value)
        }
        // A negative interval gives dates in reverse order, so the points are sorted like any
        // others.
        self.init(name: name, points: points)
    }

    /// The point whose date is closest to `date`, or `nil` for an empty series.
    ///
    /// Charts use it to show the value under the pointer. When two points are equally close,
    /// the earlier one wins. Runs in O(log n).
    public func nearestPoint(to date: Date) -> TimeSeriesPoint? {
        guard !points.isEmpty else { return nil }
        var low = 0
        var high = points.count
        while low < high {
            let middle = (low + high) / 2
            if points[middle].date < date {
                low = middle + 1
            } else {
                high = middle
            }
        }
        // `low` is the first point at or after `date`.
        if low == points.count { return points[points.count - 1] }
        if low == 0 { return points[0] }
        let before = points[low - 1]
        let after = points[low]
        let distanceBefore = date.timeIntervalSince(before.date)
        let distanceAfter = after.date.timeIntervalSince(date)
        return distanceBefore <= distanceAfter ? before : after
    }
}

/// A point on two numeric axes, used by ``ScatterChart``, ``LinearRegression`` and
/// ``Downsampling``.
public struct PlotPoint: Hashable, Sendable {
    /// The horizontal value.
    public var x: Double
    /// The vertical value.
    public var y: Double

    /// Creates a point.
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}
