# Pie Chart API

<!-- TOC START -->
## Table of Contents
- [Pie Chart API](#pie-chart-api)
- [Overview](#overview)
- [Core Components](#core-components)
  - [PieChart](#piechart)
  - [PieChartStyle](#piechartstyle)
- [Usage Examples](#usage-examples)
  - [Basic Pie Chart](#basic-pie-chart)
  - [Donut Chart](#donut-chart)
  - [Customized Pie Chart](#customized-pie-chart)
- [Interactive Features](#interactive-features)
  - [Touch Interactions](#touch-interactions)
  - [Animated Pie Chart](#animated-pie-chart)
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
  - [Exploded Pie Chart](#exploded-pie-chart)
  - [Percentage Calculation](#percentage-calculation)
  - [Legend Generation](#legend-generation)
  - [Segment Highlighting](#segment-highlighting)
<!-- TOC END -->


## Overview

The Pie Chart API provides comprehensive functionality for creating circular charts with custom segments, animations, and interactive features. This API is optimized for showing proportions and percentages in an intuitive visual format.

## Core Components

### PieChart

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

### PieChartStyle

```swift
public struct PieChartStyle {
    public var colors: [Color]
    public var showLabels: Bool
    public var labelColor: Color
    public var labelFont: Font
    public var showPercentages: Bool
    public var percentageColor: Color
    public var percentageFont: Font
    public var showLegend: Bool
    public var legendPosition: LegendPosition
    public var innerRadius: CGFloat
    public var strokeWidth: CGFloat
    public var strokeColor: Color
    
    public static let `default` = PieChartStyle(
        colors: [.red, .blue, .green, .orange, .purple],
        showLabels: true,
        labelColor: .white,
        labelFont: .systemFont(ofSize: 12, weight: .medium),
        showPercentages: true,
        percentageColor: .white,
        percentageFont: .systemFont(ofSize: 10, weight: .bold),
        showLegend: true,
        legendPosition: .bottom,
        innerRadius: 0.0,
        strokeWidth: 2.0,
        strokeColor: .white
    )
}

public enum LegendPosition {
    case top
    case bottom
    case left
    case right
}
```

## Usage Examples

### Basic Pie Chart

```swift
let data = [
    DataPoint(x: "Red", y: 30),
    DataPoint(x: "Blue", y: 25),
    DataPoint(x: "Green", y: 20),
    DataPoint(x: "Yellow", y: 15),
    DataPoint(x: "Purple", y: 10)
]

struct BasicPieChartView: View {
    var body: some View {
        VStack {
            Text("Color Distribution")
                .font(.title)
            
            PieChart(data: data)
                .frame(height: 300)
                .padding()
        }
    }
}
```

### Donut Chart

```swift
let donutStyle = PieChartStyle(
    colors: [.red, .blue, .green, .orange],
    showLabels: true,
    labelColor: .white,
    showPercentages: true,
    percentageColor: .white,
    innerRadius: 50.0,
    strokeWidth: 2.0,
    strokeColor: .white
)

let chart = PieChart(data: data, style: donutStyle)
    .frame(height: 300)
    .padding()
```

### Customized Pie Chart

```swift
let customStyle = PieChartStyle(
    colors: [.purple, .pink, .indigo, .teal],
    showLabels: true,
    labelColor: .white,
    labelFont: .systemFont(ofSize: 14, weight: .bold),
    showPercentages: true,
    percentageColor: .white,
    percentageFont: .systemFont(ofSize: 12, weight: .bold),
    showLegend: true,
    legendPosition: .right,
    innerRadius: 0.0,
    strokeWidth: 3.0,
    strokeColor: .white
)

let chart = PieChart(data: data, style: customStyle)
    .frame(height: 300)
    .padding()
```

## Interactive Features

### Touch Interactions

```swift
struct InteractivePieChartView: View {
    @State private var selectedSegment: Int?
    
    var body: some View {
        VStack {
            PieChart(data: data)
                .onSegmentTap { index in
                    selectedSegment = index
                }
                .frame(height: 300)
                .padding()
            
            if let selectedSegment = selectedSegment {
                Text("Selected: \(data[selectedSegment].x) - \(data[selectedSegment].y)%")
                    .font(.caption)
            }
        }
    }
}
```

### Animated Pie Chart

```swift
struct AnimatedPieChartView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            PieChart(data: data)
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
let optimizedChart = PieChart(data: largeDataset)
    .optimization(.largeDataset)
    .caching(.enabled)
    .maxSegments(20)
```

### Real-time Updates

```swift
class RealTimePieChartViewModel: ObservableObject {
    @Published var chartData: [DataPoint] = []
    
    func updateData() {
        let newData = fetchNewData()
        
        withAnimation(.easeInOut(duration: 0.5)) {
            chartData = newData
        }
    }
}

struct RealTimePieChartView: View {
    @StateObject private var viewModel = RealTimePieChartViewModel()
    
    var body: some View {
        PieChart(data: viewModel.chartData)
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

let chart = PieChart(data: data)
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

let chart = PieChart(data: data)
    .typography(typography)
```

### Animations

```swift
let chart = PieChart(data: data)
    .animation(.easeInOut(duration: 1.0))
    .transition(.scale.combined(with: .opacity))
```

## Accessibility

### VoiceOver Support

```swift
let chart = PieChart(data: data)
    .accessibilityLabel("Pie chart showing color distribution")
    .accessibilityHint("Double tap to select segments")
    .accessibilityValue("Red: 30%, Blue: 25%, Green: 20%")
```

### Dynamic Type

```swift
let chart = PieChart(data: data)
    .dynamicTypeSize(.large)
```

## Error Handling

```swift
enum PieChartError: Error {
    case invalidData
    case renderingFailed
    case configurationError
}

extension PieChart {
    func validateData() throws {
        guard !data.isEmpty else {
            throw PieChartError.invalidData
        }
        
        guard data.allSatisfy({ $0.y >= 0 }) else {
            throw PieChartError.invalidData
        }
        
        let total = data.reduce(0) { $0 + $1.y }
        guard total > 0 else {
            throw PieChartError.invalidData
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
9. **Segment Limits**: Limit the number of segments for clarity
10. **Percentage Display**: Show percentages for better understanding

## Advanced Features

### Exploded Pie Chart

```swift
extension PieChart {
    func createExplodedSegments() -> [DataPoint] {
        return data.enumerated().map { index, point in
            // Add explosion effect to selected segments
            let isExploded = index == selectedSegmentIndex
            return DataPoint(
                x: point.x,
                y: point.y,
                label: point.label,
                color: point.color,
                isExploded: isExploded
            )
        }
    }
}
```

### Percentage Calculation

```swift
extension PieChart {
    func calculatePercentages() -> [Double] {
        let total = data.reduce(0) { $0 + $1.y }
        return data.map { ($0.y / total) * 100 }
    }
}
```

### Legend Generation

```swift
extension PieChart {
    func generateLegend() -> [LegendItem] {
        let percentages = calculatePercentages()
        return data.enumerated().map { index, point in
            LegendItem(
                label: point.x,
                color: style.colors[index % style.colors.count],
                percentage: percentages[index]
            )
        }
    }
}

struct LegendItem {
    let label: String
    let color: Color
    let percentage: Double
}
```

### Segment Highlighting

```swift
extension PieChart {
    func highlightSegment(at index: Int) {
        // Highlight the selected segment
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedSegmentIndex = index
        }
    }
}
```

This comprehensive Pie Chart API provides everything you need to create beautiful, interactive pie charts for your iOS applications.
