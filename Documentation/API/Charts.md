# Charts API Documentation

This document provides comprehensive API documentation for all chart components in the SwiftUI Data Visualization framework.

## Table of Contents

- [LineChart](#linechart)
- [BarChart](#barchart)
- [PieChart](#piechart)
- [ScatterChart](#scatterchart)
- [AreaChart](#areachart)
- [CandlestickChart](#candlestickchart)
- [HeatmapChart](#heatmapchart)
- [RadarChart](#radarchart)
- [BubbleChart](#bubblechart)
- [DonutChart](#donutchart)
- [StackedBarChart](#stackedbarchart)
- [MultiLineChart](#multilinechart)

## LineChart

A line chart that displays data points connected by lines. Ideal for showing trends over time or continuous data.

### Initialization

```swift
// Basic initialization
LineChart(data: [ChartDataPoint])

// With configuration
LineChart(data: [ChartDataPoint], configuration: ChartConfiguration)

// With style
LineChart(data: [ChartDataPoint], style: ChartStyle)
```

### Properties

- `data: [ChartDataPoint]` - Array of data points to display
- `configuration: ChartConfiguration` - Chart configuration options

### Example Usage

```swift
let data = [
    ChartDataPoint(x: 1, y: 10, label: "Jan"),
    ChartDataPoint(x: 2, y: 25, label: "Feb"),
    ChartDataPoint(x: 3, y: 15, label: "Mar"),
    ChartDataPoint(x: 4, y: 30, label: "Apr")
]

LineChart(data: data)
    .chartStyle(.line)
    .animation(.easeInOut(duration: 0.5))
    .interactive(true)
    .frame(height: 300)
```

### Features

- **Real-time Updates**: Supports live data streaming
- **Interactive Elements**: Zoom, pan, tooltip, selection
- **Animations**: Smooth 60fps animations
- **Accessibility**: Full VoiceOver support
- **Performance**: Optimized for large datasets

## BarChart

A bar chart that displays data using rectangular bars. Supports vertical and horizontal orientations.

### Initialization

```swift
// Basic initialization
BarChart(data: [ChartDataPoint])

// With configuration
BarChart(data: [ChartDataPoint], configuration: ChartConfiguration)
```

### Example Usage

```swift
let data = [
    ChartDataPoint(x: 1, y: 10, label: "Category A"),
    ChartDataPoint(x: 2, y: 25, label: "Category B"),
    ChartDataPoint(x: 3, y: 15, label: "Category C")
]

BarChart(data: data)
    .chartStyle(.bar)
    .interactive(true)
    .frame(height: 300)
```

### Features

- **Orientation**: Vertical and horizontal bars
- **Grouping**: Multiple data series support
- **Stacking**: Stacked bar charts
- **Animations**: Smooth bar animations
- **Interactive**: Tap to select bars

## PieChart

A circular chart that displays data as slices of a pie. Perfect for showing proportions and percentages.

### Initialization

```swift
// Basic initialization
PieChart(data: [ChartDataPoint])

// With configuration
PieChart(data: [ChartDataPoint], configuration: ChartConfiguration)
```

### Example Usage

```swift
let data = [
    ChartDataPoint(x: 1, y: 30, label: "Red", color: .red),
    ChartDataPoint(x: 2, y: 25, label: "Blue", color: .blue),
    ChartDataPoint(x: 3, y: 20, label: "Green", color: .green),
    ChartDataPoint(x: 4, y: 15, label: "Yellow", color: .yellow),
    ChartDataPoint(x: 5, y: 10, label: "Purple", color: .purple)
]

PieChart(data: data)
    .chartStyle(.pie)
    .showLabels(true)
    .animation(.easeInOut(duration: 1.0))
    .frame(width: 300, height: 300)
```

### Features

- **Exploded Slices**: Highlight specific slices
- **Custom Colors**: Individual slice colors
- **Labels**: Show slice labels and values
- **Animations**: Smooth slice animations
- **Interactive**: Tap to select slices

## ScatterChart

A scatter plot that displays data points as individual markers. Ideal for showing correlations and distributions.

### Initialization

```swift
// Basic initialization
ScatterChart(data: [ChartDataPoint])

// With configuration
ScatterChart(data: [ChartDataPoint], configuration: ChartConfiguration)
```

### Example Usage

```swift
let data = [
    ChartDataPoint(x: 1, y: 10, size: 5),
    ChartDataPoint(x: 2, y: 25, size: 8),
    ChartDataPoint(x: 3, y: 15, size: 6),
    ChartDataPoint(x: 4, y: 30, size: 10)
]

ScatterChart(data: data)
    .chartStyle(.scatter)
    .pointSize(8)
    .interactive(true)
    .frame(height: 300)
```

### Features

- **Point Sizing**: Variable point sizes
- **Color Coding**: Point color variations
- **Clustering**: Data point clustering
- **Trend Lines**: Optional trend line overlay
- **Interactive**: Tap to select points

## AreaChart

An area chart that displays data as filled areas. Great for showing cumulative data and trends.

### Initialization

```swift
// Basic initialization
AreaChart(data: [ChartDataPoint])

// With configuration
AreaChart(data: [ChartDataPoint], configuration: ChartConfiguration)
```

### Example Usage

```swift
let data = [
    ChartDataPoint(x: 1, y: 10),
    ChartDataPoint(x: 2, y: 25),
    ChartDataPoint(x: 3, y: 15),
    ChartDataPoint(x: 4, y: 30)
]

AreaChart(data: data)
    .chartStyle(.area)
    .gradient(.linear)
    .animation(.easeInOut(duration: 0.8))
    .frame(height: 300)
```

### Features

- **Gradients**: Linear and radial gradients
- **Stacking**: Stacked area charts
- **Transparency**: Configurable opacity
- **Animations**: Smooth area animations
- **Interactive**: Hover and selection

## CandlestickChart

A financial chart that displays open, high, low, and close prices. Essential for financial analysis.

### Initialization

```swift
// Basic initialization
CandlestickChart(data: [CandlestickDataPoint])

// With configuration
CandlestickChart(data: [CandlestickDataPoint], configuration: ChartConfiguration)
```

### Example Usage

```swift
let data = [
    CandlestickDataPoint(
        timestamp: Date(),
        open: 100.0,
        high: 110.0,
        low: 95.0,
        close: 105.0,
        volume: 1000000
    )
]

CandlestickChart(data: data)
    .chartStyle(.candlestick)
    .showVolume(true)
    .interactive(true)
    .frame(height: 400)
```

### Features

- **OHLC Data**: Open, High, Low, Close prices
- **Volume**: Optional volume display
- **Time Series**: Real-time financial data
- **Technical Indicators**: Moving averages, RSI, etc.
- **Interactive**: Zoom and pan support

## HeatmapChart

A heatmap that displays data as a matrix of colored cells. Perfect for showing data density and correlations.

### Initialization

```swift
// Basic initialization
HeatmapChart(data: [[Double]])

// With configuration
HeatmapChart(data: [[Double]], configuration: ChartConfiguration)
```

### Example Usage

```swift
let data = [
    [1.0, 2.0, 3.0],
    [4.0, 5.0, 6.0],
    [7.0, 8.0, 9.0]
]

HeatmapChart(data: data)
    .chartStyle(.heatmap)
    .colorScale(.viridis)
    .interactive(true)
    .frame(width: 300, height: 300)
```

### Features

- **Color Scales**: Multiple color schemes
- **Normalization**: Data normalization options
- **Labels**: Row and column labels
- **Tooltips**: Cell value tooltips
- **Interactive**: Click to inspect cells

## RadarChart

A radar chart that displays multi-dimensional data as a polygon. Great for comparing multiple variables.

### Initialization

```swift
// Basic initialization
RadarChart(data: [RadarDataPoint])

// With configuration
RadarChart(data: [RadarDataPoint], configuration: ChartConfiguration)
```

### Example Usage

```swift
let data = [
    RadarDataPoint(
        category: "Speed",
        value: 80.0,
        maxValue: 100.0
    ),
    RadarDataPoint(
        category: "Accuracy",
        value: 90.0,
        maxValue: 100.0
    )
]

RadarChart(data: data)
    .chartStyle(.radar)
    .showGrid(true)
    .interactive(true)
    .frame(width: 300, height: 300)
```

### Features

- **Multi-dimensional**: Multiple variables
- **Scaling**: Automatic value scaling
- **Grid**: Configurable grid lines
- **Labels**: Category labels
- **Interactive**: Tap to select points

## BubbleChart

A bubble chart that displays data points as circles with variable sizes. Ideal for showing three-dimensional data.

### Initialization

```swift
// Basic initialization
BubbleChart(data: [ChartDataPoint])

// With configuration
BubbleChart(data: [ChartDataPoint], configuration: ChartConfiguration)
```

### Example Usage

```swift
let data = [
    ChartDataPoint(x: 1, y: 10, size: 20),
    ChartDataPoint(x: 2, y: 25, size: 35),
    ChartDataPoint(x: 3, y: 15, size: 25)
]

BubbleChart(data: data)
    .chartStyle(.bubble)
    .interactive(true)
    .frame(height: 300)
```

### Features

- **Size Encoding**: Variable bubble sizes
- **Color Coding**: Bubble color variations
- **Clustering**: Bubble clustering
- **Animations**: Smooth bubble animations
- **Interactive**: Tap to select bubbles

## DonutChart

A donut chart that displays data as slices of a ring. Similar to pie charts but with a center hole.

### Initialization

```swift
// Basic initialization
DonutChart(data: [ChartDataPoint])

// With configuration
DonutChart(data: [ChartDataPoint], configuration: ChartConfiguration)
```

### Example Usage

```swift
let data = [
    ChartDataPoint(x: 1, y: 30, label: "Red", color: .red),
    ChartDataPoint(x: 2, y: 25, label: "Blue", color: .blue),
    ChartDataPoint(x: 3, y: 20, label: "Green", color: .green)
]

DonutChart(data: data)
    .chartStyle(.donut)
    .centerText("Total")
    .showLabels(true)
    .frame(width: 300, height: 300)
```

### Features

- **Center Text**: Customizable center content
- **Ring Width**: Configurable ring thickness
- **Exploded Slices**: Highlight specific slices
- **Animations**: Smooth slice animations
- **Interactive**: Tap to select slices

## StackedBarChart

A stacked bar chart that displays multiple data series as stacked bars. Great for showing composition.

### Initialization

```swift
// Basic initialization
StackedBarChart(data: [[ChartDataPoint]])

// With configuration
StackedBarChart(data: [[ChartDataPoint]], configuration: ChartConfiguration)
```

### Example Usage

```swift
let data = [
    [
        ChartDataPoint(x: 1, y: 10, label: "Series 1"),
        ChartDataPoint(x: 2, y: 15, label: "Series 1"),
        ChartDataPoint(x: 3, y: 20, label: "Series 1")
    ],
    [
        ChartDataPoint(x: 1, y: 5, label: "Series 2"),
        ChartDataPoint(x: 2, y: 10, label: "Series 2"),
        ChartDataPoint(x: 3, y: 15, label: "Series 2")
    ]
]

StackedBarChart(data: data)
    .chartStyle(.stackedBar)
    .interactive(true)
    .frame(height: 300)
```

### Features

- **Multiple Series**: Multiple data series
- **Stacking**: Automatic stacking
- **Colors**: Series-specific colors
- **Animations**: Smooth stacking animations
- **Interactive**: Tap to select bars

## MultiLineChart

A multi-line chart that displays multiple data series as separate lines. Perfect for comparing trends.

### Initialization

```swift
// Basic initialization
MultiLineChart(data: [[ChartDataPoint]])

// With configuration
MultiLineChart(data: [[ChartDataPoint]], configuration: ChartConfiguration)
```

### Example Usage

```swift
let data = [
    [
        ChartDataPoint(x: 1, y: 10, label: "Series 1"),
        ChartDataPoint(x: 2, y: 15, label: "Series 1"),
        ChartDataPoint(x: 3, y: 20, label: "Series 1")
    ],
    [
        ChartDataPoint(x: 1, y: 5, label: "Series 2"),
        ChartDataPoint(x: 2, y: 10, label: "Series 2"),
        ChartDataPoint(x: 3, y: 15, label: "Series 2")
    ]
]

MultiLineChart(data: data)
    .chartStyle(.multiLine)
    .legend(position: .bottom)
    .interactive(true)
    .frame(height: 300)
```

### Features

- **Multiple Lines**: Multiple data series
- **Legend**: Automatic legend generation
- **Colors**: Series-specific colors
- **Animations**: Smooth line animations
- **Interactive**: Tap to select lines

## Common Features

All chart types support the following common features:

### Styling

```swift
.chartStyle(.line)
.foregroundColor(.blue)
.backgroundColor(.white)
.borderColor(.gray)
.borderWidth(1)
.cornerRadius(8)
.shadow(radius: 4)
```

### Animations

```swift
.animation(.easeInOut(duration: 0.5))
.transition(.scale.combined(with: .opacity))
```

### Interaction

```swift
.interactive(true)
.zoomEnabled(true)
.panEnabled(true)
.tooltipEnabled(true)
.selectionEnabled(true)
```

### Accessibility

```swift
.accessibilityLabel("Chart Description")
.accessibilityHint("Interactive chart with data")
.accessibilityValue("Current value: 25")
```

### Performance

```swift
.drawingGroup() // Metal rendering
.lazyVGrid(columns: columns) // Lazy loading
```

## Best Practices

1. **Data Validation**: Always validate your data before passing to charts
2. **Performance**: Use lazy loading for large datasets
3. **Accessibility**: Provide meaningful accessibility labels
4. **Responsive Design**: Make charts responsive to different screen sizes
5. **Error Handling**: Handle empty or invalid data gracefully
6. **Testing**: Test charts with various data scenarios
7. **Documentation**: Document custom chart configurations
8. **Performance Monitoring**: Monitor chart performance in production 