import SwiftUI

/// Values on axes that radiate from a center, one polygon per series, for comparing profiles
/// such as skills or product ratings.
///
/// ```swift
/// RadarChart(
///     axes: ["Speed", "Power", "Range", "Comfort", "Price"],
///     series: [.init(name: "Model A", values: [8, 6, 7, 9, 5])],
///     maximum: 10
/// )
/// .frame(height: 280)
/// ```
///
/// Swift Charts has no polar coordinates, so this chart draws with `Canvas`; VoiceOver users
/// get the data through an ``AudioGraphDescriptor``. Values are clamped to `0...maximum`, and a
/// series with fewer values than axes is padded with zeros.
public struct RadarChart: View {
    /// One polygon: a value per axis.
    public struct Series: Identifiable, Hashable, Sendable {
        /// The name in the legend. Names in one chart should be unique.
        public var name: String
        /// One value per axis, in the order of the axes.
        public var values: [Double]

        public var id: String { name }

        /// Creates a series.
        public init(name: String, values: [Double]) {
            self.name = name
            self.values = values
        }
    }

    private let axes: [String]
    private let series: [Series]
    private let maximum: Double
    private let gridLevels: Int
    private let title: String

    @Environment(\.chartPalette) private var palette

    /// The room left around the grid for the axis labels, in points.
    nonisolated static let labelMargin: CGFloat = 36

    /// Creates a radar chart.
    ///
    /// - Parameters:
    ///   - axes: The axis names, drawn clockwise from the top. A chart needs at least three.
    ///   - series: The polygons to draw.
    ///   - maximum: The value at the outer ring. `nil` rounds the largest value up to a nice
    ///     number.
    ///   - gridLevels: How many rings to draw, from 1 to 10.
    ///   - title: The chart's name for VoiceOver.
    public init(axes: [String], series: [Series], maximum: Double? = nil, gridLevels: Int = 4, title: String = "Radar chart") {
        self.axes = axes
        self.series = series.map { Series(name: $0.name, values: Self.fitted($0.values, to: axes.count)) }
        self.maximum = Self.resolvedMaximum(maximum, series: series)
        self.gridLevels = min(max(gridLevels, 1), 10)
        self.title = title
    }

    public var body: some View {
        VStack(spacing: 8) {
            Canvas { context, size in
                draw(in: &context, size: size)
            }
            .accessibilityElement()
            .accessibilityLabel(title)
            .accessibilityChartDescriptor(AudioGraphDescriptor(
                title: title,
                xAxisTitle: "Axis",
                categories: axes,
                series: series.map { .init(name: $0.name, values: $0.values) }
            ))
            if series.count > 1 {
                ChartLegend(names: series.map(\.name), palette: palette)
            }
        }
    }

    private func draw(in context: inout GraphicsContext, size: CGSize) {
        guard axes.count >= 3 else { return }
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = max(min(size.width, size.height) / 2 - Self.labelMargin, 0)
        let grid = GraphicsContext.Shading.color(.secondary.opacity(0.35))

        for level in 1...gridLevels {
            let value = maximum * Double(level) / Double(gridLevels)
            let ring = Array(repeating: value, count: axes.count)
            context.stroke(Self.polygonPath(ring, maximum: maximum, center: center, radius: radius), with: grid, lineWidth: 0.5)
        }
        for (axis, name) in axes.enumerated() {
            let end = RadarGeometry.point(value: maximum, maximum: maximum, axis: axis, axisCount: axes.count, center: center, radius: radius)
            context.stroke(Path { $0.move(to: center); $0.addLine(to: end) }, with: grid, lineWidth: 0.5)
            let angle = RadarGeometry.angle(axis: axis, axisCount: axes.count)
            let labelPoint = RadarGeometry.point(value: 1, maximum: 1, axis: axis, axisCount: axes.count, center: center, radius: radius + 6)
            context.draw(
                Text(name).font(.caption).foregroundStyle(.secondary),
                at: labelPoint,
                anchor: UnitPoint(x: 0.5 - cos(angle) * 0.5, y: 0.5 - sin(angle) * 0.5)
            )
        }
        for (index, series) in series.enumerated() {
            let path = Self.polygonPath(series.values, maximum: maximum, center: center, radius: radius)
            let color = palette.color(at: index)
            context.fill(path, with: .color(color.opacity(0.2)))
            context.stroke(path, with: .color(color), lineWidth: 2)
        }
    }

    nonisolated static func polygonPath(_ values: [Double], maximum: Double, center: CGPoint, radius: CGFloat) -> Path {
        Path { path in
            path.addLines(RadarGeometry.polygon(values: values, maximum: maximum, center: center, radius: radius))
            path.closeSubpath()
        }
    }

    /// `values` cut or padded with zeros to `count` elements.
    nonisolated static func fitted(_ values: [Double], to count: Int) -> [Double] {
        Array(values.prefix(count)) + Array(repeating: 0, count: max(count - values.count, 0))
    }

    /// The value at the outer ring: `maximum` when it is positive and finite, otherwise the
    /// largest value rounded up by ``NiceScale``, or 1 without positive data.
    nonisolated static func resolvedMaximum(_ maximum: Double?, series: [Series]) -> Double {
        if let maximum, maximum > 0, maximum.isFinite { return maximum }
        let largest = series.flatMap(\.values).filter(\.isFinite).max() ?? 0
        guard largest > 0 else { return 1 }
        return NiceScale(lower: 0, upper: largest).upperBound
    }
}

/// Colored dots with series names, for the charts that draw without Swift Charts.
struct ChartLegend: View {
    let names: [String]
    let palette: ChartPalette

    var body: some View {
        HStack(spacing: 12) {
            ForEach(Array(names.enumerated()), id: \.offset) { index, name in
                HStack(spacing: 4) {
                    Circle().fill(palette.color(at: index)).frame(width: 8, height: 8)
                    Text(name).font(.caption).foregroundStyle(.secondary)
                }
            }
        }
        .accessibilityHidden(true)
    }
}
