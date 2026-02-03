// MARK: - Dashboard View Template
// SwiftUI-Data-Visualization Framework
// Created by Muhittin Camdali

import SwiftUI
import Charts

// MARK: - Dashboard Layout

/// Layout configuration for dashboard
public struct DashboardLayout: Sendable {
    public let columns: Int
    public let spacing: CGFloat
    public let padding: EdgeInsets
    
    public static let compact = DashboardLayout(columns: 2, spacing: 8, padding: EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    public static let standard = DashboardLayout(columns: 2, spacing: 16, padding: EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    public static let spacious = DashboardLayout(columns: 2, spacing: 24, padding: EdgeInsets(top: 24, leading: 24, bottom: 24, trailing: 24))
    
    public init(columns: Int, spacing: CGFloat, padding: EdgeInsets) {
        self.columns = columns
        self.spacing = spacing
        self.padding = padding
    }
}

// MARK: - Dashboard Card

/// Individual card component for dashboard
public struct DashboardCard<Content: View>: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let content: () -> Content
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.content = content
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
            
            content()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray6) : .white)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - KPI Card

/// Key Performance Indicator card
public struct KPICard: View {
    let title: String
    let value: String
    let change: Double?
    let icon: String
    let color: Color
    
    public init(
        title: String,
        value: String,
        change: Double? = nil,
        icon: String = "chart.bar.fill",
        color: Color = .blue
    ) {
        self.title = title
        self.value = value
        self.change = change
        self.icon = icon
        self.color = color
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(color)
                
                Spacer()
                
                if let change = change {
                    HStack(spacing: 2) {
                        Image(systemName: change >= 0 ? "arrow.up.right" : "arrow.down.right")
                        Text(String(format: "%.1f%%", abs(change)))
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(change >= 0 ? .green : .red)
                }
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
            
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

// MARK: - Sparkline View

/// Compact sparkline chart
public struct SparklineView: View {
    let data: [Double]
    let color: Color
    let showArea: Bool
    
    public init(
        data: [Double],
        color: Color = .blue,
        showArea: Bool = true
    ) {
        self.data = data
        self.color = color
        self.showArea = showArea
    }
    
    public var body: some View {
        Chart(Array(data.enumerated()), id: \.offset) { index, value in
            if showArea {
                AreaMark(
                    x: .value("Index", index),
                    y: .value("Value", value)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [color.opacity(0.3), color.opacity(0.1)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
            }
            
            LineMark(
                x: .value("Index", index),
                y: .value("Value", value)
            )
            .foregroundStyle(color)
            .interpolationMethod(.catmullRom)
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartLegend(.hidden)
    }
}

// MARK: - Dashboard View

/// Main dashboard container view
public struct DashboardView<Content: View>: View {
    let title: String
    let subtitle: String?
    let layout: DashboardLayout
    let content: () -> Content
    
    @State private var refreshing = false
    
    public init(
        title: String,
        subtitle: String? = nil,
        layout: DashboardLayout = .standard,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.layout = layout
        self.content = content
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: layout.spacing) {
                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.bottom, 8)
                
                // Content
                content()
            }
            .padding(layout.padding)
        }
        .refreshable {
            refreshing = true
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            refreshing = false
        }
    }
}

// MARK: - Dashboard Grid

/// Grid layout for dashboard cards
public struct DashboardGrid<Content: View>: View {
    let columns: Int
    let spacing: CGFloat
    let content: () -> Content
    
    public init(
        columns: Int = 2,
        spacing: CGFloat = 16,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.columns = columns
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: spacing), count: columns),
            spacing: spacing
        ) {
            content()
        }
    }
}

// MARK: - Mini Chart Card

/// Compact chart card for dashboard
public struct MiniChartCard: View {
    let title: String
    let value: String
    let data: [Double]
    let color: Color
    
    public init(
        title: String,
        value: String,
        data: [Double],
        color: Color = .blue
    ) {
        self.title = title
        self.value = value
        self.data = data
        self.color = color
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            SparklineView(data: data, color: color)
                .frame(height: 40)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Progress Card

/// Card showing progress towards a goal
public struct ProgressCard: View {
    let title: String
    let current: Double
    let target: Double
    let color: Color
    
    public init(
        title: String,
        current: Double,
        target: Double,
        color: Color = .blue
    ) {
        self.title = title
        self.current = current
        self.target = target
        self.color = color
    }
    
    private var progress: Double {
        min(current / target, 1.0)
    }
    
    private var percentage: String {
        String(format: "%.0f%%", progress * 100)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Text(percentage)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(color)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color.opacity(0.2))
                        .frame(height: 12)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 12)
                }
            }
            .frame(height: 12)
            
            HStack {
                Text(String(format: "%.0f", current))
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                Text("Goal: \(String(format: "%.0f", target))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

// MARK: - Preview

#Preview("Dashboard") {
    DashboardView(title: "Analytics", subtitle: "Last 30 days") {
        DashboardGrid(columns: 2) {
            KPICard(title: "Revenue", value: "$45,231", change: 12.5, icon: "dollarsign.circle.fill", color: .green)
            KPICard(title: "Users", value: "2,345", change: -3.2, icon: "person.2.fill", color: .blue)
            MiniChartCard(title: "Sales", value: "1,234", data: [10, 15, 12, 18, 20, 25, 22, 28], color: .orange)
            ProgressCard(title: "Monthly Goal", current: 75, target: 100, color: .purple)
        }
    }
}
