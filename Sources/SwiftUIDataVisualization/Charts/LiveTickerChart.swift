import SwiftUI

/// A line with a fading fill for values that arrive many times a second, such as a price or a
/// sensor reading.
///
/// ```swift
/// @State private var load = LiveSeries(capacity: 120)
///
/// LiveTickerChart(values: load.values)
///     .frame(height: 80)
/// ```
///
/// The chart draws with `Canvas` in a single pass, which keeps up with updates at display rate
/// where a Swift Charts `Chart` rebuilds its marks for every value. Feed it from a
/// ``LiveSeries``, which keeps the latest values in a ``RingBuffer``. The vertical range fits
/// the values on screen, values that are not finite are skipped, and VoiceOver reads the latest
/// value and can play the series as an Audio Graph.
public struct LiveTickerChart: View {
    private let values: [Double]
    private let title: String

    @Environment(\.chartPalette) private var palette

    /// Creates a ticker.
    ///
    /// - Parameters:
    ///   - values: The values to draw, oldest first.
    ///   - title: The chart's name for VoiceOver.
    public init(values: [Double], title: String = "Live values") {
        self.values = values
        self.title = title
    }

    public var body: some View {
        let finite = values.filter(\.isFinite)
        let color = palette.color(at: 0)
        Canvas { context, size in
            let points = Self.points(for: finite, in: size)
            guard points.count > 1, let first = points.first, let last = points.last else { return }
            var line = Path()
            line.addLines(points)
            var fill = line
            fill.addLine(to: CGPoint(x: last.x, y: size.height))
            fill.addLine(to: CGPoint(x: first.x, y: size.height))
            fill.closeSubpath()
            context.fill(fill, with: .linearGradient(
                Gradient(colors: [color.opacity(0.3), color.opacity(0)]),
                startPoint: .zero,
                endPoint: CGPoint(x: 0, y: size.height)
            ))
            context.stroke(line, with: .color(color), style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
        .accessibilityElement()
        .accessibilityLabel(title)
        .accessibilityValue(finite.last.map { $0.formatted(.number.precision(.fractionLength(0...2))) } ?? "")
        .accessibilityChartDescriptor(AudioGraphDescriptor(title: title, xAxisTitle: "Sample", series: [.init(name: title, values: finite)]))
    }

    /// The drawing positions of `values` across `size`: evenly spaced from left to right, the
    /// smallest value at the bottom and the largest at the top. A flat series is drawn across
    /// the middle.
    nonisolated static func points(for values: [Double], in size: CGSize) -> [CGPoint] {
        guard values.count > 1, let low = values.min(), let high = values.max() else { return [] }
        let width = Double(size.width)
        let height = Double(size.height)
        let stepX = width / Double(values.count - 1)
        return values.enumerated().map { index, value in
            // Dividing before subtracting keeps the fraction finite for ranges near
            // Double.greatestFiniteMagnitude.
            let span = high / 2 - low / 2
            let fraction = span > 0 ? (value / 2 - low / 2) / span : 0.5
            return CGPoint(x: Double(index) * stepX, y: (1 - fraction) * height)
        }
    }
}
