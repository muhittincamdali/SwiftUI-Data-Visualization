import SwiftUI
import DataVisualization

struct AnimationExamples: View {
    @State private var isAnimating = false
    @State private var animationDuration: Double = 1.0
    
    let data = [
        DataPoint(x: 1, y: 10),
        DataPoint(x: 2, y: 20),
        DataPoint(x: 3, y: 15),
        DataPoint(x: 4, y: 25),
        DataPoint(x: 5, y: 30)
    ]
    
    var body: some View {
        VStack {
            Text("Animation Examples")
                .font(.title)
                .padding()
            
            VStack {
                Text("Animation Duration: \(animationDuration, specifier: "%.1f")s")
                    .font(.caption)
                
                Slider(value: $animationDuration, in: 0.1...3.0)
                    .padding(.horizontal)
            }
            .padding()
            
            LineChart(data: data)
                .animation(.easeInOut(duration: animationDuration))
                .frame(height: 300)
                .padding()
            
            Button("Trigger Animation") {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    isAnimating.toggle()
                }
            }
            .padding()
        }
    }
}

#Preview {
    AnimationExamples()
}
