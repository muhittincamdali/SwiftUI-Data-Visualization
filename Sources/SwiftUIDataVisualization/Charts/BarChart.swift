import SwiftUI

/// A bar chart that displays data using rectangular bars.
///
/// This chart type is ideal for comparing categories and showing discrete data.
/// It supports vertical and horizontal orientations, grouping, and stacking.
///
/// - Example:
/// ```swift
/// BarChart(data: categoryData)
///     .chartStyle(.bar)
///     .interactive(true)
/// ```
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct BarChart: View {
    
    // MARK: - Properties
    
    /// Data points to display
    private let data: [ChartDataPoint]
    
    /// Chart configuration
    private let configuration: ChartConfiguration
    
    /// Chart dimensions
    @State private var chartSize: CGSize = .zero
    
    /// Animation progress
    @State private var animationProgress: Double = 0
    
    /// Selected bar
    @State private var selectedBar: ChartDataPoint?
    
    /// Bar orientation
    private let orientation: BarOrientation
    
    /// Whether bars are stacked
    private let isStacked: Bool
    
    // MARK: - Initialization
    
    /// Creates a new bar chart with data and configuration.
    ///
    /// - Parameters:
    ///   - data: Array of data points to display
    ///   - configuration: Chart configuration options
    ///   - orientation: Bar orientation (vertical or horizontal)
    ///   - isStacked: Whether bars should be stacked
    public init(
        data: [ChartDataPoint],
        configuration: ChartConfiguration = ChartConfiguration(),
        orientation: BarOrientation = .vertical,
        isStacked: Bool = false
    ) {
        self.data = data
        self.configuration = configuration
        self.orientation = orientation
        self.isStacked = isStacked
    }
    
    /// Creates a new bar chart with data and style.
    ///
    /// - Parameters:
    ///   - data: Array of data points to display
    ///   - style: Chart style
    ///   - orientation: Bar orientation
    public init(
        data: [ChartDataPoint],
        style: ChartStyle = .bar,
        orientation: BarOrientation = .vertical
    ) {
        self.data = data
        self.configuration = ChartConfiguration().withStyle(style)
        self.orientation = orientation
        self.isStacked = false
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
                if configuration.tooltipEnabled && selectedBar != nil {
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
        .accessibilityLabel(configuration.accessibility.label ?? "Bar Chart")
        .accessibilityHint(configuration.accessibility.hint ?? "Shows data as bars")
        .accessibilityValue(configuration.accessibility.value ?? "\(data.count) bars")
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
            // Bars
            ForEach(data.indices, id: \.self) { index in
                barView(for: data[index], at: index)
            }
        }
    }
    
    /// Individual bar view
    private func barView(for point: ChartDataPoint, at index: Int) -> some View {
        let barRect = calculateBarRect(for: point, at: index)
        let color = point.color ?? configuration.colors[index % configuration.colors.count]
        
        return Rectangle()
            .fill(color)
            .frame(
                width: orientation == .vertical ? barRect.width : barRect.height,
                height: orientation == .vertical ? barRect.height : barRect.width
            )
            .position(barRect.midX, barRect.midY)
            .scaleEffect(selectedBar?.id == point.id ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: selectedBar?.id)
            .onTapGesture {
                handleBarTap(point)
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
                        Rectangle()
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
            if let bar = selectedBar {
                Text("Value: \(String(format: "%.2f", bar.y))")
                    .font(.caption)
                if let label = bar.label {
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
    
    /// Draws the grid
    private func drawGrid(path: inout Path) {
        let gridSpacing: CGFloat = 50
        
        if orientation == .vertical {
            // Horizontal lines
            for y in stride(from: 0, through: chartSize.height, by: gridSpacing) {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: chartSize.width, y: y))
            }
        } else {
            // Vertical lines
            for x in stride(from: 0, through: chartSize.width, by: gridSpacing) {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: chartSize.height))
            }
        }
    }
    
    /// Draws the X-axis
    private func drawXAxis(path: inout Path) {
        if orientation == .vertical {
            path.move(to: CGPoint(x: 0, y: chartSize.height - 20))
            path.addLine(to: CGPoint(x: chartSize.width, y: chartSize.height - 20))
        } else {
            path.move(to: CGPoint(x: 20, y: 0))
            path.addLine(to: CGPoint(x: 20, y: chartSize.height))
        }
    }
    
    /// Draws the Y-axis
    private func drawYAxis(path: inout Path) {
        if orientation == .vertical {
            path.move(to: CGPoint(x: 20, y: 0))
            path.addLine(to: CGPoint(x: 20, y: chartSize.height))
        } else {
            path.move(to: CGPoint(x: 0, y: chartSize.height - 20))
            path.addLine(to: CGPoint(x: chartSize.width, y: chartSize.height - 20))
        }
    }
    
    // MARK: - Calculation Methods
    
    /// Calculates bar rectangle for a data point
    private func calculateBarRect(for point: ChartDataPoint, at index: Int) -> CGRect {
        let maxValue = data.map { $0.y }.max() ?? 1.0
        let barWidth = (chartSize.width - 40) / CGFloat(data.count)
        let barHeight = (chartSize.height - 40) * CGFloat(point.y / maxValue)
        
        if orientation == .vertical {
            let x = 20 + CGFloat(index) * barWidth + barWidth / 2
            let y = chartSize.height - 20 - barHeight / 2
            return CGRect(x: x - barWidth / 2, y: y - barHeight / 2, width: barWidth * 0.8, height: barHeight)
        } else {
            let x = 20 + barHeight / 2
            let y = CGFloat(index) * barWidth + barWidth / 2
            return CGRect(x: x - barHeight / 2, y: y - barWidth / 2, width: barHeight, height: barWidth * 0.8)
        }
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
        guard let selectedBar = selectedBar else { return .zero }
        let barRect = calculateBarRect(for: selectedBar, at: data.firstIndex(of: selectedBar) ?? 0)
        return CGPoint(x: barRect.midX, y: barRect.minY - 30)
    }
    
    // MARK: - Interaction Methods
    
    /// Handles drag gesture
    private func handleDrag(_ value: DragGesture.Value) {
        guard configuration.panEnabled else { return }
        // Implement pan logic
    }
    
    /// Handles drag end
    private func handleDragEnd() {
        // Implement drag end logic
    }
    
    /// Handles tap gesture
    private func handleTap() {
        // Implement tap logic
    }
    
    /// Handles bar tap
    private func handleBarTap(_ bar: ChartDataPoint) {
        if configuration.selectionEnabled {
            selectedBar = selectedBar?.id == bar.id ? nil : bar
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

/// Bar orientation
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum BarOrientation {
    case vertical
    case horizontal
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct BarChart_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = [
            ChartDataPoint(x: 1, y: 10, label: "Category A"),
            ChartDataPoint(x: 2, y: 25, label: "Category B"),
            ChartDataPoint(x: 3, y: 15, label: "Category C"),
            ChartDataPoint(x: 4, y: 30, label: "Category D"),
            ChartDataPoint(x: 5, y: 20, label: "Category E")
        ]
        
        VStack(spacing: 20) {
            BarChart(data: sampleData, orientation: .vertical)
                .frame(height: 300)
            
            BarChart(data: sampleData, orientation: .horizontal)
                .frame(height: 300)
        }
        .padding()
    }
} 