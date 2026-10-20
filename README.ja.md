<!-- i18n-source: README.md@9c3004eb1f2fbd823bedb2aacba752257f750bb5 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-ja-light.svg" alt="SwiftUI Data Visualization: Swift Charts をベースにした、iOS と macOS の SwiftUI 向け統計・金融・ライブチャート。"></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions/workflows/ci.yml/badge.svg" alt="CI ステータス"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-light.svg" alt="最新バージョン: v2.0.2"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-light.svg" alt="対応プラットフォーム: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-light.svg" alt="言語バージョン: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-light.svg" alt="ライセンス: MIT"></picture></a>
</p>

<p align="center">
<a href="#クイックスタート"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-ja-light.svg" alt="はじめる"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-ja-light.svg" alt="ドキュメント"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/tree/master/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-ja-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-ja-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-ja-light.svg" alt="サンプル"></picture></a>
</p>

> このドキュメントは英語版 README の翻訳です。内容が異なる場合は英語版が最新です。

<!-- brand:end -->

iOS 17+ と macOS 14+ の SwiftUI 向けに、Swift Charts をベースに作られたチャートビューの Swift パッケージです。数万点規模の時系列、ヒストグラム、箱ひげ図、トレンドライン、ローソク足、ウォーターフォール、ヒートマップ、レーダーチャート、ツリーマップ、ライブティッカーなど、Swift Charts が開発者に任せている種類のチャートを扱います。さらに、その背後にある分析処理も公開しているため、ご自身の `Chart` で使うこともできます。このパッケージに依存ライブラリはありません。

## 主な特長

- **10 種類のチャートビュー**：`TimeSeriesChart`、`HistogramChart`、`BoxPlotChart`、`ScatterChart`、`CandlestickChart`、`WaterfallChart`、`HeatmapChart`、`RadarChart`、`TreemapChart`、`LiveTickerChart`。いずれも単純な値型を受け取り、必要なのは frame だけです。
- **大規模データとライブデータ**：`TimeSeriesChart` は Largest-Triangle-Three-Buckets で各系列を 1,000 点にダウンサンプリングするため、系列あたり 50,000 件の測定値でも滑らかに動作します。時間ウィンドウ内でのスクロールと、選択された日付の通知にも対応しています。`LiveSeries` は最新の値をリングバッファに保持し、`LiveTickerChart` に渡します。
- **分析処理を公開**：`Histogram`（Sturges、Freedman–Diaconis、固定幅または固定数）、`BoxPlotSummary`（Tukey のひげ）、`Statistics`、`LinearRegression`、`MovingAverage`、`NiceScale` の軸目盛り、`TreemapLayout`（squarified）、`Candle.aggregate`、`Downsampling`。
- **どんな入力でも安全**：有限でない値と西暦 1 年から 4001 年の範囲外の日付は除外され、絶対値が 1e307 を超える有限の値は ±1e307 の位置に描画され、`Double.greatestFiniteMagnitude` に近い範囲や非正規化数の範囲も有限のままで、目盛りの数、ビン、バッファ、スクロールのウィンドウ数、エクスポートには上限があります。専用のテストスイートが、分析用の型とチャートに `nan`、無限大、`Int.max`、極端な範囲、極端な日付を与えます。
- **アクセシビリティ対応**：Swift Charts ベースのビューは VoiceOver によるナビゲーションと Audio Graphs に対応し、ビン、箱、ローソク足、ステップには読み上げ用のラベルが付きます。Swift Charts を使わないビュー（レーダー、ツリーマップ、ティッカー）には `AudioGraphDescriptor` が付きます。色覚多様性に配慮したパレットも組み込まれています。
- **テスト済み**：33 スイートにわたる 188 件の Swift Testing テストを macOS と iPhone シミュレーターで実行します。README のすべてのサンプルをライトモードとダークモードでオフスクリーン描画するテストも含まれます。
- **コンパイルできる使用例**：以下のサンプルはすべて、CI が iOS と macOS 向けにビルドしている [サンプルアプリ](Examples/ChartGallery)のものです。

### 含まれるもの

| 分野             | 型                                                                                            |
| ---------------- | --------------------------------------------------------------------------------------------- |
| 時系列           | `TimeSeriesChart`, `TimeSeries`, `TimeSeriesPoint`, `MovingAverage`, `Downsampling`            |
| 統計             | `HistogramChart`, `Histogram`, `BoxPlotChart`, `BoxPlotSummary`, `ScatterChart`, `LinearRegression`, `Statistics` |
| 金融             | `CandlestickChart`, `Candle`, `WaterfallChart`, `WaterfallStep`                               |
| グリッドと図形   | `HeatmapChart`, `HeatmapCell`, `RadarChart`, `RadarGeometry`, `TreemapChart`, `TreemapLayout` |
| ライブデータ     | `LiveTickerChart`, `LiveSeries`, `RingBuffer`                                                 |
| 共通             | `ChartPalette` と `.chartPalette(_:)`, `NiceScale`, `ChartExport`, `AudioGraphDescriptor`    |

