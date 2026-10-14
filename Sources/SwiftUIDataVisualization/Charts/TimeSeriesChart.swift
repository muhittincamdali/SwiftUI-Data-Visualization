import Charts
import SwiftUI

/// Lines or filled areas for one or more ``TimeSeries``, with a readout of the values under the
/// pointer.
///
/// ```swift
/// TimeSeriesChart([revenue, costs], movingAverageWindow: 7)
///     .frame(height: 240)
/// ```
///
/// Long series are reduced with ``Downsampling`` to ``defaultMaximumPointsPerSeries`` points
/// (or the number you pass) before they are drawn, so a year of minute data scrolls as smoothly
/// as a week of daily data. Points whose value is not finite are left out. Touching or hovering
/// over the plot shows the date and each series' nearest value; pass a `selection` binding to
/// read or set that date yourself. With a `visibleDuration`, the chart shows that much time and
/// scrolls horizontally, starting at the newest data. Colors come from the ``ChartPalette`` in
/// the environment, in the order of the series.
public struct TimeSeriesChart: View {
    /// How each series is drawn.
    public enum Style: Hashable, Sendable {
        /// A line through the points.
        case line
        /// A line with the area below it filled. Areas of several series overlap rather than
        /// stack.
        case area
    }

    /// The most points each series is drawn with unless you pass another limit.
    public nonisolated static let defaultMaximumPointsPerSeries = 1_000

    private let series: [TimeSeries]
    private let style: Style
    private let movingAverageWindow: Int?
    private let maximumPointsPerSeries: Int
    private let externalSelection: Binding<Date?>?
    private let visibleDuration: TimeInterval?

    @Environment(\.chartPalette) private var palette
    @State private var internalSelection: Date?

    /// The selection binding passed in, or the chart's own state.
    private var selection: Binding<Date?> {
        externalSelection ?? $internalSelection
    }

    /// Creates a chart of several series.
    ///
    /// - Parameters:
    ///   - series: The series to draw. Their names label the legend and should be unique.
    ///   - style: Lines or filled areas.
    ///   - movingAverageWindow: When 2 or more, a dashed simple moving average over this many
    ///     points is drawn over each series.
    ///   - maximumPointsPerSeries: The most points each series is drawn with (at least 2).
    ///   - selection: The date under the pointer, `nil` when nothing is selected. Pass a binding
    ///     to react to the selection or to select a date from code.
    ///   - visibleDuration: How many seconds of data the chart shows at once. When set, the
    ///     chart scrolls horizontally and opens at the newest data; `nil` shows everything.
    public init(
        _ series: [TimeSeries],
        style: Style = .line,
        movingAverageWindow: Int? = nil,
        maximumPointsPerSeries: Int = Self.defaultMaximumPointsPerSeries,
        selection: Binding<Date?>? = nil,
        visibleDuration: TimeInterval? = nil
    ) {
        self.series = series
        self.style = style
        self.movingAverageWindow = movingAverageWindow
        self.maximumPointsPerSeries = maximumPointsPerSeries
        self.externalSelection = selection
        self.visibleDuration = visibleDuration
    }

    /// Creates a chart of one series.
    public init(
        _ series: TimeSeries,
        style: Style = .line,
        movingAverageWindow: Int? = nil,
        maximumPointsPerSeries: Int = Self.defaultMaximumPointsPerSeries,
        selection: Binding<Date?>? = nil,
        visibleDuration: TimeInterval? = nil
    ) {
        self.init(
            [series],
            style: style,
            movingAverageWindow: movingAverageWindow,
            maximumPointsPerSeries: maximumPointsPerSeries,
            selection: selection,
            visibleDuration: visibleDuration
        )
    }

