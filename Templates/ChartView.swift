// MARK: - Chart View Template
// SwiftUI-Data-Visualization Framework
// Created by Muhittin Camdali

import SwiftUI
import Charts

// MARK: - Chart Data Protocol

/// Protocol for chart data sources
public protocol ChartDataSource: Identifiable, Sendable {
    var label: String { get }
    var value: Double { get }
    var category: String { get }
}

// MARK: - Data Point

/// Generic data point for charts
public struct DataPoint: ChartDataSource, Equatable, Hashable {
    public let id = UUID()
    public let label: String
    public let value: Double
    public let category: String
    public let date: Date?
    public let metadata: [String: String]
    
    public init(
        label: String,
        value: Double,
        category: String = "Default",
        date: Date? = nil,
        metadata: [String: String] = [:]
    ) {
        self.label = label
        self.value = value
        self.category = category
        self.date = date
        self.metadata = metadata
    }
    
    public static func == (lhs: DataPoint, rhs: DataPoint) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// MARK: - Chart Configuration

/// Configuration for chart appearance
public struct ChartConfiguration {
    public var showLegend: Bool
    public var showGrid: Bool
    public var showAxes: Bool
    public var animationDuration: Double
    public var colorScheme: [Color]
    public var cornerRadius: CGFloat
    public var spacing: CGFloat
    
    public static let `default` = ChartConfiguration(
        showLegend: true,
        showGrid: true,
        showAxes: true,
        animationDuration: 0.3,
        colorScheme: [.blue, .green, .orange, .purple, .red, .pink],
        cornerRadius: 4,
        spacing: 2
    )
    
    public init(
        showLegend: Bool = true,
        showGrid: Bool = true,
        showAxes: Bool = true,
        animationDuration: Double = 0.3,
        colorScheme: [Color] = [.blue, .green, .orange, .purple, .red, .pink],
        cornerRadius: CGFloat = 4,
        spacing: CGFloat = 2
    ) {
        self.showLegend = showLegend
        self.showGrid = showGrid
        self.showAxes = showAxes
        self.animationDuration = animationDuration
        self.colorScheme = colorScheme
        self.cornerRadius = cornerRadius
        self.spacing = spacing
    }
}

// MARK: - Base Chart View

/// Base view for all chart types
public struct BaseChartView<Content: View>: View {
    let title: String?
    let subtitle: String?
    let configuration: ChartConfiguration
    let content: () -> Content
    
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        configuration: ChartConfiguration = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.configuration = configuration
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            content()
                .animation(.easeInOut(duration: configuration.animationDuration), value: UUID())
        }
        .padding()
    }
}

// MARK: - Bar Chart View

/// Bar chart view component
public struct BarChartView: View {
    let data: [DataPoint]
    let configuration: ChartConfiguration
    
    @State private var animatedData: [DataPoint] = []
    
    public init(
        data: [DataPoint],
        configuration: ChartConfiguration = .default
    ) {
        self.data = data
        self.configuration = configuration
    }
    
    public var body: some View {
        Chart(animatedData) { point in
            BarMark(
                x: .value("Category", point.label),
                y: .value("Value", point.value)
            )
            .foregroundStyle(by: .value("Category", point.category))
            .cornerRadius(configuration.cornerRadius)
        }
        .chartLegend(configuration.showLegend ? .visible : .hidden)
        .chartXAxis(configuration.showAxes ? .visible : .hidden)
        .chartYAxis(configuration.showAxes ? .visible : .hidden)
        .onAppear {
            withAnimation(.easeInOut(duration: configuration.animationDuration)) {
                animatedData = data
            }
        }
        .onChange(of: data) { _, newValue in
            withAnimation(.easeInOut(duration: configuration.animationDuration)) {
                animatedData = newValue
            }
        }
    }
}

// MARK: - Line Chart View

/// Line chart view component
public struct LineChartView: View {
    let data: [DataPoint]
    let configuration: ChartConfiguration
    let showSymbols: Bool
    let interpolation: InterpolationMethod
    
    @State private var animatedData: [DataPoint] = []
    
    public init(
        data: [DataPoint],
        configuration: ChartConfiguration = .default,
        showSymbols: Bool = true,
        interpolation: InterpolationMethod = .catmullRom
    ) {
        self.data = data
        self.configuration = configuration
        self.showSymbols = showSymbols
        self.interpolation = interpolation
    }
    
    public var body: some View {
        Chart(animatedData) { point in
            LineMark(
                x: .value("Label", point.label),
                y: .value("Value", point.value)
            )
            .foregroundStyle(by: .value("Category", point.category))
            .interpolationMethod(interpolation)
            
            if showSymbols {
                PointMark(
                    x: .value("Label", point.label),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(by: .value("Category", point.category))
            }
        }
        .chartLegend(configuration.showLegend ? .visible : .hidden)
        .onAppear {
            withAnimation(.easeInOut(duration: configuration.animationDuration)) {
                animatedData = data
            }
        }
        .onChange(of: data) { _, newValue in
            withAnimation(.easeInOut(duration: configuration.animationDuration)) {
                animatedData = newValue
            }
        }
    }
}

// MARK: - Pie Chart View

/// Pie chart view component
public struct PieChartView: View {
    let data: [DataPoint]
    let configuration: ChartConfiguration
    let innerRadius: CGFloat
    
