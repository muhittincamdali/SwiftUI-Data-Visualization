import SwiftUI

/// Configuration options for chart styling and behavior.
///
/// This model provides comprehensive configuration options for all chart types,
/// including styling, animations, interactions, and accessibility features.
///
/// - Example:
/// ```swift
/// let config = ChartConfiguration(
///     style: .line,
///     animation: .easeInOut(duration: 0.5),
///     interactive: true,
///     accessibility: .enabled
/// )
/// ```
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ChartConfiguration: Equatable {
    
    // MARK: - Chart Style
    
    /// Chart style type
    public let style: ChartStyle
    
    /// Chart theme (light/dark/auto)
    public let theme: ChartTheme
    
    /// Chart colors
    public let colors: [Color]
    
    /// Background color
    public let backgroundColor: Color
    
    /// Border color
    public let borderColor: Color
    
    /// Border width
    public let borderWidth: Double
    
    /// Corner radius
    public let cornerRadius: Double
    
    /// Shadow configuration
    public let shadow: ChartShadow
    
    // MARK: - Animation
    
    /// Animation type
    public let animation: Animation?
    
    /// Animation duration
    public let animationDuration: Double
    
    /// Whether animations are enabled
    public let animationsEnabled: Bool
    
    // MARK: - Interaction
    
    /// Whether the chart is interactive
    public let interactive: Bool
    
    /// Whether zoom is enabled
    public let zoomEnabled: Bool
    
    /// Whether pan is enabled
    public let panEnabled: Bool
    
    /// Whether tooltips are enabled
    public let tooltipEnabled: Bool
    
    /// Whether selection is enabled
    public let selectionEnabled: Bool
    
    /// Whether gestures are enabled
    public let gesturesEnabled: Bool
    
    // MARK: - Accessibility
    
    /// Accessibility configuration
    public let accessibility: AccessibilityConfiguration
    
    /// Whether VoiceOver is enabled
    public let voiceOverEnabled: Bool
    
    /// Whether Dynamic Type is supported
    public let dynamicTypeEnabled: Bool
    
    /// Whether High Contrast is supported
    public let highContrastEnabled: Bool
    
    // MARK: - Performance
    
    /// Performance configuration
    public let performance: PerformanceConfiguration
    
    /// Whether hardware acceleration is enabled
    public let hardwareAcceleration: Bool
    
    /// Memory limit in MB
    public let memoryLimit: Int
    
    /// Frame rate target
    public let targetFrameRate: Int
    
    // MARK: - Grid and Axes
    
    /// Grid configuration
    public let grid: GridConfiguration
    
    /// X-axis configuration
    public let xAxis: AxisConfiguration
    
    /// Y-axis configuration
    public let yAxis: AxisConfiguration
    
    /// Z-axis configuration (for 3D charts)
    public let zAxis: AxisConfiguration?
    
    // MARK: - Legend
    
    /// Legend configuration
    public let legend: LegendConfiguration
    
    // MARK: - Initialization
    
    /// Creates a new chart configuration with default values
    public init() {
        self.style = .line
        self.theme = .auto
        self.colors = [.blue, .green, .orange, .red, .purple]
        self.backgroundColor = .clear
        self.borderColor = .gray
        self.borderWidth = 0
        self.cornerRadius = 0
        self.shadow = ChartShadow()
        self.animation = .easeInOut(duration: 0.5)
        self.animationDuration = 0.5
        self.animationsEnabled = true
        self.interactive = false
        self.zoomEnabled = false
        self.panEnabled = false
        self.tooltipEnabled = false
        self.selectionEnabled = false
        self.gesturesEnabled = false
        self.accessibility = AccessibilityConfiguration()
        self.voiceOverEnabled = true
        self.dynamicTypeEnabled = true
        self.highContrastEnabled = true
        self.performance = PerformanceConfiguration()
        self.hardwareAcceleration = true
        self.memoryLimit = 100
        self.targetFrameRate = 60
        self.grid = GridConfiguration()
        self.xAxis = AxisConfiguration()
        self.yAxis = AxisConfiguration()
        self.zAxis = nil
        self.legend = LegendConfiguration()
    }
    
    /// Creates a new chart configuration with custom values
    ///
    /// - Parameters:
    ///   - style: Chart style
    ///   - theme: Chart theme
    ///   - colors: Chart colors
    ///   - backgroundColor: Background color
    ///   - borderColor: Border color
    ///   - borderWidth: Border width
    ///   - cornerRadius: Corner radius
    ///   - shadow: Shadow configuration
    ///   - animation: Animation type
    ///   - animationDuration: Animation duration
    ///   - animationsEnabled: Whether animations are enabled
    ///   - interactive: Whether the chart is interactive
    ///   - zoomEnabled: Whether zoom is enabled
    ///   - panEnabled: Whether pan is enabled
    ///   - tooltipEnabled: Whether tooltips are enabled
    ///   - selectionEnabled: Whether selection is enabled
    ///   - gesturesEnabled: Whether gestures are enabled
    ///   - accessibility: Accessibility configuration
    ///   - voiceOverEnabled: Whether VoiceOver is enabled
    ///   - dynamicTypeEnabled: Whether Dynamic Type is supported
    ///   - highContrastEnabled: Whether High Contrast is supported
    ///   - performance: Performance configuration
    ///   - hardwareAcceleration: Whether hardware acceleration is enabled
    ///   - memoryLimit: Memory limit in MB
    ///   - targetFrameRate: Frame rate target
    ///   - grid: Grid configuration
    ///   - xAxis: X-axis configuration
    ///   - yAxis: Y-axis configuration
    ///   - zAxis: Z-axis configuration
    ///   - legend: Legend configuration
    public init(
        style: ChartStyle = .line,
        theme: ChartTheme = .auto,
        colors: [Color] = [.blue, .green, .orange, .red, .purple],
        backgroundColor: Color = .clear,
        borderColor: Color = .gray,
        borderWidth: Double = 0,
        cornerRadius: Double = 0,
        shadow: ChartShadow = ChartShadow(),
        animation: Animation? = .easeInOut(duration: 0.5),
        animationDuration: Double = 0.5,
        animationsEnabled: Bool = true,
        interactive: Bool = false,
        zoomEnabled: Bool = false,
        panEnabled: Bool = false,
        tooltipEnabled: Bool = false,
        selectionEnabled: Bool = false,
        gesturesEnabled: Bool = false,
        accessibility: AccessibilityConfiguration = AccessibilityConfiguration(),
        voiceOverEnabled: Bool = true,
        dynamicTypeEnabled: Bool = true,
        highContrastEnabled: Bool = true,
        performance: PerformanceConfiguration = PerformanceConfiguration(),
        hardwareAcceleration: Bool = true,
        memoryLimit: Int = 100,
        targetFrameRate: Int = 60,
        grid: GridConfiguration = GridConfiguration(),
        xAxis: AxisConfiguration = AxisConfiguration(),
        yAxis: AxisConfiguration = AxisConfiguration(),
        zAxis: AxisConfiguration? = nil,
        legend: LegendConfiguration = LegendConfiguration()
    ) {
        self.style = style
        self.theme = theme
        self.colors = colors
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.animation = animation
        self.animationDuration = animationDuration
        self.animationsEnabled = animationsEnabled
        self.interactive = interactive
        self.zoomEnabled = zoomEnabled
        self.panEnabled = panEnabled
        self.tooltipEnabled = tooltipEnabled
        self.selectionEnabled = selectionEnabled
        self.gesturesEnabled = gesturesEnabled
        self.accessibility = accessibility
        self.voiceOverEnabled = voiceOverEnabled
        self.dynamicTypeEnabled = dynamicTypeEnabled
        self.highContrastEnabled = highContrastEnabled
        self.performance = performance
        self.hardwareAcceleration = hardwareAcceleration
        self.memoryLimit = memoryLimit
        self.targetFrameRate = targetFrameRate
        self.grid = grid
        self.xAxis = xAxis
        self.yAxis = yAxis
        self.zAxis = zAxis
        self.legend = legend
    }
    
    // MARK: - Builder Methods
    
    /// Creates a copy with updated style
    ///
    /// - Parameter style: New chart style
    /// - Returns: New configuration with updated style
    public func withStyle(_ style: ChartStyle) -> ChartConfiguration {
        var config = self
        config.style = style
        return config
    }
    
    /// Creates a copy with updated theme
    ///
    /// - Parameter theme: New chart theme
    /// - Returns: New configuration with updated theme
    public func withTheme(_ theme: ChartTheme) -> ChartConfiguration {
        var config = self
        config.theme = theme
        return config
    }
    
    /// Creates a copy with updated colors
    ///
    /// - Parameter colors: New chart colors
    /// - Returns: New configuration with updated colors
    public func withColors(_ colors: [Color]) -> ChartConfiguration {
        var config = self
        config.colors = colors
        return config
    }
    
    /// Creates a copy with updated animation
    ///
    /// - Parameter animation: New animation
    /// - Returns: New configuration with updated animation
    public func withAnimation(_ animation: Animation?) -> ChartConfiguration {
        var config = self
        config.animation = animation
        return config
    }
    
    /// Creates a copy with updated interaction settings
    ///
    /// - Parameter interactive: Whether the chart is interactive
    /// - Returns: New configuration with updated interaction settings
    public func withInteractive(_ interactive: Bool) -> ChartConfiguration {
        var config = self
        config.interactive = interactive
        config.zoomEnabled = interactive
        config.panEnabled = interactive
        config.tooltipEnabled = interactive
        config.selectionEnabled = interactive
        config.gesturesEnabled = interactive
        return config
    }
    
    /// Creates a copy with updated accessibility settings
    ///
    /// - Parameter accessibility: New accessibility configuration
    /// - Returns: New configuration with updated accessibility settings
    public func withAccessibility(_ accessibility: AccessibilityConfiguration) -> ChartConfiguration {
        var config = self
        config.accessibility = accessibility
        return config
    }
    
    /// Creates a copy with updated performance settings
    ///
    /// - Parameter performance: New performance configuration
    /// - Returns: New configuration with updated performance settings
    public func withPerformance(_ performance: PerformanceConfiguration) -> ChartConfiguration {
        var config = self
        config.performance = performance
        return config
    }
}

