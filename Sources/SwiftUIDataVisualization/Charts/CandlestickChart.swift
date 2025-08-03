import SwiftUI

/// A candlestick chart that displays financial data with open, high, low, and close prices.
///
/// This chart type is essential for financial analysis and trading applications.
/// It supports volume display, technical indicators, and real-time updates.
///
/// - Example:
/// ```swift
/// CandlestickChart(data: financialData)
///     .chartStyle(.candlestick)
///     .showVolume(true)
/// ```
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct CandlestickChart: View {
    
    // MARK: - Properties
    
    /// Financial data points to display
    private let data: [CandlestickDataPoint]
    
    /// Chart configuration
    private let configuration: ChartConfiguration
    
    /// Chart dimensions
    @State private var chartSize: CGSize = .zero
    
    /// Animation progress
    @State private var animationProgress: Double = 0
    
    /// Selected candlestick
    @State private var selectedCandlestick: CandlestickDataPoint?
    
    /// Whether to show volume
    private let showVolume: Bool
    
    /// Whether to show technical indicators
    private let showIndicators: Bool
    
    // MARK: - Initialization
    
    /// Creates a new candlestick chart with data and configuration.
    ///
    /// - Parameters:
    ///   - data: Array of financial data points to display
    ///   - configuration: Chart configuration options
    ///   - showVolume: Whether to show volume bars
    ///   - showIndicators: Whether to show technical indicators
    public init(
        data: [CandlestickDataPoint],
        configuration: ChartConfiguration = ChartConfiguration(),
        showVolume: Bool = false,
        showIndicators: Bool = false
    ) {
        self.data = data
        self.configuration = configuration
        self.showVolume = showVolume
        self.showIndicators = showIndicators
    }
    
    /// Creates a new candlestick chart with data and style.
    ///
    /// - Parameters:
    ///   - data: Array of financial data points to display
    ///   - style: Chart style
    ///   - showVolume: Whether to show volume bars
    public init(
        data: [CandlestickDataPoint],
        style: ChartStyle = .candlestick,
        showVolume: Bool = false
    ) {
        self.data = data
        self.configuration = ChartConfiguration().withStyle(style)
        self.showVolume = showVolume
        self.showIndicators = false
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
                
                // Volume bars
                if showVolume {
                    volumeView
                }
                
                // Technical indicators
                if showIndicators {
                    indicatorsView
                }
                
                // Legend
                if configuration.legend.enabled {
                    legendView
                }
                
                // Tooltip
                if configuration.tooltipEnabled && selectedCandlestick != nil {
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
        .accessibilityLabel(configuration.accessibility.label ?? "Candlestick Chart")
        .accessibilityHint(configuration.accessibility.hint ?? "Shows financial data with OHLC prices")
        .accessibilityValue(configuration.accessibility.value ?? "\(data.count) candlesticks")
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
            // Candlesticks
            ForEach(data.indices, id: \.self) { index in
                candlestickView(for: data[index], at: index)
            }
        }
    }
    
    /// Individual candlestick view
    private func candlestickView(for point: CandlestickDataPoint, at index: Int) -> some View {
        let candlestickRect = calculateCandlestickRect(for: point, at: index)
        let isBullish = point.close >= point.open
        let color = isBullish ? Color.green : Color.red
        let isSelected = selectedCandlestick?.id == point.id
        
        return ZStack {
            // Wick
            Rectangle()
                .fill(color)
                .frame(width: 1, height: candlestickRect.height)
                .position(candlestickRect.midX, candlestickRect.midY)
            
            // Body
            Rectangle()
                .fill(color)
                .frame(width: candlestickRect.width * 0.8, height: candlestickRect.width * 0.8)
                .position(candlestickRect.midX, candlestickRect.midY)
        }
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: selectedCandlestick?.id)
        .onTapGesture {
            handleCandlestickTap(point)
        }
    }
    
    /// Volume view
    private var volumeView: some View {
        VStack {
            ForEach(data.indices, id: \.self) { index in
                volumeBarView(for: data[index], at: index)
            }
        }
    }
    
    /// Individual volume bar view
    private func volumeBarView(for point: CandlestickDataPoint, at index: Int) -> some View {
        let volumeRect = calculateVolumeRect(for: point, at: index)
        let color = point.close >= point.open ? Color.green.opacity(0.5) : Color.red.opacity(0.5)
        
        return Rectangle()
            .fill(color)
            .frame(width: volumeRect.width, height: volumeRect.height)
            .position(volumeRect.midX, volumeRect.midY)
    }
    
    /// Technical indicators view
    private var indicatorsView: some View {
        ZStack {
            // Moving averages
            Path { path in
                drawMovingAverage(path: &path, period: 20)
            }
            .stroke(Color.blue, lineWidth: 1)
            
            Path { path in
                drawMovingAverage(path: &path, period: 50)
            }
            .stroke(Color.orange, lineWidth: 1)
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
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 12, height: 12)
                Text("Bullish")
                    .font(.caption)
                    .foregroundColor(configuration.legend.color)
                
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                Text("Bearish")
                    .font(.caption)
                    .foregroundColor(configuration.legend.color)
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
            if let candlestick = selectedCandlestick {
                Text("Open: \(String(format: "%.2f", candlestick.open))")
                    .font(.caption)
                Text("High: \(String(format: "%.2f", candlestick.high))")
                    .font(.caption)
                Text("Low: \(String(format: "%.2f", candlestick.low))")
                    .font(.caption)
                Text("Close: \(String(format: "%.2f", candlestick.close))")
                    .font(.caption)
                if let volume = candlestick.volume {
                    Text("Volume: \(String(format: "%.0f", volume))")
                        .font(.caption)
                }
                if let timestamp = candlestick.timestamp {
                    Text(timestamp, style: .date)
                        .font(.caption)
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
    
    /// Draws moving average
    private func drawMovingAverage(path: inout Path, period: Int) {
        guard data.count >= period else { return }
        
        let maValues = calculateMovingAverage(period: period)
        let points = maValues.enumerated().map { index, value in
            calculatePricePosition(for: value, at: index)
        }
        
        path.move(to: points[0])
        for i in 1..<points.count {
            path.addLine(to: points[i])
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
    
    /// Calculates candlestick rectangle for a data point
    private func calculateCandlestickRect(for point: CandlestickDataPoint, at index: Int) -> CGRect {
        let priceRange = data.map { $0.high }.max() ?? 0...data.map { $0.low }.min() ?? 1
        let candlestickWidth = (chartSize.width - 40) / CGFloat(data.count) * 0.8
        
        let x = 20 + CGFloat(index) * (chartSize.width - 40) / CGFloat(data.count) + candlestickWidth / 2
        let highY = chartSize.height - 20 - (point.high - priceRange.lowerBound) / (priceRange.upperBound - priceRange.lowerBound) * (chartSize.height - 40)
        let lowY = chartSize.height - 20 - (point.low - priceRange.lowerBound) / (priceRange.upperBound - priceRange.lowerBound) * (chartSize.height - 40)
        
        return CGRect(x: x - candlestickWidth / 2, y: lowY, width: candlestickWidth, height: highY - lowY)
    }
    
    /// Calculates volume rectangle for a data point
    private func calculateVolumeRect(for point: CandlestickDataPoint, at index: Int) -> CGRect {
        guard let volume = point.volume else { return .zero }
        
        let maxVolume = data.compactMap { $0.volume }.max() ?? 1
        let volumeHeight = (volume / maxVolume) * (chartSize.height * 0.2)
        let volumeWidth = (chartSize.width - 40) / CGFloat(data.count) * 0.6
        
        let x = 20 + CGFloat(index) * (chartSize.width - 40) / CGFloat(data.count) + volumeWidth / 2
        let y = chartSize.height - volumeHeight / 2
        
        return CGRect(x: x - volumeWidth / 2, y: y - volumeHeight / 2, width: volumeWidth, height: volumeHeight)
    }
    
    /// Calculates price position for moving average
    private func calculatePricePosition(for price: Double, at index: Int) -> CGPoint {
        let priceRange = data.map { $0.high }.max() ?? 0...data.map { $0.low }.min() ?? 1
        let x = 20 + CGFloat(index) * (chartSize.width - 40) / CGFloat(data.count)
        let y = chartSize.height - 20 - (price - priceRange.lowerBound) / (priceRange.upperBound - priceRange.lowerBound) * (chartSize.height - 40)
        
        return CGPoint(x: x, y: y)
    }
    
    /// Calculates moving average
    private func calculateMovingAverage(period: Int) -> [Double] {
        var maValues: [Double] = []
        
        for i in (period - 1)..<data.count {
            let sum = data[(i - period + 1)...i].map { $0.close }.reduce(0, +)
            maValues.append(sum / Double(period))
        }
        
        return maValues
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
        guard let selectedCandlestick = selectedCandlestick else { return .zero }
        let index = data.firstIndex(of: selectedCandlestick) ?? 0
        let candlestickRect = calculateCandlestickRect(for: selectedCandlestick, at: index)
        return CGPoint(x: candlestickRect.midX, y: candlestickRect.minY - 30)
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
    
    /// Handles candlestick tap
    private func handleCandlestickTap(_ candlestick: CandlestickDataPoint) {
        if configuration.selectionEnabled {
            selectedCandlestick = selectedCandlestick?.id == candlestick.id ? nil : candlestick
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

/// Financial data point for candlestick charts
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct CandlestickDataPoint: Identifiable, Hashable, Codable {
    public let id = UUID()
    public let timestamp: Date?
    public let open: Double
    public let high: Double
    public let low: Double
    public let close: Double
    public let volume: Double?
    
    public init(
        timestamp: Date? = nil,
        open: Double,
        high: Double,
        low: Double,
        close: Double,
        volume: Double? = nil
    ) {
        self.timestamp = timestamp
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(timestamp)
        hasher.combine(open)
        hasher.combine(high)
        hasher.combine(low)
        hasher.combine(close)
        hasher.combine(volume)
    }
    
    public static func == (lhs: CandlestickDataPoint, rhs: CandlestickDataPoint) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct CandlestickChart_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = [
            CandlestickDataPoint(
                timestamp: Date(),
                open: 100.0,
                high: 110.0,
                low: 95.0,
                close: 105.0,
                volume: 1000000
            ),
            CandlestickDataPoint(
                timestamp: Date().addingTimeInterval(86400),
                open: 105.0,
                high: 115.0,
                low: 100.0,
                close: 110.0,
                volume: 1200000
            )
        ]
        
        CandlestickChart(data: sampleData, showVolume: true)
            .frame(height: 400)
            .padding()
    }
} 