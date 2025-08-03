import SwiftUI

/// A line chart that displays data points connected by lines.
///
/// This chart type is ideal for showing trends over time or continuous data.
/// It supports multiple data series, custom styling, and interactive features.
///
/// - Example:
/// ```swift
/// LineChart(data: salesData)
///     .chartStyle(.line)
///     .animation(.easeInOut(duration: 0.5))
///     .interactive(true)
/// ```
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct LineChart: View {
    
    // MARK: - Properties
    
    /// Data points to display
    private let data: [ChartDataPoint]
    
    /// Chart configuration
    private let configuration: ChartConfiguration
    
    /// Chart dimensions
    @State private var chartSize: CGSize = .zero
    
    /// Animation progress
    @State private var animationProgress: Double = 0
    
    /// Selected data point
    @State private var selectedPoint: ChartDataPoint?
    
    /// Zoom level
    @State private var zoomLevel: Double = 1.0
    
    /// Pan offset
    @State private var panOffset: CGPoint = .zero
    
    // MARK: - Initialization
    
    /// Creates a new line chart with data and configuration.
    ///
    /// - Parameters:
    ///   - data: Array of data points to display
    ///   - configuration: Chart configuration options
    public init(data: [ChartDataPoint], configuration: ChartConfiguration = ChartConfiguration()) {
        self.data = data
        self.configuration = configuration
    }
    
    /// Creates a new line chart with data and style.
    ///
    /// - Parameters:
    ///   - data: Array of data points to display
    ///   - style: Chart style
    public init(data: [ChartDataPoint], style: ChartStyle = .line) {
        self.data = data
        self.configuration = ChartConfiguration().withStyle(style)
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundColor
                
                // Grid
                if configuration.grid.enabled {
                    gridView
                }
                
                // Chart content
                chartContent
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                // Axes
                if configuration.xAxis.enabled {
                    xAxisView
                }
                if configuration.yAxis.enabled {
                    yAxisView
                }
                
                // Legend
                if configuration.legend.enabled {
                    legendView
                }
                
                // Tooltip
                if configuration.tooltipEnabled && selectedPoint != nil {
                    tooltipView
                }
            }
            .onAppear {
                chartSize = geometry.size
                startAnimation()
            }
            .onChange(of: geometry.size) { newSize in
                chartSize = newSize
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        handleDrag(value)
                    }
                    .onEnded { _ in
                        handleDragEnd()
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { scale in
                        handleZoom(scale)
                    }
            )
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        handleTap()
                    }
            )
        }
        .background(configuration.backgroundColor)
        .border(configuration.borderColor, width: configuration.borderWidth)
        .cornerRadius(configuration.cornerRadius)
        .shadow(
            color: configuration.shadow.color,
            radius: configuration.shadow.radius,
            x: configuration.shadow.x,
            y: configuration.shadow.y
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(configuration.accessibility.label ?? "Line Chart")
        .accessibilityHint(configuration.accessibility.hint ?? "Shows data trends over time")
        .accessibilityValue(configuration.accessibility.value ?? "\(data.count) data points")
        .accessibilityAddTraits(configuration.accessibility.traits)
    }
    
    // MARK: - Chart Components
    
    /// Background view
    private var backgroundColor: some View {
        Rectangle()
            .fill(configuration.backgroundColor)
            .ignoresSafeArea()
    }
    
    /// Grid view
    private var gridView: some View {
        Path { path in
            drawGrid(path: &path)
        }
        .stroke(configuration.grid.color, lineWidth: configuration.grid.lineWidth)
        .opacity(0.3)
    }
    
    /// Chart content view
    private var chartContent: some View {
        ZStack {
            // Line path
            Path { path in
                drawLinePath(path: &path)
            }
            .stroke(configuration.colors.first ?? .blue, lineWidth: 2)
            .scaleEffect(animationProgress)
            .opacity(animationProgress)
            
            // Data points
            ForEach(data.indices, id: \.self) { index in
                dataPointView(for: data[index], at: index)
            }
        }
    }
    
    /// Data point view
    private func dataPointView(for point: ChartDataPoint, at index: Int) -> some View {
        let position = calculatePointPosition(for: point)
        let color = point.color ?? configuration.colors[index % configuration.colors.count]
        
        return Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .position(position)
            .scaleEffect(selectedPoint?.id == point.id ? 1.5 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: selectedPoint?.id)
            .onTapGesture {
                handlePointTap(point)
            }
    }
    
    /// X-axis view
    private var xAxisView: some View {
        Path { path in
            drawXAxis(path: &path)
        }
        .stroke(configuration.xAxis.color, lineWidth: configuration.xAxis.lineWidth)
    }
    
    /// Y-axis view
    private var yAxisView: some View {
        Path { path in
            drawYAxis(path: &path)
        }
        .stroke(configuration.yAxis.color, lineWidth: configuration.yAxis.lineWidth)
    }
    
    /// Legend view
    private var legendView: some View {
        VStack {
            HStack {
                ForEach(Array(configuration.colors.enumerated()), id: \.offset) { index, color in
                    HStack {
                        Circle()
                            .fill(color)
                            .frame(width: 12, height: 12)
                        Text("Series \(index + 1)")
                            .font(.caption)
                            .foregroundColor(configuration.legend.color)
                    }
                }
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(8)
        .position(calculateLegendPosition())
    }
    
    /// Tooltip view
    private var tooltipView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let point = selectedPoint {
                Text("X: \(String(format: "%.2f", point.x))")
                    .font(.caption)
                Text("Y: \(String(format: "%.2f", point.y))")
                    .font(.caption)
                if let label = point.label {
                    Text(label)
                        .font(.caption)
                        .fontWeight(.bold)
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(6)
        .shadow(radius: 2)
        .position(calculateTooltipPosition())
    }
    
    // MARK: - Drawing Methods
    
    /// Draws the line path
    private func drawLinePath(path: inout Path) {
        guard !data.isEmpty else { return }
        
        let points = data.map { calculatePointPosition(for: $0) }
        
        path.move(to: points[0])
        
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
    }
    
    /// Draws the grid
    private func drawGrid(path: inout Path) {
        let gridSpacing: CGFloat = 50
        
        // Vertical lines
        for x in stride(from: 0, through: chartSize.width, by: gridSpacing) {
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: chartSize.height))
        }
        
        // Horizontal lines
        for y in stride(from: 0, through: chartSize.height, by: gridSpacing) {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: chartSize.width, y: y))
        }
    }
    
    /// Draws the X-axis
    private func drawXAxis(path: inout Path) {
        path.move(to: CGPoint(x: 0, y: chartSize.height - 20))
        path.addLine(to: CGPoint(x: chartSize.width, y: chartSize.height - 20))
    }
    
    /// Draws the Y-axis
    private func drawYAxis(path: inout Path) {
        path.move(to: CGPoint(x: 20, y: 0))
        path.addLine(to: CGPoint(x: 20, y: chartSize.height))
    }
    
    // MARK: - Calculation Methods
    
    /// Calculates position for a data point
    private func calculatePointPosition(for point: ChartDataPoint) -> CGPoint {
        let xRange = data.map { $0.x }.min() ?? 0...data.map { $0.x }.max() ?? 1
        let yRange = data.map { $0.y }.min() ?? 0...data.map { $0.y }.max() ?? 1
        
        let xScale = (chartSize.width - 40) / (xRange.upperBound - xRange.lowerBound)
        let yScale = (chartSize.height - 40) / (yRange.upperBound - yRange.lowerBound)
        
        let x = 20 + (point.x - xRange.lowerBound) * xScale
        let y = chartSize.height - 20 - (point.y - yRange.lowerBound) * yScale
        
        return CGPoint(x: x, y: y)
    }
    
    /// Calculates legend position
    private func calculateLegendPosition() -> CGPoint {
        switch configuration.legend.position {
        case .top:
            return CGPoint(x: chartSize.width / 2, y: 50)
        case .bottom:
            return CGPoint(x: chartSize.width / 2, y: chartSize.height - 50)
        case .left:
            return CGPoint(x: 100, y: chartSize.height / 2)
        case .right:
            return CGPoint(x: chartSize.width - 100, y: chartSize.height / 2)
        }
    }
    
    /// Calculates tooltip position
    private func calculateTooltipPosition() -> CGPoint {
        guard let selectedPoint = selectedPoint else { return .zero }
        let pointPosition = calculatePointPosition(for: selectedPoint)
        return CGPoint(x: pointPosition.x, y: pointPosition.y - 30)
    }
    
    // MARK: - Interaction Methods
    
    /// Handles drag gesture
    private func handleDrag(_ value: DragGesture.Value) {
        guard configuration.panEnabled else { return }
        
        let translation = value.translation
        panOffset = CGPoint(
            x: panOffset.x + translation.x,
            y: panOffset.y + translation.y
        )
    }
    
    /// Handles drag end
    private func handleDragEnd() {
        // Implement pan end logic
    }
    
    /// Handles zoom gesture
    private func handleZoom(_ scale: Double) {
        guard configuration.zoomEnabled else { return }
        
        zoomLevel = max(0.5, min(3.0, zoomLevel * scale))
    }
    
    /// Handles tap gesture
    private func handleTap() {
        // Implement tap logic
    }
    
    /// Handles point tap
    private func handlePointTap(_ point: ChartDataPoint) {
        if configuration.selectionEnabled {
            selectedPoint = selectedPoint?.id == point.id ? nil : point
        }
    }
    
    // MARK: - Animation Methods
    
    /// Starts the animation
    private func startAnimation() {
        guard configuration.animationsEnabled else {
            animationProgress = 1.0
            return
        }
        
        withAnimation(configuration.animation ?? .easeInOut(duration: configuration.animationDuration)) {
            animationProgress = 1.0
        }
    }
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct LineChart_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = [
            ChartDataPoint(x: 1, y: 10, label: "Jan"),
            ChartDataPoint(x: 2, y: 25, label: "Feb"),
            ChartDataPoint(x: 3, y: 15, label: "Mar"),
            ChartDataPoint(x: 4, y: 30, label: "Apr"),
            ChartDataPoint(x: 5, y: 20, label: "May")
        ]
        
        LineChart(data: sampleData)
            .frame(height: 300)
            .padding()
    }
} 