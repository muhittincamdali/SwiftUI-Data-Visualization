import SwiftUI

/// Configuration for chart appearance and behavior.
///
/// This model provides comprehensive configuration options for charts including
/// styling, animations, interactions, and accessibility settings.
///
/// ```swift
/// let config = ChartConfiguration(
///     theme: .dark,
///     animation: .easeInOut(duration: 0.8),
///     showGrid: true,
///     showLegend: true
/// )
/// ```
///
/// - Note: All properties have sensible defaults for immediate use.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct ChartConfiguration: Codable, Equatable {
    
    // MARK: - Theme
    
    /// Chart theme (light, dark, or custom)
    public let theme: ChartTheme
    
    /// Custom color palette for the chart
    public let colorPalette: [Color]
    
    /// Background color for the chart area
    public let backgroundColor: Color
    
    /// Border color for the chart area
    public let borderColor: Color
    
    /// Border width for the chart area
    public let borderWidth: Double
    
    // MARK: - Grid and Axes
    
    /// Whether to show the grid
    public let showGrid: Bool
    
    /// Grid line color
    public let gridColor: Color
    
    /// Grid line width
    public let gridWidth: Double
    
    /// Grid line style (solid, dashed, dotted)
    public let gridStyle: GridStyle
    
    /// Whether to show X-axis
    public let showXAxis: Bool
    
    /// Whether to show Y-axis
    public let showYAxis: Bool
    
    /// Axis line color
    public let axisColor: Color
    
    /// Axis line width
    public let axisWidth: Double
    
    /// Axis label font
    public let axisLabelFont: Font
    
    /// Axis label color
    public let axisLabelColor: Color
    
    // MARK: - Legend
    
    /// Whether to show the legend
    public let showLegend: Bool
    
    /// Legend position
    public let legendPosition: LegendPosition
    
    /// Legend font
    public let legendFont: Font
    
    /// Legend text color
    public let legendTextColor: Color
    
    // MARK: - Animation
    
    /// Chart animation
    public let animation: Animation
    
    /// Whether animations are enabled
    public let animationsEnabled: Bool
    
    /// Animation duration for data updates
    public let updateAnimationDuration: Double
    
    /// Animation duration for entrance effects
    public let entranceAnimationDuration: Double
    
    // MARK: - Interaction
    
    /// Whether zoom is enabled
    public let zoomEnabled: Bool
    
    /// Whether pan is enabled
    public let panEnabled: Bool
    
    /// Whether tooltips are enabled
    public let tooltipsEnabled: Bool
    
    /// Whether selection is enabled
    public let selectionEnabled: Bool
    
    /// Whether highlighting is enabled
    public let highlightingEnabled: Bool
    
    // MARK: - Performance
    
    /// Maximum number of data points to render
    public let maxDataPoints: Int
    
    /// Whether to use lazy loading for large datasets
    public let useLazyLoading: Bool
    
    /// Memory limit in MB
    public let memoryLimit: Int
    
    /// Whether to enable GPU acceleration
    public let gpuAcceleration: Bool
    
    // MARK: - Accessibility
    
    /// Whether VoiceOver is enabled
    public let voiceOverEnabled: Bool
    
    /// Whether Dynamic Type is supported
    public let dynamicTypeEnabled: Bool
    
    /// Whether high contrast mode is supported
    public let highContrastEnabled: Bool
    
    /// Whether reduced motion is respected
    public let respectReducedMotion: Bool
    
    // MARK: - Initialization
    
    /// Creates a new chart configuration with default values.
    public init() {
        self.theme = .light
        self.colorPalette = [.blue, .green, .orange, .red, .purple, .yellow, .pink, .gray]
        self.backgroundColor = .clear
        self.borderColor = .gray.opacity(0.3)
        self.borderWidth = 1.0
        self.showGrid = true
        self.gridColor = .gray.opacity(0.2)
        self.gridWidth = 1.0
        self.gridStyle = .solid
        self.showXAxis = true
        self.showYAxis = true
        self.axisColor = .gray
        self.axisWidth = 1.0
        self.axisLabelFont = .caption
        self.axisLabelColor = .primary
        self.showLegend = true
        self.legendPosition = .bottom
        self.legendFont = .caption
        self.legendTextColor = .primary
        self.animation = .easeInOut(duration: 0.8)
        self.animationsEnabled = true
        self.updateAnimationDuration = 0.3
        self.entranceAnimationDuration = 0.8
        self.zoomEnabled = true
        self.panEnabled = true
        self.tooltipsEnabled = true
        self.selectionEnabled = true
        self.highlightingEnabled = true
        self.maxDataPoints = 10000
        self.useLazyLoading = true
        self.memoryLimit = 150
        self.gpuAcceleration = true
        self.voiceOverEnabled = true
        self.dynamicTypeEnabled = true
        self.highContrastEnabled = true
        self.respectReducedMotion = true
    }
    
    /// Creates a new chart configuration with custom values.
    ///
    /// - Parameters:
    ///   - theme: Chart theme
    ///   - colorPalette: Custom color palette
    ///   - backgroundColor: Background color
    ///   - borderColor: Border color
    ///   - borderWidth: Border width
    ///   - showGrid: Whether to show grid
    ///   - gridColor: Grid color
    ///   - gridWidth: Grid width
    ///   - gridStyle: Grid style
    ///   - showXAxis: Whether to show X-axis
    ///   - showYAxis: Whether to show Y-axis
    ///   - axisColor: Axis color
    ///   - axisWidth: Axis width
    ///   - axisLabelFont: Axis label font
    ///   - axisLabelColor: Axis label color
    ///   - showLegend: Whether to show legend
    ///   - legendPosition: Legend position
    ///   - legendFont: Legend font
    ///   - legendTextColor: Legend text color
    ///   - animation: Chart animation
    ///   - animationsEnabled: Whether animations are enabled
    ///   - updateAnimationDuration: Update animation duration
    ///   - entranceAnimationDuration: Entrance animation duration
    ///   - zoomEnabled: Whether zoom is enabled
    ///   - panEnabled: Whether pan is enabled
    ///   - tooltipsEnabled: Whether tooltips are enabled
    ///   - selectionEnabled: Whether selection is enabled
    ///   - highlightingEnabled: Whether highlighting is enabled
    ///   - maxDataPoints: Maximum data points
    ///   - useLazyLoading: Whether to use lazy loading
    ///   - memoryLimit: Memory limit in MB
    ///   - gpuAcceleration: Whether to use GPU acceleration
    ///   - voiceOverEnabled: Whether VoiceOver is enabled
    ///   - dynamicTypeEnabled: Whether Dynamic Type is enabled
    ///   - highContrastEnabled: Whether high contrast is enabled
    ///   - respectReducedMotion: Whether to respect reduced motion
    public init(
        theme: ChartTheme = .light,
        colorPalette: [Color] = [.blue, .green, .orange, .red, .purple, .yellow, .pink, .gray],
        backgroundColor: Color = .clear,
        borderColor: Color = .gray.opacity(0.3),
        borderWidth: Double = 1.0,
        showGrid: Bool = true,
        gridColor: Color = .gray.opacity(0.2),
        gridWidth: Double = 1.0,
        gridStyle: GridStyle = .solid,
        showXAxis: Bool = true,
        showYAxis: Bool = true,
        axisColor: Color = .gray,
        axisWidth: Double = 1.0,
        axisLabelFont: Font = .caption,
        axisLabelColor: Color = .primary,
        showLegend: Bool = true,
        legendPosition: LegendPosition = .bottom,
        legendFont: Font = .caption,
        legendTextColor: Color = .primary,
        animation: Animation = .easeInOut(duration: 0.8),
        animationsEnabled: Bool = true,
        updateAnimationDuration: Double = 0.3,
        entranceAnimationDuration: Double = 0.8,
        zoomEnabled: Bool = true,
        panEnabled: Bool = true,
        tooltipsEnabled: Bool = true,
        selectionEnabled: Bool = true,
        highlightingEnabled: Bool = true,
        maxDataPoints: Int = 10000,
        useLazyLoading: Bool = true,
        memoryLimit: Int = 150,
        gpuAcceleration: Bool = true,
        voiceOverEnabled: Bool = true,
        dynamicTypeEnabled: Bool = true,
        highContrastEnabled: Bool = true,
        respectReducedMotion: Bool = true
    ) {
        self.theme = theme
        self.colorPalette = colorPalette
        self.backgroundColor = backgroundColor
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.showGrid = showGrid
        self.gridColor = gridColor
        self.gridWidth = gridWidth
        self.gridStyle = gridStyle
        self.showXAxis = showXAxis
        self.showYAxis = showYAxis
        self.axisColor = axisColor
        self.axisWidth = axisWidth
        self.axisLabelFont = axisLabelFont
        self.axisLabelColor = axisLabelColor
        self.showLegend = showLegend
        self.legendPosition = legendPosition
        self.legendFont = legendFont
        self.legendTextColor = legendTextColor
        self.animation = animation
        self.animationsEnabled = animationsEnabled
        self.updateAnimationDuration = updateAnimationDuration
        self.entranceAnimationDuration = entranceAnimationDuration
        self.zoomEnabled = zoomEnabled
        self.panEnabled = panEnabled
        self.tooltipsEnabled = tooltipsEnabled
        self.selectionEnabled = selectionEnabled
        self.highlightingEnabled = highlightingEnabled
        self.maxDataPoints = maxDataPoints
        self.useLazyLoading = useLazyLoading
        self.memoryLimit = memoryLimit
        self.gpuAcceleration = gpuAcceleration
        self.voiceOverEnabled = voiceOverEnabled
        self.dynamicTypeEnabled = dynamicTypeEnabled
        self.highContrastEnabled = highContrastEnabled
        self.respectReducedMotion = respectReducedMotion
    }
    
    // MARK: - Convenience Initializers
    
    /// Creates a dark theme configuration.
    public static var dark: ChartConfiguration {
        return ChartConfiguration(
            theme: .dark,
            backgroundColor: Color(.systemGray6),
            borderColor: .gray.opacity(0.5),
            gridColor: .gray.opacity(0.3),
            axisColor: .gray,
            axisLabelColor: .white,
            legendTextColor: .white
        )
    }
    
    /// Creates a light theme configuration.
    public static var light: ChartConfiguration {
        return ChartConfiguration(
            theme: .light,
            backgroundColor: .white,
            borderColor: .gray.opacity(0.3),
            gridColor: .gray.opacity(0.2),
            axisColor: .gray,
            axisLabelColor: .black,
            legendTextColor: .black
        )
    }
    
    /// Creates a minimal configuration with no grid or axes.
    public static var minimal: ChartConfiguration {
        return ChartConfiguration(
            showGrid: false,
            showXAxis: false,
            showYAxis: false,
            showLegend: false
        )
    }
    
    /// Creates a performance-optimized configuration.
    public static var performance: ChartConfiguration {
        return ChartConfiguration(
            animationsEnabled: false,
            maxDataPoints: 5000,
            useLazyLoading: true,
            memoryLimit: 100,
            gpuAcceleration: true
        )
    }
    
    // MARK: - Mutating Methods
    
    /// Returns a new configuration with updated theme.
    ///
    /// - Parameter theme: New theme
    /// - Returns: Updated configuration
    public func withTheme(_ theme: ChartTheme) -> ChartConfiguration {
        var copy = self
        copy.theme = theme
        return copy
    }
    
    /// Returns a new configuration with updated color palette.
    ///
    /// - Parameter colorPalette: New color palette
    /// - Returns: Updated configuration
    public func withColorPalette(_ colorPalette: [Color]) -> ChartConfiguration {
        var copy = self
        copy.colorPalette = colorPalette
        return copy
    }
    
    /// Returns a new configuration with updated animation.
    ///
    /// - Parameter animation: New animation
    /// - Returns: Updated configuration
    public func withAnimation(_ animation: Animation) -> ChartConfiguration {
        var copy = self
        copy.animation = animation
        return copy
    }
    
    /// Returns a new configuration with animations disabled.
    ///
    /// - Returns: Updated configuration
    public func withoutAnimations() -> ChartConfiguration {
        var copy = self
        copy.animationsEnabled = false
        return copy
    }
    
    /// Returns a new configuration with interactions disabled.
    ///
    /// - Returns: Updated configuration
    public func withoutInteractions() -> ChartConfiguration {
        var copy = self
        copy.zoomEnabled = false
        copy.panEnabled = false
        copy.tooltipsEnabled = false
        copy.selectionEnabled = false
        copy.highlightingEnabled = false
        return copy
    }
}

