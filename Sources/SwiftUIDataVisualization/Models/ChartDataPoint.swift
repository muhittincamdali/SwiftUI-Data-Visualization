import Foundation
import SwiftUI

/// A data point representing a single value in a chart.
///
/// This model is used across all chart types to represent individual data points.
/// It supports various data types and includes metadata for enhanced visualization.
///
/// - Example:
/// ```swift
/// let dataPoint = ChartDataPoint(
///     x: 1.0,
///     y: 25.0,
///     label: "January",
///     color: .blue,
///     metadata: ["category": "sales"]
/// )
/// ```
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ChartDataPoint: Identifiable, Hashable, Codable {
    
    // MARK: - Properties
    
    /// Unique identifier for the data point
    public let id = UUID()
    
    /// X-axis value (horizontal position)
    public let x: Double
    
    /// Y-axis value (vertical position)
    public let y: Double
    
    /// Optional Z-axis value for 3D charts
    public let z: Double?
    
    /// Display label for the data point
    public let label: String?
    
    /// Custom color for this data point
    public let color: Color?
    
    /// Additional metadata for the data point
    public let metadata: [String: String]
    
    /// Timestamp for time-series data
    public let timestamp: Date?
    
    /// Size value for bubble charts
    public let size: Double?
    
    /// Category for grouped charts
    public let category: String?
    
    /// Confidence interval for statistical charts
    public let confidenceInterval: ClosedRange<Double>?
    
    // MARK: - Initialization
    
    /// Creates a new chart data point with basic values.
    ///
    /// - Parameters:
    ///   - x: X-axis value
    ///   - y: Y-axis value
    ///   - label: Optional display label
    ///   - color: Optional custom color
    ///   - metadata: Optional additional metadata
    public init(
        x: Double,
        y: Double,
        label: String? = nil,
        color: Color? = nil,
        metadata: [String: String] = [:]
    ) {
        self.x = x
        self.y = y
        self.z = nil
        self.label = label
        self.color = color
        self.metadata = metadata
        self.timestamp = nil
        self.size = nil
        self.category = nil
        self.confidenceInterval = nil
    }
    
    /// Creates a new chart data point with 3D coordinates.
    ///
    /// - Parameters:
    ///   - x: X-axis value
    ///   - y: Y-axis value
    ///   - z: Z-axis value
    ///   - label: Optional display label
    ///   - color: Optional custom color
    ///   - metadata: Optional additional metadata
    public init(
        x: Double,
        y: Double,
        z: Double,
        label: String? = nil,
        color: Color? = nil,
        metadata: [String: String] = [:]
    ) {
        self.x = x
        self.y = y
        self.z = z
        self.label = label
        self.color = color
        self.metadata = metadata
        self.timestamp = nil
        self.size = nil
        self.category = nil
        self.confidenceInterval = nil
    }
    
    /// Creates a new chart data point for time-series data.
    ///
    /// - Parameters:
    ///   - timestamp: Time value
    ///   - y: Y-axis value
    ///   - label: Optional display label
    ///   - color: Optional custom color
    ///   - metadata: Optional additional metadata
    public init(
        timestamp: Date,
        y: Double,
        label: String? = nil,
        color: Color? = nil,
        metadata: [String: String] = [:]
    ) {
        self.x = timestamp.timeIntervalSince1970
        self.y = y
        self.z = nil
        self.label = label
        self.color = color
        self.metadata = metadata
        self.timestamp = timestamp
        self.size = nil
        self.category = nil
        self.confidenceInterval = nil
    }
    
    /// Creates a new chart data point for bubble charts.
    ///
    /// - Parameters:
    ///   - x: X-axis value
    ///   - y: Y-axis value
    ///   - size: Size value for bubble
    ///   - label: Optional display label
    ///   - color: Optional custom color
    ///   - metadata: Optional additional metadata
    public init(
        x: Double,
        y: Double,
        size: Double,
        label: String? = nil,
        color: Color? = nil,
        metadata: [String: String] = [:]
    ) {
        self.x = x
        self.y = y
        self.z = nil
        self.label = label
        self.color = color
        self.metadata = metadata
        self.timestamp = nil
        self.size = size
        self.category = nil
        self.confidenceInterval = nil
    }
    
    /// Creates a new chart data point with category information.
    ///
    /// - Parameters:
    ///   - x: X-axis value
    ///   - y: Y-axis value
    ///   - category: Category for grouping
    ///   - label: Optional display label
    ///   - color: Optional custom color
    ///   - metadata: Optional additional metadata
    public init(
        x: Double,
        y: Double,
        category: String,
        label: String? = nil,
        color: Color? = nil,
        metadata: [String: String] = [:]
    ) {
        self.x = x
        self.y = y
        self.z = nil
        self.label = label
        self.color = color
        self.metadata = metadata
        self.timestamp = nil
        self.size = nil
        self.category = category
        self.confidenceInterval = nil
    }
    
    /// Creates a new chart data point with confidence interval.
    ///
    /// - Parameters:
    ///   - x: X-axis value
    ///   - y: Y-axis value
    ///   - confidenceInterval: Confidence interval range
    ///   - label: Optional display label
    ///   - color: Optional custom color
    ///   - metadata: Optional additional metadata
    public init(
        x: Double,
        y: Double,
        confidenceInterval: ClosedRange<Double>,
        label: String? = nil,
        color: Color? = nil,
        metadata: [String: String] = [:]
    ) {
        self.x = x
        self.y = y
        self.z = nil
        self.label = label
        self.color = color
        self.metadata = metadata
        self.timestamp = nil
        self.size = nil
        self.category = nil
        self.confidenceInterval = confidenceInterval
    }
    
    // MARK: - Computed Properties
    
    /// Returns the coordinate point for 2D charts
    public var coordinate: CGPoint {
        CGPoint(x: x, y: y)
    }
    
    /// Returns the coordinate point for 3D charts
    public var coordinate3D: CGPoint3D? {
        guard let z = z else { return nil }
        return CGPoint3D(x: x, y: y, z: z)
    }
    
    /// Returns whether this is a 3D data point
    public var is3D: Bool {
        z != nil
    }
    
    /// Returns whether this is a time-series data point
    public var isTimeSeries: Bool {
        timestamp != nil
    }
    
    /// Returns whether this is a bubble chart data point
    public var isBubble: Bool {
        size != nil
    }
    
    /// Returns whether this has a confidence interval
    public var hasConfidenceInterval: Bool {
        confidenceInterval != nil
    }
    
    // MARK: - Utility Methods
    
    /// Creates a copy with updated values
    ///
    /// - Parameters:
    ///   - x: New X value
    ///   - y: New Y value
    /// - Returns: New data point with updated values
    public func updating(x: Double? = nil, y: Double? = nil) -> ChartDataPoint {
        ChartDataPoint(
            x: x ?? self.x,
            y: y ?? self.y,
            label: self.label,
            color: self.color,
            metadata: self.metadata
        )
    }
    
    /// Creates a copy with updated metadata
    ///
    /// - Parameter metadata: New metadata dictionary
    /// - Returns: New data point with updated metadata
    public func updating(metadata: [String: String]) -> ChartDataPoint {
        ChartDataPoint(
            x: self.x,
            y: self.y,
            label: self.label,
            color: self.color,
            metadata: metadata
        )
    }
    
    // MARK: - Hashable
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(x)
        hasher.combine(y)
        hasher.combine(z)
        hasher.combine(label)
        hasher.combine(timestamp)
        hasher.combine(size)
        hasher.combine(category)
        hasher.combine(confidenceInterval)
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: ChartDataPoint, rhs: ChartDataPoint) -> Bool {
        lhs.id == rhs.id &&
        lhs.x == rhs.x &&
        lhs.y == rhs.y &&
        lhs.z == rhs.z &&
        lhs.label == rhs.label &&
        lhs.timestamp == rhs.timestamp &&
        lhs.size == rhs.size &&
        lhs.category == rhs.category &&
        lhs.confidenceInterval == rhs.confidenceInterval
    }
}

