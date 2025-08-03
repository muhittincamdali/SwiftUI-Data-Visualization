import SwiftUI

/// A high-performance candlestick chart view for financial data visualization.
///
/// This view provides candlestick charts with open, high, low, close (OHLC) data,
/// volume indicators, and technical analysis features.
///
/// ```swift
/// CandlestickChartView(data: financialData)
///     .chartStyle(.candlestick)
///     .showVolume(true)
///     .animation(.easeInOut(duration: 0.8))
///     .frame(height: 300)
/// ```
///
/// - Note: Optimized for performance with real-time financial data and smooth animations.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct CandlestickChartView: View {
    
    // MARK: - Properties
    
    /// Financial data points
    @State private var data: [CandlestickDataPoint]
    
    /// Chart configuration
    @State private var configuration: ChartConfiguration
    
    /// Chart style (candlestick, volume, technical)
    @State private var chartStyle: CandlestickChartStyle
    
    /// Animation state
    @State private var animationProgress: Double = 0.0
    
    /// Selected candlestick
    @State private var selectedCandlestick: CandlestickDataPoint?
    
    /// Highlighted candlestick
    @State private var highlightedCandlestick: CandlestickDataPoint?
    
    /// Show volume indicator
    @State private var showVolume: Bool
    
    /// Show technical indicators
    @State private var showTechnicalIndicators: Bool
    
    // MARK: - Initialization
    
    /// Creates a new candlestick chart view.
    ///
    /// - Parameters:
    ///   - data: Financial data points
    ///   - style: Chart style (defaults to candlestick)
    ///   - configuration: Chart configuration (optional)
    ///   - showVolume: Whether to show volume indicator
    ///   - showTechnicalIndicators: Whether to show technical indicators
    public init(
        data: [CandlestickDataPoint],
        style: CandlestickChartStyle = .candlestick,
        configuration: ChartConfiguration = ChartConfiguration(),
        showVolume: Bool = true,
        showTechnicalIndicators: Bool = false
    ) {
        self._data = State(initialValue: data)
        self._chartStyle = State(initialValue: style)
        self._configuration = State(initialValue: configuration)
        self._showVolume = State(initialValue: showVolume)
        self._showTechnicalIndicators = State(initialValue: showTechnicalIndicators)
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Main chart area
                mainChartArea(in: geometry)
                
                // Volume indicator
                if showVolume {
                    volumeIndicator(in: geometry)
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
            .accessibilityLabel("Candlestick chart with \(data.count) data points")
            .accessibilityValue(accessibilityValue)
            .accessibilityHint("Tap candlesticks to select, double tap to zoom")
        }
    }
    
    // MARK: - Main Chart Area
    
    private func mainChartArea(in geometry: GeometryProxy) -> some View {
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
            
            // Candlesticks
            candlesticks(in: geometry)
            
            // Technical indicators
            if showTechnicalIndicators {
                technicalIndicators(in: geometry)
            }
            
            // Interactive overlay
            interactiveOverlay(in: geometry)
            
            // Tooltip
            if let selectedCandlestick = selectedCandlestick, configuration.tooltipsEnabled {
                tooltipView(for: selectedCandlestick, in: geometry)
            }
        }
        .frame(height: geometry.size.height * 0.7)
    }
    
    // MARK: - Volume Indicator
    
    private func volumeIndicator(in geometry: GeometryProxy) -> some View {
        VolumeIndicatorView(
            data: data,
            size: CGSize(width: geometry.size.width, height: geometry.size.height * 0.3),
            configuration: configuration,
            animationProgress: animationProgress,
            dataRange: dataRange
        )
    }
    
    // MARK: - Background
    
    private var backgroundColor: some View {
        Rectangle()
            .fill(configuration.backgroundColor)
            .ignoresSafeArea()
    }
    
    // MARK: - Grid
    
    private func gridView(in geometry: GeometryProxy) -> some View {
        CandlestickGridView(
            size: geometry.size,
            configuration: configuration,
            dataRange: dataRange
        )
    }
    
    // MARK: - Axes
    
    private func axesView(in geometry: GeometryProxy) -> some View {
        CandlestickAxesView(
            size: geometry.size,
            configuration: configuration,
            dataRange: dataRange
        )
    }
    
    // MARK: - Candlesticks
    
    private func candlesticks(in geometry: GeometryProxy) -> some View {
        CandlesticksView(
            data: data,
            size: geometry.size,
            configuration: configuration,
            chartStyle: chartStyle,
            animationProgress: animationProgress,
            selectedCandlestick: $selectedCandlestick,
            highlightedCandlestick: $highlightedCandlestick,
            dataRange: dataRange
        )
    }
    
    // MARK: - Technical Indicators
    
    private func technicalIndicators(in geometry: GeometryProxy) -> some View {
        TechnicalIndicatorsView(
            data: data,
            size: geometry.size,
            configuration: configuration,
            animationProgress: animationProgress,
            dataRange: dataRange
        )
    }
    
    // MARK: - Interactive Overlay
    
    private func interactiveOverlay(in geometry: GeometryProxy) -> some View {
        CandlestickInteractiveOverlayView(
            size: geometry.size,
            configuration: configuration,
            selectedCandlestick: $selectedCandlestick,
            highlightedCandlestick: $highlightedCandlestick
        )
    }
    
    // MARK: - Tooltip
    
    private func tooltipView(for candlestick: CandlestickDataPoint, in geometry: GeometryProxy) -> some View {
        CandlestickTooltipView(
            candlestick: candlestick,
            configuration: configuration
        )
        .position(tooltipPosition(for: candlestick, in: geometry))
    }
    
    // MARK: - Computed Properties
    
    private var dataRange: CandlestickDataRange {
        return CandlestickDataRange(from: data)
    }
    
    private var accessibilityValue: String {
        let total = data.count
        let maxPrice = data.map { $0.high }.max() ?? 0
        let minPrice = data.map { $0.low }.min() ?? 0
        return "\(total) candlesticks, Price range: \(String(format: "%.2f", minPrice)) to \(String(format: "%.2f", maxPrice))"
    }
    
    // MARK: - Helper Methods
    
    private func startAnimation() {
        withAnimation(configuration.animation) {
            animationProgress = 1.0
        }
    }
    
    private func tooltipPosition(for candlestick: CandlestickDataPoint, in geometry: GeometryProxy) -> CGPoint {
        let x = dataRange.normalizeX(candlestick.timestamp.timeIntervalSince1970) * geometry.size.width
        let y = dataRange.normalizeY(candlestick.close) * geometry.size.height
        return CGPoint(x: x, y: y - 20)
    }
}

