import CoreGraphics
import Foundation
import ImageIO
import SwiftUI
import Testing
@testable import SwiftUIDataVisualization

@MainActor
@Suite("Chart export")
struct ChartExportTests {
    private let chart = WaterfallChart([WaterfallStep("Revenue", 420), WaterfallStep("Costs", -260), .total("Profit")])

    @Test func pngHasTheRequestedPixelSize() throws {
        let data = try #require(ChartExport.pngData(of: chart, size: CGSize(width: 300, height: 200), scale: 2))
        let source = try #require(CGImageSourceCreateWithData(data as CFData, nil))
        let image = try #require(CGImageSourceCreateImageAtIndex(source, 0, nil))
        #expect(image.width == 600)
        #expect(image.height == 400)
        // A PNG file starts with the bytes 89 50 4E 47.
        #expect(Array(data.prefix(4)) == [0x89, 0x50, 0x4E, 0x47])
    }

    @Test func darkExportsHaveADarkBackground() throws {
        let image = try #require(ChartExport.cgImage(of: Color.clear, size: CGSize(width: 10, height: 10), scale: 1, colorScheme: .dark))
        var pixel = [UInt8](repeating: 255, count: 4)
        let context = try #require(CGContext(
            data: &pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4,
            space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ))
        context.draw(image, in: CGRect(x: 0, y: 0, width: 1, height: 1))
        #expect(pixel[0] < 10 && pixel[1] < 10 && pixel[2] < 10)
    }

    @Test(arguments: [
        CGSize(width: 0, height: 100),
        CGSize(width: 100, height: -1),
        CGSize(width: CGFloat.nan, height: 100),
        CGSize(width: 100, height: CGFloat.infinity),
        CGSize(width: 5_000, height: 100), // 10,000 px at scale 2
    ])
    func unusableSizesGiveNil(_ size: CGSize) {
        #expect(ChartExport.pngData(of: chart, size: size) == nil)
    }

    @Test func scaleCountsTowardsThePixelLimit() {
        #expect(ChartExport.isRenderable(size: CGSize(width: 4_096, height: 10), scale: 2))
        #expect(!ChartExport.isRenderable(size: CGSize(width: 4_097, height: 10), scale: 2))
        #expect(!ChartExport.isRenderable(size: CGSize(width: 100, height: 100), scale: .nan))
        #expect(!ChartExport.isRenderable(size: CGSize(width: 100, height: 100), scale: 0))
    }
}
