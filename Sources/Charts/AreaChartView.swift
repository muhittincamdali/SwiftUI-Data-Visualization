import SwiftUI

/// A high-performance area chart view with gradient fills and smooth animations.
///
/// This view provides area charts with customizable gradients, transparency,
/// and interactive features for data visualization.
///
/// ```swift
/// AreaChartView(data: areaData)
///     .chartStyle(.area)
///     .gradientFill(.blue.opacity(0.3))
///     .animation(.easeInOut(duration: 0.8))
///     .frame(height: 300)
/// ```
///
/// - Note: Optimized for performance with large datasets and smooth 60fps animations.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AreaChartView: View {
    
    // MARK: - Properties
    
    /// Chart data points
    @State private var data: [ChartDataPoint]
    
    /// Chart configuration
    @State private var configuration: ChartConfiguration
    
    /// Chart style (area, stacked, gradient)
    @State private var chartStyle: AreaChartStyle
    
    /// Animation state
    @State private var animationProgress: Double = 0.0
    
    /// Selected area
    @State private var selectedArea: ChartDataPoint?
    
    /// Highlighted area
    @State private var highlightedArea: ChartDataPoint?
    
    /// Gradient fill color
    @State private var gradientFill: Color
    
    /// Fill opacity
    @State private var fillOpacity: Double
    
    // MARK: - Initialization
    
    /// Creates a new area chart view.
    ///
    /// - Parameters:
    ///   - data: Chart data points
    ///   - style: Chart style (defaults to area)
    ///   - configuration: Chart configuration (optional)
    ///   - gradientFill: Gradient fill color (optional)
    ///   - fillOpacity: Fill opacity (defaults to 0.3)
    public init(
        data: [ChartDataPoint],
        style: AreaChartStyle = .area,
        configuration: ChartConfiguration = ChartConfiguration(),
        gradientFill: Color? = nil,
        fillOpacity: Double = 0.3
    ) {
        self._data = State(initialValue: data)
        self._chartStyle = State(initialValue: style)
        self._configuration = State(initialValue: configuration)
        self._gradientFill = State(initialValue: gradientFill ?? .blue)
        self._fillOpacity = State(initialValue: fillOpacity)
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
                
                // Area fill
                areaFill(in: geometry)
                
                // Area line
                areaLine(in: geometry)
                
                // Data points
                dataPoints(in: geometry)
                
                // Interactive overlay
                interactiveOverlay(in: geometry)
                
                // Tooltip
                if let selectedArea = selectedArea, configuration.tooltipsEnabled {
                    tooltipView(for: selectedArea, in: geometry)
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
            .accessibilityLabel("Area chart with \(data.count) data points")
            .accessibilityValue(accessibilityValue)
            .accessibilityHint("Tap areas to select, double tap to zoom")
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
        AreaChartGridView(
            size: geometry.size,
            configuration: configuration,
            dataRange: dataRange
        )
    }
    
    // MARK: - Axes
    
    private func axesView(in geometry: GeometryProxy) -> some View {
        AreaChartAxesView(
            size: geometry.size,
            configuration: configuration,
            dataRange: dataRange
        )
    }
    
    // MARK: - Area Fill
    
    private func areaFill(in geometry: GeometryProxy) -> some View {
        AreaFillView(
            data: data,
            size: geometry.size,
            configuration: configuration,
            chartStyle: chartStyle,
            animationProgress: animationProgress,
            gradientFill: gradientFill,
            fillOpacity: fillOpacity,
            dataRange: dataRange
        )
    }
    
    // MARK: - Area Line
    
    private func areaLine(in geometry: GeometryProxy) -> some View {
        AreaLineView(
            data: data,
            size: geometry.size,
            configuration: configuration,
            chartStyle: chartStyle,
            animationProgress: animationProgress,
            dataRange: dataRange
        )
    }
    
    // MARK: - Data Points
    
    private func dataPoints(in geometry: GeometryProxy) -> some View {
        AreaChartPointsView(
            data: data,
            size: geometry.size,
            configuration: configuration,
            chartStyle: chartStyle,
            animationProgress: animationProgress,
            selectedArea: $selectedArea,
            highlightedArea: $highlightedArea,
            dataRange: dataRange
        )
    }
    
    // MARK: - Interactive Overlay
    
    private func interactiveOverlay(in geometry: GeometryProxy) -> some View {
        AreaChartInteractiveOverlayView(
            size: geometry.size,
            configuration: configuration,
            selectedArea: $selectedArea,
            highlightedArea: $highlightedArea
        )
    }
    
    // MARK: - Tooltip
    
    private func tooltipView(for area: ChartDataPoint, in geometry: GeometryProxy) -> some View {
        AreaChartTooltipView(
            area: area,
            configuration: configuration
        )
        .position(tooltipPosition(for: area, in: geometry))
    }
    
    // MARK: - Computed Properties
    
    private var dataRange: AreaChartDataRange {
        return AreaChartDataRange(from: data)
    }
    
    private var accessibilityValue: String {
        let total = data.reduce(0) { $0 + $1.y }
        let average = total / Double(data.count)
        return "Total area: \(String(format: "%.1f", total)), Average: \(String(format: "%.1f", average))"
    }
    
    // MARK: - Helper Methods
    
    private func startAnimation() {
        withAnimation(configuration.animation) {
            animationProgress = 1.0
        }
    }
    
    private func tooltipPosition(for area: ChartDataPoint, in geometry: GeometryProxy) -> CGPoint {
        let x = dataRange.normalizeX(area.x) * geometry.size.width
        let y = dataRange.normalizeY(area.y) * geometry.size.height
        return CGPoint(x: x, y: y - 20)
    }
}

