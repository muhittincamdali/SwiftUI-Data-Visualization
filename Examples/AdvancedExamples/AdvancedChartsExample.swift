import SwiftUI
import DataVisualization

struct AdvancedChartsExample: View {
    @State private var selectedChart: ChartType = .line
    
    enum ChartType: String, CaseIterable {
        case line = "Line Chart"
        case bar = "Bar Chart"
        case pie = "Pie Chart"
        case scatter = "Scatter Plot"
        case area = "Area Chart"
    }
    
    let lineData = [
        DataPoint(x: 1, y: 10),
        DataPoint(x: 2, y: 20),
        DataPoint(x: 3, y: 15),
        DataPoint(x: 4, y: 25),
        DataPoint(x: 5, y: 30)
    ]
    
    let barData = [
        DataPoint(x: "Jan", y: 100),
        DataPoint(x: "Feb", y: 150),
        DataPoint(x: "Mar", y: 120),
        DataPoint(x: "Apr", y: 200),
        DataPoint(x: "May", y: 180)
    ]
    
    let pieData = [
        DataPoint(x: "Red", y: 30),
        DataPoint(x: "Blue", y: 25),
        DataPoint(x: "Green", y: 20),
        DataPoint(x: "Yellow", y: 15),
        DataPoint(x: "Purple", y: 10)
    ]
    
    var body: some View {
        VStack {
            Text("Advanced Charts Example")
                .font(.title)
                .padding()
            
            Picker("Chart Type", selection: $selectedChart) {
                ForEach(ChartType.allCases, id: \.self) { chartType in
                    Text(chartType.rawValue).tag(chartType)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            switch selectedChart {
            case .line:
                LineChart(data: lineData)
                    .frame(height: 300)
                    .padding()
            case .bar:
                BarChart(data: barData)
                    .frame(height: 300)
                    .padding()
            case .pie:
                PieChart(data: pieData)
                    .frame(height: 300)
                    .padding()
            case .scatter:
                ScatterPlot(data: lineData)
                    .frame(height: 300)
                    .padding()
            case .area:
                AreaChart(data: lineData)
                    .frame(height: 300)
                    .padding()
            }
        }
    }
}

#Preview {
    AdvancedChartsExample()
} 