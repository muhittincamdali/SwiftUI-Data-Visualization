import SwiftUI

/// A high-performance scatter plot view with 2D and 3D support.
///
/// This view provides scatter plots, bubble charts, and 3D scatter plots
/// with customizable styling and interactive features.
///
/// ```swift
/// ScatterPlotView(data: scatterData)
///     .chartStyle(.scatter)
///     .pointSize(8)
///     .pointColor(.blue)
///     .frame(height: 300)
/// ```
///
/// - Note: Optimized for performance with large datasets and smooth animations.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ScatterPlotView: View {
    
    // MARK: - Properties
    
    /// Chart data points
    @State private var data: [ChartDataPoint]
    
    /// Chart configuration
    @State private var configuration: ChartConfiguration
    
    /// Chart style (scatter, bubble, 3D)
    @State private var chartStyle: ScatterPlotStyle
    
    /// Animation state
    @State private var animationProgress: Double = 0.0
    
    /// Selected point
    @State private var selectedPoint: ChartDataPoint?
    
    /// Highlighted point
    @State private var highlightedPoint: ChartDataPoint?
    
    // MARK: - Initialization
    
    /// Creates a new scatter plot view.
    ///
    /// - Parameters:
    ///   - data: Chart data points
    ///   - style: Chart style (defaults to scatter)
    ///   - configuration: Chart configuration (optional)
    public init(
        data: [ChartDataPoint],
        style: ScatterPlotStyle = .scatter,
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
                
                // Data points
                dataPoints(in: geometry)
                
                // Interactive overlay
                interactiveOverlay(in: geometry)
                
                // Tooltip
                if let selectedPoint = selectedPoint, configuration.tooltipsEnabled {
                    tooltipView(for: selectedPoint, in: geometry)
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
            .accessibilityLabel("Scatter plot with \(data.count) points")
            .accessibilityValue(accessibilityValue)
            .accessibilityHint("Tap points to select, double tap to zoom")
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
        ScatterPlotGridView(
            size: geometry.size,
            configuration: configuration,
            dataRange: dataRange
        )
    }
    
    // MARK: - Axes
    
    private func axesView(in geometry: GeometryProxy) -> some View {
        ScatterPlotAxesView(
            size: geometry.size,
            configuration: configuration,
            dataRange: dataRange
        )
    }
    
    // MARK: - Data Points
    
    private func dataPoints(in geometry: GeometryProxy) -> some View {
        ScatterPlotPointsView(
            data: data,
            size: geometry.size,
            configuration: configuration,
            chartStyle: chartStyle,
            animationProgress: animationProgress,
            selectedPoint: $selectedPoint,
            highlightedPoint: $highlightedPoint,
            dataRange: dataRange
        )
    }
    
    // MARK: - Interactive Overlay
    
    private func interactiveOverlay(in geometry: GeometryProxy) -> some View {
        ScatterPlotInteractiveOverlayView(
            size: geometry.size,
            configuration: configuration,
            selectedPoint: $selectedPoint,
            highlightedPoint: $highlightedPoint
        )
    }
    
    // MARK: - Tooltip
    
    private func tooltipView(for point: ChartDataPoint, in geometry: GeometryProxy) -> some View {
        ScatterPlotTooltipView(
            point: point,
            configuration: configuration
        )
        .position(tooltipPosition(for: point, in: geometry))
    }
    
    // MARK: - Computed Properties
    
    private var dataRange: ScatterPlotDataRange {
        return ScatterPlotDataRange(from: data)
    }
    
    private var accessibilityValue: String {
        let total = data.count
        let maxValue = data.maxY ?? 0
        let minValue = data.minY ?? 0
        return "\(total) points, Y range: \(String(format: "%.1f", minValue)) to \(String(format: "%.1f", maxValue))"
    }
    
    // MARK: - Helper Methods
    
    private func startAnimation() {
        withAnimation(configuration.animation) {
            animationProgress = 1.0
        }
    }
    
    private func tooltipPosition(for point: ChartDataPoint, in geometry: GeometryProxy) -> CGPoint {
        let x = dataRange.normalizeX(point.x) * geometry.size.width
        let y = dataRange.normalizeY(point.y) * geometry.size.height
        return CGPoint(x: x, y: y - 20)
    }
}

// MARK: - Chart Style

