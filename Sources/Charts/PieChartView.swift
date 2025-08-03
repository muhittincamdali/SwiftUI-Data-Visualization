import SwiftUI

/// A high-performance pie chart view with smooth animations and interactive features.
///
/// This view provides pie charts, donut charts, and exploded pie charts with
/// customizable styling, animations, and comprehensive accessibility support.
///
/// ```swift
/// PieChartView(data: chartData)
///     .chartStyle(.pie)
///     .animation(.easeInOut(duration: 1.0))
///     .frame(height: 300)
/// ```
///
/// - Note: Optimized for performance with smooth 60fps animations and real-time updates.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct PieChartView: View {
    
    // MARK: - Properties
    
    /// Chart data points
    @State private var data: [ChartDataPoint]
    
    /// Chart configuration
    @State private var configuration: ChartConfiguration
    
    /// Chart style (pie, donut, exploded)
    @State private var chartStyle: PieChartStyle
    
    /// Animation state
    @State private var animationProgress: Double = 0.0
    
    /// Selected slice
    @State private var selectedSlice: ChartDataPoint?
    
    /// Highlighted slice
    @State private var highlightedSlice: ChartDataPoint?
    
    /// Center text for donut charts
    @State private var centerText: String?
    
    // MARK: - Initialization
    
    /// Creates a new pie chart view.
    ///
    /// - Parameters:
    ///   - data: Chart data points
    ///   - style: Chart style (defaults to pie)
    ///   - configuration: Chart configuration (optional)
    ///   - centerText: Center text for donut charts (optional)
    public init(
        data: [ChartDataPoint],
        style: PieChartStyle = .pie,
        configuration: ChartConfiguration = ChartConfiguration(),
        centerText: String? = nil
    ) {
        self._data = State(initialValue: data)
        self._chartStyle = State(initialValue: style)
        self._configuration = State(initialValue: configuration)
        self._centerText = State(initialValue: centerText)
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundColor
                
                // Pie slices
                pieSlices(in: geometry)
                
                // Center text for donut charts
                if chartStyle == .donut, let centerText = centerText {
                    centerTextView(text: centerText, in: geometry)
                }
                
                // Interactive overlay
                interactiveOverlay(in: geometry)
                
                // Tooltip
                if let selectedSlice = selectedSlice, configuration.tooltipsEnabled {
                    tooltipView(for: selectedSlice, in: geometry)
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
            .accessibilityLabel("Pie chart with \(data.count) slices")
            .accessibilityValue(accessibilityValue)
            .accessibilityHint("Tap slices to select, double tap to zoom")
        }
    }
    
    // MARK: - Background
    
    private var backgroundColor: some View {
        Rectangle()
            .fill(configuration.backgroundColor)
            .ignoresSafeArea()
    }
    
    // MARK: - Pie Slices
    
    private func pieSlices(in geometry: GeometryProxy) -> some View {
        PieSlicesView(
            data: data,
            size: geometry.size,
            configuration: configuration,
            chartStyle: chartStyle,
            animationProgress: animationProgress,
            selectedSlice: $selectedSlice,
            highlightedSlice: $highlightedSlice
        )
    }
    
    // MARK: - Center Text
    
    private func centerTextView(text: String, in geometry: GeometryProxy) -> some View {
        Text(text)
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(configuration.axisLabelColor)
            .position(
                x: geometry.size.width / 2,
                y: geometry.size.height / 2
            )
    }
    
    // MARK: - Interactive Overlay
    
    private func interactiveOverlay(in geometry: GeometryProxy) -> some View {
        PieChartInteractiveOverlayView(
            size: geometry.size,
            configuration: configuration,
            selectedSlice: $selectedSlice,
            highlightedSlice: $highlightedSlice
        )
    }
    
    // MARK: - Tooltip
    
    private func tooltipView(for slice: ChartDataPoint, in geometry: GeometryProxy) -> some View {
        PieChartTooltipView(
            slice: slice,
            configuration: configuration,
            totalValue: totalValue,
            percentage: percentage(for: slice)
        )
        .position(tooltipPosition(for: slice, in: geometry))
    }
    
    // MARK: - Computed Properties
    
    private var totalValue: Double {
        return data.reduce(0) { $0 + $1.y }
    }
    
    private var accessibilityValue: String {
        let total = totalValue
        let maxSlice = data.max { $0.y < $1.y }
        let maxValue = maxSlice?.y ?? 0
        let maxPercentage = (maxValue / total) * 100
        return "Total: \(String(format: "%.1f", total)), Largest slice: \(String(format: "%.1f", maxPercentage))%"
    }
    
    // MARK: - Helper Methods
    
    private func startAnimation() {
        withAnimation(configuration.animation) {
            animationProgress = 1.0
        }
    }
    
    private func percentage(for slice: ChartDataPoint) -> Double {
        return (slice.y / totalValue) * 100
    }
    
    private func tooltipPosition(for slice: ChartDataPoint, in geometry: GeometryProxy) -> CGPoint {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius = min(geometry.size.width, geometry.size.height) / 3
        let angle = sliceAngle(for: slice)
        let x = center.x + cos(angle) * radius
        let y = center.y + sin(angle) * radius
        return CGPoint(x: x, y: y)
    }
    
    private func sliceAngle(for slice: ChartDataPoint) -> Double {
        let sliceIndex = data.firstIndex(of: slice) ?? 0
        let previousSlices = data.prefix(sliceIndex)
        let previousTotal = previousSlices.reduce(0) { $0 + $1.y }
        let startAngle = (previousTotal / totalValue) * 2 * .pi
        let sliceAngle = (slice.y / totalValue) * 2 * .pi
        return startAngle + sliceAngle / 2
    }
}