## クイックスタート

**1. パッケージを追加する**

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git
```

ウィンドウ右上の検索欄に貼り付けます。**Dependency Rule** は `2.0.2` からの **Up to Next Major Version** のままにして、**Add Package** をクリックします。次のウィンドウで **SwiftUIDataVisualization** の横にあるアプリのターゲットを選び、もう一度 **Add Package** をクリックします。

**2. モジュールをインポートする**

```swift
import SwiftUIDataVisualization
```

この行は、チャートを描画する Swift ファイルの先頭、`import SwiftUI` の下に書きます。

**3. 使ってみる**

新しい Xcode アプリ（**File › New › Project… › App**）で、`ContentView.swift` の内容をすべて次のコードに置き換えます。

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

**Run**（⌘R）を押します。アプリに直近 7 日間の青い線が表示されます。線にタッチする（Mac ではカーソルを重ねる）と、日付と歩数が表示されます。

## インストール

### Swift Package Manager

Xcode で **File › Add Package Dependencies…** を選び、リポジトリの URL を入力します。

```text
https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git
```

または `Package.swift` の `dependencies` に追加します。

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git", from: "2.0.2")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftUIDataVisualization", package: "SwiftUI-Data-Visualization")
    ])
]
```

バージョン 2.0.0（2026 年 10 月）は、ここで説明しているチャートの最初のリリースです。以前のリリースである 1.0.0 は API が異なり、現在の Xcode ではビルドできませんでした。2.0.0 には、アーカイブ予定の SwiftUI-Charts-Pro の成果も取り込まれています。破壊的変更を含む変更点は [CHANGELOG.md](CHANGELOG.md) にまとめています。

## 使い方

以下のサンプルは [`Examples/ChartGallery/ChartGallery/ReadmeSamples.swift`](Examples/ChartGallery/ChartGallery/ReadmeSamples.swift) からコピーしたものです。サンプルアプリとテストスイートの両方がこのファイルをコンパイルします。

### 時系列

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

破線は 2,000 件の測定値による移動平均です。線の下を塗りつぶすには `style: .area` を渡します。

### スクロール、選択、エクスポート

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

### 統計

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

`binning` を指定しない場合、ヒストグラムは Sturges の公式と Freedman–Diaconis の規則のうち、ビンの数が多くなるほうでビン幅を決めます。箱ひげ図は、四分位範囲の 1.5 倍を超える値を外れ値として表示します。

### トレンドライン

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

### 金融

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

### ヒートマップ

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

### レーダーチャートとツリーマップ

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

### ライブデータ

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

### 色

```swift
struct ColorblindSafeCharts: View {
    var body: some View {
        LatencyReport()
            .chartPalette(.colorblindSafe)
    }
}
```

このモディファイアより下にあるすべてのチャートがこのパレットを使います。既定の `.ocean` は、スクリーンショットで使われている青のパレットです。独自のパレットは `ChartPalette(series:positive:negative:neutral:gradient:)` で作れます。

## デモ

| ライト                                                         | ダーク                                                       |
| -------------------------------------------------------------- | ------------------------------------------------------------ |
| ![時系列（ライト）](docs/images/time-series-light.png)         | ![時系列（ダーク）](docs/images/time-series-dark.png)        |
| ![統計（ライト）](docs/images/statistics-light.png)            | ![統計（ダーク）](docs/images/statistics-dark.png)           |
| ![トレンドライン（ライト）](docs/images/trend-line-light.png)  | ![トレンドライン（ダーク）](docs/images/trend-line-dark.png) |
| ![金融（ライト）](docs/images/finance-light.png)               | ![金融（ダーク）](docs/images/finance-dark.png)              |
| ![ヒートマップ（ライト）](docs/images/heatmap-light.png)       | ![ヒートマップ（ダーク）](docs/images/heatmap-dark.png)      |
| ![レーダーとツリーマップ（ライト）](docs/images/radar-treemap-light.png) | ![レーダーとツリーマップ（ダーク）](docs/images/radar-treemap-dark.png) |

これらの画像は、「使い方」のサンプルから iOS シミュレーター上で [`Tests/SwiftUIDataVisualizationTests/RenderTests.swift`](Tests/SwiftUIDataVisualizationTests/RenderTests.swift) と [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh) によって描画したものです。

