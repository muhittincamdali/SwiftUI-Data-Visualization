# Large and Live Data

Keep charts fast with tens of thousands of points and with values that arrive many times a second.

## Large series

Swift Charts lays out every mark it is given. A line of 50,000 points costs time on each layout
pass while a phone screen can show a few hundred of them. ``TimeSeriesChart`` therefore reduces
each series to ``TimeSeriesChart/defaultMaximumPointsPerSeries`` points (1,000) before drawing:

```swift
TimeSeriesChart(servers, movingAverageWindow: 2_000) // 50,000 points per series, 1,000 drawn
```

The reduction is Largest-Triangle-Three-Buckets (``Downsampling``): it keeps the first and the
last point and, from each bucket in between, the point that forms the largest triangle with its
neighbours. Peaks and dips survive, which taking every 50th point does not guarantee. Pass
`maximumPointsPerSeries` to draw more or fewer points, and call the `Downsampling` functions
yourself for your own `Chart`.

The moving average is computed on all the points first and then reduced the same way, so it
does not change with the drawing limit.

## Live values

For a value that updates many times a second, such as a price or a sensor, keep the latest
values in a ``LiveSeries`` and draw them with ``LiveTickerChart``:

```swift
struct LiveLoad: View {
    @State private var load = LiveSeries(capacity: 120)

    var body: some View {
        LiveTickerChart(values: load.values, title: "CPU load")
            .frame(height: 80)
            .task {
                var tick = 0.0
                while !Task.isCancelled {
                    tick += 1
                    load.append(50 + 30 * sin(tick / 8)) // read the real value here
                    try? await Task.sleep(for: .milliseconds(100))
                }
            }
    }
}
```

``LiveSeries`` is an `@Observable` class on the main actor that stores values in a
``RingBuffer``: appending is O(1) and drops the oldest value when the buffer is full, without
shifting an array. Values that are not finite are ignored. ``LiveTickerChart`` draws with
`Canvas` in a single pass instead of rebuilding a `Chart` for every value.

## Limits that protect the app

Charts often draw data that comes from users or from the network. The package bounds the work
any input can cause:

- ``NiceScale`` clamps the tick count to ``NiceScale/tickCountRange`` and returns at most
  ``NiceScale/maximumTickCount`` ticks;
- ``Histogram`` makes at most ``Histogram/maximumBinCount`` bins, even for a width of `1e-300`;
- ``RingBuffer`` reserves memory for at most 4,096 elements up front, so a capacity of
  `Int.max` costs nothing until values arrive;
- ranges near `Double.greatestFiniteMagnitude` and subnormal ranges are computed in a rescaled
  space, so no chart produces `nan` coordinates or traps on an integer conversion.
