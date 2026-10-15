# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.1] - 2026-10-15

### Fixed

- Finite values near `±Double.greatestFiniteMagnitude` (such as `-1.6e308`, or `1.7e308` next to
  `-1`) no longer stop the app inside Swift Charts. `TimeSeriesChart`, `ScatterChart`,
  `HistogramChart`, `BoxPlotChart`, `HeatmapChart`, `CandlestickChart` and `WaterfallChart` draw
  values beyond ±1e307 at that limit; readouts and VoiceOver keep the original value.
- `NiceScale` covers the data with two or three ticks over a span near 1e308, where it fell back
  to `0...1`, and no longer returns a bound of `-0.0` or `0.0` inside the data when a tiny value
  divided by the step underflows.
- `CandlestickChart` draws every candle; of several candles with the same date, only the first
  was drawn.
- `BoxPlotChart` reads "1 outlier" instead of "1 outliers" to VoiceOver.

## [2.0.0] - 2026-10-15

A new package built on Swift Charts. The 1.0.0 sources did not build with current Xcode
versions, and in June 2026 they were replaced with placeholder code; this release brings back
the useful algorithms from that history and from SwiftUI-Charts-Pro (which is being archived),
rewritten for Swift 6 and tested, and adds the chart views around them. Every public type
changed, so this is a major release.

From SwiftUI-Charts-Pro, the box plot, candlestick, heatmap, waterfall, radar and treemap charts
were carried over. Its other charts were not, and none of them had tests there:

- `GaugeChart`: SwiftUI's own `Gauge` view covers it, with accessibility.
- `BubbleChart`, `FunnelChart` and `GanttChart`: one Swift Charts mark each
  (`PointMark` with `symbolSize`, a sorted `BarMark`, `BarMark(xStart:xEnd:y:)` over dates).
- `SunburstChart`: nested `SectorMark` rings in Swift Charts.
- `SankeyChart`, `ChordDiagram`, `ViolinChart` (kernel density), `ParallelCoordinatesChart` and
  `WordCloudChart`: each needs its own layout or estimation algorithm, which would need the same
  tests as `TreemapLayout` and `Histogram` before it ships. They may come in a later release.

### Added

- Chart views: `TimeSeriesChart` (lines or areas, moving average, downsampling to 1,000 points
  per series, a pointer readout, a `selection` binding and a scrolling `visibleDuration`
  window), `HistogramChart`, `BoxPlotChart`, `ScatterChart` (optional least-squares trend
  line), `CandlestickChart`, `WaterfallChart`, `HeatmapChart`, `RadarChart`, `TreemapChart` and
  `LiveTickerChart`.
- Data types: `TimeSeries`, `TimeSeriesPoint`, `PlotPoint`, `Candle` with
  `Candle.aggregate(_:interval:)` and `isValid`, `HeatmapCell`, `WaterfallStep`, `TreemapItem`,
  `BoxPlotChart.Group`, `RadarChart.Series`.
- Analysis: `Statistics` (mean, median, type 7 quantiles, variance, standard deviation),
  `BoxPlotSummary` (Tukey whiskers), `Histogram` (automatic, Sturges, Freedman–Diaconis, fixed
  count or width), `LinearRegression`, `MovingAverage` (simple and exponential), `NiceScale`
  axis ticks and `Downsampling` (Largest-Triangle-Three-Buckets).
- Layout: `TreemapLayout` (squarified) and `RadarGeometry`.
- Live data: `RingBuffer` and the observable `LiveSeries`.
- `ChartPalette` with the `ocean` and color-blind safe `colorblindSafe` palettes, set through
  `.chartPalette(_:)`.
- `ChartExport` renders a chart to PNG data or a `CGImage` at a fixed size.
- `AudioGraphDescriptor` describes Canvas-drawn charts to VoiceOver's Audio Graphs.
- The ChartGallery example app for iOS and macOS, a DocC catalog with four articles, and README
  screenshots rendered from the samples.

### Changed

- The package requires Swift 6.2 tools, iOS 17 and macOS 14, and builds in the Swift 6
  language mode.
- `LiveTickerChart` takes `values:` and an accessibility `title:`, and reads its colors from the
  palette instead of `lineColor` and `gradientColor` arguments.

### Removed

- The 1.0.0 API: `LineChart`, `BarChart`, `PieChart`, `AreaChart`, the views in `Sources/Charts`,
  `ChartDataPoint`, `ChartConfiguration`, `ChartStyle`, `BarOrientation` and `CGPoint3D`. Use Swift Charts' marks
  for plain line, bar, area and pie charts, and the views above for the rest.
- `SpatialDataPlotter`, `View.spatialPlot()` and `Visualizable`, which were added after 1.0.0
  and did not do what they described.
- The CocoaPods podspec, the outdated documentation, templates and benchmarks.

### Security

- Inputs that could crash an app, exhaust its memory or keep it busy are now handled: a tick
  count of `Int.max` in `NiceScale`, data ranges wider than `Double` can hold or of subnormal
  width in `NiceScale` and `Histogram` (which trapped on `Int(nan)`), tiny histogram widths over
  wide ranges, `RingBuffer(capacity: .max)` (which reserved the whole capacity), `nan` dates and
  dates beyond `Date.distantPast` and `Date.distantFuture` in time series, candles, selections
  and visible durations (Swift Charts traps near 1e19 seconds), scroll windows that would number
  in the millions, moving averages of overflowing sums (which took quadratic time), and sums
  that overflow in statistics, regression and the treemap layout. Each case has a test in
  `ExtremeInputTests.swift` or `ExtremeDateInputTests.swift`.

## [1.0.0] - 2026-02-02

First release: line, bar, pie, area, scatter, candlestick, heatmap and radar chart views with a
`ChartDataPoint` model.

[Unreleased]: https://github.com/muhittincamdali/SwiftUI-Data-Visualization/compare/v2.0.1...HEAD
[2.0.1]: https://github.com/muhittincamdali/SwiftUI-Data-Visualization/compare/v2.0.0...v2.0.1
[2.0.0]: https://github.com/muhittincamdali/SwiftUI-Data-Visualization/compare/v1.0.0...v2.0.0
[1.0.0]: https://github.com/muhittincamdali/SwiftUI-Data-Visualization/releases/tag/v1.0.0
