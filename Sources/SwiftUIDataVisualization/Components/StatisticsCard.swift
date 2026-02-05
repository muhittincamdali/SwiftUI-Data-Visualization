// StatisticsCard.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Statistics Data Models

/// Represents a statistic value with trend information
public struct StatisticData: Identifiable {
    public let id: UUID
    public let title: String
    public let value: String
    public let previousValue: String?
    public let trend: Trend?
    public let trendValue: String?
    public let icon: String?
    public let color: Color
    public let sparklineData: [Double]?
    
    public enum Trend {
        case up
        case down
        case neutral
        
        var icon: String {
            switch self {
            case .up: return "arrow.up.right"
            case .down: return "arrow.down.right"
            case .neutral: return "arrow.right"
            }
        }
        
        var color: Color {
            switch self {
            case .up: return .green
            case .down: return .red
            case .neutral: return .gray
            }
        }
    }
    
    public init(
        id: UUID = UUID(),
        title: String,
        value: String,
        previousValue: String? = nil,
        trend: Trend? = nil,
        trendValue: String? = nil,
        icon: String? = nil,
        color: Color = .blue,
        sparklineData: [Double]? = nil
    ) {
        self.id = id
        self.title = title
        self.value = value
        self.previousValue = previousValue
        self.trend = trend
        self.trendValue = trendValue
        self.icon = icon
        self.color = color
        self.sparklineData = sparklineData
    }
}

/// Configuration for statistics card appearance
public struct StatisticsCardConfiguration {
    public var style: CardStyle
    public var showTrendIcon: Bool
    public var showSparkline: Bool
    public var animationDuration: Double
    public var cornerRadius: CGFloat
    public var shadowRadius: CGFloat
    
    public enum CardStyle {
        case standard
        case compact
        case detailed
        case gradient
        case minimal
    }
    
    public init(
        style: CardStyle = .standard,
        showTrendIcon: Bool = true,
        showSparkline: Bool = true,
        animationDuration: Double = 0.5,
        cornerRadius: CGFloat = 16,
        shadowRadius: CGFloat = 8
    ) {
        self.style = style
        self.showTrendIcon = showTrendIcon
        self.showSparkline = showSparkline
        self.animationDuration = animationDuration
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
    }
}

// MARK: - Statistics Card View

/// A beautiful statistics card with trend indicators and sparklines
public struct StatisticsCard: View {
    let data: StatisticData
    let configuration: StatisticsCardConfiguration
    let onTap: (() -> Void)?
    
    @State private var isAnimated = false
    
    public init(
        data: StatisticData,
        configuration: StatisticsCardConfiguration = StatisticsCardConfiguration(),
        onTap: (() -> Void)? = nil
    ) {
        self.data = data
        self.configuration = configuration
        self.onTap = onTap
    }
    
    public var body: some View {
        Group {
            switch configuration.style {
            case .standard:
                standardCard
            case .compact:
                compactCard
            case .detailed:
                detailedCard
            case .gradient:
                gradientCard
            case .minimal:
                minimalCard
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                isAnimated = true
            }
        }
        .onTapGesture {
            onTap?()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(data.title): \(data.value)")
        .accessibilityHint(data.trend != nil ? "Trend: \(data.trend == .up ? "increasing" : data.trend == .down ? "decreasing" : "stable")" : "")
    }
    
    // MARK: - Standard Card
    
    private var standardCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let icon = data.icon {
                    ZStack {
                        Circle()
                            .fill(data.color.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: icon)
                            .font(.system(size: 18))
                            .foregroundColor(data.color)
                    }
                }
                
                Spacer()
                
                if let trend = data.trend, configuration.showTrendIcon {
                    trendBadge(trend: trend)
                }
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(data.title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(data.value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                    .opacity(isAnimated ? 1 : 0)
                    .offset(y: isAnimated ? 0 : 10)
            }
            
            if configuration.showSparkline, let sparklineData = data.sparklineData {
                SparklineView(data: sparklineData, color: data.color)
                    .frame(height: 40)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: configuration.shadowRadius, y: 4)
        )
    }
    
    // MARK: - Compact Card
    
    private var compactCard: some View {
        HStack(spacing: 12) {
            if let icon = data.icon {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(data.color)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(data.title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(data.value)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            
            Spacer()
            
            if let trend = data.trend, let trendValue = data.trendValue {
                HStack(spacing: 4) {
                    Image(systemName: trend.icon)
                    Text(trendValue)
                }
                .font(.caption)
                .foregroundColor(trend.color)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        )
    }
    
    // MARK: - Detailed Card
    
    private var detailedCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(data.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if let previousValue = data.previousValue {
                        Text("Previous: \(previousValue)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if let icon = data.icon {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(data.color.opacity(0.15))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(data.color)
                    }
                }
            }
            
            HStack(alignment: .bottom, spacing: 8) {
                Text(data.value)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                if let trend = data.trend, let trendValue = data.trendValue {
                    HStack(spacing: 4) {
                        Image(systemName: trend.icon)
                        Text(trendValue)
                    }
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(trend.color)
                    .padding(.bottom, 6)
                }
                
                Spacer()
            }
            
            if configuration.showSparkline, let sparklineData = data.sparklineData {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Last 7 days")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    SparklineView(data: sparklineData, color: data.color, style: .filled)
                        .frame(height: 60)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.08), radius: configuration.shadowRadius, y: 4)
        )
    }
    
    // MARK: - Gradient Card
    
