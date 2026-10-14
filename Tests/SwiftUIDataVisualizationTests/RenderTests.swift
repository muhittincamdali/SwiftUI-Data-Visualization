import CoreGraphics
import Foundation
import SwiftUI
import Testing
@testable import SwiftUIDataVisualization

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

/// The README samples that have screenshots, rendered off screen.
enum Gallery: String, CaseIterable {
    case timeSeries = "time-series"
    case statistics
    case trendLine = "trend-line"
    case finance
    case heatmap
    case radarAndTreemap = "radar-treemap"

    @MainActor @ViewBuilder
    var view: some View {
        switch self {
        case .timeSeries: ServerLoad()
        case .statistics: LatencyReport()
        case .trendLine: HeightWeight()
        case .finance: PriceAndProfit()
        case .heatmap: CommitActivity()
        case .radarAndTreemap: ProfileAndStorage()
        }
    }

    @MainActor
    func canvas(colorScheme: ColorScheme) -> some View {
        view
            .frame(width: 390)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .environment(\.colorScheme, colorScheme)
    }
}

/// Renders every chart with ImageRenderer. This catches charts that crash, lay out to an empty
/// size or draw nothing, and, when `SCREENSHOT_DIR` is set, writes the PNGs used in the README.
@MainActor
@Suite("Rendering")
struct RenderTests {
    @Test("README sample renders", arguments: Gallery.allCases, [ColorScheme.light, .dark])
    func rendersGalleryPage(page: Gallery, scheme: ColorScheme) throws {
        let renderer = ImageRenderer(content: page.canvas(colorScheme: scheme))
        renderer.scale = 2
        let image = try #require(renderer.cgImage)
        #expect(image.width == 780)
        #expect(image.height > 200)
        #expect(try drawnFraction(of: image) > 0.02, "\(page) drew almost nothing")

        if let directory = ProcessInfo.processInfo.environment["SCREENSHOT_DIR"] {
            let name = "\(page.rawValue)-\(scheme == .dark ? "dark" : "light").png"
            try writePNG(image, to: URL(fileURLWithPath: directory).appendingPathComponent(name))
        }
    }

    @Test func quickStartAndLiveSamplesRender() throws {
        for view in [AnyView(ContentView()), AnyView(ScrollingHistory()), AnyView(LiveLoad()), AnyView(ColorblindSafeCharts())] {
            let image = try #require(ImageRenderer(content: view.frame(width: 390)).cgImage)
            #expect(image.height > 50)
        }
    }

    @Test func liveTickerDrawsItsValues() throws {
        let chart = LiveTickerChart(values: (0..<120).map { sin(Double($0) / 8) }).frame(width: 300, height: 80)
        let image = try #require(ImageRenderer(content: chart).cgImage)
        #expect(try drawnFraction(of: image) > 0.05)
    }