    @State private var selectedSlice: DataPoint?
    
    public init(
        data: [DataPoint],
        configuration: ChartConfiguration = .default,
        innerRadius: CGFloat = 0
    ) {
        self.data = data
        self.configuration = configuration
        self.innerRadius = innerRadius
    }
    
    private var total: Double {
        data.reduce(0) { $0 + $1.value }
    }
    
    public var body: some View {
        Chart(data) { point in
            SectorMark(
                angle: .value("Value", point.value),
                innerRadius: .ratio(innerRadius),
                angularInset: 1.5
            )
            .foregroundStyle(by: .value("Category", point.label))
            .cornerRadius(configuration.cornerRadius)
            .opacity(selectedSlice?.id == point.id ? 1 : 0.8)
        }
        .chartLegend(configuration.showLegend ? .visible : .hidden)
        .chartBackground { chartProxy in
            if innerRadius > 0 {
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotFrame!]
                    VStack {
                        if let selected = selectedSlice {
                            Text(selected.label)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.1f%%", selected.value / total * 100))
                                .font(.headline)
                        } else {
                            Text("Total")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.0f", total))
                                .font(.headline)
                        }
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
        }
    }
}

// MARK: - Area Chart View

/// Area chart view component
public struct AreaChartView: View {
    let data: [DataPoint]
    let configuration: ChartConfiguration
    let gradient: Bool
    
    public init(
        data: [DataPoint],
        configuration: ChartConfiguration = .default,
        gradient: Bool = true
    ) {
        self.data = data
        self.configuration = configuration
        self.gradient = gradient
    }
    
    public var body: some View {
        Chart(data) { point in
            AreaMark(
                x: .value("Label", point.label),
                y: .value("Value", point.value)
            )
            .foregroundStyle(by: .value("Category", point.category))
            .interpolationMethod(.catmullRom)
            
            LineMark(
                x: .value("Label", point.label),
                y: .value("Value", point.value)
            )
            .foregroundStyle(by: .value("Category", point.category))
            .interpolationMethod(.catmullRom)
        }
        .chartLegend(configuration.showLegend ? .visible : .hidden)
    }
}

// MARK: - Scatter Chart View

/// Scatter plot view component
public struct ScatterChartView: View {
    let data: [DataPoint]
    let configuration: ChartConfiguration
    let pointSize: CGFloat
    
    public init(
        data: [DataPoint],
        configuration: ChartConfiguration = .default,
        pointSize: CGFloat = 8
    ) {
        self.data = data
        self.configuration = configuration
        self.pointSize = pointSize
    }
    
    public var body: some View {
        Chart(data) { point in
            PointMark(
                x: .value("Label", point.label),
                y: .value("Value", point.value)
            )
            .foregroundStyle(by: .value("Category", point.category))
            .symbolSize(pointSize * pointSize)
        }
        .chartLegend(configuration.showLegend ? .visible : .hidden)
    }
}

// MARK: - Chart View Modifiers

public extension View {
    /// Apply chart style
    func chartStyle(_ style: ChartStyle) -> some View {
        self.modifier(ChartStyleModifier(style: style))
    }
}

public enum ChartStyle {
    case minimal
    case detailed
    case presentation
    case dashboard
}

struct ChartStyleModifier: ViewModifier {
    let style: ChartStyle
    
    func body(content: Content) -> some View {
        switch style {
        case .minimal:
            content
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .chartLegend(.hidden)
        case .detailed:
            content
                .chartXAxis(.visible)
                .chartYAxis(.visible)
                .chartLegend(.visible)
        case .presentation:
            content
                .chartXAxis(.visible)
                .chartYAxis(.visible)
                .chartLegend(.visible)
                .frame(minHeight: 300)
        case .dashboard:
            content
                .chartXAxis(.automatic)
                .chartYAxis(.automatic)
                .chartLegend(.hidden)
                .frame(maxHeight: 200)
        }
    }
}

// MARK: - Preview

#Preview("Bar Chart") {
    let data = [
        DataPoint(label: "Jan", value: 120, category: "Sales"),
        DataPoint(label: "Feb", value: 150, category: "Sales"),
        DataPoint(label: "Mar", value: 180, category: "Sales"),
        DataPoint(label: "Apr", value: 140, category: "Sales"),
    ]
    
    return BaseChartView(title: "Monthly Sales", subtitle: "Q1 2025") {
        BarChartView(data: data)
    }
    .frame(height: 300)
}