    private var gradientCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let icon = data.icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                if let trend = data.trend, let trendValue = data.trendValue {
                    HStack(spacing: 4) {
                        Image(systemName: trend.icon)
                        Text(trendValue)
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(.white.opacity(0.2)))
                }
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 4) {
                Text(data.value)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(data.title)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .padding(20)
        .frame(minHeight: 140)
        .background(
            RoundedRectangle(cornerRadius: configuration.cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [data.color, data.color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .shadow(color: data.color.opacity(0.3), radius: configuration.shadowRadius, y: 4)
        )
    }
    
    // MARK: - Minimal Card
    
    private var minimalCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(data.title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(alignment: .bottom, spacing: 6) {
                Text(data.value)
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                if let trend = data.trend, let trendValue = data.trendValue {
                    HStack(spacing: 2) {
                        Image(systemName: trend.icon)
                            .font(.caption2)
                        Text(trendValue)
                            .font(.caption)
                    }
                    .foregroundColor(trend.color)
                    .padding(.bottom, 4)
                }
            }
        }
        .padding(12)
    }
    
    // MARK: - Helper Views
    
    private func trendBadge(trend: StatisticData.Trend) -> some View {
        HStack(spacing: 4) {
            Image(systemName: trend.icon)
            if let trendValue = data.trendValue {
                Text(trendValue)
            }
        }
        .font(.caption)
        .fontWeight(.medium)
        .foregroundColor(trend.color)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(trend.color.opacity(0.15))
        )
    }
}

// MARK: - Sparkline View

/// A mini chart for trend visualization
public struct SparklineView: View {
    let data: [Double]
    let color: Color
    let style: SparklineStyle
    
    public enum SparklineStyle {
        case line
        case filled
        case bars
    }
    
    public init(data: [Double], color: Color = .blue, style: SparklineStyle = .line) {
        self.data = data
        self.color = color
        self.style = style
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let minValue = data.min() ?? 0
            let maxValue = data.max() ?? 1
            let range = maxValue - minValue
            
            switch style {
            case .line:
                lineSparkline(in: geometry.size, minValue: minValue, range: range)
            case .filled:
                filledSparkline(in: geometry.size, minValue: minValue, range: range)
            case .bars:
                barSparkline(in: geometry.size, minValue: minValue, range: range)
            }
        }
    }
    
    private func lineSparkline(in size: CGSize, minValue: Double, range: Double) -> some View {
        Path { path in
            guard data.count > 1 else { return }
            
            let stepX = size.width / CGFloat(data.count - 1)
            
            for (index, value) in data.enumerated() {
                let x = CGFloat(index) * stepX
                let normalizedY = range > 0 ? (value - minValue) / range : 0.5
                let y = size.height * (1 - normalizedY)
                
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
    }
    
    private func filledSparkline(in size: CGSize, minValue: Double, range: Double) -> some View {
        ZStack {
            // Fill
            Path { path in
                guard data.count > 1 else { return }
                
                let stepX = size.width / CGFloat(data.count - 1)
                
                path.move(to: CGPoint(x: 0, y: size.height))
                
                for (index, value) in data.enumerated() {
                    let x = CGFloat(index) * stepX
                    let normalizedY = range > 0 ? (value - minValue) / range : 0.5
                    let y = size.height * (1 - normalizedY)
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                path.addLine(to: CGPoint(x: size.width, y: size.height))
                path.closeSubpath()
            }
            .fill(
                LinearGradient(
                    colors: [color.opacity(0.3), color.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Line
            lineSparkline(in: size, minValue: minValue, range: range)
        }
    }
    
    private func barSparkline(in size: CGSize, minValue: Double, range: Double) -> some View {
        HStack(alignment: .bottom, spacing: 2) {
            ForEach(data.indices, id: \.self) { index in
                let value = data[index]
                let normalizedHeight = range > 0 ? (value - minValue) / range : 0.5
                let height = max(2, size.height * normalizedHeight)
                
                RoundedRectangle(cornerRadius: 1)
                    .fill(color.opacity(0.8))
                    .frame(height: height)
            }
        }
    }
}

// MARK: - Statistics Grid

/// A grid of statistics cards
public struct StatisticsGrid: View {
    let statistics: [StatisticData]
    let columns: Int
    let configuration: StatisticsCardConfiguration
    
    public init(
        statistics: [StatisticData],
        columns: Int = 2,
        configuration: StatisticsCardConfiguration = StatisticsCardConfiguration()
    ) {
        self.statistics = statistics
        self.columns = columns
        self.configuration = configuration
    }
    
    public var body: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: columns),
            spacing: 16
        ) {
            ForEach(statistics) { stat in
                StatisticsCard(data: stat, configuration: configuration)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct StatisticsCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                StatisticsCard(
                    data: StatisticData(
                        title: "Total Revenue",
                        value: "$24,500",
                        trend: .up,
                        trendValue: "+12.5%",
                        icon: "dollarsign.circle.fill",
                        color: .green,
                        sparklineData: [10, 15, 12, 18, 22, 19, 25]
                    )
                )
                
                StatisticsCard(
                    data: StatisticData(
                        title: "Active Users",
                        value: "1,234",
                        trend: .up,
                        trendValue: "+8%",
                        icon: "person.2.fill",
                        color: .blue
                    ),
                    configuration: StatisticsCardConfiguration(style: .gradient)
                )
                
                StatisticsCard(
                    data: StatisticData(
                        title: "Performance",
                        value: "98.5%",
                        previousValue: "96.2%",
                        trend: .up,
                        trendValue: "+2.3%",
                        icon: "speedometer",
                        color: .purple,
                        sparklineData: [92, 94, 93, 96, 95, 97, 98]
                    ),
                    configuration: StatisticsCardConfiguration(style: .detailed)
                )
            }
            .padding()
        }
    }
}
#endif
