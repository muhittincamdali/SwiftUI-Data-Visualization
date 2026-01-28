# SwiftUI Data Visualization

<p align="center">
  <img src="Assets/banner.png" alt="SwiftUI Data Visualization" width="800">
</p>

<p align="center">
  <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.9+-F05138?style=flat&logo=swift&logoColor=white" alt="Swift"></a>
  <a href="https://developer.apple.com/ios/"><img src="https://img.shields.io/badge/iOS-15.0+-000000?style=flat&logo=apple&logoColor=white" alt="iOS"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License"></a>
  <a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions"><img src="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions/workflows/ci.yml/badge.svg" alt="CI"></a>
</p>

<p align="center">
  <b>Beautiful, interactive charts and graphs for SwiftUI applications.</b>
</p>

---

## Preview

<p align="center">
  <img src="Assets/charts-preview.png" alt="Charts Preview" width="700">
</p>

## Chart Types

| Chart | Description |
|-------|-------------|
| **Line Chart** | Time series, trends, continuous data |
| **Bar Chart** | Comparisons, categories, rankings |
| **Pie Chart** | Proportions, percentages |
| **Donut Chart** | Parts of a whole with center content |
| **Area Chart** | Cumulative data, filled line charts |
| **Scatter Plot** | Correlations, distributions |
| **Radar Chart** | Multi-variable comparisons |
| **Candlestick** | Financial data, OHLC |

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git", from: "1.0.0")
]
```

## Quick Start

### Line Chart

```swift
import SwiftUIDataVisualization

struct SalesChartView: View {
    let data: [DataPoint] = [
        DataPoint(x: "Jan", y: 120),
        DataPoint(x: "Feb", y: 180),
        DataPoint(x: "Mar", y: 150),
        DataPoint(x: "Apr", y: 220),
        DataPoint(x: "May", y: 280)
    ]
    
    var body: some View {
        LineChart(data: data)
            .lineColor(.blue)
            .lineWidth(2)
            .showPoints(true)
            .showGrid(true)
            .animated(true)
            .frame(height: 300)
    }
}
```

### Bar Chart

```swift
struct RevenueChartView: View {
    let data: [BarData] = [
        BarData(label: "Q1", value: 45000),
        BarData(label: "Q2", value: 62000),
        BarData(label: "Q3", value: 58000),
        BarData(label: "Q4", value: 71000)
    ]
    
    var body: some View {
        BarChart(data: data)
            .barColor(.green)
            .cornerRadius(8)
            .showLabels(true)
            .showValues(true)
            .frame(height: 300)
    }
}
```

### Pie Chart

```swift
struct CategoryChartView: View {
    let data: [PieSlice] = [
        PieSlice(label: "Mobile", value: 45, color: .blue),
        PieSlice(label: "Desktop", value: 35, color: .green),
        PieSlice(label: "Tablet", value: 20, color: .orange)
    ]
    
    var body: some View {
        PieChart(data: data)
            .showLabels(true)
            .showPercentages(true)
            .innerRadius(0) // 0 for pie, >0 for donut
            .frame(width: 300, height: 300)
    }
}
```

### Area Chart

```swift
struct TrafficChartView: View {
    let data: [DataPoint] = [
        DataPoint(x: "Mon", y: 1200),
        DataPoint(x: "Tue", y: 1500),
        DataPoint(x: "Wed", y: 1800),
        DataPoint(x: "Thu", y: 1600),
        DataPoint(x: "Fri", y: 2100)
    ]
    
    var body: some View {
        AreaChart(data: data)
            .fillColor(.blue.opacity(0.3))
            .lineColor(.blue)
            .showGrid(true)
            .frame(height: 250)
    }
}
```

## Customization

### Colors & Styling

```swift
LineChart(data: data)
    .lineColor(.purple)
    .lineWidth(3)
    .pointColor(.white)
    .pointSize(8)
    .pointBorderColor(.purple)
    .pointBorderWidth(2)
```

### Grid & Axes

```swift
LineChart(data: data)
    .showGrid(true)
    .gridColor(.gray.opacity(0.2))
    .showXAxis(true)
    .showYAxis(true)
    .xAxisLabel("Month")
    .yAxisLabel("Revenue ($)")
```

### Animations

```swift
BarChart(data: data)
    .animated(true)
    .animationDuration(0.8)
    .animationDelay(0.1) // Stagger bars
```

### Interactions

```swift
LineChart(data: data)
    .selectable(true)
    .onSelect { point in
        print("Selected: \(point.label) - \(point.value)")
    }
    .tooltip { point in
        Text("\(point.label): \(point.value)")
    }
```

## Real-Time Updates

```swift
struct LiveChartView: View {
    @StateObject private var dataSource = LiveDataSource()
    
    var body: some View {
        LineChart(data: dataSource.data)
            .animated(true)
            .onAppear {
                dataSource.startUpdates()
            }
    }
}

class LiveDataSource: ObservableObject {
    @Published var data: [DataPoint] = []
    
    func startUpdates() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let newPoint = DataPoint(
                x: Date().formatted(date: .omitted, time: .shortened),
                y: Double.random(in: 50...150)
            )
            self.data.append(newPoint)
            if self.data.count > 20 {
                self.data.removeFirst()
            }
        }
    }
}
```

## Project Structure

```
SwiftUI-Data-Visualization/
├── Sources/
│   ├── Charts/
│   │   ├── LineChart.swift
│   │   ├── BarChart.swift
│   │   ├── PieChart.swift
│   │   ├── AreaChart.swift
│   │   ├── ScatterPlot.swift
│   │   └── RadarChart.swift
│   ├── Core/
│   │   ├── DataModels.swift
│   │   ├── ChartStyle.swift
│   │   └── Animations.swift
│   └── Utils/
├── Examples/
└── Tests/
```

## Requirements

- iOS 15.0+ / macOS 12.0+
- Xcode 15.0+
- Swift 5.9+

## Documentation

- [Chart Types Guide](Documentation/ChartTypes.md)
- [Customization](Documentation/Customization.md)
- [Real-Time Data](Documentation/RealTimeData.md)
- [Accessibility](Documentation/Accessibility.md)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT License. See [LICENSE](LICENSE).

## Author

**Muhittin Camdali** — [@muhittincamdali](https://github.com/muhittincamdali)

---

<p align="center">
  <sub>Data visualization made easy for SwiftUI ❤️</sub>
</p>
