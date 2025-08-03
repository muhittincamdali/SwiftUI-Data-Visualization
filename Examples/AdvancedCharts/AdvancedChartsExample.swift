import SwiftUI
import DataVisualization

/// Advanced charts example demonstrating complex visualizations and interactions.
///
/// This example shows how to create sophisticated charts with multiple data series,
/// custom styling, and advanced interactions.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct AdvancedChartsExample: View {
    
    // MARK: - Sample Data
    
    private let multiLineData = [
        [
            ChartDataPoint(x: 1, y: 10, label: "Jan", color: .blue),
            ChartDataPoint(x: 2, y: 25, label: "Feb", color: .blue),
            ChartDataPoint(x: 3, y: 15, label: "Mar", color: .blue),
            ChartDataPoint(x: 4, y: 30, label: "Apr", color: .blue),
            ChartDataPoint(x: 5, y: 45, label: "May", color: .blue),
            ChartDataPoint(x: 6, y: 35, label: "Jun", color: .blue)
        ],
        [
            ChartDataPoint(x: 1, y: 15, label: "Jan", color: .green),
            ChartDataPoint(x: 2, y: 30, label: "Feb", color: .green),
            ChartDataPoint(x: 3, y: 20, label: "Mar", color: .green),
            ChartDataPoint(x: 4, y: 35, label: "Apr", color: .green),
            ChartDataPoint(x: 5, y: 50, label: "May", color: .green),
            ChartDataPoint(x: 6, y: 40, label: "Jun", color: .green)
        ]
    ]
    
    private let stackedBarData = [
        ChartDataPoint(x: 1, y: 20, label: "Product A", color: .blue, category: "Category 1"),
        ChartDataPoint(x: 1, y: 15, label: "Product B", color: .green, category: "Category 2"),
        ChartDataPoint(x: 2, y: 25, label: "Product A", color: .blue, category: "Category 1"),
        ChartDataPoint(x: 2, y: 20, label: "Product B", color: .green, category: "Category 2"),
        ChartDataPoint(x: 3, y: 30, label: "Product A", color: .blue, category: "Category 1"),
        ChartDataPoint(x: 3, y: 25, label: "Product B", color: .green, category: "Category 2")
    ]
    
    private let bubbleData = [
        ChartDataPoint(x: 1, y: 10, size: 8, weight: 1.0, label: "Small"),
        ChartDataPoint(x: 2, y: 25, size: 12, weight: 2.0, label: "Medium"),
        ChartDataPoint(x: 3, y: 15, size: 6, weight: 0.5, label: "Tiny"),
        ChartDataPoint(x: 4, y: 30, size: 16, weight: 3.0, label: "Large"),
        ChartDataPoint(x: 5, y: 45, size: 20, weight: 4.0, label: "Huge")
    ]
    
    private let financialData = [
        CandlestickDataPoint(
            timestamp: Date(),
            open: 100.0,
            high: 110.0,
            low: 95.0,
            close: 105.0,
            volume: 1000
        ),
        CandlestickDataPoint(
            timestamp: Date().addingTimeInterval(86400),
            open: 105.0,
            high: 115.0,
            low: 100.0,
            close: 110.0,
            volume: 1200
        ),
        CandlestickDataPoint(
            timestamp: Date().addingTimeInterval(172800),
            open: 110.0,
            high: 120.0,
            low: 105.0,
            close: 115.0,
            volume: 1500
        )
    ]
    
    // MARK: - State
    
    @State private var selectedChart: AdvancedChartType = .multiLine
    @State private var showAnimations = true
    @State private var showGrid = true
    @State private var showLegend = true
    @State private var selectedTheme: ChartTheme = .light
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Chart Type Selector
                advancedChartTypeSelector
                
                // Chart Display
                advancedChartDisplay
                
                // Configuration Controls
                advancedConfigurationControls
                
                Spacer()
            }
            .padding()
            .navigationTitle("Advanced Charts")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Advanced Chart Type Selector
    
    private var advancedChartTypeSelector: some View {
        Picker("Advanced Chart Type", selection: $selectedChart) {
            ForEach(AdvancedChartType.allCases, id: \.self) { chartType in
                Text(chartType.displayName).tag(chartType)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
    
    // MARK: - Advanced Chart Display
    
    private var advancedChartDisplay: some View {
        VStack {
            switch selectedChart {
            case .multiLine:
                multiLineChartView
            case .stackedBar:
                stackedBarChartView
            case .bubble:
                bubbleChartView
            case .financial:
                financialChartView
            case .interactive:
                interactiveChartView
            }
        }
        .frame(height: 300)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    private var multiLineChartView: some View {
        MultiLineChartView(dataSets: multiLineData)
            .chartStyle(.multiLine)
            .animation(showAnimations ? .easeInOut(duration: 0.8) : .none)
            .showGrid(showGrid)
            .showLegend(showLegend)
            .theme(selectedTheme)
    }
    
    private var stackedBarChartView: some View {
        StackedBarChartView(data: stackedBarData)
            .chartStyle(.stacked)
            .animation(showAnimations ? .spring() : .none)
            .showGrid(showGrid)
            .showLegend(showLegend)
            .theme(selectedTheme)
    }
    
    private var bubbleChartView: some View {
        BubbleChartView(data: bubbleData)
            .chartStyle(.bubble)
            .animation(showAnimations ? .easeInOut(duration: 1.0) : .none)
            .showLegend(showLegend)
            .theme(selectedTheme)
    }
    
    private var financialChartView: some View {
        FinancialChartView(data: financialData)
            .chartStyle(.candlestick)
            .showVolume(true)
            .showTechnicalIndicators(true)
            .animation(showAnimations ? .easeInOut(duration: 0.8) : .none)
            .theme(selectedTheme)
    }
    
    private var interactiveChartView: some View {
        InteractiveChartView(data: multiLineData[0])
            .chartStyle(.interactive)
            .zoomEnabled(true)
            .panEnabled(true)
            .tooltipsEnabled(true)
            .animation(showAnimations ? .spring() : .none)
            .showGrid(showGrid)
            .theme(selectedTheme)
    }
    
    // MARK: - Advanced Configuration Controls
    
    private var advancedConfigurationControls: some View {
        VStack(spacing: 16) {
            Text("Advanced Configuration")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                Toggle("Show Animations", isOn: $showAnimations)
                    .toggleStyle(SwitchToggleStyle())
                
                Toggle("Show Grid", isOn: $showGrid)
                    .toggleStyle(SwitchToggleStyle())
                
                Toggle("Show Legend", isOn: $showLegend)
                    .toggleStyle(SwitchToggleStyle())
                
                Picker("Theme", selection: $selectedTheme) {
                    Text("Light").tag(ChartTheme.light)
                    Text("Dark").tag(ChartTheme.dark)
                    Text("Custom").tag(ChartTheme.custom)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}

// MARK: - Advanced Chart Type Enum

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum AdvancedChartType: CaseIterable {
    case multiLine
    case stackedBar
    case bubble
    case financial
    case interactive
    
    var displayName: String {
        switch self {
        case .multiLine:
            return "Multi-Line"
        case .stackedBar:
            return "Stacked Bar"
        case .bubble:
            return "Bubble"
        case .financial:
            return "Financial"
        case .interactive:
            return "Interactive"
        }
    }
}

// MARK: - Advanced Chart Views

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct MultiLineChartView: View {
    let dataSets: [[ChartDataPoint]]
    
    var body: some View {
        VStack {
            ForEach(Array(dataSets.enumerated()), id: \.offset) { index, data in
                LineChartView(data: data)
                    .frame(height: 60)
                    .opacity(0.8)
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct StackedBarChartView: View {
    let data: [ChartDataPoint]
    
    var body: some View {
        BarChartView(data: data, style: .vertical)
            .frame(height: 300)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct BubbleChartView: View {
    let data: [ChartDataPoint]
    
    var body: some View {
        ScatterPlotView(data: data, style: .bubble)
            .frame(height: 300)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct FinancialChartView: View {
    let data: [CandlestickDataPoint]
    
    var body: some View {
        CandlestickChartView(data: data, style: .candlestick)
            .frame(height: 300)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct InteractiveChartView: View {
    let data: [ChartDataPoint]
    
    var body: some View {
        LineChartView(data: data)
            .frame(height: 300)
    }
}

// MARK: - Chart Extensions

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension MultiLineChartView {
    func chartStyle(_ style: ChartStyle) -> MultiLineChartView {
        return self
    }
    
    func animation(_ animation: Animation?) -> MultiLineChartView {
        return self
    }
    
    func showGrid(_ show: Bool) -> MultiLineChartView {
        return self
    }
    
    func showLegend(_ show: Bool) -> MultiLineChartView {
        return self
    }
    
    func theme(_ theme: ChartTheme) -> MultiLineChartView {
        return self
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension StackedBarChartView {
    func chartStyle(_ style: BarChartStyle) -> StackedBarChartView {
        return self
    }
    
    func animation(_ animation: Animation?) -> StackedBarChartView {
        return self
    }
    
    func showGrid(_ show: Bool) -> StackedBarChartView {
        return self
    }
    
    func showLegend(_ show: Bool) -> StackedBarChartView {
        return self
    }
    
    func theme(_ theme: ChartTheme) -> StackedBarChartView {
        return self
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension BubbleChartView {
    func chartStyle(_ style: ScatterPlotStyle) -> BubbleChartView {
        return self
    }
    
    func animation(_ animation: Animation?) -> BubbleChartView {
        return self
    }
    
    func showLegend(_ show: Bool) -> BubbleChartView {
        return self
    }
    
    func theme(_ theme: ChartTheme) -> BubbleChartView {
        return self
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension FinancialChartView {
    func chartStyle(_ style: CandlestickChartStyle) -> FinancialChartView {
        return self
    }
    
    func showVolume(_ show: Bool) -> FinancialChartView {
        return self
    }
    
    func showTechnicalIndicators(_ show: Bool) -> FinancialChartView {
        return self
    }
    
    func animation(_ animation: Animation?) -> FinancialChartView {
        return self
    }
    
    func theme(_ theme: ChartTheme) -> FinancialChartView {
        return self
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension InteractiveChartView {
    func chartStyle(_ style: ChartStyle) -> InteractiveChartView {
        return self
    }
    
    func zoomEnabled(_ enabled: Bool) -> InteractiveChartView {
        return self
    }
    
    func panEnabled(_ enabled: Bool) -> InteractiveChartView {
        return self
    }
    
    func tooltipsEnabled(_ enabled: Bool) -> InteractiveChartView {
        return self
    }
    
    func animation(_ animation: Animation?) -> InteractiveChartView {
        return self
    }
    
    func showGrid(_ show: Bool) -> InteractiveChartView {
        return self
    }
    
    func theme(_ theme: ChartTheme) -> InteractiveChartView {
        return self
    }
}

// MARK: - Supporting Types

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum ChartStyle {
    case line
    case multiLine
    case stacked
    case bubble
    case candlestick
    case interactive
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum ChartTheme {
    case light
    case dark
    case custom
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct AdvancedChartsExample_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedChartsExample()
    }
} 