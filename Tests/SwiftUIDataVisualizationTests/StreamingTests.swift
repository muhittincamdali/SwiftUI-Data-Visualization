import Observation
import Testing
@testable import SwiftUIDataVisualization

@Suite("Ring buffer")
struct RingBufferTests {
    @Test func keepsTheNewestElementsInOrder() {
        var buffer = RingBuffer<Int>(capacity: 3)
        buffer.append(contentsOf: [1, 2])
        #expect(Array(buffer) == [1, 2])
        #expect(!buffer.isFull)
        buffer.append(contentsOf: [3, 4, 5])
        #expect(buffer.isFull)
        #expect(Array(buffer) == [3, 4, 5])
        #expect(buffer.first == 3)
        #expect(buffer.last == 5)
        #expect(buffer[1] == 4)
    }

    @Test func wrapsAroundManyTimes() {
        var buffer = RingBuffer<Int>(capacity: 4)
        buffer.append(contentsOf: 0..<1_003)
        #expect(Array(buffer) == [999, 1_000, 1_001, 1_002])
        #expect(buffer.count == 4)
    }

    @Test func removeAllStartsOver() {
        var buffer = RingBuffer<Int>(capacity: 2)
        buffer.append(contentsOf: [1, 2, 3])
        buffer.removeAll()
        #expect(buffer.isEmpty)
        buffer.append(9)
        #expect(Array(buffer) == [9])
        #expect(buffer.capacity == 2)
    }

    @Test func capacityBelowOneCountsAsOne() {
        var buffer = RingBuffer<String>(capacity: 0)
        buffer.append(contentsOf: ["a", "b"])
        #expect(buffer.capacity == 1)
        #expect(Array(buffer) == ["b"])
    }

    @Test func equalityComparesContentsInOrder() {
        var wrapped = RingBuffer<Int>(capacity: 2)
        wrapped.append(contentsOf: [0, 1, 2])
        var direct = RingBuffer<Int>(capacity: 2)
        direct.append(contentsOf: [1, 2])
        #expect(wrapped == direct)
        #expect(wrapped != RingBuffer<Int>(capacity: 3))
    }
}

@MainActor
@Suite("Live series")
struct LiveSeriesTests {
    @Test func keepsTheLatestValues() {
        let series = LiveSeries(capacity: 3)
        #expect(series.latest == nil)
        #expect(series.range == nil)
        series.append(contentsOf: [5, 1, 9, 4])
        #expect(series.values == [1, 9, 4])
        #expect(series.latest == 4)
        #expect(series.range == 1...9)
    }

    @Test func ignoresValuesAChartCannotPlace() {
        let series = LiveSeries(capacity: 5)
        series.append(.nan)
        series.append(contentsOf: [1, .infinity, 2, -.infinity])
        #expect(series.values == [1, 2])
    }

    @Test func removeAllEmptiesTheSeries() {
        let series = LiveSeries(capacity: 5)
        series.append(contentsOf: [1, 2])
        series.removeAll()
        #expect(series.values.isEmpty)
        #expect(series.capacity == 5)
    }

    @Test func appendingNotifiesObservers() async {
        let series = LiveSeries(capacity: 5)
        let changed = Changed()
        withObservationTracking {
            _ = series.values
        } onChange: {
            changed.flag = true
        }
        series.append(1)
        #expect(changed.flag)
    }
}

/// A box the observation callback can write to from its non-isolated closure.
private final class Changed: @unchecked Sendable {
    var flag = false
}
