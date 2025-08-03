import SwiftUI

/// A high-performance bar chart view with smooth animations and interactive features.
///
/// This view provides vertical and horizontal bar charts with customizable styling,
/// animations, and comprehensive accessibility support.
///
/// ```swift
/// BarChartView(data: chartData)
///     .chartStyle(.vertical)
///     .animation(.spring())
///     .frame(height: 300)
/// ```
///
/// - Note: Optimized for performance with large datasets and smooth 60fps animations.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct BarChartView: View {
    
    // MARK: - Properties
    
    /// Chart data points
    @State private var data: [ChartDataPoint]
    
    /// Chart configuration
    @State private var configuration: ChartConfiguration
    
    /// Chart style (vertical or horizontal)
    @State private var chartStyle: BarChartStyle
    
    /// Animation state
    @State private var animationProgress: Double = 0.0
    
    /// Selected bar
    @State private var selectedBar: ChartDataPoint?
    
    /// Highlighted bar
    @State private var highlightedBar: ChartDataPoint?
    
    // MARK: - Initialization
    
    /// Creates a new bar chart view.
    ///
    /// - Parameters:
    ///   - data: Chart data points
    ///   - style: Chart style (defaults to vertical)
    ///   - configuration: Chart configuration (optional)
    public init(
        data: [ChartDataPoint],
        style: BarChartStyle = .vertical,
        configuration: ChartConfiguration = ChartConfiguration()
    ) {
        self._data = State(initialValue: data)
        self._chartStyle = State(initialValue: style)
        self._configuration = State(initialValue: configuration)
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundColor
                
                // Grid
                if configuration.showGrid {
                    gridView(in: geometry)
                }
                
                // Axes
                if configuration.showXAxis || configuration.showYAxis {
                    axesView(in: geometry)
                }
                
                // Bars
                barsView(in: geometry)
                
                // Interactive overlay
                interactiveOverlay(in: geometry)
                
                // Tooltip
                if let selectedBar = selectedBar, configuration.tooltipsEnabled {
                    tooltipView(for: selectedBar, in: geometry)
                }
            }
            .clipped()
            .border(configuration.borderColor, width: configuration.borderWidth)
            .animation(configuration.animation, value: data)
            .animation(configuration.animation, value: animationProgress)
            .onAppear {
                startAnimation()
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Bar chart with \(data.count) bars")
            .accessibilityValue(accessibilityValue)
            .accessibilityHint("Tap bars to select, double tap to zoom")
        }
    }
    
    // MARK: - Background
    
    private var backgroundColor: some View {
        Rectangle()
            .fill(configuration.backgroundColor)
            .ignoresSafeArea()
    }
    
    // MARK: - Grid
    
    private func gridView(in geometry: GeometryProxy) -> some View {
        BarChartGridView(
            size: geometry.size,
            configuration: configuration,
            chartStyle: chartStyle,
            dataRange: dataRange
        )
    }
    
    // MARK: - Axes
    
    private func axesView(in geometry: GeometryProxy) -> some View {
        BarChartAxesView(
            size: geometry.size,
            configuration: configuration,
            chartStyle: chartStyle,
            dataRange: dataRange
        )
    }
    
    // MARK: - Bars
    
    private func barsView(in geometry: GeometryProxy) -> some View {
        BarsView(
            data: data,
            size: geometry.size,
            configuration: configuration,
            chartStyle: chartStyle,
            animationProgress: animationProgress,
            selectedBar: $selectedBar,
            highlightedBar: $highlightedBar,
            dataRange: dataRange
        )
    }
    
    // MARK: - Interactive Overlay
    
    private func interactiveOverlay(in geometry: GeometryProxy) -> some View {
        BarChartInteractiveOverlayView(
            size: geometry.size,
            configuration: configuration,
            selectedBar: $selectedBar,
            highlightedBar: $highlightedBar
        )
    }
    
    // MARK: - Tooltip
    
    private func tooltipView(for bar: ChartDataPoint, in geometry: GeometryProxy) -> some View {
        BarChartTooltipView(
            bar: bar,
            configuration: configuration
        )
        .position(tooltipPosition(for: bar, in: geometry))
    }
    
    // MARK: - Computed Properties
    
    private var dataRange: BarChartDataRange {
        return BarChartDataRange(from: data, style: chartStyle)
    }
    
    private var accessibilityValue: String {
        let total = data.reduce(0) { $0 + $1.y }
        let maxValue = data.maxY ?? 0
        return "Total: \(String(format: "%.1f", total)), Maximum: \(String(format: "%.1f", maxValue))"
    }
    
    // MARK: - Helper Methods
    
    private func startAnimation() {
        withAnimation(configuration.animation) {
            animationProgress = 1.0
        }
    }
    
    private func tooltipPosition(for bar: ChartDataPoint, in geometry: GeometryProxy) -> CGPoint {
        switch chartStyle {
        case .vertical:
            let x = dataRange.normalizeX(bar.x) * geometry.size.width
            let y = dataRange.normalizeY(bar.y) * geometry.size.height
            return CGPoint(x: x, y: y - 20)
        case .horizontal:
            let x = dataRange.normalizeX(bar.x) * geometry.size.width
            let y = dataRange.normalizeY(bar.y) * geometry.size.height
            return CGPoint(x: x + 20, y: y)
        }
    }
}

// MARK: - Chart Style

/// Bar chart style options
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum BarChartStyle: String, CaseIterable, Codable {
    case vertical
    case horizontal
}

// MARK: - Supporting Views

