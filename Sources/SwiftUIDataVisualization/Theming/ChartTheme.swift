// ChartTheme.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Chart Theme Protocol

/// Protocol defining chart theme requirements
public protocol ChartThemable {
    var primaryColor: Color { get }
    var secondaryColor: Color { get }
    var accentColor: Color { get }
    var backgroundColor: Color { get }
    var gridColor: Color { get }
    var textColor: Color { get }
    var axisColor: Color { get }
    var colorPalette: [Color] { get }
    var font: Font { get }
    var titleFont: Font { get }
    var labelFont: Font { get }
    var animationDuration: Double { get }
}

// MARK: - Chart Theme

/// A comprehensive theme configuration for charts
public struct ChartTheme: ChartThemable {
    public var primaryColor: Color
    public var secondaryColor: Color
    public var accentColor: Color
    public var backgroundColor: Color
    public var gridColor: Color
    public var textColor: Color
    public var axisColor: Color
    public var colorPalette: [Color]
    public var font: Font
    public var titleFont: Font
    public var labelFont: Font
    public var animationDuration: Double
    
    // Additional styling
    public var cornerRadius: CGFloat
    public var lineWidth: CGFloat
    public var pointSize: CGFloat
    public var shadowRadius: CGFloat
    public var shadowColor: Color
    public var gradientOpacity: Double
    public var showGrid: Bool
    public var showLabels: Bool
    public var showLegend: Bool
    
    public init(
        primaryColor: Color = .blue,
        secondaryColor: Color = .gray,
        accentColor: Color = .orange,
        backgroundColor: Color = Color(.systemBackground),
        gridColor: Color = Color.gray.opacity(0.2),
        textColor: Color = .primary,
        axisColor: Color = .gray,
        colorPalette: [Color] = ChartTheme.defaultPalette,
        font: Font = .body,
        titleFont: Font = .headline,
        labelFont: Font = .caption,
        animationDuration: Double = 0.5,
        cornerRadius: CGFloat = 8,
        lineWidth: CGFloat = 2,
        pointSize: CGFloat = 6,
        shadowRadius: CGFloat = 4,
        shadowColor: Color = .black.opacity(0.1),
        gradientOpacity: Double = 0.3,
        showGrid: Bool = true,
        showLabels: Bool = true,
        showLegend: Bool = true
    ) {
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.accentColor = accentColor
        self.backgroundColor = backgroundColor
        self.gridColor = gridColor
        self.textColor = textColor
        self.axisColor = axisColor
        self.colorPalette = colorPalette
        self.font = font
        self.titleFont = titleFont
        self.labelFont = labelFont
        self.animationDuration = animationDuration
        self.cornerRadius = cornerRadius
        self.lineWidth = lineWidth
        self.pointSize = pointSize
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.gradientOpacity = gradientOpacity
        self.showGrid = showGrid
        self.showLabels = showLabels
        self.showLegend = showLegend
    }
    
    // MARK: - Default Color Palette
    
    public static let defaultPalette: [Color] = [
        .blue,
        .green,
        .orange,
        .purple,
        .red,
        .teal,
        .pink,
        .indigo,
        .yellow,
        .cyan
    ]
}

// MARK: - Pre-built Themes

extension ChartTheme {
    
    /// Default light theme
    public static let light = ChartTheme(
        primaryColor: .blue,
        secondaryColor: .gray,
        accentColor: .orange,
        backgroundColor: .white,
        gridColor: Color.gray.opacity(0.15),
        textColor: .black,
        axisColor: Color.gray.opacity(0.5)
    )
    
    /// Default dark theme
    public static let dark = ChartTheme(
        primaryColor: Color(red: 0.4, green: 0.6, blue: 1.0),
        secondaryColor: Color.gray.opacity(0.7),
        accentColor: Color.orange,
        backgroundColor: Color(red: 0.1, green: 0.1, blue: 0.15),
        gridColor: Color.white.opacity(0.1),
        textColor: .white,
        axisColor: Color.white.opacity(0.3)
    )
    
