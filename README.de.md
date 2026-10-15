<!-- i18n-source: README.md@5307a07778c46b7b0b0dfbd0a75b40a96a09d513 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-de-light.svg" alt="SwiftUI Data Visualization: Statistik-, Finanz- und Live-Diagramme für SwiftUI auf iOS und macOS, aufgebaut auf Swift Charts."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions/workflows/ci.yml/badge.svg" alt="CI-Status"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-light.svg" alt="Aktuelle Version: v2.0.1"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-light.svg" alt="Unterstützte Plattformen: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-light.svg" alt="Sprachversion: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-light.svg" alt="Lizenz: MIT"></picture></a>
</p>

<p align="center">
<a href="#schnellstart"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-de-light.svg" alt="Loslegen"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-de-light.svg" alt="Dokumentation"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/tree/master/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-de-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-de-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-de-light.svg" alt="Beispiele"></picture></a>
</p>

> Dies ist eine Übersetzung der englischen README. Bei Abweichungen gilt die englische Fassung.

<!-- brand:end -->

Ein Swift-Paket mit Diagramm-Views für SwiftUI auf iOS 17+ und macOS 14+, aufgebaut auf Swift Charts. Es deckt die Diagramme ab, die Swift Charts dir selbst überlässt – Zeitreihen mit Zehntausenden Punkten, Histogramme, Boxplots, Trendlinien, Candlesticks, Wasserfalldiagramme, Heatmaps, Radardiagramme, Treemaps und Live-Ticker – und macht die Analyse dahinter öffentlich, sodass du sie in einem eigenen `Chart` verwenden kannst. Das Paket hat keine Abhängigkeiten.

## Highlights

- **10 Diagramm-Views** – `TimeSeriesChart`, `HistogramChart`, `BoxPlotChart`, `ScatterChart`,
  `CandlestickChart`, `WaterfallChart`, `HeatmapChart`, `RadarChart`, `TreemapChart` und
  `LiveTickerChart`. Jede nimmt einfache Werttypen entgegen und braucht nur einen Frame.
- **Große und Live-Daten** – `TimeSeriesChart` reduziert jede Serie mit Largest-Triangle-Three-Buckets
  auf 1.000 Punkte, sodass 50.000 Messwerte pro Serie flüssig bleiben; es kann durch ein Zeitfenster
  scrollen und das ausgewählte Datum melden. `LiveSeries` hält die neuesten Werte in einem
  Ringpuffer für `LiveTickerChart`.
- **Die Analyse ist öffentlich** – `Histogram` (Sturges, Freedman–Diaconis, feste Breite oder
  feste Anzahl), `BoxPlotSummary` (Tukey-Whisker), `Statistics`, `LinearRegression`, `MovingAverage`,
  `NiceScale`-Achsenmarkierungen, `TreemapLayout` (squarified), `Candle.aggregate` und `Downsampling`.
- **Sicher bei jeder Eingabe** – nicht endliche Werte und Datumsangaben außerhalb der Jahre 1 bis
  4001 werden ausgelassen, endliche Werte jenseits von ±1e307 werden an dieser Grenze
  gezeichnet, Bereiche nahe `Double.greatestFiniteMagnitude` und subnormale Bereiche
  bleiben endlich, und Markierungsanzahl, Klassen (Bins), Puffer, Scroll-Fenster und Exporte haben
  Obergrenzen. Eine eigene Testsuite füttert die Analysetypen und die Diagramme mit `nan`,
  Unendlich, `Int.max`, Extrembereichen und extremen Datumsangaben.
- **Barrierefrei** – Die auf Swift Charts basierenden Views bieten VoiceOver-Navigation und Audio Graphs
  mit lesbaren Beschriftungen für Klassen, Boxen, Kerzen und Schritte; die ohne Swift Charts gezeichneten Views
  (Radar, Treemap, Ticker) hängen einen `AudioGraphDescriptor` an. Eine farbenblindheitsfreundliche
  Palette ist eingebaut.
