# 🚀 Getting Started Guide

Welcome to SwiftUI Data Visualization! This guide will help you get up and running with the world's most advanced SwiftUI data visualization library.

## 📋 Prerequisites

Before you begin, make sure you have:

- **Xcode 14.0+**
- **iOS 15.0+** (or macOS 12.0+, tvOS 15.0+, watchOS 8.0+)
- **Swift 5.7+**
- **SwiftUI 3.0+**

## ⚡ Quick Installation

### Using Swift Package Manager

1. **Add the package to your project**
   ```swift
   // In Xcode: File → Add Package Dependencies
   // Enter URL: https://github.com/muhittincamdali/SwiftUI-Data-Visualization
   ```

2. **Import the library**
   ```swift
   import DataVisualization
   ```

3. **Create your first chart**
   ```swift
   struct ContentView: View {
       let data = [
           ChartDataPoint(x: 1, y: 10, label: "Jan"),
           ChartDataPoint(x: 2, y: 25, label: "Feb"),
           ChartDataPoint(x: 3, y: 15, label: "Mar"),
           ChartDataPoint(x: 4, y: 30, label: "Apr")
       ]
       
       var body: some View {
           LineChartView(data: data)
               .frame(height: 300)
               .padding()
       }
   }
   ```

## 📊 Chart Types

### Line Charts
```swift
LineChartView(data: data)
    .chartStyle(.line)
    .animation(.easeInOut(duration: 0.8))
```

### Bar Charts
```swift
BarChartView(data: data, style: .vertical)
    .chartStyle(.vertical)
    .animation(.spring())
```

### Pie Charts
```swift
PieChartView(data: data, style: .pie, centerText: "Total")
    .chartStyle(.pie)
    .animation(.easeInOut(duration: 1.0))
```

### Scatter Plots
```swift
ScatterPlotView(data: data, style: .scatter)
    .chartStyle(.scatter)
    .pointSize(8)
    .pointColor(.blue)
```

### Area Charts
```swift
AreaChartView(data: data, style: .area)
    .chartStyle(.area)
    .gradientFill(.blue.opacity(0.3))
    .animation(.easeInOut(duration: 0.8))
```

### Candlestick Charts
```swift
CandlestickChartView(data: financialData, style: .candlestick)
    .chartStyle(.candlestick)
    .showVolume(true)
    .animation(.easeInOut(duration: 0.8))
```

## 🎨 Customization

### Chart Configuration
```swift
let config = ChartConfiguration(
    theme: .dark,
    showGrid: true,
    showLegend: true,
    animationsEnabled: true
)

LineChartView(data: data, configuration: config)
```

### Color Palettes
```swift
let customConfig = ChartConfiguration(
    colorPalette: [.red, .blue, .green, .orange, .purple]
)
```

### Animations
```swift
LineChartView(data: data)
    .animation(.spring(response: 0.8, dampingFraction: 0.6))
    .entranceAnimation(.slideInFromBottom)
    .updateAnimation(.scale)
```

## ⚡ Performance Optimization

### Large Datasets
```swift
let config = ChartConfiguration.performance

LineChartView(data: largeDataset, configuration: config)
    .maxDataPoints(5000)
    .useLazyLoading(true)
    .memoryLimit(100)
```

### Real-time Updates
```swift
RealTimeChartView()
    .dataSource(WebSocketDataSource(url: "wss://api.example.com/data"))
    .updateInterval(0.1) // 100ms updates
    .animation(.linear(duration: 0.1))
```

## ♿ Accessibility

### VoiceOver Support
```swift
ChartView(data: data)
    .accessibilityLabel("Sales data for Q1 2024")
    .accessibilityValue("Total sales: $125,000")
    .accessibilityHint("Double tap to zoom")
```

### Dynamic Type
```swift
ChartView(data: data)
    .dynamicTypeSize(.large)
    .accessibilityTextStyle(.body)
    .minimumScaleFactor(0.8)
```

## 🔧 Advanced Features

### Interactive Elements
```swift
InteractiveChartView(data: data)
    .zoomEnabled(true)
    .panEnabled(true)
    .doubleTapToReset(true)
    .longPressGesture(.highlight)
```

### Custom Tooltips
```swift
ChartView(data: data)
    .tooltipContent { point in
        VStack {
            Text(point.label ?? "")
            Text("Value: \(point.y)")
        }
    }
```

### Export Functionality
```swift
ChartView(data: data)
    .exportFormats([.png, .pdf, .svg])
    .exportQuality(.high)
```

## 🧪 Testing

### Unit Tests
```swift
import XCTest
@testable import DataVisualization

class ChartTests: XCTestCase {
    func testChartCreation() {
        let data = [ChartDataPoint(x: 1, y: 10)]
        let chart = LineChartView(data: data)
        XCTAssertNotNil(chart)
    }
}
```

### Performance Tests
```swift
func testLargeDatasetPerformance() {
    let largeData = (1...1000).map { ChartDataPoint(x: Double($0), y: Double.random(in: 10...100)) }
    
    let startTime = CFAbsoluteTimeGetCurrent()
    let chart = LineChartView(data: largeData)
    let endTime = CFAbsoluteTimeGetCurrent()
    
    let renderTime = (endTime - startTime) * 1000
    XCTAssertLessThan(renderTime, 100) // Should render in under 100ms
}
```

## 📱 Platform Support

### iOS
```swift
// Full support for iOS 15.0+
LineChartView(data: data)
    .frame(height: 300)
```

### macOS
```swift
// Full support for macOS 12.0+
BarChartView(data: data)
    .frame(height: 300)
```

### tvOS
```swift
// Full support for tvOS 15.0+
PieChartView(data: data)
    .frame(height: 300)
```

### watchOS
```swift
// Full support for watchOS 8.0+
ScatterPlotView(data: data)
    .frame(height: 150)
```

## 🚀 Next Steps

1. **Explore Examples**: Check out the [Examples](Examples/) directory for complete sample applications
2. **Read Documentation**: Visit the [API Reference](Documentation/API/) for detailed documentation
3. **Join Community**: Contribute to the project by following our [Contributing Guide](CONTRIBUTING.md)
4. **Report Issues**: Help improve the library by reporting bugs or requesting features

## 📚 Additional Resources

- [API Reference](Documentation/API/)
- [Performance Guide](Documentation/Guides/Performance.md)
- [Accessibility Guide](Documentation/Guides/Accessibility.md)
- [Customization Guide](Documentation/Guides/Customization.md)
- [Testing Guide](Documentation/Guides/Testing.md)

## 🤝 Support

- **Documentation**: [GitHub Wiki](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/wiki)
- **Issues**: [GitHub Issues](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/issues)
- **Discussions**: [GitHub Discussions](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/discussions)

---

**Ready to create amazing data visualizations? Start building with SwiftUI Data Visualization today!** 🎉 