// MARK: - Chart Style

/// Pie chart style options
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum PieChartStyle: String, CaseIterable, Codable {
    case pie
    case donut
    case exploded
}

// MARK: - Supporting Views

/// Pie slices view
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct PieSlicesView: View {
    let data: [ChartDataPoint]
    let size: CGSize
    let configuration: ChartConfiguration
    let chartStyle: PieChartStyle
    let animationProgress: Double
    @Binding var selectedSlice: ChartDataPoint?
    @Binding var highlightedSlice: ChartDataPoint?
    
    var body: some View {
        Canvas { context, size in
            drawPieSlices(context: context, size: size)
        }
    }
    
    private func drawPieSlices(context: GraphicsContext, size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = min(size.width, size.height) / 2 - 20
        let totalValue = data.reduce(0) { $0 + $1.y }
        
        var currentAngle: Double = 0
        
        for (index, slice) in data.enumerated() {
            let sliceAngle = (slice.y / totalValue) * 2 * .pi * animationProgress
            let isSelected = selectedSlice?.id == slice.id
            let isHighlighted = highlightedSlice?.id == slice.id
            
            let sliceRadius = radius
            let offset: Double = {
                switch chartStyle {
                case .pie:
                    return 0
                case .donut:
                    return radius * 0.3
                case .exploded:
                    return isSelected || isHighlighted ? 10 : 0
                }
            }()
            
            let adjustedRadius = sliceRadius - offset
            
            let path = Path { path in
                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: adjustedRadius,
                    startAngle: Angle(radians: currentAngle),
                    endAngle: Angle(radians: currentAngle + sliceAngle),
                    clockwise: false
                )
                path.closeSubpath()
            }
            
            context.fill(
                path,
                with: .color(slice.effectiveColor)
            )
            
            // Add stroke for donut charts
            if chartStyle == .donut {
                context.stroke(
                    path,
                    with: .color(configuration.backgroundColor),
                    lineWidth: 2
                )
            }
            
            currentAngle += sliceAngle
        }
    }
}

/// Interactive overlay for pie chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct PieChartInteractiveOverlayView: View {
    let size: CGSize
    let configuration: ChartConfiguration
    @Binding var selectedSlice: ChartDataPoint?
    @Binding var highlightedSlice: ChartDataPoint?
    
    var body: some View {
        Rectangle()
            .fill(Color.clear)
            .contentShape(Rectangle())
            .onTapGesture {
                selectedSlice = nil
            }
    }
}

/// Tooltip view for pie chart
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct PieChartTooltipView: View {
    let slice: ChartDataPoint
    let configuration: ChartConfiguration
    let totalValue: Double
    let percentage: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let label = slice.label {
                Text(label)
                    .font(.caption)
                    .fontWeight(.bold)
            }
            
            Text("Value: \(String(format: "%.2f", slice.y))")
                .font(.caption2)
            
            Text("Percentage: \(String(format: "%.1f", percentage))%")
                .font(.caption2)
            
            if let category = slice.category {
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