import Foundation
import SwiftUI

/// Represents a single data point in a chart.
///
/// This model provides a flexible structure for chart data points with support for
/// various data types, styling, and interaction states.
///
/// ```swift
/// let dataPoint = ChartDataPoint(
///     x: 1.0,
///     y: 25.0,
///     label: "January",
///     color: .blue,
///     size: 8.0
/// )
/// ```
///
/// - Note: All properties are optional to support different chart types and use cases.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ChartDataPoint: Identifiable, Codable, Equatable {
    
    // MARK: - Properties
    
    /// Unique identifier for the data point
    public let id: UUID
    
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
    
    /// Size of the data point (for scatter plots, bubbles, etc.)
    public let size: Double?
    
    /// Additional metadata for the data point
    public let metadata: [String: String]?
    
    /// Whether the data point is currently selected
    public var isSelected: Bool
    
    /// Whether the data point is currently highlighted
    public var isHighlighted: Bool
    
    /// Custom tooltip text for this data point
    public let tooltip: String?
    
    /// Timestamp for time-series data
    public let timestamp: Date?
    
    /// Category or group for the data point
    public let category: String?
    
    /// Weight value for weighted charts
    public let weight: Double?
    
    // MARK: - Initialization
    
    /// Creates a new chart data point with the specified values.
    ///
    /// - Parameters:
    ///   - id: Unique identifier (defaults to new UUID)
    ///   - x: X-axis value
    ///   - y: Y-axis value
    ///   - z: Optional Z-axis value
    ///   - label: Optional display label
    ///   - color: Optional custom color
    ///   - size: Optional size value
    ///   - metadata: Optional additional metadata
    ///   - tooltip: Optional tooltip text
    ///   - timestamp: Optional timestamp
    ///   - category: Optional category
    ///   - weight: Optional weight value
    public init(
        id: UUID = UUID(),
        x: Double,
        y: Double,
        z: Double? = nil,
        label: String? = nil,
        color: Color? = nil,
        size: Double? = nil,
        metadata: [String: String]? = nil,
        tooltip: String? = nil,
        timestamp: Date? = nil,
        category: String? = nil,
        weight: Double? = nil
    ) {
        self.id = id
        self.x = x
        self.y = y
        self.z = z
        self.label = label
        self.color = color
        self.size = size
        self.metadata = metadata
        self.isSelected = false
        self.isHighlighted = false
        self.tooltip = tooltip
        self.timestamp = timestamp
        self.category = category
        self.weight = weight
    }
    
    // MARK: - Convenience Initializers
    
    /// Creates a simple data point with just x and y values.
    ///
    /// - Parameters:
    ///   - x: X-axis value
    ///   - y: Y-axis value
    public init(x: Double, y: Double) {
        self.init(x: x, y: y, label: nil)
    }
    
    /// Creates a data point with x, y, and label.
    ///
    /// - Parameters:
    ///   - x: X-axis value
    ///   - y: Y-axis value
    ///   - label: Display label
    public init(x: Double, y: Double, label: String) {
        self.init(x: x, y: y, label: label, color: nil)
    }
    
    /// Creates a data point with x, y, label, and color.
    ///
    /// - Parameters:
    ///   - x: X-axis value
    ///   - y: Y-axis value
    ///   - label: Display label
    ///   - color: Custom color
    public init(x: Double, y: Double, label: String, color: Color) {
        self.init(x: x, y: y, label: label, color: color, size: nil)
    }
    
    /// Creates a 3D data point with x, y, and z values.
    ///
    /// - Parameters:
    ///   - x: X-axis value
    ///   - y: Y-axis value
    ///   - z: Z-axis value
    ///   - label: Optional display label
    public init(x: Double, y: Double, z: Double, label: String? = nil) {
        self.init(x: x, y: y, z: z, label: label, color: nil)
    }
    
    // MARK: - Computed Properties
    
    /// Returns the effective color for this data point.
    ///
    /// If no custom color is set, returns the default chart color.
    public var effectiveColor: Color {
        return color ?? .blue
    }
    
    /// Returns the effective size for this data point.
    ///
    /// If no custom size is set, returns the default size.
    public var effectiveSize: Double {
        return size ?? 8.0
    }
    
    /// Returns the effective tooltip text.
    ///
    /// Uses custom tooltip if available, otherwise generates from data.
    public var effectiveTooltip: String {
        if let tooltip = tooltip {
            return tooltip
        }
        
        var components: [String] = []
        
        if let label = label {
            components.append(label)
        }
        
        components.append("X: \(String(format: "%.2f", x))")
        components.append("Y: \(String(format: "%.2f", y))")
        
        if let z = z {
            components.append("Z: \(String(format: "%.2f", z))")
        }
        
        return components.joined(separator: " | ")
    }
    
    /// Returns whether this data point has 3D coordinates.
    public var is3D: Bool {
        return z != nil
    }
    
    /// Returns the magnitude of the data point (for vector charts).
    public var magnitude: Double {
        return sqrt(x * x + y * y)
    }
    
    // MARK: - Mutating Methods
    
    /// Updates the selection state of the data point.
    ///
    /// - Parameter isSelected: New selection state
    /// - Returns: Updated data point
    public func withSelection(_ isSelected: Bool) -> ChartDataPoint {
        var copy = self
        copy.isSelected = isSelected
        return copy
    }
    
    /// Updates the highlight state of the data point.
    ///
    /// - Parameter isHighlighted: New highlight state
    /// - Returns: Updated data point
    public func withHighlight(_ isHighlighted: Bool) -> ChartDataPoint {
        var copy = self
        copy.isHighlighted = isHighlighted
        return copy
    }
    
    // MARK: - Codable Implementation
    
    private enum CodingKeys: String, CodingKey {
        case id, x, y, z, label, size, metadata, tooltip, timestamp, category, weight
        case colorHex = "color"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        x = try container.decode(Double.self, forKey: .x)
        y = try container.decode(Double.self, forKey: .y)
        z = try container.decodeIfPresent(Double.self, forKey: .z)
        label = try container.decodeIfPresent(String.self, forKey: .label)
        size = try container.decodeIfPresent(Double.self, forKey: .size)
        metadata = try container.decodeIfPresent([String: String].self, forKey: .metadata)
        tooltip = try container.decodeIfPresent(String.self, forKey: .tooltip)
        timestamp = try container.decodeIfPresent(Date.self, forKey: .timestamp)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        weight = try container.decodeIfPresent(Double.self, forKey: .weight)
        
        // Decode color from hex string
        if let colorHex = try container.decodeIfPresent(String.self, forKey: .colorHex) {
            color = Color(hex: colorHex)
        } else {
            color = nil
        }
        
        isSelected = false
        isHighlighted = false
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(x, forKey: .x)
        try container.encode(y, forKey: .y)
        try container.encodeIfPresent(z, forKey: .z)
        try container.encodeIfPresent(label, forKey: .label)
        try container.encodeIfPresent(size, forKey: .size)
        try container.encodeIfPresent(metadata, forKey: .metadata)
        try container.encodeIfPresent(tooltip, forKey: .tooltip)
        try container.encodeIfPresent(timestamp, forKey: .timestamp)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encodeIfPresent(weight, forKey: .weight)
        
        // Encode color as hex string
        if let color = color {
            try container.encode(color.toHex(), forKey: .colorHex)
        }
    }
}