    /// Vibrant colorful theme
    public static let vibrant = ChartTheme(
        primaryColor: Color(red: 1.0, green: 0.4, blue: 0.4),
        secondaryColor: Color(red: 0.4, green: 0.8, blue: 0.6),
        accentColor: Color(red: 1.0, green: 0.8, blue: 0.2),
        backgroundColor: Color(.systemBackground),
        colorPalette: [
            Color(red: 1.0, green: 0.4, blue: 0.4),
            Color(red: 0.4, green: 0.8, blue: 0.6),
            Color(red: 1.0, green: 0.8, blue: 0.2),
            Color(red: 0.4, green: 0.6, blue: 1.0),
            Color(red: 0.9, green: 0.5, blue: 0.9)
        ],
        animationDuration: 0.6
    )
    
    /// Minimalist monochrome theme
    public static let minimal = ChartTheme(
        primaryColor: .black,
        secondaryColor: Color.gray.opacity(0.5),
        accentColor: .black,
        backgroundColor: .white,
        gridColor: Color.gray.opacity(0.1),
        textColor: .black,
        axisColor: Color.gray.opacity(0.3),
        colorPalette: [
            Color.black,
            Color.gray.opacity(0.7),
            Color.gray.opacity(0.5),
            Color.gray.opacity(0.3)
        ],
        lineWidth: 1.5,
        shadowRadius: 0,
        showGrid: false
    )
    
    /// Ocean blue theme
    public static let ocean = ChartTheme(
        primaryColor: Color(red: 0.0, green: 0.5, blue: 0.8),
        secondaryColor: Color(red: 0.2, green: 0.7, blue: 0.9),
        accentColor: Color(red: 0.0, green: 0.8, blue: 0.7),
        backgroundColor: Color(red: 0.95, green: 0.98, blue: 1.0),
        gridColor: Color(red: 0.0, green: 0.5, blue: 0.8).opacity(0.1),
        colorPalette: [
            Color(red: 0.0, green: 0.5, blue: 0.8),
            Color(red: 0.2, green: 0.7, blue: 0.9),
            Color(red: 0.0, green: 0.8, blue: 0.7),
            Color(red: 0.4, green: 0.6, blue: 0.9),
            Color(red: 0.1, green: 0.4, blue: 0.6)
        ]
    )
    
    /// Sunset warm theme
    public static let sunset = ChartTheme(
        primaryColor: Color(red: 1.0, green: 0.5, blue: 0.3),
        secondaryColor: Color(red: 1.0, green: 0.7, blue: 0.4),
        accentColor: Color(red: 0.9, green: 0.3, blue: 0.4),
        backgroundColor: Color(red: 1.0, green: 0.98, blue: 0.95),
        gridColor: Color.orange.opacity(0.1),
        colorPalette: [
            Color(red: 1.0, green: 0.5, blue: 0.3),
            Color(red: 1.0, green: 0.7, blue: 0.4),
            Color(red: 0.9, green: 0.3, blue: 0.4),
            Color(red: 0.95, green: 0.6, blue: 0.5),
            Color(red: 0.8, green: 0.4, blue: 0.5)
        ]
    )
    
    /// Forest green theme
    public static let forest = ChartTheme(
        primaryColor: Color(red: 0.2, green: 0.6, blue: 0.4),
        secondaryColor: Color(red: 0.4, green: 0.7, blue: 0.5),
        accentColor: Color(red: 0.6, green: 0.8, blue: 0.3),
        backgroundColor: Color(red: 0.96, green: 0.98, blue: 0.96),
        gridColor: Color.green.opacity(0.1),
        colorPalette: [
            Color(red: 0.2, green: 0.6, blue: 0.4),
            Color(red: 0.4, green: 0.7, blue: 0.5),
            Color(red: 0.6, green: 0.8, blue: 0.3),
            Color(red: 0.3, green: 0.5, blue: 0.3),
            Color(red: 0.5, green: 0.7, blue: 0.6)
        ]
    )
    
    /// Neon cyberpunk theme
    public static let neon = ChartTheme(
        primaryColor: Color(red: 0.0, green: 1.0, blue: 0.8),
        secondaryColor: Color(red: 1.0, green: 0.0, blue: 0.8),
        accentColor: Color(red: 1.0, green: 1.0, blue: 0.0),
        backgroundColor: Color(red: 0.05, green: 0.05, blue: 0.1),
        gridColor: Color.cyan.opacity(0.15),
        textColor: .white,
        axisColor: Color.cyan.opacity(0.3),
        colorPalette: [
            Color(red: 0.0, green: 1.0, blue: 0.8),
            Color(red: 1.0, green: 0.0, blue: 0.8),
            Color(red: 1.0, green: 1.0, blue: 0.0),
            Color(red: 0.5, green: 0.0, blue: 1.0),
            Color(red: 0.0, green: 0.8, blue: 1.0)
        ],
        shadowColor: Color.cyan.opacity(0.3),
        gradientOpacity: 0.5
    )
    