// MARK: - Supporting Types

/// Chart theme options.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum ChartTheme: String, CaseIterable, Codable {
    case light
    case dark
    case custom
}

/// Grid line styles.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum GridStyle: String, CaseIterable, Codable {
    case solid
    case dashed
    case dotted
}

/// Legend position options.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum LegendPosition: String, CaseIterable, Codable {
    case top
    case bottom
    case left
    case right
    case none
}

// MARK: - Codable Implementation

extension ChartConfiguration {
    private enum CodingKeys: String, CodingKey {
        case theme, backgroundColor, borderColor, borderWidth, showGrid, gridColor, gridWidth, gridStyle
        case showXAxis, showYAxis, axisColor, axisWidth, axisLabelFont, axisLabelColor
        case showLegend, legendPosition, legendFont, legendTextColor
        case animation, animationsEnabled, updateAnimationDuration, entranceAnimationDuration
        case zoomEnabled, panEnabled, tooltipsEnabled, selectionEnabled, highlightingEnabled
        case maxDataPoints, useLazyLoading, memoryLimit, gpuAcceleration
        case voiceOverEnabled, dynamicTypeEnabled, highContrastEnabled, respectReducedMotion
        case colorPaletteHex = "colorPalette"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        theme = try container.decode(ChartTheme.self, forKey: .theme)
        backgroundColor = try container.decode(Color.self, forKey: .backgroundColor)
        borderColor = try container.decode(Color.self, forKey: .borderColor)
        borderWidth = try container.decode(Double.self, forKey: .borderWidth)
        showGrid = try container.decode(Bool.self, forKey: .showGrid)
        gridColor = try container.decode(Color.self, forKey: .gridColor)
        gridWidth = try container.decode(Double.self, forKey: .gridWidth)
        gridStyle = try container.decode(GridStyle.self, forKey: .gridStyle)
        showXAxis = try container.decode(Bool.self, forKey: .showXAxis)
        showYAxis = try container.decode(Bool.self, forKey: .showYAxis)
        axisColor = try container.decode(Color.self, forKey: .axisColor)
        axisWidth = try container.decode(Double.self, forKey: .axisWidth)
        axisLabelFont = try container.decode(Font.self, forKey: .axisLabelFont)
        axisLabelColor = try container.decode(Color.self, forKey: .axisLabelColor)
        showLegend = try container.decode(Bool.self, forKey: .showLegend)
        legendPosition = try container.decode(LegendPosition.self, forKey: .legendPosition)
        legendFont = try container.decode(Font.self, forKey: .legendFont)
        legendTextColor = try container.decode(Color.self, forKey: .legendTextColor)
        animation = try container.decode(Animation.self, forKey: .animation)
        animationsEnabled = try container.decode(Bool.self, forKey: .animationsEnabled)
        updateAnimationDuration = try container.decode(Double.self, forKey: .updateAnimationDuration)
        entranceAnimationDuration = try container.decode(Double.self, forKey: .entranceAnimationDuration)
        zoomEnabled = try container.decode(Bool.self, forKey: .zoomEnabled)
        panEnabled = try container.decode(Bool.self, forKey: .panEnabled)
        tooltipsEnabled = try container.decode(Bool.self, forKey: .tooltipsEnabled)
        selectionEnabled = try container.decode(Bool.self, forKey: .selectionEnabled)
        highlightingEnabled = try container.decode(Bool.self, forKey: .highlightingEnabled)
        maxDataPoints = try container.decode(Int.self, forKey: .maxDataPoints)
        useLazyLoading = try container.decode(Bool.self, forKey: .useLazyLoading)
        memoryLimit = try container.decode(Int.self, forKey: .memoryLimit)
        gpuAcceleration = try container.decode(Bool.self, forKey: .gpuAcceleration)
        voiceOverEnabled = try container.decode(Bool.self, forKey: .voiceOverEnabled)
        dynamicTypeEnabled = try container.decode(Bool.self, forKey: .dynamicTypeEnabled)
        highContrastEnabled = try container.decode(Bool.self, forKey: .highContrastEnabled)
        respectReducedMotion = try container.decode(Bool.self, forKey: .respectReducedMotion)
        
