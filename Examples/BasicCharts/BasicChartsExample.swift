import SwiftUI
import DataVisualization

/// Basic charts example demonstrating line, bar, and pie charts.
///
/// This example shows how to create and configure basic chart types
/// with sample data and various styling options.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct BasicChartsExample: View {
    
    // MARK: - Sample Data
    
    private let lineChartData = [
        ChartDataPoint(x: 1, y: 10, label: "Jan", color: .blue),
        ChartDataPoint(x: 2, y: 25, label: "Feb", color: .blue),
        ChartDataPoint(x: 3, y: 15, label: "Mar", color: .blue),
        ChartDataPoint(x: 4, y: 30, label: "Apr", color: .blue),
        ChartDataPoint(x: 5, y: 45, label: "May", color: .blue),
        ChartDataPoint(x: 6, y: 35, label: "Jun", color: .blue)
    ]
    
    private let barChartData = [
        ChartDataPoint(x: 1, y: 20, label: "Product A", color: .green),
        ChartDataPoint(x: 2, y: 35, label: "Product B", color: .green),
        ChartDataPoint(x: 3, y: 15, label: "Product C", color: .green),
        ChartDataPoint(x: 4, y: 40, label: "Product D", color: .green),
        ChartDataPoint(x: 5, y: 25, label: "Product E", color: .green)
    ]
    
    private let pieChartData = [
        ChartDataPoint(x: 1, y: 30, label: "iOS", color: .blue, category: "Platform"),
        ChartDataPoint(x: 2, y: 25, label: "Android", color: .green, category: "Platform"),
        ChartDataPoint(x: 3, y: 20, label: "Web", color: .orange, category: "Platform"),
        ChartDataPoint(x: 4, y: 15, label: "Desktop", color: .red, category: "Platform"),
        ChartDataPoint(x: 5, y: 10, label: "Other", color: .purple, category: "Platform")
    ]
    
    // MARK: - State
    
    @State private var selectedChart: ChartType = .line
    @State private var showAnimations = true
    @State private var showGrid = true
    @State private var showLegend = true
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Chart Type Selector
                chartTypeSelector
                
                // Chart Display
                chartDisplay
                
                // Configuration Controls
                configurationControls
                
                Spacer()
            }
            .padding()
            .navigationTitle("Basic Charts")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Chart Type Selector
    
    private var chartTypeSelector: some View {
        Picker("Chart Type", selection: $selectedChart) {
            ForEach(ChartType.allCases, id: \.self) { chartType in
                Text(chartType.displayName).tag(chartType)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
    }
    
    // MARK: - Chart Display
    
    private var chartDisplay: some View {
        VStack {
            switch selectedChart {
            case .line:
                lineChartView
            case .bar:
                barChartView
            case .pie:
                pieChartView
            }
        }
        .frame(height: 300)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }
    
    private var lineChartView: some View {
        LineChartView(data: lineChartData)
            .chartStyle(.line)
            .animation(showAnimations ? .easeInOut(duration: 0.8) : .none)
            .showGrid(showGrid)
            .showLegend(showLegend)
    }
    
    private var barChartView: some View {
        BarChartView(data: barChartData, style: .vertical)
            .chartStyle(.vertical)
            .animation(showAnimations ? .spring() : .none)
            .showGrid(showGrid)
            .showLegend(showLegend)
    }
    
    private var pieChartView: some View {
        PieChartView(data: pieChartData, style: .pie, centerText: "Total")
            .chartStyle(.pie)
            .animation(showAnimations ? .easeInOut(duration: 1.0) : .none)
            .showLegend(showLegend)
    }
    
    // MARK: - Configuration Controls
    
    private var configurationControls: some View {
        VStack(spacing: 16) {
            Text("Configuration")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 12) {
                Toggle("Show Animations", isOn: $showAnimations)
                    .toggleStyle(SwitchToggleStyle())
                
                Toggle("Show Grid", isOn: $showGrid)
                    .toggleStyle(SwitchToggleStyle())
                
                Toggle("Show Legend", isOn: $showLegend)
                    .toggleStyle(SwitchToggleStyle())
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }
}

// MARK: - Chart Type Enum

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum ChartType: CaseIterable {
    case line
    case bar
    case pie
    
    var displayName: String {
        switch self {
        case .line:
            return "Line"
        case .bar:
            return "Bar"
        case .pie:
            return "Pie"
        }
    }
}

// MARK: - Chart Style Extensions

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension LineChartView {
    func chartStyle(_ style: ChartStyle) -> LineChartView {
        // Implementation for chart style
        return self
    }
    
    func showGrid(_ show: Bool) -> LineChartView {
        // Implementation for grid visibility
        return self
    }
    
    func showLegend(_ show: Bool) -> LineChartView {
        // Implementation for legend visibility
        return self
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension BarChartView {
    func chartStyle(_ style: BarChartStyle) -> BarChartView {
        // Implementation for chart style
        return self
    }
    
    func showGrid(_ show: Bool) -> BarChartView {
        // Implementation for grid visibility
        return self
    }
    
    func showLegend(_ show: Bool) -> BarChartView {
        // Implementation for legend visibility
        return self
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
extension PieChartView {
    func chartStyle(_ style: PieChartStyle) -> PieChartView {
        // Implementation for chart style
        return self
    }
    
    func showLegend(_ show: Bool) -> PieChartView {
        // Implementation for legend visibility
        return self
    }
}

// MARK: - Supporting Types

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum ChartStyle {
    case line
    case multiLine
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum BarChartStyle {
    case vertical
    case horizontal
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
enum PieChartStyle {
    case pie
    case donut
    case exploded
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct BasicChartsExample_Previews: PreviewProvider {
    static var previews: some View {
        BasicChartsExample()
    }
} 