// MARK: - Supporting Types

/// Chart style types
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum ChartStyle: String, CaseIterable {
    case line = "line"
    case bar = "bar"
    case pie = "pie"
    case scatter = "scatter"
    case area = "area"
    case candlestick = "candlestick"
    case heatmap = "heatmap"
    case radar = "radar"
    case bubble = "bubble"
    case donut = "donut"
    case stackedBar = "stackedBar"
    case multiLine = "multiLine"
    case gantt = "gantt"
    case waterfall = "waterfall"
    case funnel = "funnel"
    case treemap = "treemap"
    case sunburst = "sunburst"
    case sankey = "sankey"
    case chord = "chord"
    case force = "force"
}

/// Chart theme types
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum ChartTheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case auto = "auto"
}

/// Shadow configuration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ChartShadow: Equatable {
    public let color: Color
    public let radius: Double
    public let x: Double
    public let y: Double
    
    public init(color: Color = .black.opacity(0.1), radius: Double = 4, x: Double = 0, y: Double = 2) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

/// Accessibility configuration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AccessibilityConfiguration: Equatable {
    public let label: String?
    public let hint: String?
    public let value: String?
    public let traits: AccessibilityTraits
    
    public init(label: String? = nil, hint: String? = nil, value: String? = nil, traits: AccessibilityTraits = []) {
        self.label = label
        self.hint = hint
        self.value = value
        self.traits = traits
    }
}