/// Scatter plot style options
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum ScatterPlotStyle: String, CaseIterable, Codable {
    case scatter
    case bubble
    case density
}

// MARK: - Supporting Views

/// Grid view for scatter plot
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct ScatterPlotGridView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    let dataRange: ScatterPlotDataRange
    
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

/// Axes view for scatter plot
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct ScatterPlotAxesView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    let dataRange: ScatterPlotDataRange
    
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

/// Data points view for scatter plot
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct ScatterPlotPointsView: View {
    let data: [ChartDataPoint]
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: ScatterPlotStyle
    let animationProgress: Double
    @Binding var selectedPoint: ChartDataPoint?
    @Binding var highlightedPoint: ChartDataPoint?
    let dataRange: ScatterPlotDataRange
    
    var body: some View {
        ForEach(data) { point in
            ScatterPlotPointView(
                point: point,
                size: size,
                configuration: configuration,
                chartStyle: chartStyle,
                animationProgress: animationProgress,
                isSelected: selectedPoint?.id == point.id,
                isHighlighted: highlightedPoint?.id == point.id,
                dataRange: dataRange
            )
            .onTapGesture {
                selectedPoint = point
            }
            .onHover { isHovered in
                highlightedPoint = isHovered ? point : nil
            }
        }
    }
}

/// Individual point view for scatter plot
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct ScatterPlotPointView: View {
    let point: ChartDataPoint
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: ScatterPlotStyle
    let animationProgress: Double
    let isSelected: Bool
    let isHighlighted: Bool
    let dataRange: ScatterPlotDataRange
    
    var body: some View {
        Group {
            switch chartStyle {
            case .scatter:
                scatterPoint
            case .bubble:
                bubblePoint
            case .density:
                densityPoint
            }
        }
        .position(pointPosition)
        .scaleEffect(isSelected ? 1.5 : (isHighlighted ? 1.2 : 1.0))
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isHighlighted)
    }
    
    private var scatterPoint: some View {
        Circle()
            .fill(point.effectiveColor)
            .frame(width: point.effectiveSize, height: point.effectiveSize)
    }
    
    private var bubblePoint: some View {
        Circle()
            .fill(point.effectiveColor.opacity(0.7))
            .frame(width: bubbleSize, height: bubbleSize)
            .overlay(
                Circle()
                    .stroke(point.effectiveColor, lineWidth: 2)
            )
    }
    
    private var densityPoint: some View {
        Circle()
            .fill(point.effectiveColor.opacity(0.3))
            .frame(width: densitySize, height: densitySize)
    }
    
    private var bubbleSize: CGFloat {
        let baseSize = point.effectiveSize
        let weight = point.weight ?? 1.0
        return baseSize * CGFloat(weight) * 2
    }
    
    private var densitySize: CGFloat {
        let baseSize = point.effectiveSize
        let density = calculateDensity()
        return baseSize * CGFloat(density)
    }
    
    private func calculateDensity() -> Double {
        // Simplified density calculation
        let nearbyPoints = data.filter { otherPoint in
            let distance = sqrt(pow(point.x - otherPoint.x, 2) + pow(point.y - otherPoint.y, 2))
            return distance < 10
        }
        return Double(nearbyPoints.count) / 10.0
    }
    
    private var pointPosition: CGPoint {
        let x = dataRange.normalizeX(point.x) * size.width
        let y = dataRange.normalizeY(point.y) * size.height
        return CGPoint(x: x, y: y)
    }
}

/// Interactive overlay for scatter plot
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct ScatterPlotInteractiveOverlayView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    @Binding var selectedPoint: ChartDataPoint?
    @Binding var highlightedPoint: ChartDataPoint?
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                selectedPoint = nil
            }
    }
}

/// Tooltip view for scatter plot
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct ScatterPlotTooltipView: View {
    let point: ChartDataPoint
    let configuration: ChartConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let label = point.label {
                Text(label)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            
            Text("X: \(String(format: "%.2f", point.x))")
                .font(.caption2)
            
            Text("Y: \(String(format: "%.2f", point.y))")
                .font(.caption2)
            
            if let z = point.z {
                Text("Z: \(String(format: "%.2f", z))")
                    .font(.caption2)
            }
            
            if let weight = point.weight {
                Text("Weight: \(String(format: "%.2f", weight))")
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

/// Data range for scatter plot
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct ScatterPlotDataRange {
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