    /// Corporate professional theme
    public static let corporate = ChartTheme(
        primaryColor: Color(red: 0.2, green: 0.3, blue: 0.5),
        secondaryColor: Color(red: 0.4, green: 0.5, blue: 0.6),
        accentColor: Color(red: 0.8, green: 0.6, blue: 0.2),
        backgroundColor: Color(red: 0.98, green: 0.98, blue: 0.98),
        gridColor: Color.gray.opacity(0.15),
        colorPalette: [
            Color(red: 0.2, green: 0.3, blue: 0.5),
            Color(red: 0.4, green: 0.5, blue: 0.6),
            Color(red: 0.8, green: 0.6, blue: 0.2),
            Color(red: 0.5, green: 0.4, blue: 0.3),
            Color(red: 0.3, green: 0.4, blue: 0.5)
        ],
        titleFont: .system(size: 16, weight: .semibold),
        labelFont: .system(size: 11)
    )
}

// MARK: - Theme Environment Key

private struct ChartThemeKey: EnvironmentKey {
    static let defaultValue: ChartTheme = .light
}

extension EnvironmentValues {
    public var chartTheme: ChartTheme {
        get { self[ChartThemeKey.self] }
        set { self[ChartThemeKey.self] = newValue }
    }
}

// MARK: - Theme Modifier

extension View {
    /// Apply a chart theme to all child charts
    public func chartTheme(_ theme: ChartTheme) -> some View {
        environment(\.chartTheme, theme)
    }
}

// MARK: - Theme Builder

/// Builder for creating custom themes
public struct ChartThemeBuilder {
    private var theme: ChartTheme
    
    public init(base: ChartTheme = .light) {
        self.theme = base
    }
    
    public func primaryColor(_ color: Color) -> ChartThemeBuilder {
        var builder = self
        builder.theme.primaryColor = color
        return builder
    }
    
    public func secondaryColor(_ color: Color) -> ChartThemeBuilder {
        var builder = self
        builder.theme.secondaryColor = color
        return builder
    }
    
    public func accentColor(_ color: Color) -> ChartThemeBuilder {
        var builder = self
        builder.theme.accentColor = color
        return builder
    }
    
    public func backgroundColor(_ color: Color) -> ChartThemeBuilder {
        var builder = self
        builder.theme.backgroundColor = color
        return builder
    }
    
    public func colorPalette(_ colors: [Color]) -> ChartThemeBuilder {
        var builder = self
        builder.theme.colorPalette = colors
        return builder
    }
    
    public func font(_ font: Font) -> ChartThemeBuilder {
        var builder = self
        builder.theme.font = font
        return builder
    }
    
    public func animationDuration(_ duration: Double) -> ChartThemeBuilder {
        var builder = self
        builder.theme.animationDuration = duration
        return builder
    }
    
    public func showGrid(_ show: Bool) -> ChartThemeBuilder {
        var builder = self
        builder.theme.showGrid = show
        return builder
    }
    
    public func build() -> ChartTheme {
        return theme
    }
}

// MARK: - Color Extension

extension Color {
    /// Generate a gradient from the color
    public func gradient(to endColor: Color? = nil) -> LinearGradient {
        LinearGradient(
            colors: [self, endColor ?? self.opacity(0.5)],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// Generate complementary color
    public var complementary: Color {
        // This is a simplified version - in production you'd want proper color math
        return self.opacity(0.7)
    }
}

// MARK: - Preview

#if DEBUG
struct ChartTheme_Previews: PreviewProvider {
    static var themes: [(name: String, theme: ChartTheme)] = [
        ("Light", .light),
        ("Dark", .dark),
        ("Vibrant", .vibrant),
        ("Ocean", .ocean),
        ("Sunset", .sunset),
        ("Neon", .neon)
    ]
    
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                ForEach(themes, id: \.name) { item in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.name)
                            .font(.headline)
                        
                        HStack(spacing: 4) {
                            ForEach(item.theme.colorPalette.prefix(5), id: \.self) { color in
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(color)
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                    .padding()
                    .background(item.theme.backgroundColor)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
    }
}
#endif
