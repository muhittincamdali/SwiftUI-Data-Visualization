# Accessible Charts

What VoiceOver users hear, and how to keep charts readable with color blindness.

## VoiceOver

The charts built on Swift Charts (``TimeSeriesChart``, ``ScatterChart``, ``HistogramChart``,
``BoxPlotChart``, ``CandlestickChart``, ``WaterfallChart`` and ``HeatmapChart``) get Swift
Charts' accessibility support: VoiceOver can move through the marks and play the data as an
Audio Graph. The package adds a label and a value to the marks where the defaults say too
little:

- a histogram bar reads its range, such as "100 to 125", and its count;
- a box reads its median, quartiles, range and number of outliers;
- a candle reads its open, high, low and close;
- a waterfall step reads its signed change and the total it leads to;
- a scatter chart with a trend line reads the line's equation and r².

``RadarChart``, ``TreemapChart`` and ``LiveTickerChart`` draw with `Canvas`, which VoiceOver
sees as a single image. Each of them attaches an ``AudioGraphDescriptor``, so VoiceOver users
can still play and explore the data, and ``TreemapChart`` also makes every tile its own element
with its label and value. Pass a `title` to name the chart:

```swift
RadarChart(axes: axes, series: series, maximum: 10, title: "Model comparison")
```

You can describe a chart of your own the same way:

```swift
MyGauge(values: weekly)
    .accessibilityChartDescriptor(AudioGraphDescriptor(
        title: "Weekly load",
        categories: ["Mon", "Tue", "Wed"],
        series: [.init(name: "Load", values: weekly)]
    ))
```

## Color

The default ``ChartPalette/ocean`` palette uses blues for series and increases and orange for
decreases, a pair that stays distinct with red-green color blindness. When several series must
be told apart by color alone, switch to ``ChartPalette/colorblindSafe``, the Okabe–Ito colors:

```swift
ReportView()
    .chartPalette(.colorblindSafe)
```

Charts with several series also show a legend, so the names do not depend on color, and the
heatmap prints values in white or in the primary color depending on how dark the cell is.
