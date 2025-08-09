# Accessibility API

<!-- TOC START -->
## Table of Contents
- [Accessibility API](#accessibility-api)
- [Overview](#overview)
- [Core Components](#core-components)
  - [ChartAccessibility](#chartaccessibility)
  - [Accessibility Traits](#accessibility-traits)
- [Usage Examples](#usage-examples)
  - [Basic Accessibility](#basic-accessibility)
  - [VoiceOver Support](#voiceover-support)
  - [Dynamic Type Support](#dynamic-type-support)
- [VoiceOver Integration](#voiceover-integration)
  - [Data Point Accessibility](#data-point-accessibility)
  - [Navigation Support](#navigation-support)
- [Dynamic Type](#dynamic-type)
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
- [Error Handling](#error-handling)
<!-- TOC END -->


## Overview

The Accessibility API provides comprehensive support for VoiceOver, Dynamic Type, and other accessibility features. This API ensures that all charts are accessible to users with disabilities and comply with iOS accessibility guidelines.

## Core Components

### ChartAccessibility

```swift
public struct ChartAccessibility {
    public var accessibilityLabel: String
    public var accessibilityHint: String
    public var accessibilityValue: String
    public var accessibilityTraits: AccessibilityTraits
    public var accessibilityElements: [Any]
    public var shouldGroupAccessibilityChildren: Bool
    
    public static let `default` = ChartAccessibility(
        accessibilityLabel: "",
        accessibilityHint: "",
        accessibilityValue: "",
        accessibilityTraits: [],
        accessibilityElements: [],
        shouldGroupAccessibilityChildren: true
    )
}
```

### Accessibility Traits

```swift
public enum ChartAccessibilityTrait {
    case chart
    case interactive
    case adjustable
    case button
    case image
    case staticText
    case summaryElement
}
```

## Usage Examples

### Basic Accessibility

```swift
let chart = LineChart(data: data)
    .accessibilityLabel("Sales trend chart")
    .accessibilityHint("Double tap to select data points")
    .accessibilityValue("Current value: $25,000")
```

### VoiceOver Support

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

### Dynamic Type Support

```swift
let chart = BarChart(data: data)
    .dynamicTypeSize(.large)
    .accessibilityLabel("Bar chart showing revenue by month")
```

## VoiceOver Integration

### Data Point Accessibility

```swift
extension Chart {
    public func makeAccessibleDataPoints() -> [AccessibleDataPoint] {
        return data.enumerated().map { index, point in
            AccessibleDataPoint(
                index: index,
                label: "\(point.x): \(point.y)",
                value: point.y,
                accessibilityLabel: "Data point \(index + 1), \(point.x), value \(point.y)"
            )
        }
    }
}

struct AccessibleDataPoint {
    let index: Int
    let label: String
    let value: Double
    let accessibilityLabel: String
}
```

### Navigation Support

```swift
extension Chart {
    public func enableVoiceOverNavigation() {
        // Enable VoiceOver navigation between data points
        accessibilityElements = makeAccessibleDataPoints()
        accessibilityTraits = [.chart, .interactive]
    }
}
```

## Dynamic Type

### Font Scaling

```swift
extension Chart {
    public func supportDynamicType() {
        // Support Dynamic Type for all text elements
        titleFont = .preferredFont(forTextStyle: .title1)
        axisFont = .preferredFont(forTextStyle: .caption1)
        labelFont = .preferredFont(forTextStyle: .caption2)
        legendFont = .preferredFont(forTextStyle: .footnote)
    }
}
```

### Layout Adaptation

```swift
extension Chart {
    public func adaptLayoutForDynamicType() {
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
    public func supportHighContrast() {
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
    public func supportColorBlindness() {
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
    public func supportVoiceOverGestures() {
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
    public func supportSwitchControl() {
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
    public func generateDescriptiveLabels() -> [String] {
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
    public func provideContext() -> String {
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
    public func testVoiceOverAccessibility() -> AccessibilityTestResult {
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

struct AccessibilityTestResult {
    var hasAccessibilityLabel: Bool = false
    var hasAccessibilityHint: Bool = false
    var hasAccessibilityValue: Bool = false
    var supportsNavigation: Bool = false
    var hasAppropriateTraits: Bool = false
    var supportsDynamicType: Bool = false
    var supportsHighContrast: Bool = false
}
```

### Automated Testing

```swift
extension Chart {
    public func runAccessibilityTests() -> [AccessibilityIssue] {
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

enum AccessibilityIssue {
    case missingAccessibilityLabel
    case missingAccessibilityHint
    case insufficientColorContrast
    case missingDynamicTypeSupport
    case missingVoiceOverSupport
    case missingSwitchControlSupport
}
```

## Best Practices

1. **Provide Descriptive Labels**: Always include meaningful accessibility labels
2. **Use Clear Hints**: Provide helpful hints for VoiceOver users
3. **Support Dynamic Type**: Ensure text scales with user preferences
4. **High Contrast Support**: Ensure good contrast in high contrast mode
5. **Color Blind Friendly**: Use color blind friendly palettes
6. **VoiceOver Navigation**: Enable proper navigation between elements
7. **Switch Control**: Support Switch Control for motor impairments
8. **Context Information**: Provide context about chart data
9. **Test Thoroughly**: Test with VoiceOver and other accessibility tools
10. **Follow Guidelines**: Adhere to iOS accessibility guidelines

## Error Handling

```swift
enum AccessibilityError: Error {
    case missingAccessibilityLabel
    case insufficientColorContrast
    case unsupportedDynamicType
    case voiceOverNavigationFailed
}

extension Chart {
    public func validateAccessibility() throws {
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

This comprehensive Accessibility API ensures that all charts are accessible to users with disabilities and comply with iOS accessibility guidelines.
