# Customization API

<!-- TOC START -->
## Table of Contents
- [Customization API](#customization-api)
- [Overview](#overview)
- [Core Components](#core-components)
  - [ChartColorScheme](#chartcolorscheme)
  - [ChartTypography](#charttypography)
- [Color Customization](#color-customization)
  - [Custom Color Schemes](#custom-color-schemes)
  - [Brand Colors](#brand-colors)
  - [Dark Mode Support](#dark-mode-support)
- [Typography Customization](#typography-customization)
  - [Custom Fonts](#custom-fonts)
  - [Dynamic Type Support](#dynamic-type-support)
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
- [Error Handling](#error-handling)
<!-- TOC END -->


## Overview

The Customization API provides comprehensive tools for customizing chart appearance, behavior, and functionality. This API allows developers to create unique, branded visualizations that match their application's design language.

## Core Components

### ChartColorScheme

```swift
public struct ChartColorScheme {
    public var primary: Color
    public var secondary: Color
    public var accent: Color
    public var background: Color
    public var text: Color
    public var grid: Color
    public var success: Color
    public var warning: Color
    public var error: Color
    
    public static let `default` = ChartColorScheme(
        primary: .blue,
        secondary: .green,
        accent: .orange,
        background: .white,
        text: .black,
        grid: .gray.opacity(0.3),
        success: .green,
        warning: .orange,
        error: .red
    )
}
```

### ChartTypography

```swift
public struct ChartTypography {
    public var titleFont: Font
    public var axisFont: Font
    public var labelFont: Font
    public var legendFont: Font
    public var valueFont: Font
    
    public static let `default` = ChartTypography(
        titleFont: .systemFont(ofSize: 18, weight: .bold),
        axisFont: .systemFont(ofSize: 12, weight: .medium),
        labelFont: .systemFont(ofSize: 10, weight: .regular),
        legendFont: .systemFont(ofSize: 11, weight: .medium),
        valueFont: .systemFont(ofSize: 12, weight: .semibold)
    )
}
```

## Color Customization

### Custom Color Schemes

```swift
let customColorScheme = ChartColorScheme(
    primary: .purple,
    secondary: .pink,
    accent: .indigo,
    background: .systemBackground,
    text: .label,
    grid: .separator,
    success: .systemGreen,
    warning: .systemOrange,
    error: .systemRed
)

let chart = LineChart(data: data)
    .colorScheme(customColorScheme)
```

### Brand Colors

```swift
let brandColorScheme = ChartColorScheme(
    primary: Color(red: 0.2, green: 0.6, blue: 0.9),
    secondary: Color(red: 0.9, green: 0.3, blue: 0.5),
    accent: Color(red: 0.3, green: 0.8, blue: 0.4),
    background: .white,
    text: .black,
    grid: .gray.opacity(0.2)
)

let chart = BarChart(data: data)
    .colorScheme(brandColorScheme)
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

let chart = PieChart(data: data)
    .colorScheme(adaptiveColorScheme)
```

## Typography Customization

### Custom Fonts

```swift
let customTypography = ChartTypography(
    titleFont: .custom("HelveticaNeue-Bold", size: 20),
    axisFont: .custom("HelveticaNeue-Medium", size: 14),
    labelFont: .custom("HelveticaNeue", size: 12),
    legendFont: .custom("HelveticaNeue-Medium", size: 13),
    valueFont: .custom("HelveticaNeue-Bold", size: 14)
)

let chart = LineChart(data: data)
    .typography(customTypography)
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

let chart = BarChart(data: data)
    .typography(dynamicTypography)
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

let chart = LineChart(data: data, style: customLineStyle)
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

let chart = BarChart(data: data, style: customBarStyle)
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

let chart = PieChart(data: data, style: customPieStyle)
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

let chart = LineChart(data: data)
    .theme(lightTheme)
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

let chart = BarChart(data: data)
    .theme(darkTheme)
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

1. **Consistent Design**: Maintain consistent design language across charts
2. **Accessibility**: Ensure customizations don't break accessibility
3. **Performance**: Optimize customizations for performance
4. **Responsive Design**: Make customizations work on all screen sizes
5. **Brand Guidelines**: Follow brand guidelines when customizing
6. **User Preferences**: Respect user preferences for colors and fonts
7. **Testing**: Test customizations on different devices and orientations
8. **Documentation**: Document custom themes and styles
9. **Reusability**: Create reusable customization components
10. **Maintainability**: Keep customizations maintainable and organized

## Error Handling

```swift
enum CustomizationError: Error {
    case invalidColorScheme
    case invalidTypography
    case unsupportedCustomization
    case performanceIssue
}

extension Chart {
    public func validateCustomization() throws {
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

This comprehensive Customization API provides everything you need to create unique, branded chart visualizations for your iOS applications.
