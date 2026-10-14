# Choosing a Chart

Pick the chart that answers your question, and know when plain Swift Charts is enough.

## Start from the question

| Question | Chart | Input |
| --- | --- | --- |
| How does a value change over time? | ``TimeSeriesChart`` | ``TimeSeries`` |
| How are the values spread out? | ``HistogramChart`` | `[Double]` or a ``Histogram`` |
| How do several groups compare? | ``BoxPlotChart`` | ``BoxPlotChart/Group`` |
| Do two measures move together? | ``ScatterChart`` | ``PlotPoint`` |
| How did a price move in each period? | ``CandlestickChart`` | ``Candle`` |
| How do changes add up to a total? | ``WaterfallChart`` | ``WaterfallStep`` |
| Where are values high across two categories? | ``HeatmapChart`` | ``HeatmapCell`` |
| How do profiles compare on several scores? | ``RadarChart`` | ``RadarChart/Series`` |
| Which parts make up a whole? | ``TreemapChart`` | ``TreemapItem`` |
| What is the latest value right now? | ``LiveTickerChart`` | `[Double]` from a ``LiveSeries`` |

For a plain bar, line or pie chart of a few categories, Swift Charts' `BarMark`, `LineMark` and
`SectorMark` are already the shortest code; this package does not wrap them.

## Statistics that the charts compute

``HistogramChart`` bins with ``Histogram/Binning/automatic`` unless you choose otherwise:
whichever of Sturges' rule and the Freedman–Diaconis rule gives more bins, with edges rounded
to a 1, 2 or 5 step. Use ``Histogram/Binning/width(_:)`` when the bins should match a unit
people know, such as 25 ms or 10 points:

```swift
HistogramChart(values: latencies, binning: .width(25), valueLabel: "Latency (ms)")
```

``BoxPlotChart`` uses ``BoxPlotSummary``: quartiles with linear interpolation (the method of
Excel's `PERCENTILE.INC` and NumPy's default), and Tukey's whiskers at 1.5 interquartile ranges.
Values beyond the whiskers are drawn as points.

``ScatterChart`` draws the ordinary least-squares line from ``LinearRegression`` when
`showsTrendLine` is `true`, and VoiceOver reads its equation and r².

## Use the analysis in your own charts

The computations are public, so they work in a `Chart` you write yourself:

```swift
let summary = BoxPlotSummary(values: responseTimes)
let fit = LinearRegression(points: points)
let averages = MovingAverage.simple(values, window: 7)
let ticks = NiceScale(lower: 3, upper: 97, desiredTickCount: 6).ticks // [0, 20, …, 100]
let tiles = TreemapLayout.squarify(sizes, in: CGRect(x: 0, y: 0, width: 300, height: 200))
```

Each of them ignores values that are not finite and returns `nil` or an empty result when no
usable value is left, instead of a misleading zero.
