# Customization Guide

<!-- TOC START -->
## Table of Contents
- [Customization Guide](#customization-guide)
- [Overview](#overview)
- [Color Customization](#color-customization)
  - [Color Schemes](#color-schemes)
    - [Default Color Scheme](#default-color-scheme)
    - [Custom Color Scheme](#custom-color-scheme)
    - [Brand Colors](#brand-colors)
  - [Dark Mode Support](#dark-mode-support)
- [Typography Customization](#typography-customization)
  - [Font Selection](#font-selection)
  - [Dynamic Type Support](#dynamic-type-support)
  - [Font Weight and Style](#font-weight-and-style)
- [Layout Customization](#layout-customization)
  - [Spacing and Padding](#spacing-and-padding)
  - [Aspect Ratio](#aspect-ratio)
  - [Responsive Layout](#responsive-layout)
- [Style Customization](#style-customization)
  - [Line Chart Styles](#line-chart-styles)
  - [Bar Chart Styles](#bar-chart-styles)
  - [Pie Chart Styles](#pie-chart-styles)
- [Interactive Customization](#interactive-customization)
  - [Custom Gestures](#custom-gestures)
  - [Custom Callbacks](#custom-callbacks)
- [Theme Customization](#theme-customization)
  - [Light Theme](#light-theme)
  - [Dark Theme](#dark-theme)
- [Advanced Customization](#advanced-customization)
  - [Custom Renderers](#custom-renderers)
  - [Custom Animations](#custom-animations)
  - [Custom Modifiers](#custom-modifiers)
- [Best Practices](#best-practices)
  - [1. Consistent Design](#1-consistent-design)
  - [2. Accessibility](#2-accessibility)
  - [3. Performance](#3-performance)
  - [4. Responsive Design](#4-responsive-design)
  - [5. Brand Guidelines](#5-brand-guidelines)
  - [6. User Preferences](#6-user-preferences)
  - [7. Testing](#7-testing)
  - [8. Documentation](#8-documentation)
  - [9. Reusability](#9-reusability)
  - [10. Maintenance](#10-maintenance)
- [Error Handling](#error-handling)
<!-- TOC END -->


## Overview

The Customization Guide provides comprehensive information on customizing chart appearance, behavior, and functionality. This guide covers color schemes, typography, layouts, and advanced customization options to create unique, branded visualizations.

## Color Customization

### Color Schemes

Color schemes define the overall color palette for your charts.

#### Default Color Scheme

```swift
let defaultColorScheme = ChartColorScheme(
    primary: .blue,
    secondary: .green,
    accent: .orange,
    background: .white,
    text: .black,
    grid: .gray.opacity(0.3)
)
```

#### Custom Color Scheme

```swift
let customColorScheme = ChartColorScheme(
    primary: Color(red: 0.2, green: 0.6, blue: 0.9),
    secondary: Color(red: 0.9, green: 0.3, blue: 0.5),
    accent: Color(red: 0.3, green: 0.8, blue: 0.4),
    background: .white,
    text: .black,
    grid: .gray.opacity(0.2)
)
```

#### Brand Colors

```swift
let brandColorScheme = ChartColorScheme(
    primary: Color("BrandPrimary"),
    secondary: Color("BrandSecondary"),
    accent: Color("BrandAccent"),
    background: Color("BrandBackground"),
    text: Color("BrandText"),
    grid: Color("BrandGrid")
)
```

### Dark Mode Support

```swift
let adaptiveColorScheme = ChartColorScheme(
    primary: .blue,
    secondary: .green,
    accent: .orange,
    background: .systemBackground,
    text: .label,
    grid: .separator
)
```

## Typography Customization

### Font Selection

```swift
let customTypography = ChartTypography(
    titleFont: .custom("HelveticaNeue-Bold", size: 20),
    axisFont: .custom("HelveticaNeue-Medium", size: 14),
    labelFont: .custom("HelveticaNeue", size: 12),
    legendFont: .custom("HelveticaNeue-Medium", size: 13),
    valueFont: .custom("HelveticaNeue-Bold", size: 14)
)
```

### Dynamic Type Support

```swift
let dynamicTypography = ChartTypography(
    titleFont: .preferredFont(forTextStyle: .title1),
    axisFont: .preferredFont(forTextStyle: .caption1),
    labelFont: .preferredFont(forTextStyle: .caption2),
    legendFont: .preferredFont(forTextStyle: .footnote),
    valueFont: .preferredFont(forTextStyle: .body)
)
```

### Font Weight and Style

```swift
let boldTypography = ChartTypography(
    titleFont: .systemFont(ofSize: 18, weight: .bold),
    axisFont: .systemFont(ofSize: 12, weight: .semibold),
    labelFont: .systemFont(ofSize: 10, weight: .medium),
    legendFont: .systemFont(ofSize: 11, weight: .bold),
    valueFont: .systemFont(ofSize: 12, weight: .bold)
)
```

## Layout Customization

### Spacing and Padding

```swift
let chart = LineChart(data: data)
    .padding(.horizontal, 20)
    .padding(.vertical, 10)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
```

### Aspect Ratio

```swift
let chart = BarChart(data: data)
    .aspectRatio(16/9, contentMode: .fit)
    .frame(height: 300)
```

### Responsive Layout

```swift
struct ResponsiveChartView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        LineChart(data: data)
            .frame(height: horizontalSizeClass == .compact ? 200 : 300)
            .padding()
    }
}
```

## Style Customization

### Line Chart Styles

```swift
let customLineStyle = LineChartStyle(
    lineColor: .blue,
    lineWidth: 3.0,
    showPoints: true,
    pointSize: 8.0,
    pointColor: .blue,
    showArea: true,
    areaColor: .blue.opacity(0.2),
    areaOpacity: 0.3
)
```

### Bar Chart Styles

```swift
let customBarStyle = BarChartStyle(
    barColor: .green,
    barWidth: 0.8,
    showValues: true,
    valueColor: .white,
    valueFont: .systemFont(ofSize: 14, weight: .bold),
    showLabels: true,
    labelColor: .black,
    labelFont: .systemFont(ofSize: 12, weight: .medium),
    orientation: .vertical,
    spacing: 8.0
)
```

### Pie Chart Styles

```swift
let customPieStyle = PieChartStyle(
    colors: [.red, .blue, .green, .orange, .purple],
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
```

## Interactive Customization

### Custom Gestures

```swift
let chart = LineChart(data: data)
    .onTapGesture {
        // Handle tap gesture
    }
    .onLongPressGesture {
        // Handle long press gesture
    }
    .gesture(
        DragGesture()
            .onChanged { value in
                // Handle drag gesture
            }
    )
```

### Custom Callbacks

```swift
let chart = BarChart(data: data)
    .onBarTap { index in
        // Handle bar tap
    }
    .onDataPointSelect { point in
        // Handle data point selection
    }
    .onChartUpdate { newData in
        // Handle chart update
    }
```

## Theme Customization

### Light Theme

```swift
let lightTheme = ChartTheme(
    colorScheme: ChartColorScheme(
        primary: .blue,
        secondary: .green,
        accent: .orange,
        background: .white,
        text: .black,
        grid: .gray.opacity(0.3)
    ),
    typography: ChartTypography(
        titleFont: .systemFont(ofSize: 18, weight: .bold),
        axisFont: .systemFont(ofSize: 12, weight: .medium),
        labelFont: .systemFont(ofSize: 10, weight: .regular),
        legendFont: .systemFont(ofSize: 11, weight: .medium),
        valueFont: .systemFont(ofSize: 12, weight: .semibold)
    )
)
```

### Dark Theme

```swift
let darkTheme = ChartTheme(
    colorScheme: ChartColorScheme(
        primary: .blue,
        secondary: .green,
        accent: .orange,
        background: .black,
        text: .white,
        grid: .gray.opacity(0.5)
    ),
    typography: ChartTypography(
        titleFont: .systemFont(ofSize: 18, weight: .bold),
        axisFont: .systemFont(ofSize: 12, weight: .medium),
        labelFont: .systemFont(ofSize: 10, weight: .regular),
        legendFont: .systemFont(ofSize: 11, weight: .medium),
        valueFont: .systemFont(ofSize: 12, weight: .semibold)
    )
)
```

## Advanced Customization

### Custom Renderers

```swift
protocol CustomChartRenderer {
    func render(_ data: [DataPoint]) -> AnyView
}

struct CustomLineRenderer: CustomChartRenderer {
    func render(_ data: [DataPoint]) -> AnyView {
        // Custom rendering logic
        return AnyView(
            Path { path in
                // Custom path drawing
            }
            .stroke(Color.blue, lineWidth: 2)
        )
    }
}
```

### Custom Animations

```swift
let customAnimation = Animation.timingCurve(0.25, 0.46, 0.45, 0.94, duration: 2.0)

let chart = PieChart(data: data)
    .animation(customAnimation)
    .transition(.scale.combined(with: .opacity))
```

### Custom Modifiers

```swift
extension Chart {
    func customModifier() -> some View {
        self
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .border(Color.gray.opacity(0.3), width: 1)
            .cornerRadius(8)
    }
}
```

## Best Practices

### 1. Consistent Design

```swift
// Use consistent colors across all charts
let brandColors = ChartColorScheme(
    primary: Color("BrandPrimary"),
    secondary: Color("BrandSecondary"),
    accent: Color("BrandAccent")
)

let chart1 = LineChart(data: data1).colorScheme(brandColors)
let chart2 = BarChart(data: data2).colorScheme(brandColors)
let chart3 = PieChart(data: data3).colorScheme(brandColors)
```

### 2. Accessibility

```swift
let chart = LineChart(data: data)
    .accessibilityLabel("Sales trend chart")
    .accessibilityHint("Double tap to select data points")
    .dynamicTypeSize(.large)
```

### 3. Performance

```swift
let chart = LineChart(data: data)
    .optimization(.largeDataset)
    .caching(.enabled)
    .lazyLoading(.enabled)
```

### 4. Responsive Design

```swift
struct ResponsiveChartView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        LineChart(data: data)
            .frame(
                height: horizontalSizeClass == .compact ? 200 : 300
            )
            .padding()
    }
}
```

### 5. Brand Guidelines

```swift
// Follow brand guidelines
let brandTheme = ChartTheme(
    colorScheme: brandColorScheme,
    typography: brandTypography,
    spacing: brandSpacing
)
```

### 6. User Preferences

```swift
// Respect user preferences
let chart = LineChart(data: data)
    .preferredColorScheme(userPreferredColorScheme)
    .dynamicTypeSize(userPreferredTextSize)
```

### 7. Testing

```swift
// Test customizations on different devices
struct ChartTestView: View {
    var body: some View {
        Group {
            // Test on iPhone
            LineChart(data: data)
                .frame(height: 300)
            
            // Test on iPad
            LineChart(data: data)
                .frame(height: 400)
        }
    }
}
```

### 8. Documentation

```swift
// Document custom themes
struct BrandChartTheme {
    static let light = ChartTheme(
        colorScheme: brandLightColorScheme,
        typography: brandTypography,
        spacing: brandSpacing
    )
    
    static let dark = ChartTheme(
        colorScheme: brandDarkColorScheme,
        typography: brandTypography,
        spacing: brandSpacing
    )
}
```

### 9. Reusability

```swift
// Create reusable customization components
struct CustomChartModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            .border(Color.gray.opacity(0.3), width: 1)
            .cornerRadius(8)
    }
}

extension View {
    func customChartStyle() -> some View {
        modifier(CustomChartModifier())
    }
}
```

### 10. Maintenance

```swift
// Keep customizations maintainable
struct ChartCustomizationManager {
    static func applyBrandCustomization(to chart: Chart) -> Chart {
        return chart
            .colorScheme(brandColorScheme)
            .typography(brandTypography)
            .theme(brandTheme)
    }
}
```

## Error Handling

```swift
enum CustomizationError: Error {
    case invalidColorScheme
    case invalidTypography
    case unsupportedCustomization
    case performanceIssue
}

extension Chart {
    func validateCustomization() throws {
        // Validate color scheme
        guard colorScheme.primary != colorScheme.secondary else {
            throw CustomizationError.invalidColorScheme
        }
        
        // Validate typography
        guard typography.titleFont != typography.labelFont else {
            throw CustomizationError.invalidTypography
        }
    }
}
```

This comprehensive Customization Guide provides everything you need to create unique, branded chart visualizations for your iOS applications.
