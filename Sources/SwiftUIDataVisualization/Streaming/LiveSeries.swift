import Observation

/// The latest values of a live measurement, kept in a ``RingBuffer`` and observed by SwiftUI.
///
/// Create one in a view's state, feed it from a task, and pass ``values`` to a
/// ``LiveTickerChart``. Views that read the series update when a value arrives.
///
/// ```swift
/// struct CPUView: View {
///     @State private var load = LiveSeries(capacity: 120)
///
///     var body: some View {
///         LiveTickerChart(dataPoints: load.values)
///             .frame(height: 80)
///             .task {
///                 while !Task.isCancelled {
///                     load.append(Double.random(in: 20...80)) // read the real value here
///                     try? await Task.sleep(for: .milliseconds(250))
///                 }
///             }
///     }
/// }
/// ```
@MainActor
@Observable
public final class LiveSeries {
    private var buffer: RingBuffer<Double>

    /// Creates an empty series that keeps the last `capacity` values (at least one).
    public init(capacity: Int) {
        buffer = RingBuffer(capacity: capacity)
    }

    /// The most values the series keeps.
    public var capacity: Int { buffer.capacity }

    /// The kept values, oldest first.
    public var values: [Double] { Array(buffer) }

    /// The newest value, or `nil` before the first one arrives.
    public var latest: Double? { buffer.last }

    /// The smallest and the largest kept value, or `nil` when the series is empty.
    public var range: ClosedRange<Double>? {
        guard let low = buffer.min(), let high = buffer.max() else { return nil }
        return low...high
    }

    /// Adds a value, dropping the oldest one when the series is full. `nan` and infinite values
    /// are ignored, because a chart cannot place them.
    public func append(_ value: Double) {
        guard value.isFinite else { return }
        buffer.append(value)
    }

    /// Adds several values in order; see ``append(_:)``.
    public func append<S: Sequence>(contentsOf values: S) where S.Element == Double {
        buffer.append(contentsOf: values.lazy.filter(\.isFinite))
    }

    /// Removes every value.
    public func removeAll() {
        buffer.removeAll()
    }
}