// MARK: - Chart Style

/// Candlestick chart style options
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum CandlestickChartStyle: String, CaseIterable, Codable {
    case candlestick
    case volume
    case technical
}

// MARK: - Supporting Views

/// Grid view for candlestick chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct CandlestickGridView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    let dataRange: CandlestickDataRange
    
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

/// Axes view for candlestick chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct CandlestickAxesView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    let dataRange: CandlestickDataRange
    
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

/// Candlesticks view
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct CandlesticksView: View {
    let data: [CandlestickDataPoint]
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: CandlestickChartStyle
    let animationProgress: Double
    @Binding var selectedCandlestick: CandlestickDataPoint?
    @Binding var highlightedCandlestick: CandlestickDataPoint?
    let dataRange: CandlestickDataRange
    
    var body: some View {
        ForEach(data) { candlestick in
            CandlestickView(
                candlestick: candlestick,
                size: size,
                configuration: configuration,
                chartStyle: chartStyle,
                animationProgress: animationProgress,
                isSelected: selectedCandlestick?.id == candlestick.id,
                isHighlighted: highlightedCandlestick?.id == candlestick.id,
                dataRange: dataRange
            )
            .onTapGesture {
                selectedCandlestick = candlestick
            }
            .onHover { isHovered in
                highlightedCandlestick = isHovered ? candlestick : nil
            }
        }
    }
}

/// Individual candlestick view
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct CandlestickView: View {
    let candlestick: CandlestickDataPoint
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: CandlestickChartStyle
    let animationProgress: Double
    let isSelected: Bool
    let isHighlighted: Bool
    let dataRange: CandlestickDataRange
    
    var body: some View {
        Canvas { context, size in
            drawCandlestick(context: context, size: size)
        }
        .scaleEffect(isSelected ? 1.2 : (isHighlighted ? 1.1 : 1.0))
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isHighlighted)
    }
    
    private func drawCandlestick(context: GraphicsContext, size: CGSize) {
        let x = dataRange.normalizeX(candlestick.timestamp.timeIntervalSince1970) * size.width
        let openY = dataRange.normalizeY(candlestick.open) * size.height * animationProgress
        let closeY = dataRange.normalizeY(candlestick.close) * size.height * animationProgress
        let highY = dataRange.normalizeY(candlestick.high) * size.height * animationProgress
        let lowY = dataRange.normalizeY(candlestick.low) * size.height * animationProgress
        
        let isBullish = candlestick.close > candlestick.open
        let color = isBullish ? Color.green : Color.red
        
        // Draw wick (high-low line)
        let wickPath = Path { path in
            path.move(to: CGPoint(x: x, y: highY))
            path.addLine(to: CGPoint(x: x, y: lowY))
        }
        
        context.stroke(
            wickPath,
            with: .color(color),
            lineWidth: 1.0
        )
        
        // Draw body (open-close rectangle)
        let bodyRect = CGRect(
            x: x - 3,
            y: min(openY, closeY),
            width: 6,
            height: abs(closeY - openY)
        )
        
        let bodyPath = Path(bodyRect)
        context.fill(
            bodyPath,
            with: .color(color.opacity(0.8))
        )
        
        context.stroke(
            bodyPath,
            with: .color(color),
            lineWidth: 1.0
        )
    }
}