/// Performance configuration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct PerformanceConfiguration: Equatable {
    public let enableLazyLoading: Bool
    public let enableCaching: Bool
    public let enableOptimization: Bool
    public let maxDataPoints: Int
    
    public init(enableLazyLoading: Bool = true, enableCaching: Bool = true, enableOptimization: Bool = true, maxDataPoints: Int = 10000) {
        self.enableLazyLoading = enableLazyLoading
        self.enableCaching = enableCaching
        self.enableOptimization = enableOptimization
        self.maxDataPoints = maxDataPoints
    }
}

/// Grid configuration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct GridConfiguration: Equatable {
    public let enabled: Bool
    public let color: Color
    public let lineWidth: Double
    public let style: GridStyle
    
    public init(enabled: Bool = true, color: Color = .gray.opacity(0.3), lineWidth: Double = 1, style: GridStyle = .solid) {
        self.enabled = enabled
        self.color = color
        self.lineWidth = lineWidth
        self.style = style
    }
}

/// Grid style types
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum GridStyle: String, CaseIterable {
    case solid = "solid"
    case dashed = "dashed"
    case dotted = "dotted"
}

/// Axis configuration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AxisConfiguration: Equatable {
    public let enabled: Bool
    public let title: String?
    public let color: Color
    public let lineWidth: Double
    public let showLabels: Bool
    public let labelRotation: Double
    
    public init(enabled: Bool = true, title: String? = nil, color: Color = .primary, lineWidth: Double = 1, showLabels: Bool = true, labelRotation: Double = 0) {
        self.enabled = enabled
        self.title = title
        self.color = color
        self.lineWidth = lineWidth
        self.showLabels = showLabels
        self.labelRotation = labelRotation
    }
}

/// Legend configuration
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct LegendConfiguration: Equatable {
    public let enabled: Bool
    public let position: LegendPosition
    public let color: Color
    public let fontSize: Double
    
    public init(enabled: Bool = true, position: LegendPosition = .bottom, color: Color = .primary, fontSize: Double = 12) {
        self.enabled = enabled
        self.position = position
        self.color = color
        self.fontSize = fontSize
    }
}

/// Legend position types
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum LegendPosition: String, CaseIterable {
    case top = "top"
    case bottom = "bottom"
    case left = "left"
    case right = "right"
} 