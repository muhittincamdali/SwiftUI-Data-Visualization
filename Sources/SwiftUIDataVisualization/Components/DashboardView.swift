// DashboardView.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Dashboard Data Models

/// Represents a widget in the dashboard
public struct DashboardWidget: Identifiable {
    public let id: UUID
    public let title: String
    public let subtitle: String?
    public let size: WidgetSize
    public let content: AnyView
    public let refreshInterval: TimeInterval?
    public var isLoading: Bool
    public var lastUpdated: Date?
    
    public enum WidgetSize {
        case small      // 1x1
        case medium     // 2x1
        case large      // 2x2
        case wide       // 3x1
        case tall       // 1x2
        case extraLarge // 3x2
        
        var columns: Int {
            switch self {
            case .small, .tall: return 1
            case .medium, .large: return 2
            case .wide, .extraLarge: return 3
            }
        }
        
        var rows: Int {
            switch self {
            case .small, .medium, .wide: return 1
            case .tall, .large, .extraLarge: return 2
            }
        }
    }
    
    public init<Content: View>(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        size: WidgetSize = .medium,
        refreshInterval: TimeInterval? = nil,
        isLoading: Bool = false,
        lastUpdated: Date? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.size = size
        self.refreshInterval = refreshInterval
        self.isLoading = isLoading
        self.lastUpdated = lastUpdated
        self.content = AnyView(content())
    }
}

/// Configuration for dashboard appearance
public struct DashboardConfiguration {
    public var columns: Int
    public var spacing: CGFloat
    public var widgetCornerRadius: CGFloat
    public var showWidgetHeaders: Bool
    public var showRefreshIndicator: Bool
    public var enableDragReorder: Bool
    public var animationDuration: Double
    public var style: DashboardStyle
    
    public enum DashboardStyle {
        case standard
        case card
        case flat
        case glass
    }
    
    public init(
        columns: Int = 3,
        spacing: CGFloat = 16,
        widgetCornerRadius: CGFloat = 16,
        showWidgetHeaders: Bool = true,
        showRefreshIndicator: Bool = true,
        enableDragReorder: Bool = false,
        animationDuration: Double = 0.3,
        style: DashboardStyle = .card
    ) {
        self.columns = columns
        self.spacing = spacing
        self.widgetCornerRadius = widgetCornerRadius
        self.showWidgetHeaders = showWidgetHeaders
        self.showRefreshIndicator = showRefreshIndicator
        self.enableDragReorder = enableDragReorder
        self.animationDuration = animationDuration
        self.style = style
    }
}

// MARK: - Dashboard View

/// A responsive dashboard layout with customizable widgets
public struct DashboardView: View {
    @Binding private var widgets: [DashboardWidget]
    private let configuration: DashboardConfiguration
    private let onWidgetTap: ((DashboardWidget) -> Void)?
    private let onRefresh: ((DashboardWidget) -> Void)?
    
    @State private var selectedWidget: DashboardWidget?
    @State private var animationProgress: CGFloat = 0
    @State private var draggedWidget: DashboardWidget?
    
    public init(
        widgets: Binding<[DashboardWidget]>,
        configuration: DashboardConfiguration = DashboardConfiguration(),
        onWidgetTap: ((DashboardWidget) -> Void)? = nil,
        onRefresh: ((DashboardWidget) -> Void)? = nil
    ) {
        self._widgets = widgets
        self.configuration = configuration
        self.onWidgetTap = onWidgetTap
        self.onRefresh = onRefresh
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let columnWidth = (geometry.size.width - CGFloat(configuration.columns - 1) * configuration.spacing) / CGFloat(configuration.columns)
            
            ScrollView {
                LazyVGrid(
                    columns: Array(repeating: GridItem(.fixed(columnWidth), spacing: configuration.spacing), count: configuration.columns),
                    spacing: configuration.spacing
                ) {
                    ForEach(widgets) { widget in
                        widgetView(widget, columnWidth: columnWidth)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedWidget = widget
                                }
                                onWidgetTap?(widget)
                            }
                    }
                }
                .padding(configuration.spacing)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animationProgress = 1
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Dashboard with \(widgets.count) widgets")
    }
    
    // MARK: - Widget View
    
    private func widgetView(_ widget: DashboardWidget, columnWidth: CGFloat) -> some View {
        let width = columnWidth * CGFloat(widget.size.columns) + configuration.spacing * CGFloat(widget.size.columns - 1)
        let height = columnWidth * CGFloat(widget.size.rows) + configuration.spacing * CGFloat(widget.size.rows - 1)
        
        return VStack(alignment: .leading, spacing: 0) {
            // Header
            if configuration.showWidgetHeaders {
                widgetHeader(widget)
            }
            
            // Content
            ZStack {
                widget.content
                
                // Loading overlay
                if widget.isLoading {
                    loadingOverlay
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: width, height: height)
        .background(widgetBackground(widget))
        .clipShape(RoundedRectangle(cornerRadius: configuration.widgetCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: configuration.widgetCornerRadius)
                .stroke(selectedWidget?.id == widget.id ? Color.blue : Color.clear, lineWidth: 2)
        )
        .opacity(Double(animationProgress))
        .scaleEffect(animationProgress)
    }
    
    private func widgetHeader(_ widget: DashboardWidget) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(widget.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                if let subtitle = widget.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            if configuration.showRefreshIndicator {
                if widget.isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else if let lastUpdated = widget.lastUpdated {
                    Text(timeAgo(lastUpdated))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            // Refresh button
            if widget.refreshInterval != nil {
                Button(action: { onRefresh?(widget) }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .disabled(widget.isLoading)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
    
    @ViewBuilder
    private func widgetBackground(_ widget: DashboardWidget) -> some View {
        switch configuration.style {
        case .standard:
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
            
        case .card:
            RoundedRectangle(cornerRadius: configuration.widgetCornerRadius)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: 8, y: 4)
            
        case .flat:
            Color(.secondarySystemBackground)
            
        case .glass:
            Color(.systemBackground)
                .opacity(0.8)
                .background(.ultraThinMaterial)
        }
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.1)
            ProgressView()
        }
    }
    
    private func timeAgo(_ date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            return "\(Int(interval / 60))m ago"
        } else if interval < 86400 {
            return "\(Int(interval / 3600))h ago"
        }
        return "\(Int(interval / 86400))d ago"
    }
}

// MARK: - Dashboard Builder

/// A builder for creating dashboard layouts
public struct DashboardBuilder {
    private var widgets: [DashboardWidget] = []
    
    public init() {}
    
    public mutating func addWidget<Content: View>(
        title: String,
        subtitle: String? = nil,
        size: DashboardWidget.WidgetSize = .medium,
        refreshInterval: TimeInterval? = nil,
        @ViewBuilder content: () -> Content
    ) -> DashboardBuilder {
        widgets.append(DashboardWidget(
            title: title,
            subtitle: subtitle,
            size: size,
            refreshInterval: refreshInterval,
            content: content
        ))
        return self
    }
    
    public func build() -> [DashboardWidget] {
        return widgets
    }
}

// MARK: - Pre-built Dashboard Widgets

/// Quick stats widget
public struct QuickStatsWidget: View {
    let title: String
    let value: String
    let change: String?
    let icon: String
    let color: Color
    
    public init(title: String, value: String, change: String? = nil, icon: String, color: Color = .blue) {
        self.title = title
        self.value = value
        self.change = change
        self.icon = icon
        self.color = color
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let change = change {
                        Text(change)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(change.hasPrefix("+") ? .green : .red)
                    }
                }
            }
        }
        .padding(16)
    }
}

