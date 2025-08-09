import SwiftUI
import DataVisualization

struct InteractiveChartsExample: View {
    @State private var selectedPoint: DataPoint?
    @State private var selectedIndex: Int?
    
    let data = [
        DataPoint(x: 1, y: 10),
        DataPoint(x: 2, y: 20),
        DataPoint(x: 3, y: 15),
        DataPoint(x: 4, y: 25),
        DataPoint(x: 5, y: 30)
    ]
    
    var body: some View {
        VStack {
            Text("Interactive Charts Example")
                .font(.title)
                .padding()
            
            LineChart(data: data)
                .onPointTap { point, index in
                    selectedPoint = point
                    selectedIndex = index
                }
                .frame(height: 300)
                .padding()
            
            if let selectedPoint = selectedPoint, let selectedIndex = selectedIndex {
                VStack {
                    Text("Selected Point: \(selectedIndex + 1)")
                        .font(.headline)
                    Text("X: \(selectedPoint.x), Y: \(selectedPoint.y)")
                        .font(.caption)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        }
    }
}

#Preview {
    InteractiveChartsExample()
}
