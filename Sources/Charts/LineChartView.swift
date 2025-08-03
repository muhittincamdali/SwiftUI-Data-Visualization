import SwiftUI

/// A SwiftUI view that displays data as a line chart.
///
/// Use `LineChartView` to create interactive line charts with customizable
/// styling and animations. Supports multiple data sets, real-time updates,
/// and comprehensive accessibility features.
///
/// ```swift
/// LineChartView(data: chartData)
///     .chartStyle(.line)
///     .animation(.easeInOut(duration: 0.8))
/// ```
///
/// - Note: Requires iOS 15.0+ and SwiftUI 3.0+
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct LineChartView: View {
    
    // MARK: - Properties
    
    /// The data points to display in the chart
    public let data: [ChartDataPoint]
    
    /// Chart configuration for styling and behavior
    public let configuration: ChartConfiguration
    
    /// Chart style (line, area, step, etc.)
    public let chartStyle: LineChartStyle
    
    /// Whether to show data points
    public let showDataPoints: Bool
    
    /// Whether to show data labels
    public let showDataLabels: Bool
    
    /// Whether to show trend line
    public let showTrendLine: Bool
    
    /// Whether to show confidence intervals
    public let showConfidenceIntervals: Bool
    
    /// Chart bounds for coordinate system
    @State private var chartBounds: CGRect = .zero
    
    /// Current zoom level
    @State private var zoomLevel: Double = 1.0
    
    /// Current pan offset
    @State private var panOffset: CGSize = .zero
    
    /// Selected data point
    @State private var selectedPoint: ChartDataPoint?
    
    /// Highlighted data point
    @State private var highlightedPoint: ChartDataPoint?
    
    /// Animation progress for entrance animation
    @State private var animationProgress: Double = 0.0
    
    // MARK: - Initialization
    
    /// Creates a new line chart view with the specified data.
    ///
    /// - Parameters:
    ///   - data: The data points to display
    ///   - configuration: Chart configuration (optional)
    ///   - chartStyle: Chart style (default: .line)
    ///   - showDataPoints: Whether to show data points (default: true)
    ///   - showDataLabels: Whether to show data labels (default: false)
    ///   - showTrendLine: Whether to show trend line (default: false)
    ///   - showConfidenceIntervals: Whether to show confidence intervals (default: false)
    public init(
        data: [ChartDataPoint],
        configuration: ChartConfiguration = ChartConfiguration(),
        chartStyle: LineChartStyle = .line,
        showDataPoints: Bool = true,
        showDataLabels: Bool = false,
        showTrendLine: Bool = false,
        showConfidenceIntervals: Bool = false
    ) {
        self.data = data
        self.configuration = configuration
        self.chartStyle = chartStyle
        self.showDataPoints = showDataPoints
        self.showDataLabels = showDataLabels
        self.showTrendLine = showTrendLine
        self.showConfidenceIntervals = showConfidenceIntervals
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundColor
                
                // Grid
                if configuration.showGrid {
                    gridView
                }
                
                // Chart content
                chartContent
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                
                // Axes
                if configuration.showXAxis || configuration.showYAxis {
                    axesView
                }
                
                // Legend
                if configuration.showLegend && data.categories.count > 1 {
                    legendView
                }
                
                // Tooltip
                if configuration.tooltipsEnabled, let highlightedPoint = highlightedPoint {
                    tooltipView(for: highlightedPoint)
                }
            }
            .onAppear {
                setupChartBounds(geometry: geometry)
                startEntranceAnimation()
            }
            .onChange(of: geometry.size) { _ in
                setupChartBounds(geometry: geometry)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        handlePanGesture(value)
                    }
                    .onEnded { _ in
                        handlePanGestureEnd()
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        handleZoomGesture(value)
                    }
                    .onEnded { _ in
                        handleZoomGestureEnd()
                    }
            )
            .accessibilityElement(children: .combine)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityValue(accessibilityValue)
            .accessibilityHint(accessibilityHint)
        }
    }
    
    // MARK: - Background
    
    private var backgroundColor: some View {
        Rectangle()
            .fill(configuration.backgroundColor)
            .border(configuration.borderColor, width: configuration.borderWidth)
    }
    
    // MARK: - Grid
    
    private var gridView: some View {
        Path { path in
            let gridSpacing = chartBounds.width / 10
            
            // Vertical grid lines
            for i in 0...10 {
                let x = chartBounds.minX + CGFloat(i) * gridSpacing
                path.move(to: CGPoint(x: x, y: chartBounds.minY))
                path.addLine(to: CGPoint(x: x, y: chartBounds.maxY))
            }
            
            // Horizontal grid lines
            let horizontalSpacing = chartBounds.height / 8
            for i in 0...8 {
                let y = chartBounds.minY + CGFloat(i) * horizontalSpacing
                path.move(to: CGPoint(x: chartBounds.minX, y: y))
                path.addLine(to: CGPoint(x: chartBounds.maxX, y: y))
            }
        }
        .stroke(configuration.gridColor, style: StrokeStyle(
            lineWidth: configuration.gridWidth,
            lineCap: .round,
            lineJoin: .round,
            dash: gridDashPattern
        ))
    }
    
    private var gridDashPattern: [CGFloat] {
        switch configuration.gridStyle {
        case .solid:
            return []
        case .dashed:
            return [5, 5]
        case .dotted:
            return [1, 3]
        }
    }
    
    // MARK: - Chart Content
    
    private var chartContent: some View {
        ZStack {
            // Confidence intervals
            if showConfidenceIntervals {
                confidenceIntervalsView
            }
            
            // Trend line
            if showTrendLine {
                trendLineView
            }
            
            // Main line
            linePathView
            
            // Data points
            if showDataPoints {
                dataPointsView
            }
            
            // Data labels
            if showDataLabels {
                dataLabelsView
            }
        }
        .scaleEffect(zoomLevel)
        .offset(panOffset)
        .animation(configuration.animationsEnabled ? configuration.animation : .none, value: animationProgress)
    }
    
    // MARK: - Line Path
    
    private var linePathView: some View {
        Path { path in
            guard !data.isEmpty else { return }
            
            let sortedData = data.sortedByX
            let points = sortedData.map { dataPoint in
                convertToChartCoordinates(dataPoint)
            }
            
            guard let firstPoint = points.first else { return }
            
            path.move(to: firstPoint)
            
            for point in points.dropFirst() {
                path.addLine(to: point)
            }
        }
        .stroke(configuration.colorPalette.first ?? .blue, style: StrokeStyle(
            lineWidth: 2.0,
            lineCap: .round,
            lineJoin: .round
        ))
        .scaleEffect(animationProgress, anchor: .bottomLeading)
    }
    
    // MARK: - Data Points
    
    private var dataPointsView: some View {
        ForEach(data) { dataPoint in
            Circle()
                .fill(dataPoint.effectiveColor)
                .frame(width: dataPoint.effectiveSize, height: dataPoint.effectiveSize)
                .position(convertToChartCoordinates(dataPoint))
                .scaleEffect(dataPoint.isHighlighted ? 1.5 : 1.0)
                .opacity(animationProgress)
                .onTapGesture {
                    handleDataPointTap(dataPoint)
                }
                .onHover { isHovered in
                    handleDataPointHover(dataPoint, isHovered: isHovered)
                }
        }
    }
    
    // MARK: - Data Labels
    
    private var dataLabelsView: some View {
        ForEach(data) { dataPoint in
            if let label = dataPoint.label {
                Text(label)
                    .font(configuration.axisLabelFont)
                    .foregroundColor(configuration.axisLabelColor)
                    .position(convertToChartCoordinates(dataPoint))
                    .offset(y: -20)
                    .opacity(animationProgress)
            }
        }
    }
    
    // MARK: - Trend Line
    
    private var trendLineView: some View {
        Path { path in
            guard data.count >= 2 else { return }
            
            let sortedData = data.sortedByX
            let trendPoints = calculateTrendLine(sortedData)
            
            guard let firstPoint = trendPoints.first else { return }
            
            path.move(to: firstPoint)
            
            for point in trendPoints.dropFirst() {
                path.addLine(to: point)
            }
        }
        .stroke(Color.red.opacity(0.7), style: StrokeStyle(
            lineWidth: 1.0,
            lineCap: .round,
            lineJoin: .round,
            dash: [5, 5]
        ))
    }
    
    // MARK: - Confidence Intervals
    
    private var confidenceIntervalsView: some View {
        Path { path in
            guard data.count >= 2 else { return }
            
            let sortedData = data.sortedByX
            let confidencePoints = calculateConfidenceIntervals(sortedData)
            
            // Upper bound
            if let firstUpper = confidencePoints.upper.first {
                path.move(to: firstUpper)
                for point in confidencePoints.upper.dropFirst() {
                    path.addLine(to: point)
                }
            }
            
            // Lower bound
            if let firstLower = confidencePoints.lower.first {
                path.move(to: firstLower)
                for point in confidencePoints.lower.dropFirst() {
                    path.addLine(to: point)
                }
            }
        }
        .stroke(Color.blue.opacity(0.3), style: StrokeStyle(
            lineWidth: 1.0,
            lineCap: .round,
            lineJoin: .round
        ))
    }
    
    // MARK: - Axes
    
    private var axesView: some View {
        Path { path in
            if configuration.showXAxis {
                // X-axis
                path.move(to: CGPoint(x: chartBounds.minX, y: chartBounds.midY))
                path.addLine(to: CGPoint(x: chartBounds.maxX, y: chartBounds.midY))
            }
            
            if configuration.showYAxis {
                // Y-axis
                path.move(to: CGPoint(x: chartBounds.midX, y: chartBounds.minY))
                path.addLine(to: CGPoint(x: chartBounds.midX, y: chartBounds.maxY))
            }
        }
        .stroke(configuration.axisColor, lineWidth: configuration.axisWidth)
    }
    
    // MARK: - Legend
    
    private var legendView: some View {
        VStack {
            ForEach(data.categories, id: \.self) { category in
                HStack {
                    Circle()
                        .fill(configuration.colorPalette.first ?? .blue)
                        .frame(width: 12, height: 12)
                    
                    Text(category)
                        .font(configuration.legendFont)
                        .foregroundColor(configuration.legendTextColor)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground).opacity(0.9))
        .cornerRadius(8)
        .position(legendPosition)
    }
    
    private var legendPosition: CGPoint {
        switch configuration.legendPosition {
        case .top:
            return CGPoint(x: chartBounds.midX, y: chartBounds.minY + 30)
        case .bottom:
            return CGPoint(x: chartBounds.midX, y: chartBounds.maxY - 30)
        case .left:
            return CGPoint(x: chartBounds.minX + 60, y: chartBounds.midY)
        case .right:
            return CGPoint(x: chartBounds.maxX - 60, y: chartBounds.midY)
        case .none:
            return CGPoint.zero
        }
    }
    
    // MARK: - Tooltip
    
    private func tooltipView(for dataPoint: ChartDataPoint) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let label = dataPoint.label {
                Text(label)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            
            Text("X: \(String(format: "%.2f", dataPoint.x))")
                .font(.caption)
            
            Text("Y: \(String(format: "%.2f", dataPoint.y))")
                .font(.caption)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(6)
        .shadow(radius: 2)
        .position(convertToChartCoordinates(dataPoint))
        .offset(y: -40)
    }
    
    // MARK: - Coordinate Conversion
    
    private func convertToChartCoordinates(_ dataPoint: ChartDataPoint) -> CGPoint {
        guard let xRange = data.xRange, let yRange = data.yRange else {
            return CGPoint.zero
        }
        
        let normalizedX = (dataPoint.x - xRange.lowerBound) / (xRange.upperBound - xRange.lowerBound)
        let normalizedY = 1.0 - (dataPoint.y - yRange.lowerBound) / (yRange.upperBound - yRange.lowerBound)
        
        let x = chartBounds.minX + CGFloat(normalizedX) * chartBounds.width
        let y = chartBounds.minY + CGFloat(normalizedY) * chartBounds.height
        
        return CGPoint(x: x, y: y)
    }
    
    // MARK: - Calculations
    
    private func calculateTrendLine(_ data: [ChartDataPoint]) -> [CGPoint] {
        // Simple linear regression
        let n = Double(data.count)
        let sumX = data.reduce(0) { $0 + $1.x }
        let sumY = data.reduce(0) { $0 + $1.y }
        let sumXY = data.reduce(0) { $0 + $1.x * $1.y }
        let sumXX = data.reduce(0) { $0 + $1.x * $1.x }
        
        let slope = (n * sumXY - sumX * sumY) / (n * sumXX - sumX * sumX)
        let intercept = (sumY - slope * sumX) / n
        
        return data.map { dataPoint in
            let y = slope * dataPoint.x + intercept
            return convertToChartCoordinates(ChartDataPoint(x: dataPoint.x, y: y))
        }
    }
    
    private func calculateConfidenceIntervals(_ data: [ChartDataPoint]) -> (upper: [CGPoint], lower: [CGPoint]) {
        // Simplified confidence interval calculation
        let mean = data.reduce(0) { $0 + $1.y } / Double(data.count)
        let stdDev = sqrt(data.reduce(0) { $0 + pow($1.y - mean, 2) } / Double(data.count))
        let confidenceLevel = 1.96 // 95% confidence interval
        
        let upper = data.map { dataPoint in
            let y = dataPoint.y + confidenceLevel * stdDev
            return convertToChartCoordinates(ChartDataPoint(x: dataPoint.x, y: y))
        }
        
        let lower = data.map { dataPoint in
            let y = dataPoint.y - confidenceLevel * stdDev
            return convertToChartCoordinates(ChartDataPoint(x: dataPoint.x, y: y))
        }
        
        return (upper: upper, lower: lower)
    }
    
    // MARK: - Gesture Handling
    
    private func handlePanGesture(_ value: DragGesture.Value) {
        guard configuration.panEnabled else { return }
        
        let sensitivity: CGFloat = 1.0
        panOffset = CGSize(
            width: value.translation.width * sensitivity,
            height: value.translation.height * sensitivity
        )
    }
    
    private func handlePanGestureEnd() {
        // Implement pan gesture end logic
    }
    
    private func handleZoomGesture(_ value: MagnificationGesture.Value) {
        guard configuration.zoomEnabled else { return }
        
        let minZoom: Double = 0.5
        let maxZoom: Double = 3.0
        zoomLevel = max(minZoom, min(maxZoom, value))
    }
    
    private func handleZoomGestureEnd() {
        // Implement zoom gesture end logic
    }
    
    private func handleDataPointTap(_ dataPoint: ChartDataPoint) {
        guard configuration.selectionEnabled else { return }
        
        selectedPoint = selectedPoint?.id == dataPoint.id ? nil : dataPoint
    }
    
    private func handleDataPointHover(_ dataPoint: ChartDataPoint, isHovered: Bool) {
        guard configuration.highlightingEnabled else { return }
        
        highlightedPoint = isHovered ? dataPoint : nil
    }
    
    // MARK: - Setup
    
    private func setupChartBounds(geometry: GeometryProxy) {
        let padding: CGFloat = 40
        chartBounds = CGRect(
            x: padding,
            y: padding,
            width: geometry.size.width - 2 * padding,
            height: geometry.size.height - 2 * padding
        )
    }
    
    private func startEntranceAnimation() {
        guard configuration.animationsEnabled else {
            animationProgress = 1.0
            return
        }
        
        withAnimation(.easeInOut(duration: configuration.entranceAnimationDuration)) {
            animationProgress = 1.0
        }
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabel: String {
        return "Line chart with \(data.count) data points"
    }
    
    private var accessibilityValue: String {
        guard let selectedPoint = selectedPoint else {
            return "No data point selected"
        }
        return selectedPoint.effectiveTooltip
    }
    
    private var accessibilityHint: String {
        return "Double tap to zoom, drag to pan, tap data points to select"
    }
}

// MARK: - Line Chart Style

/// Available line chart styles.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum LineChartStyle: String, CaseIterable, Codable {
    case line
    case area
    case step
    case smooth
}

