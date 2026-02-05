// SwiftUIDataVisualization.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

/// SwiftUI Data Visualization - A comprehensive data visualization library for SwiftUI
///
/// This library provides:
/// - 8 Chart Types: Line, Bar, Pie, Area, Scatter, Radar, Candlestick, Heatmap
/// - Advanced Visualizations: Timeline, Flowchart, Mind Map, Org Chart, Network Graph
/// - UI Components: Progress Indicators, Statistics Cards, Comparison Tables, Leaderboards, Dashboards
/// - Data Tools: Transformers, Filters, Sorters, Real-time Updates
/// - Theming: 10+ Pre-built themes, Custom theme builder
/// - Export: PNG, PDF, SVG, CSV, JSON
/// - Accessibility: VoiceOver support, Color-blind friendly palettes
///
/// # Quick Start
/// ```swift
/// import SwiftUIDataVisualization
///
/// LineChart(
///     data: [10, 25, 15, 30, 20],
///     labels: ["Mon", "Tue", "Wed", "Thu", "Fri"]
/// )
/// .chartTheme(.vibrant)
/// ```

// MARK: - Charts
@_exported import struct SwiftUIDataVisualization.LineChart
@_exported import struct SwiftUIDataVisualization.BarChart
@_exported import struct SwiftUIDataVisualization.PieChart
@_exported import struct SwiftUIDataVisualization.AreaChart
@_exported import struct SwiftUIDataVisualization.ScatterChart
@_exported import struct SwiftUIDataVisualization.RadarChart
@_exported import struct SwiftUIDataVisualization.CandlestickChart
@_exported import struct SwiftUIDataVisualization.HeatmapChart

// MARK: - Library Version
public enum SwiftUIDataVisualization {
    public static let version = "2.0.0"
    public static let buildDate = "2025-07-06"
    
    /// Feature flags
    public struct Features {
        public static let chartsEnabled = true
        public static let advancedVisualizationsEnabled = true
        public static let dataBindingEnabled = true
        public static let themingEnabled = true
        public static let exportEnabled = true
        public static let accessibilityEnabled = true
    }
    
    /// Component count
    public struct Components {
        public static let chartTypes = 8
        public static let advancedVisualizations = 5
        public static let uiComponents = 5
        public static let themes = 10
        public static let progressIndicators = 6
    }
}

// MARK: - Convenience Typealiases

// Charts
public typealias DVLineChart = LineChart
public typealias DVBarChart = BarChart
public typealias DVPieChart = PieChart
public typealias DVAreaChart = AreaChart
public typealias DVScatterChart = ScatterChart
public typealias DVRadarChart = RadarChart
public typealias DVCandlestickChart = CandlestickChart
public typealias DVHeatmapChart = HeatmapChart

// Advanced Visualizations
public typealias DVTimeline = TimelineView
public typealias DVFlowchart = FlowchartView
public typealias DVMindMap = MindMapView
public typealias DVOrgChart = OrgChartView
public typealias DVNetworkGraph = NetworkGraphView

// Components
public typealias DVStatCard = StatisticsCard
public typealias DVLeaderboard = LeaderboardView
public typealias DVDashboard = DashboardView
public typealias DVComparisonTable = ComparisonTable

// Progress
public typealias DVCircularProgress = CircularProgressView
public typealias DVLinearProgress = LinearProgressView
public typealias DVGaugeProgress = GaugeProgressView
public typealias DVWaveProgress = WaveProgressView

// MARK: - Global Configuration

/// Global configuration for all charts
public class DVConfiguration: ObservableObject {
    public static let shared = DVConfiguration()
    
    @Published public var defaultTheme: ChartTheme = .light
    @Published public var defaultAnimationDuration: Double = 0.5
    @Published public var enableHaptics: Bool = true
    @Published public var enableAccessibility: Bool = true
    @Published public var debugMode: Bool = false
    
    private init() {}
    
    public func reset() {
        defaultTheme = .light
        defaultAnimationDuration = 0.5
        enableHaptics = true
        enableAccessibility = true
        debugMode = false
    }
}

// MARK: - Sample Data Generators

/// Generates sample data for testing and previews
public enum SampleDataGenerator {
    
    /// Generate random line chart data
    public static func lineChartData(count: Int = 7, range: ClosedRange<Double> = 0...100) -> [(label: String, value: Double)] {
        let labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return (0..<min(count, labels.count)).map { i in
            (label: labels[i], value: Double.random(in: range))
        }
    }
    
    /// Generate random bar chart data
    public static func barChartData(categories: [String] = ["A", "B", "C", "D", "E"]) -> [(label: String, value: Double)] {
        categories.map { ($0, Double.random(in: 10...100)) }
    }
    
    /// Generate random pie chart data
    public static func pieChartData() -> [(label: String, value: Double, color: Color)] {
        [
            ("Mobile", Double.random(in: 20...40), .blue),
            ("Desktop", Double.random(in: 25...45), .green),
            ("Tablet", Double.random(in: 10...20), .orange),
            ("Other", Double.random(in: 5...15), .purple)
        ]
    }
    
    /// Generate random scatter data
    public static func scatterData(count: Int = 50) -> [(x: Double, y: Double)] {
        (0..<count).map { _ in
            (x: Double.random(in: 0...100), y: Double.random(in: 0...100))
        }
    }
    
    /// Generate timeline events
    public static func timelineEvents() -> [TimelineEvent] {
        let now = Date()
        return [
            TimelineEvent(date: now.addingTimeInterval(-86400 * 30), title: "Project Started", subtitle: "Initial planning", icon: "star.fill", color: .blue),
            TimelineEvent(date: now.addingTimeInterval(-86400 * 20), title: "Design Complete", subtitle: "UI/UX approved", icon: "paintbrush.fill", color: .purple),
            TimelineEvent(date: now.addingTimeInterval(-86400 * 10), title: "Development", subtitle: "Core features done", icon: "hammer.fill", color: .orange),
            TimelineEvent(date: now, title: "Launch", subtitle: "Released to production", icon: "rocket.fill", color: .green)
        ]
    }
    
    /// Generate leaderboard entries
    public static func leaderboardEntries() -> [LeaderboardEntry] {
        let names = ["Alice", "Bob", "Carol", "David", "Eva", "Frank", "Grace"]
        return names.enumerated().map { index, name in
            LeaderboardEntry(
                rank: index + 1,
                name: name,
                subtitle: "Level \(40 - index * 2)",
                score: Double(15000 - index * 1500 + Int.random(in: -500...500)),
                previousRank: index + 1 + Int.random(in: -2...2),
                color: ChartTheme.defaultPalette[index % ChartTheme.defaultPalette.count]
            )
        }
    }
}

// MARK: - Debug Helpers

#if DEBUG
extension View {
    /// Add debug border to view
    public func debugBorder(_ color: Color = .red) -> some View {
        self.border(color, width: 1)
    }
    
    /// Print view lifecycle
    public func debugLifecycle(_ name: String) -> some View {
        self.onAppear { print("[\(name)] appeared") }
            .onDisappear { print("[\(name)] disappeared") }
    }
}
#endif
