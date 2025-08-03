import SwiftUI

/// A radar chart that displays multi-dimensional data as a polygon.
///
/// This chart type is great for comparing multiple variables.
/// It supports scaling, grid lines, and interactive features.
///
/// - Example:
/// ```swift
/// RadarChart(data: radarData)
///     .chartStyle(.radar)
///     .showGrid(true)
/// ```
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RadarChart: View {
    
    // MARK: - Properties
    
    /// Radar data points to display
    private let data: [RadarDataPoint]
    
    /// Chart configuration
    private let configuration: ChartConfiguration
    
    /// Chart dimensions
    @State private var chartSize: CGSize = .zero
    
    /// Animation progress
    @State private var animationProgress: Double = 0
    
    /// Selected point
    @State private var selectedPoint: RadarDataPoint?
    
    /// Whether to show grid
    private let showGrid: Bool
    
    /// Whether to show labels
    private let showLabels: Bool
    
    // MARK: - Initialization
    
    /// Creates a new radar chart with data and configuration.
    ///
    /// - Parameters:
    ///   - data: Array of radar data points to display
    ///   - configuration: Chart configuration options
    ///   - showGrid: Whether to show grid lines
    ///   - showLabels: Whether to show category labels
    public init(
        data: [RadarDataPoint],
        configuration: ChartConfiguration = ChartConfiguration(),
        showGrid: Bool = true,
        showLabels: Bool = true
    ) {
        self.data = data
        self.configuration = configuration
        self.showGrid = showGrid
        self.showLabels = showLabels
    }
    
    /// Creates a new radar chart with data and style.
    ///
    /// - Parameters:
    ///   - data: Array of radar data points to display
    ///   - style: Chart style
    ///   - showGrid: Whether to show grid lines
    public init(
        data: [RadarDataPoint],
        style: ChartStyle = .radar,
        showGrid: Bool = true
    ) {
        self.data = data
        self.configuration = ChartConfiguration().withStyle(style)
        self.showGrid = showGrid
        self.showLabels = true
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundColor
                
                // Grid
                if showGrid {
                    gridView
                }
                
                // Chart content
                chartContent
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                // Labels
                if showLabels {
                    labelsView
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
        .accessibilityLabel(configuration.accessibility.label ?? "Radar Chart")
        .accessibilityHint(configuration.accessibility.hint ?? "Shows multi-dimensional data")
        .accessibilityValue(configuration.accessibility.value ?? "\(data.count) dimensions")
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
        ZStack {
            // Grid circles
            ForEach(1...5, id: \.self) { level in
                Circle()
                    .stroke(configuration.grid.color.opacity(0.3), lineWidth: 1)
                    .frame(width: getGridCircleSize(level: level), height: getGridCircleSize(level: level))
                    .position(x: chartSize.width / 2, y: chartSize.height / 2)
            }
            
            // Grid lines
            ForEach(0..<data.count, id: \.self) { index in
                Path { path in
                    drawGridLine(path: &path, index: index)
                }
                .stroke(configuration.grid.color.opacity(0.3), lineWidth: 1)
            }
        }
    }
    
    /// Chart content view
    private var chartContent: some View {
        ZStack {
            // Radar polygon
            Path { path in
                drawRadarPolygon(path: &path)
            }
            .fill(configuration.colors.first?.opacity(0.3) ?? .blue.opacity(0.3))
            .scaleEffect(animationProgress)
            .opacity(animationProgress)
            
            // Radar line
            Path { path in
                drawRadarLine(path: &path)
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
    
    /// Individual data point view
    private func dataPointView(for point: RadarDataPoint, at index: Int) -> some View {
        let position = calculatePointPosition(for: point, at: index)
        let color = point.color ?? configuration.colors[index % configuration.colors.count]
        let isSelected = selectedPoint?.id == point.id
        
        return Circle()
            .fill(color)
            .frame(width: 8, height: 8)
            .position(position)
            .scaleEffect(isSelected ? 1.5 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: selectedPoint?.id)
            .onTapGesture {
                handlePointTap(point)
            }
    }
    
    /// Labels view
    private var labelsView: some View {
        ZStack {
            ForEach(data.indices, id: \.self) { index in
                labelView(for: data[index], at: index)
            }
        }
    }
    
    /// Individual label view
    private func labelView(for point: RadarDataPoint, at index: Int) -> some View {
        let position = calculateLabelPosition(for: point, at: index)
        
        return Text(point.category)
            .font(.caption)
            .foregroundColor(.primary)
            .position(position)
    }
    
    /// Tooltip view
    private var tooltipView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let point = selectedPoint {
                Text(point.category)
                    .font(.caption)
                    .fontWeight(.bold)
                Text("Value: \(String(format: "%.2f", point.value))")
                    .font(.caption)
                Text("Max Value: \(String(format: "%.2f", point.maxValue))")
                    .font(.caption)
                Text("Percentage: \(String(format: "%.1f", (point.value / point.maxValue) * 100))%")
                    .font(.caption)
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(6)
        .shadow(radius: 2)
        .position(calculateTooltipPosition())
    }
    
    // MARK: - Drawing Methods
    
    /// Draws the radar polygon
    private func drawRadarPolygon(path: inout Path) {
        guard !data.isEmpty else { return }
        
        let points = data.enumerated().map { index, point in
            calculatePointPosition(for: point, at: index)
        }
        
        path.move(to: points[0])
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        path.closeSubpath()
    }
    
    /// Draws the radar line
    private func drawRadarLine(path: inout Path) {
        guard !data.isEmpty else { return }
        
        let points = data.enumerated().map { index, point in
            calculatePointPosition(for: point, at: index)
        }
        
        path.move(to: points[0])
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        path.closeSubpath()
    }
    
    /// Draws grid line
    private func drawGridLine(path: inout Path, index: Int) {
        let center = CGPoint(x: chartSize.width / 2, y: chartSize.height / 2)
        let angle = (2 * .pi * Double(index)) / Double(data.count)
        let radius = min(chartSize.width, chartSize.height) / 2 - 40
        
        let endPoint = CGPoint(
            x: center.x + radius * cos(angle),
            y: center.y + radius * sin(angle)
        )
        
        path.move(to: center)
        path.addLine(to: endPoint)
    }
    
    // MARK: - Calculation Methods
    
    /// Calculates position for a data point
    private func calculatePointPosition(for point: RadarDataPoint, at index: Int) -> CGPoint {
        let center = CGPoint(x: chartSize.width / 2, y: chartSize.height / 2)
        let angle = (2 * .pi * Double(index)) / Double(data.count)
        let normalizedValue = point.value / point.maxValue
        let radius = min(chartSize.width, chartSize.height) / 2 - 60
        
        let x = center.x + radius * normalizedValue * cos(angle)
        let y = center.y + radius * normalizedValue * sin(angle)
        
        return CGPoint(x: x, y: y)
    }
    
    /// Calculates label position
    private func calculateLabelPosition(for point: RadarDataPoint, at index: Int) -> CGPoint {
        let center = CGPoint(x: chartSize.width / 2, y: chartSize.height / 2)
        let angle = (2 * .pi * Double(index)) / Double(data.count)
        let radius = min(chartSize.width, chartSize.height) / 2 - 20
        
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)
        
        return CGPoint(x: x, y: y)
    }
    
    /// Gets grid circle size for a specific level
    private func getGridCircleSize(level: Int) -> CGFloat {
        let maxRadius = min(chartSize.width, chartSize.height) / 2 - 40
        return maxRadius * CGFloat(level) / 5.0
    }
    
    /// Calculates tooltip position
    private func calculateTooltipPosition() -> CGPoint {
        guard let selectedPoint = selectedPoint else { return .zero }
        let index = data.firstIndex(of: selectedPoint) ?? 0
        let pointPosition = calculatePointPosition(for: selectedPoint, at: index)
        return CGPoint(x: pointPosition.x, y: pointPosition.y - 30)
    }
    
    // MARK: - Interaction Methods
    
    /// Handles tap gesture
    private func handleTap() {
        // Implement tap logic
    }
    
    /// Handles point tap
    private func handlePointTap(_ point: RadarDataPoint) {
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

// MARK: - Supporting Types

/// Radar data point for radar charts
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct RadarDataPoint: Identifiable, Hashable, Codable {
    public let id = UUID()
    public let category: String
    public let value: Double
    public let maxValue: Double
    public let color: Color?
    
    public init(
        category: String,
        value: Double,
        maxValue: Double,
        color: Color? = nil
    ) {
        self.category = category
        self.value = value
        self.maxValue = maxValue
        self.color = color
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(category)
        hasher.combine(value)
        hasher.combine(maxValue)
    }
    
    public static func == (lhs: RadarDataPoint, rhs: RadarDataPoint) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct RadarChart_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = [
            RadarDataPoint(category: "Speed", value: 80.0, maxValue: 100.0),
            RadarDataPoint(category: "Accuracy", value: 90.0, maxValue: 100.0),
            RadarDataPoint(category: "Power", value: 70.0, maxValue: 100.0),
            RadarDataPoint(category: "Control", value: 85.0, maxValue: 100.0),
            RadarDataPoint(category: "Endurance", value: 75.0, maxValue: 100.0)
        ]
        
        RadarChart(data: sampleData, showGrid: true)
            .frame(width: 300, height: 300)
            .padding()
    }
} 