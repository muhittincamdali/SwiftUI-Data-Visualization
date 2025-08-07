# Line Chart API

## Overview

The Line Chart API provides comprehensive functionality for creating smooth, interactive line charts with multiple series, trend analysis, and real-time updates. This API is optimized for performance and supports large datasets.

## Core Components

### LineChart

```swift
public struct LineChart: Chart {
    public let data: [DataPoint]
    public let style: LineChartStyle
    public let configuration: ChartConfiguration
    
    public init(
        data: [DataPoint],
        style: LineChartStyle = .default,
        configuration: ChartConfiguration = .default
    ) {
        self.data = data
        self.style = style
        self.configuration = configuration
    }
}
```

### LineChartStyle

```swift
public struct LineChartStyle {
    public var lineColor: Color
    public var lineWidth: CGFloat
    public var showPoints: Bool
    public var pointSize: CGFloat
    public var pointColor: Color
    public var showArea: Bool
    public var areaColor: Color
    public var areaOpacity: Double
    public var showGridLines: Bool
    public var gridLineColor: Color
    public var gridLineWidth: CGFloat
    
    public static let `default` = LineChartStyle(
        lineColor: .blue,
        lineWidth: 2.0,
        showPoints: true,
        pointSize: 6.0,
        pointColor: .blue,
        showArea: false,
        areaColor: .blue,
        areaOpacity: 0.3,
        showGridLines: true,
        gridLineColor: .gray.opacity(0.3),
        gridLineWidth: 1.0
    )
}
```

## Usage Examples

### Basic Line Chart

```swift
let data = [
    DataPoint(x: 1, y: 10),
    DataPoint(x: 2, y: 20),
    DataPoint(x: 3, y: 15),
    DataPoint(x: 4, y: 25),
    DataPoint(x: 5, y: 30)
]

struct BasicLineChartView: View {
    var body: some View {
        VStack {
            Text("Sales Trend")
                .font(.title)
            
            LineChart(data: data)
                .frame(height: 300)
                .padding()
        }
    }
}
```

### Customized Line Chart

```swift
let customStyle = LineChartStyle(
    lineColor: .red,
    lineWidth: 3.0,
    showPoints: true,
    pointSize: 8.0,
    pointColor: .red,
    showArea: true,
    areaColor: .red,
    areaOpacity: 0.2,
    showGridLines: true,
    gridLineColor: .gray.opacity(0.2),
    gridLineWidth: 0.5
)

let chart = LineChart(data: data, style: customStyle)
    .frame(height: 300)
    .padding()
```

### Multiple Series Line Chart

```swift
struct MultiSeriesLineChartView: View {
    let series1 = [
        DataPoint(x: 1, y: 10, label: "Series 1"),
        DataPoint(x: 2, y: 20, label: "Series 1"),
        DataPoint(x: 3, y: 15, label: "Series 1"),
        DataPoint(x: 4, y: 25, label: "Series 1"),
        DataPoint(x: 5, y: 30, label: "Series 1")
    ]
    
    let series2 = [
        DataPoint(x: 1, y: 5, label: "Series 2"),
        DataPoint(x: 2, y: 15, label: "Series 2"),
        DataPoint(x: 3, y: 10, label: "Series 2"),
        DataPoint(x: 4, y: 20, label: "Series 2"),
        DataPoint(x: 5, y: 25, label: "Series 2")
    ]
    
    var body: some View {
        VStack {
            Text("Multiple Series")
                .font(.title)
            
            LineChart(data: series1 + series2)
                .frame(height: 300)
                .padding()
        }
    }
}
```

## Interactive Features

### Touch Interactions

```swift
struct InteractiveLineChartView: View {
    @State private var selectedPoint: DataPoint?
    
    var body: some View {
        VStack {
            LineChart(data: data)
                .onPointTap { point in
                    selectedPoint = point
                }
                .frame(height: 300)
                .padding()
            
            if let selectedPoint = selectedPoint {
                Text("Selected: \(selectedPoint.x) - \(selectedPoint.y)")
                    .font(.caption)
            }
        }
    }
}
```

