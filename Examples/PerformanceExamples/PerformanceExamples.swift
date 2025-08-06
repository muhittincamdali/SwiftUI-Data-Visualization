import SwiftUI
import DataVisualization

struct PerformanceExamples: View {
    @State private var dataPoints: Int = 1000
    @State private var isOptimized = true
    
    var largeDataset: [DataPoint] {
        (1...dataPoints).map { i in
            DataPoint(x: Double(i), y: Double.random(in: 0...100))
        }
    }
    
    var body: some View {
        VStack {
            Text("Performance Examples")
                .font(.title)
                .padding()
            
            VStack {
                HStack {
                    Text("Data Points: \(dataPoints)")
                    Slider(value: Binding(
                        get: { Double(dataPoints) },
                        set: { dataPoints = Int($0) }
                    ), in: 100...10000, step: 100)
                }
                
                Toggle("Enable Optimizations", isOn: $isOptimized)
            }
            .padding()
            
            LineChart(data: largeDataset)
                .performance(ChartPerformanceConfig(
                    maxDataPoints: isOptimized ? 10000 : 1000,
                    enableCaching: isOptimized,
                    enableLazyLoading: isOptimized,
                    enableGPUAcceleration: isOptimized
                ))
                .frame(height: 300)
                .padding()
        }
    }
}

#Preview {
    PerformanceExamples()
} 