// MARK: - View Modifiers

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension LineChartView {
    
    /// Sets the chart style.
    ///
    /// - Parameter style: The chart style to apply
    /// - Returns: Modified chart view
    func chartStyle(_ style: LineChartStyle) -> LineChartView {
        var copy = self
        copy.chartStyle = style
        return copy
    }
    
    /// Enables or disables data points.
    ///
    /// - Parameter show: Whether to show data points
    /// - Returns: Modified chart view
    func showDataPoints(_ show: Bool) -> LineChartView {
        var copy = self
        copy.showDataPoints = show
        return copy
    }
    
    /// Enables or disables data labels.
    ///
    /// - Parameter show: Whether to show data labels
    /// - Returns: Modified chart view
    func showDataLabels(_ show: Bool) -> LineChartView {
        var copy = self
        copy.showDataLabels = show
        return copy
    }
    
    /// Enables or disables trend line.
    ///
    /// - Parameter show: Whether to show trend line
    /// - Returns: Modified chart view
    func showTrendLine(_ show: Bool) -> LineChartView {
        var copy = self
        copy.showTrendLine = show
        return copy
    }
    
    /// Enables or disables confidence intervals.
    ///
    /// - Parameter show: Whether to show confidence intervals
    /// - Returns: Modified chart view
    func showConfidenceIntervals(_ show: Bool) -> LineChartView {
        var copy = self
        copy.showConfidenceIntervals = show
        return copy
    }
} 