# Getting Started Guide

<!-- TOC START -->
## Table of Contents
- [Getting Started Guide](#getting-started-guide)
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
  - [Manual Installation](#manual-installation)
- [Clone the repository](#clone-the-repository)
- [Navigate to project directory](#navigate-to-project-directory)
- [Install dependencies](#install-dependencies)
- [Open in Xcode](#open-in-xcode)
- [Quick Start](#quick-start)
  - [1. Import the Framework](#1-import-the-framework)
  - [2. Create Sample Data](#2-create-sample-data)
  - [3. Create Your First Chart](#3-create-your-first-chart)
- [Chart Types](#chart-types)
  - [Line Charts](#line-charts)
  - [Bar Charts](#bar-charts)
  - [Pie Charts](#pie-charts)
- [Customization](#customization)
  - [Color Schemes](#color-schemes)
  - [Typography](#typography)
  - [Animations](#animations)
- [Performance Optimization](#performance-optimization)
  - [Large Datasets](#large-datasets)
  - [Real-time Updates](#real-time-updates)
- [Accessibility](#accessibility)
  - [VoiceOver Support](#voiceover-support)
  - [Dynamic Type](#dynamic-type)
- [Best Practices](#best-practices)
  - [1. Data Preparation](#1-data-preparation)
  - [2. Responsive Design](#2-responsive-design)
  - [3. Error Handling](#3-error-handling)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
  - [Debug Tips](#debug-tips)
- [Next Steps](#next-steps)
- [Support](#support)
<!-- TOC END -->


## Introduction

Welcome to SwiftUI Data Visualization Framework! This comprehensive guide will help you get started with creating beautiful, interactive charts and data visualizations for your iOS applications.

## Prerequisites

Before you begin, ensure you have:

- **iOS 15.0+** with iOS 15.0+ SDK
- **Swift 5.9+** programming language
- **Xcode 15.0+** development environment
- **Git** version control system
- **Swift Package Manager** for dependency management

## Installation

### Swift Package Manager

Add the framework to your project:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git", from: "1.0.0")
]
```

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git

# Navigate to project directory
cd SwiftUI-Data-Visualization

# Install dependencies
swift package resolve

# Open in Xcode
open Package.swift
```

## Quick Start

### 1. Import the Framework

```swift
import SwiftUI
import DataVisualization
```

### 2. Create Sample Data

```swift
let sampleData = [
    DataPoint(x: 1, y: 10),
    DataPoint(x: 2, y: 20),
    DataPoint(x: 3, y: 15),
    DataPoint(x: 4, y: 25),
    DataPoint(x: 5, y: 30)
]
```

### 3. Create Your First Chart

```swift
struct BasicChartView: View {
    var body: some View {
        VStack {
            Text("Sample Chart")
                .font(.title)
            
            LineChart(data: sampleData)
                .frame(height: 300)
                .padding()
        }
    }
}
```

## Chart Types

### Line Charts

Perfect for showing trends over time:

```swift
struct LineChartExample: View {
    let data = [
        DataPoint(x: "Jan", y: 100),
        DataPoint(x: "Feb", y: 150),
        DataPoint(x: "Mar", y: 120),
        DataPoint(x: "Apr", y: 200),
        DataPoint(x: "May", y: 180)
    ]
    
    var body: some View {
        LineChart(data: data)
            .frame(height: 300)
            .padding()
    }
}
```

### Bar Charts

Great for comparing categories:

```swift
struct BarChartExample: View {
    let data = [
        DataPoint(x: "Product A", y: 45),
        DataPoint(x: "Product B", y: 32),
        DataPoint(x: "Product C", y: 67),
        DataPoint(x: "Product D", y: 23)
    ]
    
    var body: some View {
        BarChart(data: data)
            .frame(height: 300)
            .padding()
    }
}
```

### Pie Charts

Ideal for showing proportions:

```swift
struct PieChartExample: View {
    let data = [
        DataPoint(x: "Red", y: 30),
        DataPoint(x: "Blue", y: 25),
        DataPoint(x: "Green", y: 20),
        DataPoint(x: "Yellow", y: 15),
        DataPoint(x: "Purple", y: 10)
    ]
    
    var body: some View {
        PieChart(data: data)
            .frame(height: 300)
            .padding()
    }
}
```

## Customization

### Color Schemes

```swift
let customColorScheme = ChartColorScheme(
    primary: .blue,
    secondary: .green,
    accent: .orange,
    background: .white,
    text: .black,
    grid: .gray.opacity(0.3)
)

let chart = LineChart(data: data)
    .colorScheme(customColorScheme)
```

### Typography

```swift
let customTypography = ChartTypography(
    titleFont: .systemFont(ofSize: 18, weight: .bold),
    axisFont: .systemFont(ofSize: 12, weight: .medium),
    labelFont: .systemFont(ofSize: 10, weight: .regular),
    legendFont: .systemFont(ofSize: 11, weight: .medium)
)

let chart = BarChart(data: data)
    .typography(customTypography)
```

### Animations

```swift
let chart = LineChart(data: data)
    .animation(.easeInOut(duration: 1.0))
    .transition(.scale.combined(with: .opacity))
```

## Performance Optimization

### Large Datasets

```swift
let optimizedChart = LineChart(data: largeDataset)
    .optimization(.largeDataset)
    .caching(.enabled)
    .lazyLoading(.enabled)
```

### Real-time Updates

```swift
class RealTimeChartViewModel: ObservableObject {
    @Published var chartData: [DataPoint] = []
    
    func updateData() {
        chartData = fetchNewData()
        
        withAnimation(.easeInOut(duration: 0.5)) {
            // Chart will automatically update
        }
    }
}
```

## Accessibility

### VoiceOver Support

```swift
let chart = LineChart(data: data)
    .accessibilityLabel("Sales trend chart")
    .accessibilityHint("Shows monthly sales data")
    .accessibilityValue("Current value: $25,000")
```

### Dynamic Type

```swift
let chart = BarChart(data: data)
    .dynamicTypeSize(.large)
```

## Best Practices

### 1. Data Preparation

```swift
// Always validate your data
guard !data.isEmpty else {
    return EmptyChartView()
}

// Handle edge cases
let validData = data.filter { $0.y >= 0 }
```

### 2. Responsive Design

```swift
let chart = LineChart(data: data)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .aspectRatio(16/9, contentMode: .fit)
```

### 3. Error Handling

```swift
struct SafeChartView: View {
    let data: [DataPoint]
    
    var body: some View {
        Group {
            if data.isEmpty {
                Text("No data available")
                    .foregroundColor(.secondary)
            } else {
                LineChart(data: data)
            }
        }
    }
}
```

## Troubleshooting

### Common Issues

1. **Chart not displaying**: Check if data array is not empty
2. **Performance issues**: Use optimization features for large datasets
3. **Accessibility problems**: Ensure proper labels and hints are provided
4. **Animation not working**: Verify animation is enabled in configuration

### Debug Tips

```swift
// Enable debug mode
let chart = LineChart(data: data)
    .debugMode(true)

// Check data validation
try chart.validateData()
```

## Next Steps

1. **Explore Examples**: Check the Examples folder for more complex scenarios
2. **Read API Documentation**: Visit Documentation folder for detailed API reference
3. **Customize Charts**: Experiment with different styles and configurations
4. **Optimize Performance**: Learn about performance optimization techniques
5. **Add Interactivity**: Implement touch gestures and user interactions

## Support

- **Documentation**: [API Reference](ChartAPI.md)
- **Examples**: [Basic Examples](Examples/BasicExamples/)
- **Issues**: [GitHub Issues](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/issues)
- **Discussions**: [GitHub Discussions](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/discussions)

Happy charting! 📊