    public var body: some View {
        let plotted = Self.plottedSeries(
            series,
            movingAverageWindow: movingAverageWindow,
            maximumPointsPerSeries: maximumPointsPerSeries
        )
        Chart {
            ForEach(Array(plotted.enumerated()), id: \.offset) { index, line in
                ForEach(Array(line.points.enumerated()), id: \.offset) { _, point in
                    if style == .area {
                        AreaMark(
                            x: .value("Date", point.date),
                            y: .value("Value", point.value),
                            series: .value("Series", line.name),
                            stacking: .unstacked
                        )
                        .foregroundStyle(palette.color(at: index).opacity(0.25))
                    }
                    LineMark(x: .value("Date", point.date), y: .value("Value", point.value))
                        .foregroundStyle(by: .value("Series", line.name))
                        .interpolationMethod(.monotone)
                }
                ForEach(Array(line.average.enumerated()), id: \.offset) { _, point in
                    LineMark(
                        x: .value("Date", point.date),
                        y: .value("Average", point.value),
                        series: .value("Average", "\(line.name) average")
                    )
                    .foregroundStyle(palette.color(at: index))
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
                }
            }
            if let selectedDate = selection.wrappedValue {
                RuleMark(x: .value("Selected", selectedDate))
                    .foregroundStyle(.secondary.opacity(0.6))
                    .annotation(position: .top, spacing: 4, overflowResolution: .init(x: .fit(to: .chart), y: .disabled)) {
                        readout(at: selectedDate, in: plotted)
                    }
            }
        }
        .chartForegroundStyleScale(domain: plotted.map(\.name), range: palette.colors(count: plotted.count))
        .chartXSelection(value: selection)
        .modifier(ScrollableTimeAxis(window: Self.scrollWindow(for: plotted, visibleDuration: visibleDuration)))
    }

    /// The visible length and the date the chart opens at, or `nil` when it should not scroll:
    /// no positive, finite duration was given, or no point is drawn.
    nonisolated static func scrollWindow(
        for plotted: [PlottedSeries],
        visibleDuration: TimeInterval?
    ) -> (length: TimeInterval, start: Date)? {
        guard
            let length = visibleDuration, length > 0, length.isFinite,
            let newest = plotted.compactMap({ $0.points.last?.date }).max()
        else { return nil }
        return (length, newest.addingTimeInterval(-length))
    }

    private func readout(at date: Date, in plotted: [PlottedSeries]) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(date, format: .dateTime.year().month().day().hour().minute())
                .font(.caption2)
                .foregroundStyle(.secondary)
            ForEach(Array(plotted.enumerated()), id: \.offset) { index, line in
                if let point = line.nearestPoint(to: date) {
                    Label {
                        Text("\(line.name): \(point.value, format: .number.precision(.fractionLength(0...2)))")
                    } icon: {
                        Circle().fill(palette.color(at: index)).frame(width: 6, height: 6)
                    }
                    .font(.caption)
                }
            }
        }
        .padding(6)
        .background(.background.opacity(0.9), in: RoundedRectangle(cornerRadius: 6))
    }

    /// One series as drawn: finite points, downsampled, with its moving average.
    struct PlottedSeries: Hashable {
        /// The downsampled points, kept as a series for its binary search.
        let drawn: TimeSeries
        let average: [TimeSeriesPoint]

        var name: String { drawn.name }
        var points: [TimeSeriesPoint] { drawn.points }

        func nearestPoint(to date: Date) -> TimeSeriesPoint? {
            drawn.nearestPoint(to: date)
        }
    }

    /// The points each series is drawn with.
    nonisolated static func plottedSeries(
        _ series: [TimeSeries],
        movingAverageWindow: Int?,
        maximumPointsPerSeries: Int
    ) -> [PlottedSeries] {
        let threshold = max(maximumPointsPerSeries, 2)
        return series.map { series in
            let finite = series.points.filter(\.value.isFinite)
            var average: [TimeSeriesPoint] = []
            if let window = movingAverageWindow, window >= 2 {
                let values = MovingAverage.simple(finite.map(\.value), window: window)
                average = zip(finite, values).compactMap { point, value in
                    value.map { TimeSeriesPoint(date: point.date, value: $0) }
                }
            }
            return PlottedSeries(
                drawn: TimeSeries(name: series.name, points: Downsampling.largestTriangleThreeBuckets(finite, threshold: threshold)),
                average: Downsampling.largestTriangleThreeBuckets(average, threshold: threshold)
            )
        }
    }
}

/// Makes a date axis scroll horizontally through a window of a fixed length.
private struct ScrollableTimeAxis: ViewModifier {
    let window: (length: TimeInterval, start: Date)?

    func body(content: Content) -> some View {
        if let window {
            content
                .chartScrollableAxes(.horizontal)
                .chartXVisibleDomain(length: window.length)
                .chartScrollPosition(initialX: window.start)
        } else {
            content
        }
    }
}