/// Chart widget wrapper
public struct ChartWidget<ChartContent: View>: View {
    let chartContent: ChartContent
    
    public init(@ViewBuilder chart: () -> ChartContent) {
        self.chartContent = chart()
    }
    
    public var body: some View {
        chartContent
            .padding(16)
    }
}

/// Activity feed widget
public struct ActivityFeedWidget: View {
    let activities: [Activity]
    
    public struct Activity: Identifiable {
        public let id: UUID
        public let icon: String
        public let title: String
        public let subtitle: String
        public let time: String
        public let color: Color
        
        public init(id: UUID = UUID(), icon: String, title: String, subtitle: String, time: String, color: Color = .blue) {
            self.id = id
            self.icon = icon
            self.title = title
            self.subtitle = subtitle
            self.time = time
            self.color = color
        }
    }
    
    public init(activities: [Activity]) {
        self.activities = activities
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            ForEach(activities.prefix(5)) { activity in
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(activity.color.opacity(0.15))
                            .frame(width: 36, height: 36)
                        
                        Image(systemName: activity.icon)
                            .font(.caption)
                            .foregroundColor(activity.color)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(activity.title)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Text(activity.subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    Text(activity.time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
    }
}

/// Progress list widget
public struct ProgressListWidget: View {
    let items: [ProgressItem]
    
    public struct ProgressItem: Identifiable {
        public let id: UUID
        public let title: String
        public let progress: Double
        public let color: Color
        
        public init(id: UUID = UUID(), title: String, progress: Double, color: Color = .blue) {
            self.id = id
            self.title = title
            self.progress = progress
            self.color = color
        }
    }
    
    public init(items: [ProgressItem]) {
        self.items = items
    }
    
    public var body: some View {
        VStack(spacing: 16) {
            ForEach(items.prefix(4)) { item in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(item.title)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Text("\(Int(item.progress * 100))%")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.gray.opacity(0.2))
                            
                            RoundedRectangle(cornerRadius: 3)
                                .fill(item.color)
                                .frame(width: geometry.size.width * item.progress)
                        }
                    }
                    .frame(height: 6)
                }
            }
        }
        .padding(16)
    }
}

// MARK: - Preview

#if DEBUG
struct DashboardView_Previews: PreviewProvider {
    static var widgets: [DashboardWidget] = [
        DashboardWidget(title: "Revenue", subtitle: "This month", size: .small) {
            QuickStatsWidget(title: "Total", value: "$24,500", change: "+12%", icon: "dollarsign.circle.fill", color: .green)
        },
        DashboardWidget(title: "Users", subtitle: "Active now", size: .small) {
            QuickStatsWidget(title: "Online", value: "1,234", change: "+8%", icon: "person.2.fill", color: .blue)
        },
        DashboardWidget(title: "Tasks", subtitle: "In progress", size: .medium) {
            ProgressListWidget(items: [
                ProgressListWidget.ProgressItem(title: "Design System", progress: 0.85, color: .purple),
                ProgressListWidget.ProgressItem(title: "API Integration", progress: 0.60, color: .blue),
                ProgressListWidget.ProgressItem(title: "Testing", progress: 0.35, color: .orange)
            ])
        },
        DashboardWidget(title: "Activity", subtitle: "Recent", size: .large) {
            ActivityFeedWidget(activities: [
                ActivityFeedWidget.Activity(icon: "person.fill.badge.plus", title: "New user signed up", subtitle: "john@example.com", time: "2m", color: .green),
                ActivityFeedWidget.Activity(icon: "cart.fill", title: "New order received", subtitle: "Order #12345", time: "15m", color: .blue),
                ActivityFeedWidget.Activity(icon: "star.fill", title: "New review", subtitle: "5 stars from Alice", time: "1h", color: .yellow)
            ])
        }
    ]
    
    static var previews: some View {
        DashboardView(widgets: .constant(widgets))
    }
}
#endif
