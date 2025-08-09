# Bar Chart API

<!-- TOC START -->
## Table of Contents
- [Bar Chart API](#bar-chart-api)
- [Overview](#overview)
- [Core Components](#core-components)
  - [BarChart](#barchart)
  - [BarChartStyle](#barchartstyle)
- [Usage Examples](#usage-examples)
  - [Basic Bar Chart](#basic-bar-chart)
  - [Horizontal Bar Chart](#horizontal-bar-chart)
  - [Customized Bar Chart](#customized-bar-chart)
- [Interactive Features](#interactive-features)
  - [Touch Interactions](#touch-interactions)
  - [Animated Bar Chart](#animated-bar-chart)
- [Performance Optimization](#performance-optimization)
  - [Large Dataset Handling](#large-dataset-handling)
  - [Real-time Updates](#real-time-updates)
- [Customization Options](#customization-options)
  - [Color Schemes](#color-schemes)
  - [Typography](#typography)
  - [Animations](#animations)
- [Accessibility](#accessibility)
  - [VoiceOver Support](#voiceover-support)
  - [Dynamic Type](#dynamic-type)
- [Error Handling](#error-handling)
- [Best Practices](#best-practices)
- [Advanced Features](#advanced-features)
  - [Grouped Bar Charts](#grouped-bar-charts)
  - [Stacked Bar Charts](#stacked-bar-charts)
  - [Value Formatting](#value-formatting)
<!-- TOC END -->


## Overview

The Bar Chart API provides comprehensive functionality for creating vertical and horizontal bar charts with grouping, stacking, and interactive features. This API is optimized for performance and supports large datasets.

## Core Components

### BarChart

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

### BarChartStyle

```swift
public struct BarChartStyle {
    public var barColor: Color
    public var barWidth: CGFloat
    public var showValues: Bool
    public var valueColor: Color
    public var valueFont: Font
    public var showLabels: Bool
    public var labelColor: Color
    public var labelFont: Font
    public var orientation: BarOrientation
    public var spacing: CGFloat
    
    public static let `default` = BarChartStyle(
        barColor: .blue,
        barWidth: 0.8,
        showValues: true,
        valueColor: .black,
        valueFont: .systemFont(ofSize: 12),
        showLabels: true,
        labelColor: .black,
        labelFont: .systemFont(ofSize: 10),
        orientation: .vertical,
        spacing: 4.0
    )
}

public enum BarOrientation {
    case vertical
    case horizontal
}
```

## Usage Examples

### Basic Bar Chart

```swift
let data = [
    DataPoint(x: "Jan", y: 100),
    DataPoint(x: "Feb", y: 150),
    DataPoint(x: "Mar", y: 120),
    DataPoint(x: "Apr", y: 200),
    DataPoint(x: "May", y: 180)
]

struct BasicBarChartView: View {
    var body: some View {
        VStack {
            Text("Monthly Revenue")
                .font(.title)
            
            BarChart(data: data)
                .frame(height: 300)
                .padding()
        }
    }
}
```

### Horizontal Bar Chart

```swift
let horizontalStyle = BarChartStyle(
    barColor: .green,
    barWidth: 0.8,
    showValues: true,
    valueColor: .black,
    orientation: .horizontal
)

let chart = BarChart(data: data, style: horizontalStyle)
    .frame(height: 300)
    .padding()
```

### Customized Bar Chart

```swift
let customStyle = BarChartStyle(
    barColor: .orange,
    barWidth: 0.6,
    showValues: true,
    valueColor: .white,
    valueFont: .systemFont(ofSize: 14, weight: .bold),
    showLabels: true,
    labelColor: .black,
    labelFont: .systemFont(ofSize: 12, weight: .medium),
    orientation: .vertical,
    spacing: 8.0
)

let chart = BarChart(data: data, style: customStyle)
    .frame(height: 300)
    .padding()
```

## Interactive Features

### Touch Interactions

```swift
struct InteractiveBarChartView: View {
    @State private var selectedBar: Int?
    
    var body: some View {
        VStack {
            BarChart(data: data)
                .onBarTap { index in
                    selectedBar = index
                }
                .frame(height: 300)
                .padding()
            
            if let selectedBar = selectedBar {
                Text("Selected: \(data[selectedBar].x) - \(data[selectedBar].y)")
                    .font(.caption)
            }
        }
    }
}
```

### Animated Bar Chart

```swift
struct AnimatedBarChartView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            BarChart(data: data)
                .animation(.easeInOut(duration: 1.0))
                .frame(height: 300)
                .padding()
            
            Button("Animate") {
                withAnimation {
                    isAnimating.toggle()
                }
            }
        }
    }
}
```

## Performance Optimization

### Large Dataset Handling

```swift
let optimizedChart = BarChart(data: largeDataset)
    .optimization(.largeDataset)
    .caching(.enabled)
    .lazyLoading(.enabled)
    .maxDataPoints(1000)
```

### Real-time Updates

```swift
class RealTimeBarChartViewModel: ObservableObject {
    @Published var chartData: [DataPoint] = []
    
    func updateData() {
        let newData = fetchNewData()
        
        withAnimation(.easeInOut(duration: 0.5)) {
            chartData = newData
        }
    }
}

struct RealTimeBarChartView: View {
    @StateObject private var viewModel = RealTimeBarChartViewModel()
    
    var body: some View {
        BarChart(data: viewModel.chartData)
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

let chart = BarChart(data: data)
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

let chart = BarChart(data: data)
    .typography(typography)
```

### Animations

```swift
let chart = BarChart(data: data)
    .animation(.easeInOut(duration: 1.0))
    .transition(.scale.combined(with: .opacity))
```

## Accessibility

### VoiceOver Support

```swift
let chart = BarChart(data: data)
    .accessibilityLabel("Bar chart showing monthly revenue")
    .accessibilityHint("Double tap to select bars")
    .accessibilityValue("Total revenue: $750")
```

### Dynamic Type

```swift
let chart = BarChart(data: data)
    .dynamicTypeSize(.large)
```

## Error Handling

```swift
enum BarChartError: Error {
    case invalidData
    case renderingFailed
    case configurationError
}

extension BarChart {
    func validateData() throws {
        guard !data.isEmpty else {
            throw BarChartError.invalidData
        }
        
        guard data.allSatisfy({ $0.y >= 0 }) else {
            throw BarChartError.invalidData
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
8. **Color Contrast**: Ensure good color contrast for accessibility

## Advanced Features

### Grouped Bar Charts

```swift
struct GroupedBarChartView: View {
    let group1 = [
        DataPoint(x: "Q1", y: 100, label: "2023"),
        DataPoint(x: "Q2", y: 150, label: "2023"),
        DataPoint(x: "Q3", y: 120, label: "2023"),
        DataPoint(x: "Q4", y: 200, label: "2023")
    ]
    
    let group2 = [
        DataPoint(x: "Q1", y: 80, label: "2024"),
        DataPoint(x: "Q2", y: 130, label: "2024"),
        DataPoint(x: "Q3", y: 110, label: "2024"),
        DataPoint(x: "Q4", y: 180, label: "2024")
    ]
    
    var body: some View {
        BarChart(data: group1 + group2)
            .frame(height: 300)
            .padding()
    }
}
```

### Stacked Bar Charts

```swift
extension BarChart {
    func createStackedBars() -> [DataPoint] {
        // Group data by x-axis value
        let groupedData = Dictionary(grouping: data) { $0.x }
        
        return groupedData.map { key, values in
            let totalValue = values.reduce(0) { $0 + $1.y }
            return DataPoint(x: key, y: totalValue)
        }
    }
}
```

### Value Formatting

```swift
extension BarChart {
    func formatValue(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}
```

This comprehensive Bar Chart API provides everything you need to create beautiful, interactive bar charts for your iOS applications.
