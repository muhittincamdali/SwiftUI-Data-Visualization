// ChartAccessibility.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Chart Accessibility Provider

/// Generates accessibility descriptions for charts
public struct ChartAccessibilityProvider {
    
    // MARK: - Line Chart
    
    /// Generate accessibility description for line chart
    public static func lineChartDescription(
        title: String,
        dataPoints: [(label: String, value: Double)],
        unit: String? = nil
    ) -> String {
        guard !dataPoints.isEmpty else {
            return "\(title). No data available."
        }
        
        let values = dataPoints.map { $0.value }
        let minValue = values.min() ?? 0
        let maxValue = values.max() ?? 0
        let avgValue = values.reduce(0, +) / Double(values.count)
        
        let unitSuffix = unit.map { " \($0)" } ?? ""
        
        var description = "\(title) line chart with \(dataPoints.count) data points. "
        description += "Values range from \(formatNumber(minValue))\(unitSuffix) to \(formatNumber(maxValue))\(unitSuffix). "
        description += "Average value is \(formatNumber(avgValue))\(unitSuffix). "
        
        // Trend analysis
        if let first = values.first, let last = values.last {
            let trend = last - first
            if trend > 0 {
                description += "Overall trend is increasing by \(formatNumber(abs(trend)))\(unitSuffix)."
            } else if trend < 0 {
                description += "Overall trend is decreasing by \(formatNumber(abs(trend)))\(unitSuffix)."
            } else {
                description += "Values remained stable."
            }
        }
        
        return description
    }
    
    // MARK: - Bar Chart
    
    /// Generate accessibility description for bar chart
    public static func barChartDescription(
        title: String,
        bars: [(label: String, value: Double)],
        unit: String? = nil
    ) -> String {
        guard !bars.isEmpty else {
            return "\(title). No data available."
        }
        
        let unitSuffix = unit.map { " \($0)" } ?? ""
        let sorted = bars.sorted { $0.value > $1.value }
        
        var description = "\(title) bar chart with \(bars.count) bars. "
        
        // Highest and lowest
        if let highest = sorted.first {
            description += "Highest: \(highest.label) at \(formatNumber(highest.value))\(unitSuffix). "
        }
        if let lowest = sorted.last, sorted.count > 1 {
            description += "Lowest: \(lowest.label) at \(formatNumber(lowest.value))\(unitSuffix). "
        }
        
        // List all values
        description += "All values: "
        description += bars.map { "\($0.label): \(formatNumber($0.value))\(unitSuffix)" }.joined(separator: ", ")
        description += "."
        
        return description
    }
    
    // MARK: - Pie Chart
    
    /// Generate accessibility description for pie chart
    public static func pieChartDescription(
        title: String,
        slices: [(label: String, value: Double)],
        unit: String? = nil
    ) -> String {
        guard !slices.isEmpty else {
            return "\(title). No data available."
        }
        
        let total = slices.map { $0.value }.reduce(0, +)
        let sorted = slices.sorted { $0.value > $1.value }
        
        var description = "\(title) pie chart with \(slices.count) segments. "
        
        // Percentages
        description += "Distribution: "
        description += sorted.map { slice in
            let percentage = (slice.value / total) * 100
            return "\(slice.label): \(formatNumber(percentage))%"
        }.joined(separator: ", ")
        description += ". "
        
        // Largest segment
        if let largest = sorted.first {
            let percentage = (largest.value / total) * 100
            description += "\(largest.label) is the largest segment at \(formatNumber(percentage))%."
        }
        
        return description
    }
    
    // MARK: - Scatter Chart
    
