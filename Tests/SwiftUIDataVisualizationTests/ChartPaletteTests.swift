import SwiftUI
import Testing
@testable import SwiftUIDataVisualization

@Suite("Chart palette")
struct ChartPaletteTests {
    private let palette = ChartPalette(series: [.red, .green, .blue], positive: .blue, negative: .orange, neutral: .gray, gradient: [])

    @Test func colorsRepeatPastTheEndOfTheList() {
        #expect(palette.color(at: 0) == .red)
        #expect(palette.color(at: 3) == .red)
        #expect(palette.color(at: 7) == .green)
        #expect(palette.colors(count: 4) == [.red, .green, .blue, .red])
    }

    @Test func negativeIndicesAndCountsAreSafe() {
        #expect(palette.color(at: -1) == .blue)
        #expect(palette.colors(count: -2).isEmpty)
    }

    @Test func emptySeriesFallsBackToTheAccentColor() {
        let empty = ChartPalette(series: [], positive: .blue, negative: .orange, neutral: .gray, gradient: [])
        #expect(empty.color(at: 2) == .accentColor)
    }

    @Test func environmentDefaultsToOcean() {
        #expect(EnvironmentValues().chartPalette == .ocean)
        var values = EnvironmentValues()
        values.chartPalette = .colorblindSafe
        #expect(values.chartPalette == .colorblindSafe)
    }

    @Test func builtInPalettesHaveDistinctSeriesColors() {
        for palette in [ChartPalette.ocean, .colorblindSafe] {
            #expect(Set(palette.series).count == palette.series.count)
            #expect(palette.positive != palette.negative)
            #expect(palette.gradient.count >= 2)
        }
    }
}