- **Getestet** – 188 Swift-Testing-Tests in 33 Suites, ausgeführt auf macOS und in einem
  iPhone-Simulator, einschließlich Offscreen-Renderings jedes README-Beispiels im hellen und dunklen Modus.
- **Beispiele, die kompilieren** – Jedes Beispiel unten stammt aus der
  [Beispiel-App](Examples/ChartGallery), die die CI für iOS und macOS baut.

### Was enthalten ist

| Bereich              | Typen                                                                                         |
| -------------------- | --------------------------------------------------------------------------------------------- |
| Zeitreihen           | `TimeSeriesChart`, `TimeSeries`, `TimeSeriesPoint`, `MovingAverage`, `Downsampling`            |
| Statistik            | `HistogramChart`, `Histogram`, `BoxPlotChart`, `BoxPlotSummary`, `ScatterChart`, `LinearRegression`, `Statistics` |
| Finanzen             | `CandlestickChart`, `Candle`, `WaterfallChart`, `WaterfallStep`                               |
| Raster und Formen    | `HeatmapChart`, `HeatmapCell`, `RadarChart`, `RadarGeometry`, `TreemapChart`, `TreemapLayout` |
| Live-Daten           | `LiveTickerChart`, `LiveSeries`, `RingBuffer`                                                 |
| Gemeinsam genutzt    | `ChartPalette` und `.chartPalette(_:)`, `NiceScale`, `ChartExport`, `AudioGraphDescriptor`    |

## Schnellstart

**1. Paket hinzufügen**

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git
```

Füge sie in das Suchfeld oben rechts im Fenster ein. Lass **Dependency Rule** auf **Up to Next Major Version** ab `2.0.1` stehen und klicke auf **Add Package**. Wähle im nächsten Fenster neben **SwiftUIDataVisualization** dein App-Target aus und klicke erneut auf **Add Package**.

**2. Modul importieren**

```swift
import SwiftUIDataVisualization
```

Setze diese Zeile an den Anfang der Swift-Datei, in der du ein Diagramm zeichnest, unter `import SwiftUI`.

**3. Verwenden**

Ersetze in einer neuen Xcode-App (**File › New › Project… › App**) den gesamten Inhalt von `ContentView.swift` durch:

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

Drücke **Run** (⌘R). Die App zeigt eine blaue Linie der letzten sieben Tage; berühre die Linie (auf dem Mac fährst du mit dem Mauszeiger darüber), um das Datum und die Anzahl der Schritte zu sehen.

## Installation

### Swift Package Manager

Wähle in Xcode **File › Add Package Dependencies…** und gib die Repository-URL ein:

```text
https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git
```

Oder füge es zu den `dependencies` in deiner `Package.swift` hinzu:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git", from: "2.0.1")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftUIDataVisualization", package: "SwiftUI-Data-Visualization")
    ])
]
```

Version 2.0.0 (Oktober 2026) ist die erste Veröffentlichung der hier beschriebenen Diagramme. Die frühere Version 1.0.0 hatte eine andere API, die sich mit aktuellen Xcode-Versionen nicht bauen ließ; 2.0.0 übernimmt außerdem die Arbeit von SwiftUI-Charts-Pro, das archiviert wird. [CHANGELOG.md](CHANGELOG.md) listet die Änderungen auf, auch die inkompatiblen.

## Verwendung

Die folgenden Beispiele sind aus
[`Examples/ChartGallery/ChartGallery/ReadmeSamples.swift`](Examples/ChartGallery/ChartGallery/ReadmeSamples.swift)
kopiert. Die Beispiel-App und die Testsuite kompilieren beide diese Datei.

### Zeitreihen

```swift
struct ServerLoad: View {
    // 50,000 readings per server, one every 30 seconds; the chart draws 1,000 of each.
    let servers = [readings(name: "api-1", phase: 0), readings(name: "api-2", phase: 1)]

    static func readings(name: String, phase: Double) -> TimeSeries {
        let values = (0..<50_000).map { index -> Double in
            let wave = 25 * sin(Double(index) / 3_000 + phase)
            let noise = Double(index % 97) / 40
            return 40 + wave + noise
        }
        return TimeSeries(name: name, values: values, start: Date(timeIntervalSinceReferenceDate: 800_000_000), interval: 30)
    }

    var body: some View {
        TimeSeriesChart(servers, movingAverageWindow: 2_000)
            .frame(height: 240)
            .padding()
    }
}
```