### Zoom and Pan

```swift
let chart = LineChart(data: data)
    .enableZoom(true)
    .enablePan(true)
    .zoomLevel(1.5)
    .frame(height: 300)
    .padding()
```

## Performance Optimization

### Large Dataset Handling

```swift
let optimizedChart = LineChart(data: largeDataset)
    .optimization(.largeDataset)
    .caching(.enabled)
    .lazyLoading(.enabled)
    .maxDataPoints(10000)
```

### Real-time Updates

```swift
class RealTimeLineChartViewModel: ObservableObject {
    @Published var chartData: [DataPoint] = []
    
    func updateData() {
        // Fetch new data
        let newData = fetchNewData()
        
        // Update with animation
        withAnimation(.easeInOut(duration: 0.5)) {
            chartData = newData
        }
    }
}

struct RealTimeLineChartView: View {
    @StateObject private var viewModel = RealTimeLineChartViewModel()
    
    var body: some View {
        LineChart(data: viewModel.chartData)
            .animation(.easeInOut(duration: 0.5))
    }
}
```

## Customization Options

### Color Schemes

```swift
let colorScheme = ChartColorScheme(
    primary: .blue,
    secondary: .green,
    accent: .orange,
    background: .white,
    text: .black,
    grid: .gray.opacity(0.3)
)

let chart = LineChart(data: data)
    .colorScheme(colorScheme)
```

### Typography

```swift
let typography = ChartTypography(
    titleFont: .systemFont(ofSize: 18, weight: .bold),
    axisFont: .systemFont(ofSize: 12, weight: .medium),
    labelFont: .systemFont(ofSize: 10, weight: .regular),
    legendFont: .systemFont(ofSize: 11, weight: .medium)
)

let chart = LineChart(data: data)
    .typography(typography)
```

### Animations

```swift
let chart = LineChart(data: data)
    .animation(.easeInOut(duration: 1.0))
    .transition(.scale.combined(with: .opacity))
```

## Accessibility

### VoiceOver Support

```swift
let chart = LineChart(data: data)
    .accessibilityLabel("Line chart showing sales trend")
    .accessibilityHint("Double tap to select data points")
    .accessibilityValue("Current trend: increasing")
```

### Dynamic Type

```swift
let chart = LineChart(data: data)
    .dynamicTypeSize(.large)
```

## Error Handling

```swift
enum LineChartError: Error {
    case invalidData
    case renderingFailed
    case configurationError
}

extension LineChart {
    func validateData() throws {
        guard !data.isEmpty else {
            throw LineChartError.invalidData
        }
        
        guard data.count >= 2 else {
            throw LineChartError.invalidData
        }
    }
}
```

## Best Practices

1. **Data Validation**: Always validate your data before rendering
2. **Performance**: Use optimization features for large datasets
3. **Accessibility**: Provide proper accessibility labels and hints
4. **Responsive Design**: Ensure charts work on all device sizes
5. **Error Handling**: Implement proper error handling for edge cases
6. **Animation**: Use smooth animations for better user experience
7. **Interactivity**: Add touch interactions for better engagement

## Advanced Features

### Trend Analysis

```swift
extension LineChart {
    func calculateTrend() -> TrendDirection {
        // Calculate trend based on data points
        let firstValue = data.first?.y ?? 0
        let lastValue = data.last?.y ?? 0
        
        if lastValue > firstValue {
            return .increasing
        } else if lastValue < firstValue {
            return .decreasing
        } else {
            return .stable
        }
    }
}

enum TrendDirection {
    case increasing
    case decreasing
    case stable
}
```

### Data Smoothing

```swift
extension LineChart {
    func smoothData() -> [DataPoint] {
        // Apply smoothing algorithm to data points
        return data.enumerated().map { index, point in
            // Smoothing logic here
            return point
        }
    }
}
```

This comprehensive Line Chart API provides everything you need to create beautiful, interactive line charts for your iOS applications.
