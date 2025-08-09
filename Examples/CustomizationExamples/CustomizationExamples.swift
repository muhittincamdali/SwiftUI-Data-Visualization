import SwiftUI
import DataVisualization

struct CustomizationExamples: View {
    @State private var chartColor: Color = .blue
    @State private var showGridLines = true
    @State private var showLegend = true
    
    let data = [
        DataPoint(x: 1, y: 10),
        DataPoint(x: 2, y: 20),
        DataPoint(x: 3, y: 15),
        DataPoint(x: 4, y: 25),
        DataPoint(x: 5, y: 30)
    ]
    
    var body: some View {
        VStack {
            Text("Customization Examples")
                .font(.title)
                .padding()
            
            VStack {
                HStack {
                    Text("Chart Color:")
                    ColorPicker("", selection: $chartColor)
                }
                
                Toggle("Show Grid Lines", isOn: $showGridLines)
                Toggle("Show Legend", isOn: $showLegend)
            }
            .padding()
            
            LineChart(data: data)
                .chartColor(chartColor)
                .showGridLines(showGridLines)
                .showLegend(showLegend)
                .frame(height: 300)
                .padding()
        }
    }
}

#Preview {
    CustomizationExamples()
}
