import SwiftUI
import DataVisualization

struct BasicLineChartExample: View {
    let data = [
        DataPoint(x: 1, y: 10),
        DataPoint(x: 2, y: 20),
        DataPoint(x: 3, y: 15),
        DataPoint(x: 4, y: 25),
        DataPoint(x: 5, y: 30)
    ]
    
    var body: some View {
        VStack {
            Text("Basic Line Chart")
                .font(.title)
                .padding()
            
            LineChart(data: data)
                .frame(height: 300)
                .padding()
        }
    }
}

#Preview {
    BasicLineChartExample()
}
