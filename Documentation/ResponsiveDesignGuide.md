# Responsive Design Guide

<!-- TOC START -->
## Table of Contents
- [Responsive Design Guide](#responsive-design-guide)
- [Overview](#overview)
- [Responsive Design Fundamentals](#responsive-design-fundamentals)
  - [Device Adaptation](#device-adaptation)
  - [Breakpoint Strategy](#breakpoint-strategy)
- [Layout Strategies](#layout-strategies)
  - [Adaptive Sizing](#adaptive-sizing)
  - [Flexible Layouts](#flexible-layouts)
  - [Grid-Based Layouts](#grid-based-layouts)
- [Orientation Handling](#orientation-handling)
  - [Portrait Layout](#portrait-layout)
  - [Landscape Layout](#landscape-layout)
- [Device-Specific Optimizations](#device-specific-optimizations)
  - [iPhone Optimizations](#iphone-optimizations)
  - [iPad Optimizations](#ipad-optimizations)
  - [Mac Optimizations](#mac-optimizations)
- [Dynamic Type Support](#dynamic-type-support)
  - [Font Scaling](#font-scaling)
  - [Layout Adaptation](#layout-adaptation)
- [Accessibility Integration](#accessibility-integration)
  - [VoiceOver Layout](#voiceover-layout)
  - [Switch Control Support](#switch-control-support)
- [Performance Considerations](#performance-considerations)
  - [Efficient Rendering](#efficient-rendering)
  - [Memory Management](#memory-management)
- [Best Practices](#best-practices)
  - [1. Use Size Classes](#1-use-size-classes)
  - [2. Adaptive Spacing](#2-adaptive-spacing)
  - [3. Flexible Dimensions](#3-flexible-dimensions)
  - [4. Touch-Friendly Controls](#4-touch-friendly-controls)
  - [5. Orientation Awareness](#5-orientation-awareness)
  - [6. Accessibility First](#6-accessibility-first)
  - [7. Performance Optimization](#7-performance-optimization)
  - [8. Testing Strategy](#8-testing-strategy)
- [Error Handling](#error-handling)
<!-- TOC END -->


## Overview

The Responsive Design Guide provides comprehensive strategies for creating charts that adapt seamlessly to different screen sizes, orientations, and device capabilities. This guide ensures optimal user experience across all iOS devices.

## Responsive Design Fundamentals

### Device Adaptation

Charts should automatically adapt to different device characteristics:

- **Screen Size**: iPhone, iPad, Mac
- **Orientation**: Portrait, Landscape
- **Display Density**: Standard, Retina, Super Retina
- **Input Methods**: Touch, Mouse, Trackpad

### Breakpoint Strategy

```swift
struct ResponsiveChartView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                // iPhone layout
                CompactChartLayout()
            } else {
                // iPad layout
                RegularChartLayout()
            }
        }
    }
}
```

## Layout Strategies

### Adaptive Sizing

```swift
struct AdaptiveChartView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var chartHeight: CGFloat {
        switch horizontalSizeClass {
        case .compact:
            return 200
        case .regular:
            return 300
        default:
            return 250
        }
    }
    
    var body: some View {
        LineChart(data: data)
            .frame(height: chartHeight)
            .padding()
    }
}
```

### Flexible Layouts

```swift
struct FlexibleChartView: View {
    var body: some View {
        VStack {
            LineChart(data: data)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(16/9, contentMode: .fit)
                .padding()
        }
    }
}
```

### Grid-Based Layouts

```swift
struct GridChartView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var columns: [GridItem] {
        switch horizontalSizeClass {
        case .compact:
            return [GridItem(.flexible())]
        case .regular:
            return [GridItem(.flexible()), GridItem(.flexible())]
        default:
            return [GridItem(.flexible())]
        }
    }
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 20) {
            LineChart(data: data1)
            BarChart(data: data2)
            PieChart(data: data3)
        }
        .padding()
    }
}
```

## Orientation Handling

### Portrait Layout

```swift
struct PortraitChartView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Sales Analytics")
                .font(.title)
            
            LineChart(data: data)
                .frame(height: 250)
            
            HStack {
                BarChart(data: data1)
                    .frame(height: 150)
                
                PieChart(data: data2)
                    .frame(height: 150)
            }
        }
        .padding()
    }
}
```

### Landscape Layout

```swift
struct LandscapeChartView: View {
    var body: some View {
        HStack(spacing: 20) {
            VStack {
                Text("Sales Analytics")
                    .font(.title)
                
                LineChart(data: data)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            VStack {
                BarChart(data: data1)
                    .frame(height: 200)
                
                PieChart(data: data2)
                    .frame(height: 200)
            }
        }
        .padding()
    }
}
```

## Device-Specific Optimizations

### iPhone Optimizations

```swift
struct iPhoneChartView: View {
    var body: some View {
        VStack {
            // Compact layout for iPhone
            LineChart(data: data)
                .frame(height: 200)
                .padding(.horizontal, 16)
            
            // Touch-friendly controls
            HStack {
                Button("Zoom In") { }
                    .buttonStyle(.bordered)
                
                Button("Reset") { }
                    .buttonStyle(.bordered)
                
                Button("Share") { }
                    .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
```

### iPad Optimizations

```swift
struct iPadChartView: View {
    var body: some View {
        HStack {
            // Sidebar for iPad
            VStack {
                Text("Chart Controls")
                    .font(.headline)
                
                VStack(alignment: .leading) {
                    Button("Line Chart") { }
                    Button("Bar Chart") { }
                    Button("Pie Chart") { }
                }
                .padding()
            }
            .frame(width: 200)
            .background(Color.gray.opacity(0.1))
            
            // Main chart area
            VStack {
                LineChart(data: data)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            }
        }
    }
}
```

### Mac Optimizations

```swift
struct MacChartView: View {
    var body: some View {
        VStack {
            // Mac-specific controls
            HStack {
                Button("Export") { }
                Button("Print") { }
                Button("Share") { }
            }
            .padding()
            
            // Large chart area for Mac
            LineChart(data: data)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
        }
    }
}
```

## Dynamic Type Support

### Font Scaling

```swift
struct DynamicTypeChartView: View {
    @Environment(\.sizeCategory) var sizeCategory
    
    var titleFont: Font {
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge:
            return .systemFont(ofSize: 24, weight: .bold)
        case .accessibilityExtraExtraLarge:
            return .systemFont(ofSize: 22, weight: .bold)
        case .accessibilityExtraLarge:
            return .systemFont(ofSize: 20, weight: .bold)
        case .accessibilityLarge:
            return .systemFont(ofSize: 18, weight: .bold)
        case .accessibilityMedium:
            return .systemFont(ofSize: 16, weight: .bold)
        default:
            return .systemFont(ofSize: 18, weight: .bold)
        }
    }
    
    var body: some View {
        VStack {
            Text("Sales Analytics")
                .font(titleFont)
            
            LineChart(data: data)
                .frame(height: 300)
                .padding()
        }
    }
}
```

### Layout Adaptation

```swift
extension Chart {
    func adaptLayoutForDynamicType() {
        let sizeCategory = UIApplication.shared.preferredContentSizeCategory
        
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge:
            adjustSpacing(scale: 1.5)
            increaseTouchTargets()
        case .accessibilityExtraExtraLarge:
            adjustSpacing(scale: 1.4)
            increaseTouchTargets()
        case .accessibilityExtraLarge:
            adjustSpacing(scale: 1.3)
            increaseTouchTargets()
        case .accessibilityLarge:
            adjustSpacing(scale: 1.2)
        case .accessibilityMedium:
            adjustSpacing(scale: 1.1)
        default:
            adjustSpacing(scale: 1.0)
        }
    }
}
```

## Accessibility Integration

### VoiceOver Layout

```swift
struct AccessibleChartView: View {
    var body: some View {
        VStack {
            LineChart(data: data)
                .accessibilityLabel("Sales trend chart")
                .accessibilityHint("Double tap to select data points")
                .frame(height: 300)
                .padding()
            
            // Accessible controls
            HStack {
                Button("Previous") { }
                    .accessibilityLabel("Go to previous data point")
                
                Button("Next") { }
                    .accessibilityLabel("Go to next data point")
            }
        }
    }
}
```

### Switch Control Support

```swift
struct SwitchControlChartView: View {
    var body: some View {
        VStack {
            LineChart(data: data)
                .accessibilityTraits(.adjustable)
                .frame(height: 300)
                .padding()
            
            // Switch Control friendly buttons
            HStack(spacing: 20) {
                Button("Zoom In") { }
                    .frame(minWidth: 44, minHeight: 44)
                
                Button("Zoom Out") { }
                    .frame(minWidth: 44, minHeight: 44)
                
                Button("Reset") { }
                    .frame(minWidth: 44, minHeight: 44)
            }
        }
    }
}
```

## Performance Considerations

### Efficient Rendering

```swift
struct EfficientChartView: View {
    @State private var chartData: [DataPoint] = []
    
    var body: some View {
        LineChart(data: chartData)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                loadDataEfficiently()
            }
    }
    
    private func loadDataEfficiently() {
        // Load data progressively based on screen size
        let maxPoints = UIScreen.main.bounds.width > 768 ? 1000 : 500
        chartData = sampleData(originalData, maxPoints: maxPoints)
    }
}
```

### Memory Management

```swift
extension Chart {
    func optimizeForDevice() {
        let screenSize = UIScreen.main.bounds.size
        let screenArea = screenSize.width * screenSize.height
        
        // Adjust quality based on screen size
        if screenArea > 1000000 { // iPad or larger
            setHighQuality()
        } else {
            setStandardQuality()
        }
    }
}
```

## Best Practices

### 1. Use Size Classes

```swift
struct ResponsiveChartView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                // iPhone Portrait
                iPhonePortraitLayout()
            } else if horizontalSizeClass == .compact && verticalSizeClass == .compact {
                // iPhone Landscape
                iPhoneLandscapeLayout()
            } else if horizontalSizeClass == .regular {
                // iPad
                iPadLayout()
            }
        }
    }
}
```

### 2. Adaptive Spacing

```swift
struct AdaptiveSpacingView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var spacing: CGFloat {
        switch horizontalSizeClass {
        case .compact:
            return 8
        case .regular:
            return 16
        default:
            return 12
        }
    }
    
    var body: some View {
        VStack(spacing: spacing) {
            LineChart(data: data)
            BarChart(data: data)
        }
        .padding(spacing)
    }
}
```

### 3. Flexible Dimensions

```swift
struct FlexibleChartView: View {
    var body: some View {
        GeometryReader { geometry in
            LineChart(data: data)
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height * 0.7
                )
                .padding()
        }
    }
}
```

### 4. Touch-Friendly Controls

```swift
struct TouchFriendlyView: View {
    var body: some View {
        VStack {
            LineChart(data: data)
                .frame(height: 300)
            
            HStack(spacing: 20) {
                Button("Zoom") { }
                    .frame(minWidth: 44, minHeight: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
                Button("Reset") { }
                    .frame(minWidth: 44, minHeight: 44)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}
```

### 5. Orientation Awareness

```swift
struct OrientationAwareView: View {
    @State private var orientation = UIDeviceOrientation.portrait
    
    var body: some View {
        Group {
            if orientation.isPortrait {
                PortraitLayout()
            } else {
                LandscapeLayout()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            orientation = UIDevice.current.orientation
        }
    }
}
```

### 6. Accessibility First

```swift
struct AccessibleResponsiveView: View {
    var body: some View {
        VStack {
            LineChart(data: data)
                .accessibilityLabel("Sales trend chart")
                .accessibilityHint("Double tap to select data points")
                .frame(height: 300)
                .padding()
            
            // Accessible controls with proper sizing
            HStack(spacing: 20) {
                Button("Previous") { }
                    .frame(minWidth: 44, minHeight: 44)
                    .accessibilityLabel("Go to previous data point")
                
                Button("Next") { }
                    .frame(minWidth: 44, minHeight: 44)
                    .accessibilityLabel("Go to next data point")
            }
        }
    }
}
```

### 7. Performance Optimization

```swift
struct OptimizedResponsiveView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var optimizedData: [DataPoint] {
        let maxPoints = horizontalSizeClass == .regular ? 1000 : 500
        return sampleData(originalData, maxPoints: maxPoints)
    }
    
    var body: some View {
        LineChart(data: optimizedData)
            .frame(height: horizontalSizeClass == .regular ? 400 : 250)
            .padding()
    }
}
```

### 8. Testing Strategy

```swift
struct ResponsiveTestView: View {
    var body: some View {
        Group {
            // Test on different devices
            ResponsiveChartView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 14"))
                .previewDisplayName("iPhone")
            
            ResponsiveChartView()
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch)"))
                .previewDisplayName("iPad")
        }
    }
}
```

## Error Handling

```swift
enum ResponsiveDesignError: Error {
    case unsupportedDevice
    case invalidLayout
    case performanceIssue
}

extension Chart {
    func validateResponsiveDesign() throws {
        let screenSize = UIScreen.main.bounds.size
        
        // Validate minimum screen size
        guard screenSize.width >= 320 && screenSize.height >= 568 else {
            throw ResponsiveDesignError.unsupportedDevice
        }
        
        // Validate layout constraints
        guard validateLayoutConstraints() else {
            throw ResponsiveDesignError.invalidLayout
        }
    }
}
```

This comprehensive Responsive Design Guide ensures that all charts provide optimal user experience across all iOS devices and orientations.
