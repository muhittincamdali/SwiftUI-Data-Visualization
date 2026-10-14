import CoreGraphics
import Foundation
import ImageIO
import SwiftUI
import UniformTypeIdentifiers

/// Renders a chart, or any view, to a PNG image for sharing, reports or a pasteboard.
///
/// ```swift
/// let data = ChartExport.pngData(of: TimeSeriesChart(revenue), size: CGSize(width: 600, height: 300))
/// ```
///
/// The view is drawn off screen with `ImageRenderer` on a white (light) or black (dark)
/// background, so the image does not depend on the screen it was shown on. Controls backed by
/// UIKit or AppKit, such as text fields, render as placeholders; charts render completely.
@MainActor
public enum ChartExport {
    /// The longest side, in pixels, an export may have, so a size from user input cannot
    /// allocate an arbitrarily large bitmap.
    public nonisolated static let maximumPixelLength: CGFloat = 8_192

    /// The view rendered as PNG data, or `nil` when the size is empty, not finite, larger than
    /// ``maximumPixelLength`` pixels on a side at `scale`, or rendering fails.
    ///
    /// - Parameters:
    ///   - view: The chart or view to render.
    ///   - size: The size to lay the view out at, in points.
    ///   - scale: Pixels per point; 2 matches most screens.
    ///   - colorScheme: The appearance to render in.
    public static func pngData(
        of view: some View,
        size: CGSize,
        scale: CGFloat = 2,
        colorScheme: ColorScheme = .light
    ) -> Data? {
        guard let image = cgImage(of: view, size: size, scale: scale, colorScheme: colorScheme) else { return nil }
        let data = NSMutableData()
        guard let destination = CGImageDestinationCreateWithData(data, UTType.png.identifier as CFString, 1, nil) else {
            return nil
        }
        CGImageDestinationAddImage(destination, image, nil)
        return CGImageDestinationFinalize(destination) ? data as Data : nil
    }

    /// The view rendered as a `CGImage`, under the same rules as
    /// ``pngData(of:size:scale:colorScheme:)``.
    public static func cgImage(
        of view: some View,
        size: CGSize,
        scale: CGFloat = 2,
        colorScheme: ColorScheme = .light
    ) -> CGImage? {
        guard isRenderable(size: size, scale: scale) else { return nil }
        let content = view
            .frame(width: size.width, height: size.height)
            .background(colorScheme == .dark ? Color.black : Color.white)
            .environment(\.colorScheme, colorScheme)
        let renderer = ImageRenderer(content: content)
        renderer.scale = scale
        return renderer.cgImage
    }

    /// Whether `size` at `scale` gives a bitmap with positive, finite sides no longer than
    /// ``maximumPixelLength``.
    nonisolated static func isRenderable(size: CGSize, scale: CGFloat) -> Bool {
        let width = size.width * scale
        let height = size.height * scale
        return width.isFinite && height.isFinite && width >= 1 && height >= 1
            && width <= maximumPixelLength && height <= maximumPixelLength
    }
}
