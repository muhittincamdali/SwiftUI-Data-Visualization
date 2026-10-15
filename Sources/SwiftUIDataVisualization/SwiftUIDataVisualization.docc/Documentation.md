# ``SwiftUIDataVisualization``

Statistical, financial and live charts for SwiftUI on iOS 17 and macOS 14, built on Swift Charts, with the analysis behind them.

## Overview

Swift Charts draws marks; it leaves binning, quartiles, trend lines, candles, treemap layout and
downsampling to you. This package adds ten chart views that do that work, and makes the work
itself public, so you can use it in your own `Chart` too.

```swift
import SwiftUI
import SwiftUIDataVisualization

struct StepsView: View {
    let steps = TimeSeries(
        name: "Steps",
        values: [4_200, 8_100, 6_900, 10_400, 7_800, 12_100, 9_300],
        start: .now.addingTimeInterval(-6 * 86_400),
        interval: 86_400
    )

    var body: some View {
        TimeSeriesChart(steps)
            .frame(height: 240)
    }
}
```

Every chart takes its colors from a ``ChartPalette`` in the environment and accepts any input
without crashing: values that are not finite and dates outside the years 1 to 4001 are left
out, finite values beyond ±1e307 are drawn at that limit, ranges near
`Double.greatestFiniteMagnitude` stay finite, and limits such as
``NiceScale/tickCountRange``, ``Histogram/maximumBinCount`` and
``TimeSeriesChart/maximumScrolledWindows`` bound the memory and time a chart can use.

## Topics

### Essentials

- <doc:GettingStarted>
- <doc:ChoosingAChart>
- <doc:LargeAndLiveData>
- <doc:AccessibleCharts>

### Time series

- ``TimeSeriesChart``
- ``TimeSeries``
- ``TimeSeriesPoint``

### Statistics

- ``HistogramChart``
- ``Histogram``
- ``BoxPlotChart``
- ``BoxPlotSummary``
- ``ScatterChart``
- ``PlotPoint``
- ``LinearRegression``
- ``Statistics``
- ``MovingAverage``

### Finance and business

- ``CandlestickChart``
- ``Candle``
- ``WaterfallChart``
- ``WaterfallStep``
- ``HeatmapChart``
- ``HeatmapCell``

### Radar and treemap

- ``RadarChart``
- ``RadarGeometry``
- ``TreemapChart``
- ``TreemapItem``
- ``TreemapLayout``

### Live data and large data

- ``LiveTickerChart``
- ``LiveSeries``
- ``RingBuffer``
- ``Downsampling``

### Export

- ``ChartExport``

### Axes, colors and accessibility

- ``NiceScale``
- ``ChartPalette``
- ``AudioGraphDescriptor``
- ``SwiftUIDataVisualization/SwiftUIDataVisualization``