Die gestrichelten Linien sind die gleitenden Durchschnitte über 2.000 Messwerte. Übergib `style: .area`, um den Bereich unter den Linien zu füllen.

### Scrollen, Auswahl und Export

```swift
struct ScrollingHistory: View {
    @State private var selected: Date?
    @State private var exported: Data?
    let load = ServerLoad.readings(name: "api-1", phase: 0)

    var chart: some View {
        // Two days at a time out of 17; the chart opens at the newest data.
        TimeSeriesChart(load, selection: $selected, visibleDuration: 2 * 86_400)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(selected.map { "Selected \($0.formatted(date: .abbreviated, time: .shortened))" } ?? "Touch the chart")
                .font(.headline)
            chart
                .frame(height: 220)
            Button("Export PNG") {
                exported = ChartExport.pngData(of: chart, size: CGSize(width: 600, height: 300))
            }
            if let exported {
                Text("\(exported.count) bytes")
            }
        }
        .padding()
    }
}
```

### Statistik

```swift
struct LatencyReport: View {
    let ios: [Double] = [112, 98, 130, 101, 145, 120, 99, 180, 104, 117, 125, 133, 230, 108, 121]
    let android: [Double] = [140, 151, 128, 160, 149, 171, 138, 155, 162, 147, 158, 133, 166, 152]

    var body: some View {
        VStack(spacing: 24) {
            HistogramChart(values: ios + android, binning: .width(25), valueLabel: "Latency (ms)")
                .frame(height: 180)
            BoxPlotChart([
                .init(name: "iOS", values: ios),
                .init(name: "Android", values: android),
            ], valueLabel: "Latency (ms)")
            .frame(height: 200)
        }
        .padding()
    }
}
```

Ohne `binning` wählt das Histogramm die Klassenbreite nach der Regel von Sturges oder der von Freedman–Diaconis, je nachdem, welche mehr Klassen ergibt. Der Boxplot markiert Werte, die mehr als das 1,5-Fache des Interquartilsabstands entfernt liegen, als Ausreißer.

### Trendlinie

```swift
struct HeightWeight: View {
    let people: [PlotPoint] = [
        .init(x: 158, y: 54), .init(x: 163, y: 60), .init(x: 167, y: 59), .init(x: 171, y: 68),
        .init(x: 174, y: 70), .init(x: 178, y: 74), .init(x: 181, y: 77), .init(x: 186, y: 85),
    ]

    var body: some View {
        ScatterChart(people, xLabel: "Height (cm)", yLabel: "Weight (kg)", showsTrendLine: true)
            .frame(height: 220)
            .padding()
    }
}
```

### Finanzen

```swift
struct PriceAndProfit: View {
    // Trades every 5 minutes for three days, grouped into one candle per 6 hours.
    let candles = Candle.aggregate(trades, interval: 6 * 3_600)

    static let trades = (0..<864).map { index -> TimeSeriesPoint in
        let date = Date(timeIntervalSinceReferenceDate: 800_000_000 + Double(index) * 300)
        let price = 100 + 6 * sin(Double(index) / 40) + Double(index % 13) / 4
        return TimeSeriesPoint(date: date, value: price)
    }

    var body: some View {
        VStack(spacing: 24) {
            CandlestickChart(candles)
                .frame(height: 200)
            WaterfallChart([
                WaterfallStep("Revenue", 420),
                WaterfallStep("Costs", -260),
                WaterfallStep("Tax", -40),
                .total("Profit"),
            ])
            .frame(height: 200)
        }
        .padding()
    }
}
```

### Heatmap

```swift
struct CommitActivity: View {
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    let hours = ["9", "11", "13", "15", "17"]

    var cells: [HeatmapCell] {
        days.enumerated().flatMap { day, dayName in
            hours.enumerated().map { hour, hourName in
                HeatmapCell(column: hourName, row: dayName, value: Double((day * 7 + hour * 3) % 11))
            }
        }
    }

    var body: some View {
        HeatmapChart(cells, valueLabel: "Commits", showsValues: true)
            .frame(height: 220)
            .padding()
    }
}
```

