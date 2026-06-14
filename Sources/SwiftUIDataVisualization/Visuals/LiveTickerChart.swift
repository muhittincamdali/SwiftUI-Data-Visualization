import SwiftUI
import Combine

/// A high-performance, 60fps Live Ticker Chart.
/// 
/// Designed for the 2026 standard, this chart uses `Canvas` to render 
/// high-frequency financial data (e.g., Stock/Crypto tickers) with zero dropped frames.
@MainActor
public struct LiveTickerChart: View {
    public let dataPoints: [Double]
    public let lineColor: Color
    public let gradientColor: Color
    
    public init(dataPoints: [Double], lineColor: Color = .green, gradientColor: Color = .green.opacity(0.3)) {
        self.dataPoints = dataPoints
        self.lineColor = lineColor
        self.gradientColor = gradientColor
    }
    
    public var body: some View {
        Canvas { context, size in
            guard dataPoints.count > 1 else { return }
            
            let maxVal = dataPoints.max() ?? 1
            let minVal = dataPoints.min() ?? 0
            let range = max(maxVal - minVal, 1)
            
            let stepX = size.width / CGFloat(dataPoints.count - 1)
            
            var path = Path()
            var fillPath = Path()
            
            fillPath.move(to: CGPoint(x: 0, y: size.height))
            
            for (index, value) in dataPoints.enumerated() {
                let x = CGFloat(index) * stepX
                let normalizedY = 1.0 - CGFloat((value - minVal) / range)
                let y = normalizedY * size.height
                
                let point = CGPoint(x: x, y: y)
                
                if index == 0 {
                    path.move(to: point)
                    fillPath.addLine(to: point)
                } else {
                    path.addLine(to: point)
                    fillPath.addLine(to: point)
                }
            }
            
            fillPath.addLine(to: CGPoint(x: size.width, y: size.height))
            fillPath.closeSubpath()
            
            // Draw Gradient Fill
            context.fill(
                fillPath,
                with: .linearGradient(
                    Gradient(colors: [gradientColor, .clear]),
                    startPoint: CGPoint(x: 0, y: 0),
                    endPoint: CGPoint(x: 0, y: size.height)
                )
            )
            
            // Draw Line
            context.stroke(
                path,
                with: .color(lineColor),
                style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round)
            )
        }
    }
}