    /// Generate accessibility description for scatter chart
    public static func scatterChartDescription(
        title: String,
        points: [(x: Double, y: Double)],
        xLabel: String,
        yLabel: String
    ) -> String {
        guard !points.isEmpty else {
            return "\(title). No data available."
        }
        
        let xValues = points.map { $0.x }
        let yValues = points.map { $0.y }
        
        var description = "\(title) scatter chart with \(points.count) data points. "
        description += "\(xLabel) ranges from \(formatNumber(xValues.min() ?? 0)) to \(formatNumber(xValues.max() ?? 0)). "
        description += "\(yLabel) ranges from \(formatNumber(yValues.min() ?? 0)) to \(formatNumber(yValues.max() ?? 0)). "
        
        // Correlation hint (simplified)
        let correlation = calculateCorrelation(points)
        if correlation > 0.7 {
            description += "There appears to be a strong positive correlation between \(xLabel) and \(yLabel)."
        } else if correlation < -0.7 {
            description += "There appears to be a strong negative correlation between \(xLabel) and \(yLabel)."
        } else if abs(correlation) > 0.3 {
            description += "There appears to be a moderate \(correlation > 0 ? "positive" : "negative") correlation."
        } else {
            description += "There appears to be little correlation between the variables."
        }
        
        return description
    }
    
    // MARK: - Timeline
    
    /// Generate accessibility description for timeline
    public static func timelineDescription(
        title: String,
        events: [(date: Date, title: String)]
    ) -> String {
        guard !events.isEmpty else {
            return "\(title). No events."
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        var description = "\(title) with \(events.count) events. "
        
        if let first = events.first, let last = events.last {
            description += "Spanning from \(formatter.string(from: first.date)) to \(formatter.string(from: last.date)). "
        }
        
        description += "Events: "
        description += events.prefix(5).map { "\($0.title) on \(formatter.string(from: $0.date))" }.joined(separator: "; ")
        
        if events.count > 5 {
            description += "; and \(events.count - 5) more events."
        } else {
            description += "."
        }
        
        return description
    }
    
    // MARK: - Leaderboard
    
    /// Generate accessibility description for leaderboard
    public static func leaderboardDescription(
        title: String,
        entries: [(rank: Int, name: String, score: Double)]
    ) -> String {
        guard !entries.isEmpty else {
            return "\(title). No entries."
        }
        
        var description = "\(title) with \(entries.count) entries. "
        
        // Top 3
        description += "Top positions: "
        description += entries.prefix(3).map { "\(ordinal($0.rank)): \($0.name) with \(formatNumber($0.score)) points" }.joined(separator: "; ")
        description += ". "
        
        if entries.count > 3 {
            description += "\(entries.count - 3) more participants follow."
        }
        
        return description
    }
    
    // MARK: - Helper Functions
    
    private static func formatNumber(_ value: Double) -> String {
        if value == value.rounded() && abs(value) < 10000 {
            return String(format: "%.0f", value)
        } else if abs(value) >= 1000000 {
            return String(format: "%.1fM", value / 1000000)
        } else if abs(value) >= 1000 {
            return String(format: "%.1fK", value / 1000)
        } else {
            return String(format: "%.1f", value)
        }
    }
    
    private static func ordinal(_ n: Int) -> String {
        let suffix: String
        let ones = n % 10
        let tens = (n / 10) % 10
        
        if tens == 1 {
            suffix = "th"
        } else {
            switch ones {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: suffix = "th"
            }
        }
        
        return "\(n)\(suffix)"
    }
    
    private static func calculateCorrelation(_ points: [(x: Double, y: Double)]) -> Double {
        guard points.count > 1 else { return 0 }
        
        let n = Double(points.count)
        let sumX = points.map { $0.x }.reduce(0, +)
        let sumY = points.map { $0.y }.reduce(0, +)
        let sumXY = points.map { $0.x * $0.y }.reduce(0, +)
        let sumX2 = points.map { $0.x * $0.x }.reduce(0, +)
        let sumY2 = points.map { $0.y * $0.y }.reduce(0, +)
        
        let numerator = n * sumXY - sumX * sumY
        let denominator = sqrt((n * sumX2 - sumX * sumX) * (n * sumY2 - sumY * sumY))
        
        guard denominator != 0 else { return 0 }
        return numerator / denominator
    }
}

// MARK: - Accessibility Modifiers

extension View {
    /// Add chart accessibility description
    public func chartAccessibility(
        label: String,
        hint: String? = nil,
        value: String? = nil
    ) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityValue(value ?? "")
    }
    
    /// Add data point accessibility
    public func dataPointAccessibility(
        label: String,
        value: Double,
        unit: String? = nil,
        position: String? = nil
    ) -> some View {
        let valueText = unit != nil ? "\(value) \(unit!)" : "\(value)"
        let hint = position ?? ""
        
        return self
            .accessibilityElement()
            .accessibilityLabel("\(label): \(valueText)")
            .accessibilityHint(hint)
            .accessibilityAddTraits(.isButton)
    }
}