### Radar und Treemap

```swift
struct ProfileAndStorage: View {
    var body: some View {
        VStack(spacing: 24) {
            RadarChart(
                axes: ["Speed", "Power", "Range", "Comfort", "Price"],
                series: [
                    .init(name: "Model A", values: [8, 6, 7, 9, 5]),
                    .init(name: "Model B", values: [6, 9, 5, 6, 8]),
                ],
                maximum: 10
            )
            .frame(height: 260)
            TreemapChart([
                TreemapItem("Photos", value: 48),
                TreemapItem("Apps", value: 31),
                TreemapItem("Music", value: 12),
                TreemapItem("Mail", value: 6),
                TreemapItem("Notes", value: 3),
            ])
            .frame(height: 200)
        }
        .padding()
    }
}
```

### Live-Daten

```swift
struct LiveLoad: View {
    @State private var load = LiveSeries(capacity: 120)

    var body: some View {
        LiveTickerChart(values: load.values, title: "CPU load")
            .frame(height: 80)
            .padding()
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

### Farben

```swift
struct ColorblindSafeCharts: View {
    var body: some View {
        LatencyReport()
            .chartPalette(.colorblindSafe)
    }
}
```

Jedes Diagramm unterhalb des Modifiers verwendet die Palette. Die Standardpalette `.ocean` ist die blaue Palette auf den Screenshots; eigene Paletten erstellst du mit `ChartPalette(series:positive:negative:neutral:gradient:)`.

## Demo

| Hell                                                           | Dunkel                                                       |
| -------------------------------------------------------------- | ------------------------------------------------------------ |
| ![Zeitreihen, hell](docs/images/time-series-light.png)         | ![Zeitreihen, dunkel](docs/images/time-series-dark.png)      |
| ![Statistik, hell](docs/images/statistics-light.png)           | ![Statistik, dunkel](docs/images/statistics-dark.png)        |
| ![Trendlinie, hell](docs/images/trend-line-light.png)          | ![Trendlinie, dunkel](docs/images/trend-line-dark.png)       |
| ![Finanzen, hell](docs/images/finance-light.png)               | ![Finanzen, dunkel](docs/images/finance-dark.png)            |
| ![Heatmap, hell](docs/images/heatmap-light.png)                | ![Heatmap, dunkel](docs/images/heatmap-dark.png)             |
| ![Radar und Treemap, hell](docs/images/radar-treemap-light.png) | ![Radar und Treemap, dunkel](docs/images/radar-treemap-dark.png) |

Die Bilder werden im iOS-Simulator aus den Beispielen im Abschnitt Verwendung von
[`Tests/SwiftUIDataVisualizationTests/RenderTests.swift`](Tests/SwiftUIDataVisualizationTests/RenderTests.swift)
und [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) gerendert.

Die Zeitreihen- und Live-Daten-Bildschirme der Beispiel-App, aufgenommen in einem iPhone-Simulator mit
[`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh):

| Zeitreihen                                                       | Live-Daten                                                   |
| ---------------------------------------------------------------- | ------------------------------------------------------------ |
| ![Zeitreihen-Bildschirm, hell](docs/images/example-timeSeries-light.png) | ![Live-Daten-Bildschirm, hell](docs/images/example-liveData-light.png) |
| ![Zeitreihen-Bildschirm, dunkel](docs/images/example-timeSeries-dark.png) | ![Live-Daten-Bildschirm, dunkel](docs/images/example-liveData-dark.png) |

Um die Diagramme selbst auszuprobieren, öffne in Xcode `ChartGallery.xcodeproj` in [`Examples/ChartGallery`](Examples/ChartGallery), wähle einen iPhone-Simulator oder **My Mac** und drücke **Run**. Die App hat für jedes Beispiel oben einen Bildschirm; Details stehen in [Examples/README.md](Examples/README.md).

