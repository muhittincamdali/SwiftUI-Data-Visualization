import SwiftUI

/// The colors the charts in this package draw with.
///
/// Set a palette for a whole screen with ``SwiftUICore/View/chartPalette(_:)``; every chart
/// below it reads the palette from the environment.
///
/// ```swift
/// DashboardView()
///     .chartPalette(.colorblindSafe)
/// ```
public struct ChartPalette: Hashable, Sendable {
    /// Colors for series and categories, used in order and repeated when there are more series.
    public var series: [Color]
    /// Rising candles and increasing waterfall steps.
    public var positive: Color
    /// Falling candles and decreasing waterfall steps.
    public var negative: Color
    /// Waterfall totals and other reference marks.
    public var neutral: Color
    /// The colors a heatmap blends between, from the lowest to the highest value.
    public var gradient: [Color]

    /// Creates a palette. An empty `series` list falls back to the system accent color.
    public init(series: [Color], positive: Color, negative: Color, neutral: Color, gradient: [Color]) {
        self.series = series
        self.positive = positive
        self.negative = negative
        self.neutral = neutral
        self.gradient = gradient
    }

    /// The color for the series or category at `index`, repeating the list as needed.
    public func color(at index: Int) -> Color {
        guard !series.isEmpty else { return .accentColor }
        let wrapped = index % series.count
        return series[wrapped < 0 ? wrapped + series.count : wrapped]
    }

    /// The colors for `count` series, in order.
    public func colors(count: Int) -> [Color] {
        (0..<max(count, 0)).map(color(at:))
    }

    /// Blues from light to deep, with orange for decreases. The default.
    public static let ocean = ChartPalette(
        series: [
            Color(red: 0.039, green: 0.518, blue: 1.000), // #0A84FF
            Color(red: 0.353, green: 0.784, blue: 0.980), // #5AC8FA
            Color(red: 0.000, green: 0.345, blue: 0.831), // #0058D4
            Color(red: 0.369, green: 0.361, blue: 0.902), // #5E5CE6
            Color(red: 0.392, green: 0.824, blue: 1.000), // #64D2FF
            Color(red: 0.000, green: 0.227, blue: 0.549), // #003A8C
        ],
        positive: Color(red: 0.039, green: 0.518, blue: 1.000), // #0A84FF
        negative: Color(red: 1.000, green: 0.624, blue: 0.039), // #FF9F0A
        neutral: Color(red: 0.369, green: 0.361, blue: 0.902), // #5E5CE6
        gradient: [
            Color(red: 0.039, green: 0.518, blue: 1.000).opacity(0.12),
            Color(red: 0.039, green: 0.518, blue: 1.000).opacity(0.55),
            Color(red: 0.000, green: 0.345, blue: 0.831),
        ]
    )

    /// The Okabe–Ito palette, whose colors stay distinguishable with the common forms of color
    /// blindness. Use it when series must be told apart by color alone.
    public static let colorblindSafe = ChartPalette(
        series: [
            Color(red: 0.000, green: 0.447, blue: 0.698), // #0072B2 blue
            Color(red: 0.902, green: 0.624, blue: 0.000), // #E69F00 orange
            Color(red: 0.000, green: 0.620, blue: 0.451), // #009E73 bluish green
            Color(red: 0.800, green: 0.475, blue: 0.655), // #CC79A7 reddish purple
            Color(red: 0.337, green: 0.706, blue: 0.914), // #56B4E9 sky blue
            Color(red: 0.835, green: 0.369, blue: 0.000), // #D55E00 vermillion
            Color(red: 0.941, green: 0.894, blue: 0.259), // #F0E442 yellow
        ],
        positive: Color(red: 0.000, green: 0.447, blue: 0.698),
        negative: Color(red: 0.835, green: 0.369, blue: 0.000),
        neutral: Color(red: 0.600, green: 0.600, blue: 0.600),
        gradient: [
            Color(red: 0.941, green: 0.894, blue: 0.259),
            Color(red: 0.000, green: 0.620, blue: 0.451),
            Color(red: 0.000, green: 0.447, blue: 0.698),
        ]
    )
}

private struct ChartPaletteKey: EnvironmentKey {
    static let defaultValue = ChartPalette.ocean
}

extension EnvironmentValues {
    /// The palette the charts in this package use. Defaults to ``ChartPalette/ocean``.
    public var chartPalette: ChartPalette {
        get { self[ChartPaletteKey.self] }
        set { self[ChartPaletteKey.self] = newValue }
    }
}

extension View {
    /// Sets the palette for the charts in this view and its descendants.
    public func chartPalette(_ palette: ChartPalette) -> some View {
        environment(\.chartPalette, palette)
    }
}
