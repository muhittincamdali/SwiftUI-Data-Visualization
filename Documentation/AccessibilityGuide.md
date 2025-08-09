# Accessibility Guide

<!-- TOC START -->
## Table of Contents
- [Accessibility Guide](#accessibility-guide)
- [Overview](#overview)
- [Accessibility Fundamentals](#accessibility-fundamentals)
  - [VoiceOver Support](#voiceover-support)
    - [Basic VoiceOver Implementation](#basic-voiceover-implementation)
    - [VoiceOver Navigation](#voiceover-navigation)
  - [Dynamic Type Support](#dynamic-type-support)
    - [Font Scaling](#font-scaling)
    - [Layout Adaptation](#layout-adaptation)
- [Color Accessibility](#color-accessibility)
  - [High Contrast Support](#high-contrast-support)
  - [Color Blind Support](#color-blind-support)
- [Gesture Accessibility](#gesture-accessibility)
  - [VoiceOver Gestures](#voiceover-gestures)
  - [Switch Control Support](#switch-control-support)
- [Screen Reader Support](#screen-reader-support)
  - [Descriptive Labels](#descriptive-labels)
  - [Context Information](#context-information)
- [Testing Accessibility](#testing-accessibility)
  - [VoiceOver Testing](#voiceover-testing)
  - [Automated Testing](#automated-testing)
- [Best Practices](#best-practices)
  - [1. Provide Descriptive Labels](#1-provide-descriptive-labels)
  - [2. Use Clear Hints](#2-use-clear-hints)
  - [3. Support Dynamic Type](#3-support-dynamic-type)
  - [4. High Contrast Support](#4-high-contrast-support)
  - [5. Color Blind Friendly](#5-color-blind-friendly)
  - [6. VoiceOver Navigation](#6-voiceover-navigation)
  - [7. Switch Control](#7-switch-control)
  - [8. Context Information](#8-context-information)
  - [9. Test Thoroughly](#9-test-thoroughly)
  - [10. Follow Guidelines](#10-follow-guidelines)
- [Error Handling](#error-handling)
- [Advanced Features](#advanced-features)
  - [Custom Accessibility Actions](#custom-accessibility-actions)
  - [Accessibility Notifications](#accessibility-notifications)
<!-- TOC END -->


## Overview

The Accessibility Guide provides comprehensive information on making charts accessible to users with disabilities. This guide covers VoiceOver support, Dynamic Type, color accessibility, and other accessibility features to ensure inclusive data visualization.

## Accessibility Fundamentals

### VoiceOver Support

VoiceOver is Apple's screen reader that helps users with visual impairments navigate and interact with apps.

#### Basic VoiceOver Implementation

```swift
struct AccessibleChartView: View {
    var body: some View {
        VStack {
            Text("Sales Data")
                .font(.title)
            
            LineChart(data: data)
                .accessibilityLabel("Line chart showing monthly sales data")
                .accessibilityHint("Swipe left or right to navigate between data points")
                .accessibilityValue("January: $10,000, February: $15,000, March: $12,000")
                .accessibilityTraits(.chart)
        }
    }
}
```

#### VoiceOver Navigation

```swift
extension Chart {
    func enableVoiceOverNavigation() {
        // Enable VoiceOver navigation between data points
        accessibilityElements = makeAccessibleDataPoints()
        accessibilityTraits = [.chart, .interactive]
        
        // Add custom actions
        accessibilityCustomActions = [
            UIAccessibilityCustomAction(
                name: "Select data point",
                target: self,
                selector: #selector(selectDataPoint)
            ),
            UIAccessibilityCustomAction(
                name: "Show details",
                target: self,
                selector: #selector(showDetails)
            )
        ]
    }
}
```

### Dynamic Type Support

Dynamic Type allows users to adjust text size based on their preferences.

#### Font Scaling

```swift
extension Chart {
    func supportDynamicType() {
        // Support Dynamic Type for all text elements
        titleFont = .preferredFont(forTextStyle: .title1)
        axisFont = .preferredFont(forTextStyle: .caption1)
        labelFont = .preferredFont(forTextStyle: .caption2)
        legendFont = .preferredFont(forTextStyle: .footnote)
    }
}
```

#### Layout Adaptation

```swift
extension Chart {
    func adaptLayoutForDynamicType() {
        // Adjust layout based on Dynamic Type size
        let sizeCategory = UIApplication.shared.preferredContentSizeCategory
        
        switch sizeCategory {
        case .accessibilityExtraExtraExtraLarge:
            adjustSpacing(scale: 1.5)
        case .accessibilityExtraExtraLarge:
            adjustSpacing(scale: 1.4)
        case .accessibilityExtraLarge:
            adjustSpacing(scale: 1.3)
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

## Color Accessibility

### High Contrast Support

```swift
extension Chart {
    func supportHighContrast() {
        // Adjust colors for high contrast mode
        if UIAccessibility.isReduceTransparencyEnabled {
            useHighContrastColors()
        }
    }
    
    private func useHighContrastColors() {
        // Use high contrast color scheme
        primaryColor = .systemBlue
        secondaryColor = .systemGreen
        accentColor = .systemOrange
        backgroundColor = .systemBackground
        textColor = .label
    }
}
```

### Color Blind Support

```swift
extension Chart {
    func supportColorBlindness() {
        // Use color blind friendly palette
        let colorBlindPalette: [Color] = [
            .blue, .orange, .green, .red, .purple, .brown, .pink, .gray
        ]
        
        // Ensure sufficient contrast
        ensureColorContrast()
    }
    
    private func ensureColorContrast() {
        // Check and adjust color contrast ratios
        for color in colors {
            let contrastRatio = calculateContrastRatio(color, against: .white)
            if contrastRatio < 4.5 {
                // Adjust color for better contrast
                adjustColorForContrast(color)
            }
        }
    }
}
```

## Gesture Accessibility

### VoiceOver Gestures

```swift
extension Chart {
    func supportVoiceOverGestures() {
        // Support VoiceOver specific gestures
        accessibilityTraits = [.chart, .interactive]
        
        // Add custom actions
        accessibilityCustomActions = [
            UIAccessibilityCustomAction(
                name: "Select data point",
                target: self,
                selector: #selector(selectDataPoint)
            ),
            UIAccessibilityCustomAction(
                name: "Show details",
                target: self,
                selector: #selector(showDetails)
            )
        ]
    }
}
```

### Switch Control Support

```swift
extension Chart {
    func supportSwitchControl() {
        // Enable Switch Control navigation
        isAccessibilityElement = true
        accessibilityTraits = [.chart, .adjustable]
        
        // Add focus management
        accessibilityElementsHidden = false
        accessibilityViewIsModal = false
    }
}
```

## Screen Reader Support

### Descriptive Labels

```swift
extension Chart {
    func generateDescriptiveLabels() -> [String] {
        return data.enumerated().map { index, point in
            let percentage = calculatePercentage(point.y)
            return "\(point.x): \(point.y) (\(percentage)%)"
        }
    }
    
    private func calculatePercentage(_ value: Double) -> String {
        let total = data.reduce(0) { $0 + $1.y }
        let percentage = (value / total) * 100
        return String(format: "%.1f", percentage)
    }
}
```

### Context Information

```swift
extension Chart {
    func provideContext() -> String {
        let total = data.reduce(0) { $0 + $1.y }
        let average = total / Double(data.count)
        let max = data.map { $0.y }.max() ?? 0
        let min = data.map { $0.y }.min() ?? 0
        
        return """
        Chart contains \(data.count) data points.
        Total value: \(total)
        Average: \(average)
        Maximum: \(max)
        Minimum: \(min)
        """
    }
}
```

## Testing Accessibility

### VoiceOver Testing

```swift
extension Chart {
    func testVoiceOverAccessibility() -> AccessibilityTestResult {
        var result = AccessibilityTestResult()
        
        // Test VoiceOver labels
        result.hasAccessibilityLabel = !accessibilityLabel.isEmpty
        result.hasAccessibilityHint = !accessibilityHint.isEmpty
        result.hasAccessibilityValue = !accessibilityValue.isEmpty
        
        // Test navigation
        result.supportsNavigation = accessibilityElements.count > 0
        
        // Test traits
        result.hasAppropriateTraits = accessibilityTraits.contains(.chart)
        
        return result
    }
}
```

### Automated Testing

```swift
extension Chart {
    func runAccessibilityTests() -> [AccessibilityIssue] {
        var issues: [AccessibilityIssue] = []
        
        // Check for missing labels
        if accessibilityLabel.isEmpty {
            issues.append(.missingAccessibilityLabel)
        }
        
        // Check for missing hints
        if accessibilityHint.isEmpty {
            issues.append(.missingAccessibilityHint)
        }
        
        // Check color contrast
        if !hasSufficientColorContrast() {
            issues.append(.insufficientColorContrast)
        }
        
        // Check Dynamic Type support
        if !supportsDynamicType() {
            issues.append(.missingDynamicTypeSupport)
        }
        
        return issues
    }
}
```

## Best Practices

### 1. Provide Descriptive Labels

```swift
let chart = LineChart(data: data)
    .accessibilityLabel("Line chart showing monthly sales trend")
    .accessibilityHint("Double tap to select data points")
    .accessibilityValue("Current trend: increasing, total sales: $150,000")
```

### 2. Use Clear Hints

```swift
let chart = BarChart(data: data)
    .accessibilityHint("Swipe left or right to navigate between bars")
```

### 3. Support Dynamic Type

```swift
let chart = PieChart(data: data)
    .dynamicTypeSize(.large)
```

### 4. High Contrast Support

```swift
let chart = ScatterPlot(data: data)
    .accessibilityLabel("Scatter plot showing correlation data")
    .accessibilityHint("Double tap to select data points")
```

### 5. Color Blind Friendly

```swift
let colorBlindPalette: [Color] = [
    .blue, .orange, .green, .red, .purple, .brown, .pink, .gray
]
```

### 6. VoiceOver Navigation

```swift
extension Chart {
    func enableVoiceOverNavigation() {
        accessibilityElements = makeAccessibleDataPoints()
        accessibilityTraits = [.chart, .interactive]
    }
}
```

### 7. Switch Control

```swift
extension Chart {
    func supportSwitchControl() {
        isAccessibilityElement = true
        accessibilityTraits = [.chart, .adjustable]
    }
}
```

### 8. Context Information

```swift
extension Chart {
    func provideContext() -> String {
        return "Chart shows \(data.count) data points with total value of \(total)"
    }
}
```

### 9. Test Thoroughly

```swift
extension Chart {
    func testAccessibility() {
        // Test with VoiceOver
        testVoiceOverAccessibility()
        
        // Test Dynamic Type
        testDynamicTypeSupport()
        
        // Test color contrast
        testColorContrast()
    }
}
```

### 10. Follow Guidelines

```swift
extension Chart {
    func followAccessibilityGuidelines() {
        // Follow iOS accessibility guidelines
        ensureMinimumTouchTargets()
        provideAlternativeText()
        supportVoiceOver()
        supportSwitchControl()
        supportDynamicType()
    }
}
```

## Error Handling

```swift
enum AccessibilityError: Error {
    case missingAccessibilityLabel
    case insufficientColorContrast
    case unsupportedDynamicType
    case voiceOverNavigationFailed
}

extension Chart {
    func validateAccessibility() throws {
        guard !accessibilityLabel.isEmpty else {
            throw AccessibilityError.missingAccessibilityLabel
        }
        
        guard hasSufficientColorContrast() else {
            throw AccessibilityError.insufficientColorContrast
        }
        
        guard supportsDynamicType() else {
            throw AccessibilityError.unsupportedDynamicType
        }
    }
}
```

## Advanced Features

### Custom Accessibility Actions

```swift
extension Chart {
    func addCustomAccessibilityActions() {
        accessibilityCustomActions = [
            UIAccessibilityCustomAction(
                name: "Zoom in",
                target: self,
                selector: #selector(zoomIn)
            ),
            UIAccessibilityCustomAction(
                name: "Zoom out",
                target: self,
                selector: #selector(zoomOut)
            ),
            UIAccessibilityCustomAction(
                name: "Reset view",
                target: self,
                selector: #selector(resetView)
            )
        ]
    }
}
```

### Accessibility Notifications

```swift
extension Chart {
    func announceAccessibilityChanges() {
        // Announce changes to VoiceOver
        UIAccessibility.post(notification: .announcement, argument: "Chart data updated")
    }
}
```

This comprehensive Accessibility Guide ensures that all charts are accessible to users with disabilities and comply with iOS accessibility guidelines.