サンプルアプリの時系列画面とライブデータ画面を、[`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh) で iPhone シミュレーター上にキャプチャしたものです。

| 時系列                                                           | ライブデータ                                                 |
| ---------------------------------------------------------------- | ------------------------------------------------------------ |
| ![時系列画面（ライト）](docs/images/example-timeSeries-light.png) | ![ライブデータ画面（ライト）](docs/images/example-liveData-light.png) |
| ![時系列画面（ダーク）](docs/images/example-timeSeries-dark.png)  | ![ライブデータ画面（ダーク）](docs/images/example-liveData-dark.png)  |

チャートを実際に試すには、Xcode で [`Examples/ChartGallery`](Examples/ChartGallery) の `ChartGallery.xcodeproj` を開き、iPhone シミュレーターまたは **My Mac** を選んで **Run** を押します。アプリには、上のサンプルごとに 1 つの画面があります。詳しくは [Examples/README.md](Examples/README.md) を参照してください。

## ドキュメント

API リファレンスと解説記事：

- [API リファレンス](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/)（DocC。`master` から GitHub Pages に公開されます）
- ローカルでは、Xcode の **Product › Build Documentation** で、またはコマンドラインからビルドできます。

```sh
xcodebuild docbuild -scheme SwiftUIDataVisualization -destination 'generic/platform=macOS'
```

## ガイド

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/gettingstarted)：パッケージの追加、最初のチャートの描画、自分のデータの割り当て、パレットの設定（[ソース](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/GettingStarted.md)）。
- [Choosing a Chart](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/choosingachart)：どのチャートがどんな疑問に答えるか、そしてその背後にある統計（[ソース](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/ChoosingAChart.md)）。
- [Large and Live Data](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/largeandlivedata)：ダウンサンプリング、長い履歴のスクロール、ライブ値、入力の上限（[ソース](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/LargeAndLiveData.md)）。
- [Accessible Charts](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/accessiblecharts)：VoiceOver が各チャートで何を読み上げるか、そして色覚多様性に配慮したパレット（[ソース](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/AccessibleCharts.md)）。

## 動作要件

| プラットフォーム | 最小バージョン        |
| ---------------- | --------------------- |
| iOS              | 17                    |
| macOS            | 14                    |
| ツールチェーン   | Swift 6.2 · Xcode 26+ |

CI は GitHub の `macos-26` ランナーイメージに入っている既定の Xcode でビルドします。パッケージ自体は Xcode 27 で開発しています。

## アーキテクチャ

- `Sources/SwiftUIDataVisualization/Charts/` には、チャートビューごとに 1 つのファイルがあります。そのうち 7 つは Swift Charts の `Chart` です。`RadarChart`、`TreemapChart`、`LiveTickerChart` は `Canvas` または通常のビューで描画します。Swift Charts には極座標やツリーマップの座標がなく、表示のリフレッシュレートで再描画されるティッカーは 1 回の `Canvas` パスで描くほうが軽いためです。
- `Analysis/`、`Layout/`、`Data/` には、チャートが使う値型と関数があります（`Histogram`、`BoxPlotSummary`、`LinearRegression`、`NiceScale`、`TreemapLayout`、`Candle` など）。ビューのコードは含まず、`Sendable` なので、メインアクターの外でも実行できます。
- 各チャートが描画前に行う準備（ダウンサンプリング、ひげの値域、ローソク足の実体の幅、ウォーターフォールのバー、レーダーの最大値）は、`nonisolated static` な関数に置かれており、テストはそれらを直接呼び出します。
- `Streaming/` には `RingBuffer` と `LiveSeries` があります。`LiveSeries` は唯一の参照型で、メインアクター上の `@Observable` クラスです。`Style/ChartPalette.swift` は色を環境（environment）経由で渡します。
- CI は macOS で `swift test`、iPhone シミュレーターで `xcodebuild test` を実行し、サンプルアプリを iOS と macOS 向けにビルドして、DocC ドキュメントを公開します。

ローカルでテストを実行するには次のようにします。

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIDataVisualization \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## ロードマップ

- パッケージを Swift Package Index に追加する。`.spi.yml` はすでにリポジトリに含まれています。
- `TimeSeriesChart` の時間軸でのピンチズーム。
- Swift Charts が対応している visionOS でのテストと有効化。

## コントリビューション

コントリビューションを歓迎します。pull request を作成する前に[コントリビューションガイド](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/CONTRIBUTING.md)と[行動規範](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)をお読みください。セキュリティ上の問題は[セキュリティポリシー](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)に従って非公開で報告してください。

## ライセンス

MIT ライセンスで公開しています。詳細は [LICENSE](LICENSE) を参照してください。