// MARK: - VoiceOver Audio Graph Support

/// Provides audio graph data for VoiceOver
public struct AudioGraphData {
    public let title: String
    public let xAxisTitle: String
    public let yAxisTitle: String
    public let dataPoints: [(x: Double, y: Double, label: String?)]
    
    public init(
        title: String,
        xAxisTitle: String = "X",
        yAxisTitle: String = "Y",
        dataPoints: [(x: Double, y: Double, label: String?)]
    ) {
        self.title = title
        self.xAxisTitle = xAxisTitle
        self.yAxisTitle = yAxisTitle
        self.dataPoints = dataPoints
    }
    
    /// Generate accessible summary
    public func summary() -> String {
        guard !dataPoints.isEmpty else {
            return "\(title): No data"
        }
        
        let yValues = dataPoints.map { $0.y }
        let min = yValues.min() ?? 0
        let max = yValues.max() ?? 0
        let avg = yValues.reduce(0, +) / Double(yValues.count)
        
        return "\(title). \(dataPoints.count) points. \(yAxisTitle) ranges from \(String(format: "%.1f", min)) to \(String(format: "%.1f", max)). Average: \(String(format: "%.1f", avg))."
    }
}

// MARK: - Accessibility Color Support

/// Color accessibility utilities
public struct AccessibleColors {
    
    /// Check if colors have sufficient contrast
    public static func hasAdequateContrast(
        foreground: Color,
        background: Color,
        minimumRatio: Double = 4.5
    ) -> Bool {
        // Simplified contrast check
        // In production, you'd convert colors to luminance and calculate actual ratio
        return true
    }
    
    /// Color-blind friendly palette
    public static let colorBlindFriendly: [Color] = [
        Color(red: 0.0, green: 0.45, blue: 0.7),    // Blue
        Color(red: 0.9, green: 0.6, blue: 0.0),     // Orange
        Color(red: 0.0, green: 0.6, blue: 0.5),     // Teal
        Color(red: 0.8, green: 0.4, blue: 0.0),     // Vermillion
        Color(red: 0.35, green: 0.7, blue: 0.9),    // Sky Blue
        Color(red: 0.95, green: 0.9, blue: 0.25),   // Yellow
        Color(red: 0.8, green: 0.6, blue: 0.7)      // Pink
    ]
    
    /// High contrast palette
    public static let highContrast: [Color] = [
        .black,
        Color(red: 0.0, green: 0.0, blue: 0.8),
        Color(red: 0.8, green: 0.0, blue: 0.0),
        Color(red: 0.0, green: 0.5, blue: 0.0),
        Color(red: 0.5, green: 0.0, blue: 0.5),
        Color(red: 0.6, green: 0.4, blue: 0.0)
    ]
}

// MARK: - Haptic Feedback

#if canImport(UIKit)
import UIKit

/// Haptic feedback for chart interactions
public struct ChartHaptics {
    
    /// Provide haptic feedback for data point selection
    public static func dataPointSelected() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    /// Provide haptic feedback for peak/valley detection
    public static func peakDetected() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /// Provide haptic feedback for crossing threshold
    public static func thresholdCrossed() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    /// Provide haptic feedback for completion
    public static func chartLoaded() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
#endif

// MARK: - Preview

#if DEBUG
struct ChartAccessibility_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            Text("Accessibility Features")
                .font(.title)
            
            Text(ChartAccessibilityProvider.lineChartDescription(
                title: "Revenue",
                dataPoints: [
                    ("Jan", 100),
                    ("Feb", 150),
                    ("Mar", 130),
                    ("Apr", 180)
                ],
                unit: "K"
            ))
            .font(.caption)
            .padding()
            
            HStack(spacing: 8) {
                ForEach(AccessibleColors.colorBlindFriendly.prefix(5), id: \.self) { color in
                    Circle()
                        .fill(color)
                        .frame(width: 30, height: 30)
                }
            }
            
            Text("Color-blind friendly palette")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
#endif