// MARK: - Chart Style

/// Area chart style options
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum AreaChartStyle: String, CaseIterable, Codable {
    case area
    case stacked
    case gradient
}

// MARK: - Supporting Views

/// Grid view for area chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct AreaChartGridView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    let dataRange: AreaChartDataRange
    
    var body: some View {
        Canvas { context, size in
            drawGrid(context: context, size: size)
        }
    }
    
    private func drawGrid(context: GraphicsContext, size: CGSize) {
        let path = Path { path in
            // Vertical grid lines
            for i in 0...10 {
                let x = size.width * Double(i) / 10.0
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
            
            // Horizontal grid lines
            for i in 0...10 {
                let y = size.height * Double(i) / 10.0
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }
        }
        
        context.stroke(
            path,
            with: .color(configuration.gridColor),
            lineWidth: configuration.gridWidth
        )
    }
}

/// Axes view for area chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct AreaChartAxesView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    let dataRange: AreaChartDataRange
    
    var body: some View {
        Canvas { context, size in
            drawAxes(context: context, size: size)
        }
    }
    
    private func drawAxes(context: GraphicsContext, size: CGSize) {
        let path = Path { path in
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
        }
        
        context.stroke(
            path,
            with: .color(configuration.axisColor),
            lineWidth: configuration.axisWidth
        )
    }
}