/// Grid view for bar chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct BarChartGridView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: BarChartStyle
    let dataRange: BarChartDataRange
    
    var body: some View {
        Canvas { context, size in
            drawGrid(context: context, size: size)
        }
    }
    
    private func drawGrid(context: GraphicsContext, size: CGSize) {
        let path = Path { path in
            switch chartStyle {
            case .vertical:
                // Horizontal grid lines
                for i in 0...10 {
                    let y = size.height * Double(i) / 10.0
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: size.width, y: y))
                }
            case .horizontal:
                // Vertical grid lines
                for i in 0...10 {
                    let x = size.width * Double(i) / 10.0
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: size.height))
                }
            }
        }
        
        context.stroke(
            path,
            with: .color(configuration.gridColor),
            lineWidth: configuration.gridWidth
        )
    }
}

/// Axes view for bar chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct BarChartAxesView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: BarChartStyle
    let dataRange: BarChartDataRange
    
    var body: some View {
        Canvas { context, size in
            drawAxes(context: context, size: size)
        }
    }
    
    private func drawAxes(context: GraphicsContext, size: CGSize) {
        let path = Path { path in
            switch chartStyle {
            case .vertical:
                // X-axis
                if configuration.showXAxis {
                    path.move(to: CGPoint(x: 0, y: size.height))
                    path.addLine(to: CGPoint(x: size.width, y: size.height))
                }
                // Y-axis
                if configuration.showYAxis {
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: size.height))
                }
            case .horizontal:
                // X-axis
                if configuration.showXAxis {
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: size.width, y: 0))
                }
                // Y-axis
                if configuration.showYAxis {
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: 0, y: size.height))
                }
            }
        }
        
        context.stroke(
            path,
            with: .color(configuration.axisColor),
            lineWidth: configuration.axisWidth
        )
    }
}

/// Bars view
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct BarsView: View {
    let data: [ChartDataPoint]
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: BarChartStyle
    let animationProgress: Double
    @Binding var selectedBar: ChartDataPoint?
    @Binding var highlightedBar: ChartDataPoint?
    let dataRange: BarChartDataRange
    
    var body: some View {
        ForEach(data) { bar in
            BarView(
                bar: bar,
                size: size,
                configuration: configuration,
                chartStyle: chartStyle,
                animationProgress: animationProgress,
                isSelected: selectedBar?.id == bar.id,
                isHighlighted: highlightedBar?.id == bar.id,
                dataRange: dataRange
            )
            .onTapGesture {
                selectedBar = bar
            }
            .onHover { isHovered in
                highlightedBar = isHovered ? bar : nil
            }
        }
    }
}

/// Individual bar view
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct BarView: View {
    let bar: ChartDataPoint
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: BarChartStyle
    let animationProgress: Double
    let isSelected: Bool
    let isHighlighted: Bool
    let dataRange: BarChartDataRange
    
    var body: some View {
        Rectangle()
            .fill(bar.effectiveColor)
            .frame(
                width: barWidth,
                height: barHeight
            )
            .position(barPosition)
            .scaleEffect(isSelected ? 1.1 : (isHighlighted ? 1.05 : 1.0))
            .animation(.easeInOut(duration: 0.2), value: isSelected)
            .animation(.easeInOut(duration: 0.1), value: isHighlighted)
    }
    
    private var barWidth: CGFloat {
        switch chartStyle {
        case .vertical:
            return size.width / CGFloat(dataRange.dataCount) * 0.8
        case .horizontal:
            return dataRange.normalizeValue(bar.y) * size.width * animationProgress
        }
    }
    
    private var barHeight: CGFloat {
        switch chartStyle {
        case .vertical:
            return dataRange.normalizeValue(bar.y) * size.height * animationProgress
        case .horizontal:
            return size.height / CGFloat(dataRange.dataCount) * 0.8
        }
    }
    
    private var barPosition: CGPoint {
        switch chartStyle {
        case .vertical:
            let x = dataRange.normalizeX(bar.x) * size.width
            let y = size.height - barHeight / 2
            return CGPoint(x: x, y: y)
        case .horizontal:
            let x = barWidth / 2
            let y = dataRange.normalizeY(bar.y) * size.height
            return CGPoint(x: x, y: y)
        }
    }
}

/// Interactive overlay for bar chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct BarChartInteractiveOverlayView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    @Binding var selectedBar: ChartDataPoint?
    @Binding var highlightedBar: ChartDataPoint?
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                selectedBar = nil
            }
    }
}

/// Tooltip view for bar chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct BarChartTooltipView: View {
    let bar: ChartDataPoint
    let configuration: ChartConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let label = bar.label {
                Text(label)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            
            Text("Value: \(String(format: "%.2f", bar.y))")
                .font(.caption2)
            
            if let category = bar.category {
                Text("Category: \(category)")
                    .font(.caption2)
            }
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

// MARK: - Supporting Types

/// Data range for bar chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct BarChartDataRange {
    let minX: Double
    let maxX: Double
    let minValue: Double
    let maxValue: Double
    let dataCount: Int
    
    init(from data: [ChartDataPoint], style: BarChartStyle) {
        self.minX = data.minX ?? 0
        self.maxX = data.maxX ?? 1
        self.minValue = data.minY ?? 0
        self.maxValue = data.maxY ?? 1
        self.dataCount = data.count
    }
    
    func normalizeX(_ x: Double) -> Double {
        return (x - minX) / (maxX - minX)
    }
    
    func normalizeY(_ y: Double) -> Double {
        return (y - minX) / (maxX - minX)
    }
    
    func normalizeValue(_ value: Double) -> Double {
        return (value - minValue) / (maxValue - minValue)
    }
} 