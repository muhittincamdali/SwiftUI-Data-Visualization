# Getting Started

Add the package, draw a first chart, and give it your data.

## Add the package

In Xcode choose **File > Add Package Dependencies…**, paste
`https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git` into the search field at the
top right, leave **Dependency Rule** at **Up to Next Major Version** from `2.0.2`, choose
**Add Package**, and in the next sheet add the **SwiftUIDataVisualization** library to your app
target. Use 2.0.0 or later: the charts in this documentation arrived in 2.0.0, and the earlier
1.0.0 release has a different API. In a package, add it to `Package.swift` instead:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git", from: "2.0.2")
],
targets: [
    .target(name: "MyApp", dependencies: [
        .product(name: "SwiftUIDataVisualization", package: "SwiftUI-Data-Visualization")
    ])
]
```

The package requires Swift 6.2 tools, iOS 17 or macOS 14, and has no dependencies besides
Apple's frameworks.

## Draw a first chart

Import the module next to SwiftUI and put a chart in a view. Charts fill the space they are
given, so give them a height:

```swift
import SwiftUI
import SwiftUIDataVisualization

struct ContentView: View {
    let steps = TimeSeries(
        name: "Steps",
        values: [4_200, 8_100, 6_900, 10_400, 7_800, 12_100, 9_300],
        start: .now.addingTimeInterval(-6 * 86_400),
        interval: 86_400
    )

    var body: some View {
        TimeSeriesChart(steps)
            .frame(height: 240)
            .padding()
    }
}
```

Run the app and touch the chart (or hover over it on the Mac): a rule follows the pointer and
shows the date and value of the nearest point.

## Bring your own data

Each chart takes plain value types, so converting your model is usually one `map`:

```swift
struct Reading {
    let time: Date
    let celsius: Double
}

func temperature(_ readings: [Reading]) -> TimeSeries {
    TimeSeries(name: "Temperature", points: readings.map {
        TimeSeriesPoint(date: $0.time, value: $0.celsius)
    })
}
```

``TimeSeries`` sorts its points by date, so the order of `readings` does not matter. The other
inputs work the same way: ``PlotPoint`` for ``ScatterChart``, ``Candle`` for
``CandlestickChart`` (or ``Candle/aggregate(_:interval:)`` to build candles from individual
trades), ``HeatmapCell``, ``WaterfallStep``, ``TreemapItem``, ``BoxPlotChart/Group`` and
``RadarChart/Series``.

## Change the colors

Charts read a ``ChartPalette`` from the environment. Set one for a whole screen:

```swift
DashboardView()
    .chartPalette(.colorblindSafe)
```

``ChartPalette/ocean`` is the default. You can also build a palette from your own colors with
``ChartPalette/init(series:positive:negative:neutral:gradient:)``.

## Try the example app

`Examples/ChartGallery` in the repository is an iOS and macOS app with one screen per sample in
the README. Open `ChartGallery.xcodeproj`, choose the **ChartGallery** scheme and run it.
