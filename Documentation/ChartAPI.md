# Chart API

## Overview

The Chart API provides the core functionality for creating and managing data visualizations in SwiftUI. This comprehensive API offers a wide range of chart types, customization options, and performance optimizations.

## Core Components

### Chart Protocol

```swift
public protocol Chart {
    associatedtype DataType
    associatedtype StyleType
    
    var data: [DataType] { get }
    var style: StyleType { get }
    var configuration: ChartConfiguration { get }
    
    func render() -> AnyView
    func update(with newData: [DataType])
}
```

### ChartConfiguration

```swift
public struct ChartConfiguration {
    public var showGridLines: Bool
    public var showLegend: Bool
    public var showAxisLabels: Bool
    public var enableInteractions: Bool
    public var enableAnimations: Bool
    public var responsiveLayout: Bool
    
    public init(
        showGridLines: Bool = true,
        showLegend: Bool = true,
        showAxisLabels: Bool = true,
        enableInteractions: Bool = true,
        enableAnimations: Bool = true,
        responsiveLayout: Bool = true
    ) {
        self.showGridLines = showGridLines
        self.showLegend = showLegend
        self.showAxisLabels = showAxisLabels
        self.enableInteractions = enableInteractions
        self.enableAnimations = enableAnimations
        self.responsiveLayout = responsiveLayout
    }
}
```

## Chart Types

### Line Chart

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

### Bar Chart

```swift
public struct BarChart: Chart {
    public let data: [DataPoint]
    public let style: BarChartStyle
    public let configuration: ChartConfiguration
    
    public init(
        data: [DataPoint],
        style: BarChartStyle = .default,
        configuration: ChartConfiguration = .default
    ) {
        self.data = data
        self.style = style
        self.configuration = configuration
    }
}
```

### Pie Chart

```swift
public struct PieChart: Chart {
    public let data: [DataPoint]
    public let style: PieChartStyle
    public let configuration: ChartConfiguration
    
    public init(
        data: [DataPoint],
        style: PieChartStyle = .default,
        configuration: ChartConfiguration = .default
    ) {
        self.data = data
        self.style = style
        self.configuration = configuration
    }
}
```

## Data Models

### DataPoint

```swift
public struct DataPoint: Identifiable, Codable {
    public let id = UUID()
    public let x: Any
    public let y: Double
    public let label: String?
    public let color: Color?
    
    public init(x: Any, y: Double, label: String? = nil, color: Color? = nil) {
        self.x = x
        self.y = y
        self.label = label
        self.color = color
    }
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

let chart = LineChart(data: data)
    .frame(height: 300)
    .padding()
```

### Customized Bar Chart

```swift
let style = BarChartStyle(
    barColor: .blue,
    barWidth: 0.8,
    showValues: true,
    valueColor: .black
)

let chart = BarChart(data: data, style: style)
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
```

### Real-time Updates

```swift
class ChartViewModel: ObservableObject {
    @Published var chartData: [DataPoint] = []
    
    func updateData() {
        chartData = fetchNewData()
    }
}
```

## Accessibility

### VoiceOver Support

```swift
let chart = LineChart(data: data)
    .accessibilityLabel("Sales trend chart")
    .accessibilityHint("Shows monthly sales data")
```

## Error Handling

```swift
enum ChartError: Error {
    case invalidData
    case renderingFailed
    case configurationError
}

extension Chart {
    func validateData() throws {
        guard !data.isEmpty else {
            throw ChartError.invalidData
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