/// Area fill view
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct AreaFillView: View {
    let data: [ChartDataPoint]
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: AreaChartStyle
    let animationProgress: Double
    let gradientFill: Color
    let fillOpacity: Double
    let dataRange: AreaChartDataRange
    
    var body: some View {
        Canvas { context, size in
            drawAreaFill(context: context, size: size)
        }
    }
    
    private func drawAreaFill(context: GraphicsContext, size: CGSize) {
        guard data.count > 1 else { return }
        
        let sortedData = data.sortedByX
        let path = Path { path in
            // Start at bottom-left
            path.move(to: CGPoint(x: 0, y: size.height))
            
            // Draw line through data points
            for (index, point) in sortedData.enumerated() {
                let x = dataRange.normalizeX(point.x) * size.width
                let y = dataRange.normalizeY(point.y) * size.height * animationProgress
                
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            
            // Close the path to bottom-right
            path.addLine(to: CGPoint(x: size.width, y: size.height))
            path.closeSubpath()
        }
        
        // Create gradient
        let gradient = Gradient(colors: [
            gradientFill.opacity(fillOpacity),
            gradientFill.opacity(fillOpacity * 0.5)
        ])
        
        context.fill(
            path,
            with: .linearGradient(
                gradient,
                startPoint: CGPoint(x: 0, y: 0),
                endPoint: CGPoint(x: 0, y: size.height)
            )
        )
    }
}

/// Area line view
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct AreaLineView: View {
    let data: [ChartDataPoint]
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: AreaChartStyle
    let animationProgress: Double
    let dataRange: AreaChartDataRange
    
    var body: some View {
        Canvas { context, size in
            drawAreaLine(context: context, size: size)
        }
    }
    
    private func drawAreaLine(context: GraphicsContext, size: CGSize) {
        guard data.count > 1 else { return }
        
        let sortedData = data.sortedByX
        let path = Path { path in
            for (index, point) in sortedData.enumerated() {
                let x = dataRange.normalizeX(point.x) * size.width
                let y = dataRange.normalizeY(point.y) * size.height * animationProgress
                
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        
        context.stroke(
            path,
            with: .color(data.first?.effectiveColor ?? .blue),
            lineWidth: 2.0
        )
    }
}

/// Data points view for area chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct AreaChartPointsView: View {
    let data: [ChartDataPoint]
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: AreaChartStyle
    let animationProgress: Double
    @Binding var selectedArea: ChartDataPoint?
    @Binding var highlightedArea: ChartDataPoint?
    let dataRange: AreaChartDataRange
    
    var body: some View {
        ForEach(data) { point in
            AreaChartPointView(
                point: point,
                size: size,
                configuration: configuration,
                chartStyle: chartStyle,
                animationProgress: animationProgress,
                isSelected: selectedArea?.id == point.id,
                isHighlighted: highlightedArea?.id == point.id,
                dataRange: dataRange
            )
            .onTapGesture {
                selectedArea = point
            }
            .onHover { isHovered in
                highlightedArea = isHovered ? point : nil
            }
        }
    }
}

/// Individual point view for area chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct AreaChartPointView: View {
    let point: ChartDataPoint
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: AreaChartStyle
    let animationProgress: Double
    let isSelected: Bool
    let isHighlighted: Bool
    let dataRange: AreaChartDataRange
    
    var body: some View {
        Circle()
            .fill(point.effectiveColor)
            .frame(width: point.effectiveSize, height: point.effectiveSize)
            .scaleEffect(isSelected ? 1.5 : (isHighlighted ? 1.2 : 1.0))
            .position(pointPosition)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
            .animation(.easeInOut(duration: 0.1), value: isHighlighted)
    }
    
    private var pointPosition: CGPoint {
        let x = dataRange.normalizeX(point.x) * size.width
        let y = dataRange.normalizeY(point.y) * size.height * animationProgress
        return CGPoint(x: x, y: y)
    }
}

/// Interactive overlay for area chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct AreaChartInteractiveOverlayView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    @Binding var selectedArea: ChartDataPoint?
    @Binding var highlightedArea: ChartDataPoint?
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                selectedArea = nil
            }
    }
}

/// Tooltip view for area chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct AreaChartTooltipView: View {
    let area: ChartDataPoint
    let configuration: ChartConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let label = area.label {
                Text(label)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            
            Text("X: \(String(format: "%.2f", area.x))")
                .font(.caption2)
            
            Text("Y: \(String(format: "%.2f", area.y))")
                .font(.caption2)
            
            if let category = area.category {
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

/// Data range for area chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct AreaChartDataRange {
    let minX: Double
    let maxX: Double
    let minY: Double
    let maxY: Double
    
    init(from data: [ChartDataPoint]) {
        self.minX = data.minX ?? 0
        self.maxX = data.maxX ?? 1
        self.minY = data.minY ?? 0
        self.maxY = data.maxY ?? 1
    }
    
    func normalizeX(_ x: Double) -> Double {
        return (x - minX) / (maxX - minX)
    }
    
    func normalizeY(_ y: Double) -> Double {
        return 1.0 - (y - minY) / (maxY - minY)
    }
} 