// MARK: - 3D Point Structure

/// A 3D coordinate point for 3D charts
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct CGPoint3D: Equatable, Hashable {
    public let x: Double
    public let y: Double
    public let z: Double
    
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
}

// MARK: - Extensions

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension ChartDataPoint {
    
    /// Creates an array of data points from coordinate arrays
    ///
    /// - Parameters:
    ///   - xValues: Array of X values
    ///   - yValues: Array of Y values
    ///   - labels: Optional array of labels
    /// - Returns: Array of chart data points
    public static func fromArrays(
        xValues: [Double],
        yValues: [Double],
        labels: [String]? = nil
    ) -> [ChartDataPoint] {
        guard xValues.count == yValues.count else {
            return []
        }
        
        return zip(xValues, yValues).enumerated().map { index, coordinates in
            let label = labels?[safe: index]
            return ChartDataPoint(
                x: coordinates.0,
                y: coordinates.1,
                label: label
            )
        }
    }
    
    /// Creates an array of data points from time-series data
    ///
    /// - Parameters:
    ///   - timestamps: Array of timestamps
    ///   - values: Array of Y values
    ///   - labels: Optional array of labels
    /// - Returns: Array of chart data points
    public static func fromTimeSeries(
        timestamps: [Date],
        values: [Double],
        labels: [String]? = nil
    ) -> [ChartDataPoint] {
        guard timestamps.count == values.count else {
            return []
        }
        
        return zip(timestamps, values).enumerated().map { index, data in
            let label = labels?[safe: index]
            return ChartDataPoint(
                timestamp: data.0,
                y: data.1,
                label: label
            )
        }
    }
}

// MARK: - Array Extension

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
} 