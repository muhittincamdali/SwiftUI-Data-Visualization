# Scatter Plot API

<!-- TOC START -->
## Table of Contents
- [Scatter Plot API](#scatter-plot-api)
- [Overview](#overview)
- [Core Components](#core-components)
  - [ScatterPlot](#scatterplot)
  - [ScatterPlotStyle](#scatterplotstyle)
- [Usage Examples](#usage-examples)
  - [Basic Scatter Plot](#basic-scatter-plot)
  - [Scatter Plot with Trend Line](#scatter-plot-with-trend-line)
  - [Customized Scatter Plot](#customized-scatter-plot)
- [Interactive Features](#interactive-features)
  - [Touch Interactions](#touch-interactions)
  - [Zoom and Pan](#zoom-and-pan)
  - [Selection Mode](#selection-mode)
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
  - [Correlation Analysis](#correlation-analysis)
  - [Trend Line Calculation](#trend-line-calculation)
  - [Clustering Analysis](#clustering-analysis)
<!-- TOC END -->


## Overview

The Scatter Plot API provides comprehensive functionality for creating point-based charts for correlation analysis, clustering, and data distribution visualization. This API is optimized for performance and supports large datasets with interactive features.

## Core Components

### ScatterPlot

```swift
public struct ScatterPlot: Chart {
    public let data: [DataPoint]
    public let style: ScatterPlotStyle
    public let configuration: ChartConfiguration
    
    public init(
        data: [DataPoint],
        style: ScatterPlotStyle = .default,
        configuration: ChartConfiguration = .default
    ) {
        self.data = data
        self.style = style
        self.configuration = configuration
    }
}
```

### ScatterPlotStyle

```swift
public struct ScatterPlotStyle {
    public var pointColor: Color
    public var pointSize: CGFloat
    public var showTrendLine: Bool
    public var trendLineColor: Color
    public var trendLineWidth: CGFloat
    public var showGridLines: Bool
    public var gridLineColor: Color
    public var gridLineWidth: CGFloat
    public var showLabels: Bool
    public var labelColor: Color
    public var labelFont: Font
    
    public static let `default` = ScatterPlotStyle(
        pointColor: .blue,
        pointSize: 6.0,
        showTrendLine: false,
        trendLineColor: .red,
        trendLineWidth: 2.0,
        showGridLines: true,
        gridLineColor: .gray.opacity(0.3),
        gridLineWidth: 1.0,
        showLabels: false,
        labelColor: .black,
        labelFont: .systemFont(ofSize: 10)
    )
}
```

## Usage Examples

### Basic Scatter Plot

```swift
let data = [
    DataPoint(x: 1.0, y: 2.0),
    DataPoint(x: 2.0, y: 4.0),
    DataPoint(x: 3.0, y: 1.5),
    DataPoint(x: 4.0, y: 5.0),
    DataPoint(x: 5.0, y: 3.0)
]

struct BasicScatterPlotView: View {
    var body: some View {
        VStack {
            Text("Correlation Analysis")
                .font(.title)
            
            ScatterPlot(data: data)
                .frame(height: 300)
                .padding()
        }
    }
}
```

### Scatter Plot with Trend Line

```swift
let styleWithTrend = ScatterPlotStyle(
    pointColor: .purple,
    pointSize: 8.0,
    showTrendLine: true,
    trendLineColor: .red,
    trendLineWidth: 2.0,
    showGridLines: true,
    gridLineColor: .gray.opacity(0.3),
    gridLineWidth: 1.0
)

let chart = ScatterPlot(data: data, style: styleWithTrend)
    .frame(height: 300)
    .padding()
```

### Customized Scatter Plot

```swift
let customStyle = ScatterPlotStyle(
    pointColor: .orange,
    pointSize: 10.0,
    showTrendLine: true,
    trendLineColor: .blue,
    trendLineWidth: 3.0,
    showGridLines: true,
    gridLineColor: .gray.opacity(0.2),
    gridLineWidth: 0.5,
    showLabels: true,
    labelColor: .black,
    labelFont: .systemFont(ofSize: 12, weight: .medium)
)

let chart = ScatterPlot(data: data, style: customStyle)
    .frame(height: 300)
    .padding()
```

## Interactive Features

### Touch Interactions

```swift
struct InteractiveScatterPlotView: View {
    @State private var selectedPoint: DataPoint?
    
    var body: some View {
        VStack {
            ScatterPlot(data: data)
                .onPointTap { point in
                    selectedPoint = point
                }
                .frame(height: 300)
                .padding()
            
            if let selectedPoint = selectedPoint {
                Text("Selected: (\(selectedPoint.x), \(selectedPoint.y))")
                    .font(.caption)
            }
        }
    }
}
```

### Zoom and Pan

```swift
let chart = ScatterPlot(data: data)
    .enableZoom(true)
    .enablePan(true)
    .zoomLevel(1.5)
    .frame(height: 300)
    .padding()
```

### Selection Mode

```swift
struct SelectionScatterPlotView: View {
    @State private var selectedPoints: Set<Int> = []
    
    var body: some View {
        VStack {
            ScatterPlot(data: data)
                .onPointSelect { index in
                    if selectedPoints.contains(index) {
                        selectedPoints.remove(index)
                    } else {
                        selectedPoints.insert(index)
                    }
                }
                .frame(height: 300)
                .padding()
            
            Text("Selected: \(selectedPoints.count) points")
                .font(.caption)
        }
    }
}
```

## Performance Optimization

### Large Dataset Handling

```swift
let optimizedChart = ScatterPlot(data: largeDataset)
    .optimization(.largeDataset)
    .caching(.enabled)
    .lazyLoading(.enabled)
    .maxDataPoints(10000)
```

### Real-time Updates

```swift
class RealTimeScatterPlotViewModel: ObservableObject {
    @Published var chartData: [DataPoint] = []
    
    func updateData() {
        let newData = fetchNewData()
        
        withAnimation(.easeInOut(duration: 0.5)) {
            chartData = newData
        }
    }
}

struct RealTimeScatterPlotView: View {
    @StateObject private var viewModel = RealTimeScatterPlotViewModel()
    
    var body: some View {
        ScatterPlot(data: viewModel.chartData)
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

let chart = ScatterPlot(data: data)
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

let chart = ScatterPlot(data: data)
    .typography(typography)
```

### Animations

```swift
let chart = ScatterPlot(data: data)
    .animation(.easeInOut(duration: 1.0))
    .transition(.scale.combined(with: .opacity))
```

## Accessibility

### VoiceOver Support

```swift
let chart = ScatterPlot(data: data)
    .accessibilityLabel("Scatter plot showing correlation data")
    .accessibilityHint("Double tap to select data points")
    .accessibilityValue("Shows relationship between variables")
```

### Dynamic Type

```swift
let chart = ScatterPlot(data: data)
    .dynamicTypeSize(.large)
```

## Error Handling

```swift
enum ScatterPlotError: Error {
    case invalidData
    case renderingFailed
    case configurationError
}

extension ScatterPlot {
    func validateData() throws {
        guard !data.isEmpty else {
            throw ScatterPlotError.invalidData
        }
        
        guard data.count >= 2 else {
            throw ScatterPlotError.invalidData
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
9. **Trend Lines**: Use trend lines to show correlation patterns
10. **Point Sizing**: Adjust point size based on data density

## Advanced Features

### Correlation Analysis

```swift
extension ScatterPlot {
    func calculateCorrelation() -> Double {
        let n = data.count
        let sumX = data.reduce(0) { $0 + $1.x }
        let sumY = data.reduce(0) { $0 + $1.y }
        let sumXY = data.reduce(0) { $0 + ($1.x * $1.y) }
        let sumX2 = data.reduce(0) { $0 + ($1.x * $1.x) }
        let sumY2 = data.reduce(0) { $0 + ($1.y * $1.y) }
        
        let numerator = (n * sumXY) - (sumX * sumY)
        let denominator = sqrt(((n * sumX2) - (sumX * sumX)) * ((n * sumY2) - (sumY * sumY)))
        
        return denominator != 0 ? numerator / denominator : 0
    }
}
```

### Trend Line Calculation

```swift
extension ScatterPlot {
    func calculateTrendLine() -> (slope: Double, intercept: Double) {
        let n = data.count
        let sumX = data.reduce(0) { $0 + $1.x }
        let sumY = data.reduce(0) { $0 + $1.y }
        let sumXY = data.reduce(0) { $0 + ($1.x * $1.y) }
        let sumX2 = data.reduce(0) { $0 + ($1.x * $1.x) }
        
        let slope = ((n * sumXY) - (sumX * sumY)) / ((n * sumX2) - (sumX * sumX))
        let intercept = (sumY - (slope * sumX)) / Double(n)
        
        return (slope: slope, intercept: intercept)
    }
}
```

### Clustering Analysis

```swift
extension ScatterPlot {
    func performClustering(k: Int) -> [[DataPoint]] {
        // K-means clustering implementation
        var clusters: [[DataPoint]] = Array(repeating: [], count: k)
        
        // Initialize centroids
        var centroids = data.prefix(k).map { DataPoint(x: $0.x, y: $0.y) }
        
        // Perform clustering iterations
        for _ in 0..<10 {
            // Assign points to nearest centroid
            clusters = Array(repeating: [], count: k)
            
            for point in data {
                let distances = centroids.map { centroid in
                    sqrt(pow(point.x - centroid.x, 2) + pow(point.y - centroid.y, 2))
                }
                let nearestCentroid = distances.enumerated().min(by: { $0.element < $1.element })?.offset ?? 0
                clusters[nearestCentroid].append(point)
            }
            
            // Update centroids
            for i in 0..<k {
                if !clusters[i].isEmpty {
                    let avgX = clusters[i].reduce(0) { $0 + $1.x } / Double(clusters[i].count)
                    let avgY = clusters[i].reduce(0) { $0 + $1.y } / Double(clusters[i].count)
                    centroids[i] = DataPoint(x: avgX, y: avgY)
                }
            }
        }
        
        return clusters
    }
}
```

This comprehensive Scatter Plot API provides everything you need to create beautiful, interactive scatter plots for correlation analysis and data visualization.
