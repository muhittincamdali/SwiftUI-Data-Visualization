# Examples

## ChartGallery

A small iOS and macOS app with one screen per README sample: the quick start, server load over
50,000 points per series, scrolling with selection and PNG export, latency statistics, a trend
line, candles with a waterfall, a heatmap, radar and treemap, a live ticker, and the color-blind
safe palette. It uses the package from this checkout (a local package reference to `../..`), so
it always shows the current code.

Run it:

1. Open `Examples/ChartGallery/ChartGallery.xcodeproj` in Xcode 26 or later.
2. Choose the **ChartGallery** scheme and an iPhone simulator or **My Mac** as the run
   destination.
3. Press **Run** (⌘R).

From the command line:

```sh
cd Examples/ChartGallery
xcodebuild build -scheme ChartGallery -destination 'generic/platform=iOS Simulator'
xcodebuild build -scheme ChartGallery -destination 'platform=macOS'
```

To open one screen directly, pass its case name with `-sample`, for example
`-sample finance` in the scheme's arguments or with `xcrun simctl launch`.

The samples live in
[`ChartGallery/ReadmeSamples.swift`](ChartGallery/ChartGallery/ReadmeSamples.swift).
The README copies its code from that file, and the package's test target compiles and renders
the same file through the symlink `Tests/SwiftUIDataVisualizationTests/ReadmeExamples.swift`.

The project file is made with [XcodeGen](https://github.com/yonaskolb/XcodeGen) from
[`project.yml`](ChartGallery/project.yml) and committed, so you only need XcodeGen after
editing `project.yml`.
