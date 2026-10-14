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
        for view in [AnyView(ContentView()), AnyView(LiveLoad()), AnyView(ColorblindSafeCharts())] {
            let image = try #require(ImageRenderer(content: view.frame(width: 390)).cgImage)
            #expect(image.height > 50)
        }
    }

    @Test func liveTickerDrawsItsValues() throws {
        let chart = LiveTickerChart(values: (0..<120).map { sin(Double($0) / 8) }).frame(width: 300, height: 80)
        let image = try #require(ImageRenderer(content: chart).cgImage)
        #expect(try drawnFraction(of: image) > 0.05)
    }

    @Test func chartsWithoutUsableDataRenderEmpty() throws {
        let views: [AnyView] = [
            AnyView(TimeSeriesChart([TimeSeries]())),
            AnyView(ScatterChart([PlotPoint(x: .nan, y: 1)], showsTrendLine: true)),
            AnyView(HistogramChart(values: [])),
            AnyView(BoxPlotChart([.init(name: "A", values: [.nan])])),
            AnyView(CandlestickChart([Candle(date: .now, open: 1, high: 0, low: 2, close: 1)])),
            AnyView(HeatmapChart([HeatmapCell(column: "a", row: "b", value: .infinity)])),
            AnyView(WaterfallChart([])),
            AnyView(RadarChart(axes: ["A", "B"], series: [.init(name: "S", values: [1, 2])])),
            AnyView(TreemapChart([TreemapItem("Zero", value: 0)])),
            AnyView(LiveTickerChart(values: [.nan, .infinity])),
        ]
        for view in views {
            let image = try #require(ImageRenderer(content: view.frame(width: 200, height: 120)).cgImage)
            #expect(image.width == 200)
        }
    }

    /// The share of pixels that differ clearly from the top-left pixel (the background).
    private func drawnFraction(of image: CGImage) throws -> Double {
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
        let background = Array(pixels[0..<4])
        var drawn = 0
        for offset in stride(from: 0, to: pixels.count, by: 4) {
            let difference = (0..<4).reduce(0) { $0 + abs(Int(pixels[offset + $1]) - Int(background[$1])) }
            if difference > 48 { drawn += 1 }
        }
        return Double(drawn) / Double(width * height)
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
