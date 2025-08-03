import SwiftUI

/// A pie chart that displays data as slices of a pie.
///
/// This chart type is ideal for showing proportions and percentages.
/// It supports custom colors, labels, and interactive features.
///
/// - Example:
/// ```swift
/// PieChart(data: marketShareData)
///     .chartStyle(.pie)
///     .showLabels(true)
/// ```
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct PieChart: View {
    
    // MARK: - Properties
    
    /// Data points to display
    private let data: [ChartDataPoint]
    
    /// Chart configuration
    private let configuration: ChartConfiguration
    
    /// Chart dimensions
    @State private var chartSize: CGSize = .zero
    
    /// Animation progress
    @State private var animationProgress: Double = 0
    
    /// Selected slice
    @State private var selectedSlice: ChartDataPoint?
    
    /// Whether to show labels
    private let showLabels: Bool
    
    /// Whether to show values
    private let showValues: Bool
    
    /// Center text
    private let centerText: String?
    
    // MARK: - Initialization
    
    /// Creates a new pie chart with data and configuration.
    ///
    /// - Parameters:
    ///   - data: Array of data points to display
    ///   - configuration: Chart configuration options
    ///   - showLabels: Whether to show slice labels
    ///   - showValues: Whether to show slice values
    ///   - centerText: Optional center text
    public init(
        data: [ChartDataPoint],
        configuration: ChartConfiguration = ChartConfiguration(),
        showLabels: Bool = false,
        showValues: Bool = false,
        centerText: String? = nil
    ) {
        self.data = data
        self.configuration = configuration
        self.showLabels = showLabels
        self.showValues = showValues
        self.centerText = centerText
    }
    
    /// Creates a new pie chart with data and style.
    ///
    /// - Parameters:
    ///   - data: Array of data points to display
    ///   - style: Chart style
    ///   - showLabels: Whether to show slice labels
    public init(
        data: [ChartDataPoint],
        style: ChartStyle = .pie,
        showLabels: Bool = false
    ) {
        self.data = data
        self.configuration = ChartConfiguration().withStyle(style)
        self.showLabels = showLabels
        self.showValues = false
        self.centerText = nil
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundColor
                
                // Chart content
                chartContent
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                // Center text
                if let centerText = centerText {
                    centerTextView(text: centerText)
                }
                
                // Legend
                if configuration.legend.enabled {
                    legendView
                }
                
                // Tooltip
                if configuration.tooltipEnabled && selectedSlice != nil {
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
        .accessibilityLabel(configuration.accessibility.label ?? "Pie Chart")
        .accessibilityHint(configuration.accessibility.hint ?? "Shows data as pie slices")
        .accessibilityValue(configuration.accessibility.value ?? "\(data.count) slices")
        .accessibilityAddTraits(configuration.accessibility.traits)
    }
    
    // MARK: - Chart Components
    
    /// Background view
    private var backgroundColor: some View {
        Rectangle()
            .fill(configuration.backgroundColor)
            .ignoresSafeArea()
    }
    
    /// Chart content view
    private var chartContent: some View {
        ZStack {
            // Pie slices
            ForEach(data.indices, id: \.self) { index in
                pieSliceView(for: data[index], at: index)
            }
            
            // Labels
            if showLabels {
                ForEach(data.indices, id: \.self) { index in
                    sliceLabelView(for: data[index], at: index)
                }
            }
        }
    }
    
    /// Individual pie slice view
    private func pieSliceView(for point: ChartDataPoint, at index: Int) -> some View {
        let slicePath = calculateSlicePath(for: point, at: index)
        let color = point.color ?? configuration.colors[index % configuration.colors.count]
        let isSelected = selectedSlice?.id == point.id
        
        return Path { path in
            path.addPath(slicePath)
        }
        .fill(color)
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: selectedSlice?.id)
        .onTapGesture {
            handleSliceTap(point)
        }
    }
    
    /// Slice label view
    private func sliceLabelView(for point: ChartDataPoint, at index: Int) -> some View {
        let labelPosition = calculateLabelPosition(for: point, at: index)
        let label = point.label ?? "Slice \(index + 1)"
        
        return Text(label)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(.white)
            .position(labelPosition)
            .shadow(color: .black, radius: 1)
    }
    
    /// Center text view
    private func centerTextView(text: String) -> some View {
        Text(text)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .position(x: chartSize.width / 2, y: chartSize.height / 2)
    }
    
    /// Legend view
    private var legendView: some View {
        VStack {
            ForEach(data.indices, id: \.self) { index in
                let point = data[index]
                let color = point.color ?? configuration.colors[index % configuration.colors.count]
                let label = point.label ?? "Slice \(index + 1)"
                let value = point.y
                let percentage = (value / data.map { $0.y }.reduce(0, +)) * 100
                
                HStack {
                    Circle()
                        .fill(color)
                        .frame(width: 12, height: 12)
                    
                    Text(label)
                        .font(.caption)
                        .foregroundColor(configuration.legend.color)
                    
                    Spacer()
                    
                    if showValues {
                        Text("\(percentage, specifier: "%.1f")%")
                            .font(.caption)
                            .foregroundColor(.secondary)
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
            if let slice = selectedSlice {
                if let label = slice.label {
                    Text(label)
                        .font(.caption)
                        .fontWeight(.bold)
                }
                
                let percentage = (slice.y / data.map { $0.y }.reduce(0, +)) * 100
                Text("Value: \(String(format: "%.2f", slice.y))")
                    .font(.caption)
                Text("Percentage: \(String(format: "%.1f", percentage))%")
                    .font(.caption)
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(6)
        .shadow(radius: 2)
        .position(calculateTooltipPosition())
    }
    
    // MARK: - Calculation Methods
    
    /// Calculates slice path for a data point
    private func calculateSlicePath(for point: ChartDataPoint, at index: Int) -> Path {
        let total = data.map { $0.y }.reduce(0, +)
        let startAngle = data.prefix(index).map { $0.y }.reduce(0, +) / total * 2 * .pi
        let endAngle = data.prefix(index + 1).map { $0.y }.reduce(0, +) / total * 2 * .pi
        
        let center = CGPoint(x: chartSize.width / 2, y: chartSize.height / 2)
        let radius = min(chartSize.width, chartSize.height) / 2 - 20
        
        var path = Path()
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: Angle(radians: startAngle),
            endAngle: Angle(radians: endAngle),
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }
    
    /// Calculates label position for a slice
    private func calculateLabelPosition(for point: ChartDataPoint, at index: Int) -> CGPoint {
        let total = data.map { $0.y }.reduce(0, +)
        let startAngle = data.prefix(index).map { $0.y }.reduce(0, +) / total * 2 * .pi
        let endAngle = data.prefix(index + 1).map { $0.y }.reduce(0, +) / total * 2 * .pi
        let midAngle = (startAngle + endAngle) / 2
        
        let center = CGPoint(x: chartSize.width / 2, y: chartSize.height / 2)
        let radius = min(chartSize.width, chartSize.height) / 2 - 40
        
        let x = center.x + radius * cos(midAngle)
        let y = center.y + radius * sin(midAngle)
        
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
        guard let selectedSlice = selectedSlice else { return .zero }
        let index = data.firstIndex(of: selectedSlice) ?? 0
        let labelPosition = calculateLabelPosition(for: selectedSlice, at: index)
        return CGPoint(x: labelPosition.x, y: labelPosition.y - 30)
    }
    
    // MARK: - Interaction Methods
    
    /// Handles tap gesture
    private func handleTap() {
        // Implement tap logic
    }
    
    /// Handles slice tap
    private func handleSliceTap(_ slice: ChartDataPoint) {
        if configuration.selectionEnabled {
            selectedSlice = selectedSlice?.id == slice.id ? nil : slice
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
struct PieChart_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = [
            ChartDataPoint(x: 1, y: 30, label: "Red", color: .red),
            ChartDataPoint(x: 2, y: 25, label: "Blue", color: .blue),
            ChartDataPoint(x: 3, y: 20, label: "Green", color: .green),
            ChartDataPoint(x: 4, y: 15, label: "Yellow", color: .yellow),
            ChartDataPoint(x: 5, y: 10, label: "Purple", color: .purple)
        ]
        
        PieChart(data: sampleData, showLabels: true, centerText: "Total")
            .frame(width: 300, height: 300)
            .padding()
    }
} 