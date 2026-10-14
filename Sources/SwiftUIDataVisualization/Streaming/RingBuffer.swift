/// A fixed-capacity collection that drops its oldest element when a new one arrives while full.
///
/// Appending and reading are O(1), so a buffer can take values at a high rate without the
/// array shifting that `removeFirst()` causes. Elements are indexed from `0` (oldest) to
/// `count - 1` (newest).
///
/// ```swift
/// var buffer = RingBuffer<Int>(capacity: 3)
/// buffer.append(contentsOf: [1, 2, 3, 4])
/// Array(buffer) // [2, 3, 4]
/// ```
public struct RingBuffer<Element>: RandomAccessCollection {
    /// The most elements the buffer holds.
    public let capacity: Int
    private var storage: [Element] = []
    /// The storage index of the oldest element once the buffer is full.
    private var head = 0

    /// Creates an empty buffer. A capacity below 1 counts as 1.
    public init(capacity: Int) {
        self.capacity = Swift.max(capacity, 1)
        storage.reserveCapacity(self.capacity)
    }

    public var startIndex: Int { 0 }
    public var endIndex: Int { storage.count }

    public subscript(position: Int) -> Element {
        precondition(indices.contains(position), "RingBuffer index out of range")
        return storage[(head + position) % storage.count]
    }

    /// Whether the next append drops the oldest element.
    public var isFull: Bool { storage.count == capacity }

    /// Adds `element` as the newest element, dropping the oldest one when the buffer is full.
    public mutating func append(_ element: Element) {
        if storage.count < capacity {
            storage.append(element)
        } else {
            storage[head] = element
            head = (head + 1) % capacity
        }
    }

    /// Appends each element of `elements` in order.
    public mutating func append<S: Sequence>(contentsOf elements: S) where S.Element == Element {
        for element in elements {
            append(element)
        }
    }

    /// Removes every element and keeps the capacity.
    public mutating func removeAll() {
        storage.removeAll(keepingCapacity: true)
        head = 0
    }
}

extension RingBuffer: Sendable where Element: Sendable {}

extension RingBuffer: Equatable where Element: Equatable {
    /// Two buffers are equal when they have the same capacity and the same elements in order.
    public static func == (lhs: RingBuffer, rhs: RingBuffer) -> Bool {
        lhs.capacity == rhs.capacity && lhs.elementsEqual(rhs)
    }
}