    /// Each chart given only data it cannot draw, the same chart given no data, and given data
    /// it can draw.
    private static var unusableEmptyAndUsableCharts: [(name: String, unusable: AnyView, empty: AnyView, usable: AnyView)] {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        let candle = Candle(date: date, open: 1, high: 3, low: 0, close: 2)
        return [
            ("time series",
             AnyView(TimeSeriesChart(TimeSeries(name: "A", points: [.init(date: date, value: .nan)]))),
             AnyView(TimeSeriesChart(TimeSeries(name: "A", points: []))),
             AnyView(TimeSeriesChart(TimeSeries(name: "A", values: [1, 3, 2], start: date, interval: 60)))),
            ("scatter",
             AnyView(ScatterChart([PlotPoint(x: .nan, y: 1)], showsTrendLine: true)),
             AnyView(ScatterChart([], showsTrendLine: true)),
             AnyView(ScatterChart([PlotPoint(x: 1, y: 1), PlotPoint(x: 2, y: 3)], showsTrendLine: true))),
            ("histogram",
             AnyView(HistogramChart(values: [.nan, .infinity])),
             AnyView(HistogramChart(values: [])),
             AnyView(HistogramChart(values: [1, 2, 2, 3]))),
            ("box plot",
             AnyView(BoxPlotChart([.init(name: "A", values: [.nan])])),
             AnyView(BoxPlotChart([])),
             AnyView(BoxPlotChart([.init(name: "A", values: [1, 2, 3, 4, 9])]))),
            ("candlestick",
             AnyView(CandlestickChart([Candle(date: date, open: 1, high: 0, low: 2, close: 1)])),
             AnyView(CandlestickChart([])),
             AnyView(CandlestickChart([candle]))),
            ("heatmap",
             AnyView(HeatmapChart([HeatmapCell(column: "a", row: "b", value: .infinity)])),
             AnyView(HeatmapChart([])),
             AnyView(HeatmapChart([HeatmapCell(column: "a", row: "b", value: 1), HeatmapCell(column: "c", row: "b", value: 2)]))),
            ("waterfall",
             AnyView(WaterfallChart([WaterfallStep("A", .nan)])),
             AnyView(WaterfallChart([])),
             AnyView(WaterfallChart([WaterfallStep("A", 5), WaterfallStep("B", -2)]))),
            ("radar",
             AnyView(RadarChart(axes: ["A", "B"], series: [.init(name: "S", values: [1, 2])])),
             AnyView(RadarChart(axes: [], series: [])),
             AnyView(RadarChart(axes: ["A", "B", "C"], series: [.init(name: "S", values: [1, 2, 3])]))),
            ("treemap",
             AnyView(TreemapChart([TreemapItem("Zero", value: 0)])),
             AnyView(TreemapChart([])),
             AnyView(TreemapChart([TreemapItem("One", value: 1)]))),
            ("live ticker",
             AnyView(LiveTickerChart(values: [.nan, .infinity])),
             AnyView(LiveTickerChart(values: [])),
             AnyView(LiveTickerChart(values: [1, 3, 2]))),
        ]
    }

    /// An empty render matches the chart with no data, and the comparison would notice a mark:
    /// the same chart with drawable data renders differently.
    @Test func chartsWithoutUsableDataRenderEmpty() throws {
        for chart in Self.unusableEmptyAndUsableCharts {
            let unusable = try pixels(of: render(chart.unusable))
            let empty = try pixels(of: render(chart.empty))
            let usable = try pixels(of: render(chart.usable))
            #expect(unusable == empty, "\(chart.name) drew something for unusable data")
            #expect(usable != empty, "\(chart.name) drew nothing for usable data")
        }
    }

    private func render(_ view: AnyView) throws -> CGImage {
        let image = try #require(ImageRenderer(content: view.frame(width: 200, height: 120)).cgImage)
        #expect(image.width == 200 && image.height == 120)
        return image
    }

    /// The share of pixels that differ clearly from the top-left pixel (the background).
    private func drawnFraction(of image: CGImage) throws -> Double {
        let pixels = try pixels(of: image)
        let background = Array(pixels[0..<4])
        var drawn = 0
        for offset in stride(from: 0, to: pixels.count, by: 4) {
            let difference = (0..<4).reduce(0) { $0 + abs(Int(pixels[offset + $1]) - Int(background[$1])) }
            if difference > 48 { drawn += 1 }
        }
        return Double(drawn) / Double(image.width * image.height)
    }

    /// The image's pixels as premultiplied RGBA bytes.
    private func pixels(of image: CGImage) throws -> [UInt8] {
        let width = image.width
        let height = image.height
        var pixels = [UInt8](repeating: 0, count: width * height * 4)
        let context = try #require(CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ))
        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
        return pixels
    }

    private func writePNG(_ image: CGImage, to url: URL) throws {
        #if canImport(UIKit)
        let data = try #require(UIImage(cgImage: image).pngData())
        #else
        let data = try #require(NSBitmapImageRep(cgImage: image).representation(using: .png, properties: [:]))
        #endif
        try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        try data.write(to: url)
    }
}