## Dokumentation

Referenzdokumentation und Artikel:

- [API-Referenz](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/)
  (DocC, von `master` auf GitHub Pages veröffentlicht)
- Baue sie lokal in Xcode mit **Product › Build Documentation** oder über die Kommandozeile:

```sh
xcodebuild docbuild -scheme SwiftUIDataVisualization -destination 'generic/platform=macOS'
```

## Anleitungen

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/gettingstarted)
  – Paket hinzufügen, ein erstes Diagramm zeichnen, eigene Daten zuordnen und eine Palette festlegen
  ([Quelle](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/GettingStarted.md)).
- [Choosing a Chart](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/choosingachart)
  – welches Diagramm welche Frage beantwortet und welche Statistik dahintersteckt
  ([Quelle](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/ChoosingAChart.md)).
- [Large and Live Data](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/largeandlivedata)
  – Downsampling, Scrollen durch lange Verläufe, Live-Werte und die Eingabegrenzen
  ([Quelle](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/LargeAndLiveData.md)).
- [Accessible Charts](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/accessiblecharts)
  – was VoiceOver bei jedem Diagramm vorliest und die farbenblindheitsfreundliche Palette
  ([Quelle](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/AccessibleCharts.md)).

## Voraussetzungen

| Plattform | Mindestversion        |
| --------- | --------------------- |
| iOS       | 17                    |
| macOS     | 14                    |
| Toolchain | Swift 6.2 · Xcode 26+ |

Die CI baut mit dem Standard-Xcode des `macos-26`-Runner-Images von GitHub. Das Paket wird mit Xcode 27 entwickelt.

## Architektur

- `Sources/SwiftUIDataVisualization/Charts/` enthält pro Diagramm-View eine Datei. Sieben davon sind
  `Chart`s von Swift Charts; `RadarChart`, `TreemapChart` und `LiveTickerChart` zeichnen mit `Canvas`
  oder einfachen Views, weil Swift Charts weder Polar- noch Treemap-Koordinaten kennt und ein Ticker,
  der mit der Bildwiederholrate neu gezeichnet wird, in einem einzigen `Canvas`-Durchlauf günstiger ist.
- `Analysis/`, `Layout/` und `Data/` enthalten die Werttypen und Funktionen, die die Diagramme nutzen
  (`Histogram`, `BoxPlotSummary`, `LinearRegression`, `NiceScale`, `TreemapLayout`, `Candle`, …). Sie
  enthalten keinen View-Code und sind `Sendable`, können also abseits des Main Actors laufen.
- Die Vorbereitung, die jedes Diagramm vor dem Zeichnen vornimmt (Downsampling, Whisker-Bereiche,
  Breiten der Kerzenkörper, Wasserfall-Balken, Radar-Maximum), liegt in `nonisolated static`-Funktionen,
  die die Tests direkt aufrufen.
- `Streaming/` enthält `RingBuffer` und `LiveSeries`, den einzigen Referenztyp, eine `@Observable`-Klasse
  auf dem Main Actor. `Style/ChartPalette.swift` reicht Farben über die Umgebung (Environment) weiter.
- Die CI führt `swift test` auf macOS und `xcodebuild test` in einem iPhone-Simulator aus, baut die
  Beispiel-App für iOS und macOS und veröffentlicht die DocC-Dokumentation.

Tests lokal ausführen:

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIDataVisualization \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Roadmap

- Das Paket zum Swift Package Index hinzufügen; `.spi.yml` liegt bereits im Repository.
- Zoomen mit zwei Fingern auf der Zeitachse von `TimeSeriesChart`.
- visionOS testen und aktivieren, das Swift Charts unterstützt.

## Mitwirken

Beiträge sind willkommen. Lies vor einem Pull Request den [Leitfaden für Beiträge](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/CONTRIBUTING.md) und den [Verhaltenskodex](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md). Sicherheitsprobleme meldest du vertraulich, wie in der [Sicherheitsrichtlinie](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md) beschrieben.

## Lizenz

Veröffentlicht unter der MIT-Lizenz. Siehe [LICENSE](LICENSE).