// MARK: - Color Extension

private extension Color {
    /// Converts the color to a hex string representation.
    func toHex() -> String {
        // Simplified implementation - in a real app, you'd want more sophisticated color handling
        return "#0000FF" // Default to blue
    }
    
    /// Creates a color from a hex string.
    init?(hex: String) {
        // Simplified implementation - in a real app, you'd want more sophisticated color handling
        self = .blue
    }
}

// MARK: - Array Extensions

public extension Array where Element == ChartDataPoint {
    
    /// Returns the minimum X value in the data set.
    var minX: Double? {
        return self.map { $0.x }.min()
    }
    
    /// Returns the maximum X value in the data set.
    var maxX: Double? {
        return self.map { $0.x }.max()
    }
    
    /// Returns the minimum Y value in the data set.
    var minY: Double? {
        return self.map { $0.y }.min()
    }
    
    /// Returns the maximum Y value in the data set.
    var maxY: Double? {
        return self.map { $0.y }.max()
    }
    
    /// Returns the X range of the data set.
    var xRange: ClosedRange<Double>? {
        guard let minX = minX, let maxX = maxX else { return nil }
        return minX...maxX
    }
    
    /// Returns the Y range of the data set.
    var yRange: ClosedRange<Double>? {
        guard let minY = minY, let maxY = maxY else { return nil }
        return minY...maxY
    }
    
    /// Returns data points sorted by X value.
    var sortedByX: [ChartDataPoint] {
        return self.sorted { $0.x < $1.x }
    }
    
    /// Returns data points sorted by Y value.
    var sortedByY: [ChartDataPoint] {
        return self.sorted { $0.y < $1.y }
    }
    
    /// Returns data points filtered by the given category.
    ///
    /// - Parameter category: Category to filter by
    /// - Returns: Filtered data points
    func filterByCategory(_ category: String) -> [ChartDataPoint] {
        return self.filter { $0.category == category }
    }
    
    /// Returns unique categories in the data set.
    var categories: [String] {
        return Array(Set(self.compactMap { $0.category })).sorted()
    }
} 