/// Volume indicator view
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct VolumeIndicatorView: View {
    let data: [CandlestickDataPoint]
    let size: CGSize
    let configuration: ChartConfiguration
    let animationProgress: Double
    let dataRange: CandlestickDataRange
    
    var body: some View {
        Canvas { context, size in
            drawVolumeBars(context: context, size: size)
        }
        .background(Color(.systemGray6))
    }
    
    private func drawVolumeBars(context: GraphicsContext, size: CGSize) {
        let maxVolume = data.map { $0.volume }.max() ?? 1
        
        for candlestick in data {
            let x = dataRange.normalizeX(candlestick.timestamp.timeIntervalSince1970) * size.width
            let volumeHeight = (candlestick.volume / maxVolume) * size.height * animationProgress
            
            let barRect = CGRect(
                x: x - 2,
                y: size.height - volumeHeight,
                width: 4,
                height: volumeHeight
            )
            
            let barPath = Path(barRect)
            let isBullish = candlestick.close > candlestick.open
            let color = isBullish ? Color.green.opacity(0.6) : Color.red.opacity(0.6)
            
            context.fill(
                barPath,
                with: .color(color)
            )
        }
    }
}

/// Technical indicators view
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct TechnicalIndicatorsView: View {
    let data: [CandlestickDataPoint]
    let size: CGSize
    let configuration: ChartConfiguration
    let animationProgress: Double
    let dataRange: CandlestickDataRange
    
    var body: some View {
        Canvas { context, size in
            drawMovingAverages(context: context, size: size)
        }
    }
    
    private func drawMovingAverages(context: GraphicsContext, size: CGSize) {
        // Simple moving average calculation
        let period = 20
        guard data.count >= period else { return }
        
        let smaValues = calculateSMA(period: period)
        let path = Path { path in
            for (index, value) in smaValues.enumerated() {
                let x = dataRange.normalizeX(data[index + period - 1].timestamp.timeIntervalSince1970) * size.width
                let y = dataRange.normalizeY(value) * size.height * animationProgress
                
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        
        context.stroke(
            path,
            with: .color(.blue),
            lineWidth: 2.0
        )
    }
    
    private func calculateSMA(period: Int) -> [Double] {
        var smaValues: [Double] = []
        
        for i in (period - 1)..<data.count {
            let sum = data[(i - period + 1)...i].reduce(0) { $0 + $1.close }
            smaValues.append(sum / Double(period))
        }
        
        return smaValues
    }
}

/// Interactive overlay for candlestick chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct CandlestickInteractiveOverlayView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    @Binding var selectedCandlestick: CandlestickDataPoint?
    @Binding var highlightedCandlestick: CandlestickDataPoint?
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                selectedCandlestick = nil
            }
    }
}

/// Tooltip view for candlestick chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct CandlestickTooltipView: View {
    let candlestick: CandlestickDataPoint
    let configuration: ChartConfiguration
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(candlestick.timestamp, style: .date)
                .font(.caption)
                .fontWeight(.bold)
            
            Text("Open: \(String(format: "%.2f", candlestick.open))")
                .font(.caption2)
            
            Text("High: \(String(format: "%.2f", candlestick.high))")
                .font(.caption2)
            
            Text("Low: \(String(format: "%.2f", candlestick.low))")
                .font(.caption2)
            
            Text("Close: \(String(format: "%.2f", candlestick.close))")
                .font(.caption2)
            
            Text("Volume: \(String(format: "%.0f", candlestick.volume))")
                .font(.caption2)
        }
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}

// MARK: - Supporting Types

/// Candlestick data point
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct CandlestickDataPoint: Identifiable, Codable, Equatable {
    public let id: UUID
    public let timestamp: Date
    public let open: Double
    public let high: Double
    public let low: Double
    public let close: Double
    public let volume: Double
    
    public init(
        id: UUID = UUID(),
        timestamp: Date,
        open: Double,
        high: Double,
        low: Double,
        close: Double,
        volume: Double
    ) {
        self.id = id
        self.timestamp = timestamp
        self.open = open
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
    }
}

/// Data range for candlestick chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct CandlestickDataRange {
    let minTime: Double
    let maxTime: Double
    let minPrice: Double
    let maxPrice: Double
    
    init(from data: [CandlestickDataPoint]) {
        self.minTime = data.map { $0.timestamp.timeIntervalSince1970 }.min() ?? 0
        self.maxTime = data.map { $0.timestamp.timeIntervalSince1970 }.max() ?? 1
        self.minPrice = data.map { $0.low }.min() ?? 0
        self.maxPrice = data.map { $0.high }.max() ?? 1
    }
    
    func normalizeX(_ time: Double) -> Double {
        return (time - minTime) / (maxTime - minTime)
    }
    
    func normalizeY(_ price: Double) -> Double {
        return 1.0 - (price - minPrice) / (maxPrice - minPrice)
    }
} 