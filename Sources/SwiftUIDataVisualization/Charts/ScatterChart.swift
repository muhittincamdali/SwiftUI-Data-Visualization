import Charts
import SwiftUI

/// Points on two numeric axes, optionally with the least-squares trend line through them.
///
/// ```swift
/// ScatterChart(points, xLabel: "Height (cm)", yLabel: "Weight (kg)", showsTrendLine: true)
///     .frame(height: 240)
/// ```
///
/// The trend line is the ``LinearRegression`` of the points, drawn across their x range in the
/// palette's ``ChartPalette/neutral`` color; its equation and r² are part of the chart's
/// accessibility label. Points with a coordinate that is not finite are left out, and
/// coordinates beyond ±1e307 are drawn at that limit.
public struct ScatterChart: View {
    private let points: [PlotPoint]
    private let xLabel: String
    private let yLabel: String
    private let showsTrendLine: Bool

    @Environment(\.chartPalette) private var palette

    /// Creates a scatter chart.
    ///
    /// - Parameters:
    ///   - points: The points to draw.
    ///   - xLabel: The name of the horizontal axis.
    ///   - yLabel: The name of the vertical axis.
    ///   - showsTrendLine: Whether to draw the least-squares line through the points.
    public init(_ points: [PlotPoint], xLabel: String = "x", yLabel: String = "y", showsTrendLine: Bool = false) {
        self.points = points
        self.xLabel = xLabel
        self.yLabel = yLabel
        self.showsTrendLine = showsTrendLine
    }

    public var body: some View {
        let finite = points.filter { $0.x.isFinite && $0.y.isFinite }
        let trend = showsTrendLine ? Self.trendSegment(for: finite) : nil
        Chart {
            ForEach(Array(finite.enumerated()), id: \.offset) { _, point in
                PointMark(x: .value(xLabel, ChartValues.clamped(point.x)), y: .value(yLabel, ChartValues.clamped(point.y)))
                    .foregroundStyle(palette.color(at: 0).opacity(0.8))
            }
            if let trend {
                ForEach([trend.start, trend.end], id: \.self) { point in
                    LineMark(
                        x: .value(xLabel, ChartValues.clamped(point.x)),
                        y: .value(yLabel, ChartValues.clamped(point.y)),
                        series: .value("Line", "Trend")
                    )
                        .foregroundStyle(palette.neutral)
                        .lineStyle(StrokeStyle(lineWidth: 2))
                }
            }
        }
        .chartXAxisLabel(xLabel)
        .chartYAxisLabel(yLabel)
        .chartXScale(domain: .automatic(includesZero: false))
        .chartYScale(domain: .automatic(includesZero: false))
        .accessibilityValue(trend.map(Self.describe) ?? "")
    }

    /// The trend line from the smallest to the largest x value, or `nil` when no line fits.
    nonisolated static func trendSegment(for points: [PlotPoint]) -> (start: PlotPoint, end: PlotPoint, fit: LinearRegression)? {
        guard
            let fit = LinearRegression(points: points),
            let lowest = points.map(\.x).min(),
            let highest = points.map(\.x).max()
        else { return nil }
        let start = PlotPoint(x: lowest, y: fit.predict(lowest))
        let end = PlotPoint(x: highest, y: fit.predict(highest))
        guard start.y.isFinite, end.y.isFinite else { return nil }
        return (start, end, fit)
    }

    /// The trend line as VoiceOver reads it.
    nonisolated static func describe(_ trend: (start: PlotPoint, end: PlotPoint, fit: LinearRegression)) -> String {
        let format = FloatingPointFormatStyle<Double>.number.precision(.significantDigits(1...3))
        return "Trend line: y = \(trend.fit.slope.formatted(format)) x + \(trend.fit.intercept.formatted(format)), "
            + "r squared \(trend.fit.rSquared.formatted(format))"
    }
}