        // Decode color palette from hex strings
        if let colorPaletteHex = try container.decodeIfPresent([String].self, forKey: .colorPaletteHex) {
            colorPalette = colorPaletteHex.compactMap { Color(hex: $0) }
        } else {
            colorPalette = [.blue, .green, .orange, .red, .purple, .yellow, .pink, .gray]
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(theme, forKey: .theme)
        try container.encode(backgroundColor, forKey: .backgroundColor)
        try container.encode(borderColor, forKey: .borderColor)
        try container.encode(borderWidth, forKey: .borderWidth)
        try container.encode(showGrid, forKey: .showGrid)
        try container.encode(gridColor, forKey: .gridColor)
        try container.encode(gridWidth, forKey: .gridWidth)
        try container.encode(gridStyle, forKey: .gridStyle)
        try container.encode(showXAxis, forKey: .showXAxis)
        try container.encode(showYAxis, forKey: .showYAxis)
        try container.encode(axisColor, forKey: .axisColor)
        try container.encode(axisWidth, forKey: .axisWidth)
        try container.encode(axisLabelFont, forKey: .axisLabelFont)
        try container.encode(axisLabelColor, forKey: .axisLabelColor)
        try container.encode(showLegend, forKey: .showLegend)
        try container.encode(legendPosition, forKey: .legendPosition)
        try container.encode(legendFont, forKey: .legendFont)
        try container.encode(legendTextColor, forKey: .legendTextColor)
        try container.encode(animation, forKey: .animation)
        try container.encode(animationsEnabled, forKey: .animationsEnabled)
        try container.encode(updateAnimationDuration, forKey: .updateAnimationDuration)
        try container.encode(entranceAnimationDuration, forKey: .entranceAnimationDuration)
        try container.encode(zoomEnabled, forKey: .zoomEnabled)
        try container.encode(panEnabled, forKey: .panEnabled)
        try container.encode(tooltipsEnabled, forKey: .tooltipsEnabled)
        try container.encode(selectionEnabled, forKey: .selectionEnabled)
        try container.encode(highlightingEnabled, forKey: .highlightingEnabled)
        try container.encode(maxDataPoints, forKey: .maxDataPoints)
        try container.encode(useLazyLoading, forKey: .useLazyLoading)
        try container.encode(memoryLimit, forKey: .memoryLimit)
        try container.encode(gpuAcceleration, forKey: .gpuAcceleration)
        try container.encode(voiceOverEnabled, forKey: .voiceOverEnabled)
        try container.encode(dynamicTypeEnabled, forKey: .dynamicTypeEnabled)
        try container.encode(highContrastEnabled, forKey: .highContrastEnabled)
        try container.encode(respectReducedMotion, forKey: .respectReducedMotion)
        
        // Encode color palette as hex strings
        let colorPaletteHex = colorPalette.map { $0.toHex() }
        try container.encode(colorPaletteHex, forKey: .colorPaletteHex)
    }
} 