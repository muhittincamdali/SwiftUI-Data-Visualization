<!-- i18n-source: README.md@a0927e461cd2c1c9614e7b64e10615258019dc9e status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-ko-light.svg" alt="SwiftUI Data Visualization: Swift Charts 기반의 iOS·macOS SwiftUI용 통계, 금융, 실시간 차트."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions/workflows/ci.yml/badge.svg" alt="CI 상태"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-light.svg" alt="최신 버전: v2.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-light.svg" alt="지원 플랫폼: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-light.svg" alt="언어 버전: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-light.svg" alt="라이선스: MIT"></picture></a>
</p>

<p align="center">
<a href="#빠른-시작"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-ko-light.svg" alt="시작하기"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-ko-light.svg" alt="문서"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/tree/master/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-ko-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-ko-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-ko-light.svg" alt="예제"></picture></a>
</p>

> 이 문서는 영어 README의 번역본입니다. 내용이 다를 경우 영어 버전이 최신입니다.

<!-- brand:end -->

iOS 17+와 macOS 14+의 SwiftUI에서 쓸 수 있는, Swift Charts 기반 차트 뷰 Swift 패키지입니다. 수만 개의 점을 가진 시계열, 히스토그램, 박스 플롯, 추세선, 캔들스틱, 워터폴, 히트맵, 레이더 차트, 트리맵, 실시간 티커처럼 Swift Charts가 직접 구현하도록 남겨 둔 차트를 다룹니다. 그 뒤의 분석 로직도 공개하므로 직접 만든 `Chart`에서도 사용할 수 있습니다. 이 패키지는 의존성이 없습니다.

## 주요 기능

- **10가지 차트 뷰** — `TimeSeriesChart`, `HistogramChart`, `BoxPlotChart`, `ScatterChart`,
  `CandlestickChart`, `WaterfallChart`, `HeatmapChart`, `RadarChart`, `TreemapChart`,
  `LiveTickerChart`. 각각 단순한 값 타입을 받으며 frame만 지정하면 됩니다.
- **대용량 데이터와 실시간 데이터** — `TimeSeriesChart`는 Largest-Triangle-Three-Buckets로 각 시리즈를
  1,000개 점으로 다운샘플링하므로 시리즈당 측정값 50,000개도 부드럽게 표시됩니다. 시간 구간 안에서
  스크롤할 수 있고 선택한 날짜를 알려 줍니다. `LiveSeries`는 최신 값을 링 버퍼에 보관하여
  `LiveTickerChart`에 제공합니다.
- **분석 로직 공개** — `Histogram`(Sturges, Freedman–Diaconis, 고정 너비 또는 개수),
  `BoxPlotSummary`(Tukey 수염), `Statistics`, `LinearRegression`, `MovingAverage`,
  `NiceScale` 축 눈금, `TreemapLayout`(squarified), `Candle.aggregate`, `Downsampling`.
- **어떤 입력에도 안전** — 유한하지 않은 값과 1년부터 4001년 밖의 날짜는 제외되고,
  절댓값이 1e307을 넘는 유한한 값은 ±1e307 위치에 그려지며,
  `Double.greatestFiniteMagnitude`에 가까운 범위와 비정규 수 범위도 유한한 값으로 유지되며, 눈금 수,
  구간(bin), 버퍼, 스크롤 창 수, 내보내기에는 상한이 있습니다. 전용 테스트 스위트가 분석 타입과 차트에 `nan`, 무한대,
  `Int.max`, 극단적인 범위, 극단적인 날짜를 입력합니다.
- **접근성** — Swift Charts 기반 뷰는 VoiceOver 탐색과 Audio Graphs를 지원하며, 구간, 상자, 캔들, 단계에
  읽을 수 있는 레이블이 붙습니다. Canvas 기반 뷰(레이더, 트리맵, 티커)에는 `AudioGraphDescriptor`가
  연결됩니다. 색각 이상 사용자를 위한 팔레트가 기본으로 들어 있습니다.
- **테스트 완료** — 33개 스위트에 걸친 Swift Testing 테스트 188개를 macOS와 iPhone 시뮬레이터에서
  실행하며, README의 모든 예제를 라이트 모드와 다크 모드로 화면 밖에서 렌더링하는 테스트도 포함됩니다.
- **컴파일되는 사용 예제** — 아래의 모든 예제는 CI가 iOS와 macOS용으로 빌드하는
  [예제 앱](Examples/ChartGallery)에서 가져온 것입니다.

### 포함된 항목

| 영역             | 타입                                                                                          |
| ---------------- | --------------------------------------------------------------------------------------------- |
| 시계열           | `TimeSeriesChart`, `TimeSeries`, `TimeSeriesPoint`, `MovingAverage`, `Downsampling`            |
| 통계             | `HistogramChart`, `Histogram`, `BoxPlotChart`, `BoxPlotSummary`, `ScatterChart`, `LinearRegression`, `Statistics` |
| 금융             | `CandlestickChart`, `Candle`, `WaterfallChart`, `WaterfallStep`                               |
| 격자와 도형      | `HeatmapChart`, `HeatmapCell`, `RadarChart`, `RadarGeometry`, `TreemapChart`, `TreemapLayout` |
| 실시간 데이터    | `LiveTickerChart`, `LiveSeries`, `RingBuffer`                                                 |
| 공통             | `ChartPalette` 및 `.chartPalette(_:)`, `NiceScale`, `ChartExport`, `AudioGraphDescriptor`    |

## 빠른 시작

**1. 패키지 추가**

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git
```

창 오른쪽 위의 검색란에 붙여 넣으세요. **Dependency Rule**은 `2.0.0`부터 **Up to Next Major Version**으로 그대로 두고 **Add Package**를 클릭하세요. 다음 창에서 **SwiftUIDataVisualization** 옆에서 앱 타깃을 선택하고 **Add Package**를 다시 클릭하세요.

**2. 모듈 가져오기**

```swift
import SwiftUIDataVisualization
```

이 줄은 차트를 그리는 Swift 파일의 맨 위, `import SwiftUI` 아래에 넣으세요.

**3. 사용하기**

새 Xcode 앱(**File › New › Project… › App**)에서 `ContentView.swift`의 내용을 모두 다음으로 바꾸세요.

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

**Run**(⌘R)을 누르세요. 앱에 최근 7일간의 파란 선이 표시됩니다. 선을 터치하면(Mac에서는 마우스를 올리면) 날짜와 걸음 수를 볼 수 있습니다.

## 설치

### Swift Package Manager

Xcode에서 **File › Add Package Dependencies…**를 선택하고 저장소 URL을 입력하세요.

```text
https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git
```

또는 `Package.swift`의 `dependencies`에 추가하세요.

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git", from: "2.0.0")
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "SwiftUIDataVisualization", package: "SwiftUI-Data-Visualization")
    ])
]
```

버전 2.0.0(2026년 10월)은 여기서 설명하는 차트의 첫 번째 릴리스입니다. 이전 릴리스인 1.0.0은 API가 달랐고 현재 Xcode 버전에서는 빌드되지 않았습니다. 2.0.0에는 보관(archive)될 예정인 SwiftUI-Charts-Pro의 작업도 통합되었습니다. 호환성을 깨는 변경을 포함한 모든 변경 사항은 [CHANGELOG.md](CHANGELOG.md)에 정리되어 있습니다.

## 사용법

아래 예제는
[`Examples/ChartGallery/ChartGallery/ReadmeSamples.swift`](Examples/ChartGallery/ChartGallery/ReadmeSamples.swift)에서
복사한 것입니다. 예제 앱과 테스트 스위트가 모두 이 파일을 컴파일합니다.

### 시계열

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

점선은 측정값 2,000개에 대한 이동 평균입니다. 선 아래를 채우려면 `style: .area`를 전달하세요.

### 스크롤, 선택, 내보내기

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

### 통계

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

`binning`을 지정하지 않으면 히스토그램은 Sturges 규칙과 Freedman–Diaconis 규칙 중 구간이 더 많아지는 쪽으로 구간 너비를 정합니다. 박스 플롯은 사분위 범위의 1.5배를 벗어나는 값을 이상치로 표시합니다.

### 추세선

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

### 금융

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

### 히트맵

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

### 레이더와 트리맵

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

### 실시간 데이터

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

### 색상

```swift
struct ColorblindSafeCharts: View {
    var body: some View {
        LatencyReport()
            .chartPalette(.colorblindSafe)
    }
}
```

이 수정자 아래의 모든 차트가 해당 팔레트를 사용합니다. 기본값인 `.ocean`은 스크린샷에 쓰인 파란색 팔레트이며, 직접 만들려면 `ChartPalette(series:positive:negative:neutral:gradient:)`를 사용하세요.

## 데모

| 라이트                                                         | 다크                                                         |
| -------------------------------------------------------------- | ------------------------------------------------------------ |
| ![시계열, 라이트](docs/images/time-series-light.png)           | ![시계열, 다크](docs/images/time-series-dark.png)            |
| ![통계, 라이트](docs/images/statistics-light.png)              | ![통계, 다크](docs/images/statistics-dark.png)               |
| ![추세선, 라이트](docs/images/trend-line-light.png)            | ![추세선, 다크](docs/images/trend-line-dark.png)             |
| ![금융, 라이트](docs/images/finance-light.png)                 | ![금융, 다크](docs/images/finance-dark.png)                  |
| ![히트맵, 라이트](docs/images/heatmap-light.png)               | ![히트맵, 다크](docs/images/heatmap-dark.png)                |
| ![레이더와 트리맵, 라이트](docs/images/radar-treemap-light.png) | ![레이더와 트리맵, 다크](docs/images/radar-treemap-dark.png) |

이미지는 사용법의 예제를 iOS 시뮬레이터에서
[`Tests/SwiftUIDataVisualizationTests/RenderTests.swift`](Tests/SwiftUIDataVisualizationTests/RenderTests.swift)와
[`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh)로 렌더링한 것입니다.

예제 앱의 시계열 화면과 실시간 데이터 화면을
[`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh)로 iPhone 시뮬레이터에서 캡처한 이미지입니다.

| 시계열                                                           | 실시간 데이터                                                |
| ---------------------------------------------------------------- | ------------------------------------------------------------ |
| ![시계열 화면, 라이트](docs/images/example-timeSeries-light.png) | ![실시간 데이터 화면, 라이트](docs/images/example-liveData-light.png) |
| ![시계열 화면, 다크](docs/images/example-timeSeries-dark.png)    | ![실시간 데이터 화면, 다크](docs/images/example-liveData-dark.png)    |

차트를 직접 사용해 보려면 Xcode에서 [`Examples/ChartGallery`](Examples/ChartGallery)의 `ChartGallery.xcodeproj`를 열고 iPhone 시뮬레이터나 **My Mac**을 선택한 다음 **Run**을 누르세요. 앱에는 위의 각 예제마다 화면이 하나씩 있습니다. 자세한 내용은 [Examples/README.md](Examples/README.md)를 참고하세요.

## 문서

API 레퍼런스와 문서:

- [API 레퍼런스](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/)
  (DocC, `master`에서 GitHub Pages로 게시됩니다)
- Xcode에서 **Product › Build Documentation**으로 로컬에서 빌드하거나 명령줄에서 빌드할 수 있습니다.

```sh
xcodebuild docbuild -scheme SwiftUIDataVisualization -destination 'generic/platform=macOS'
```

## 가이드

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/gettingstarted)
  — 패키지 추가, 첫 차트 그리기, 내 데이터 연결, 팔레트 설정
  ([소스](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/GettingStarted.md)).
- [Choosing a Chart](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/choosingachart)
  — 어떤 차트가 어떤 질문에 답하는지와 그 뒤의 통계
  ([소스](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/ChoosingAChart.md)).
- [Large and Live Data](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/largeandlivedata)
  — 다운샘플링, 긴 기록 스크롤, 실시간 값, 입력 한도
  ([소스](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/LargeAndLiveData.md)).
- [Accessible Charts](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/accessiblecharts)
  — 차트별로 VoiceOver가 읽어 주는 내용과 색각 이상 사용자를 위한 팔레트
  ([소스](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/AccessibleCharts.md)).

## 요구 사항

| 플랫폼    | 최소 버전             |
| --------- | --------------------- |
| iOS       | 17                    |
| macOS     | 14                    |
| 툴체인    | Swift 6.2 · Xcode 26+ |

CI는 GitHub `macos-26` 러너 이미지의 기본 Xcode로 빌드합니다. 패키지는 Xcode 27로 개발하고 있습니다.

## 아키텍처

- `Sources/SwiftUIDataVisualization/Charts/`에는 차트 뷰마다 파일이 하나씩 있습니다. 그중 7개는
  Swift Charts의 `Chart`입니다. `RadarChart`, `TreemapChart`, `LiveTickerChart`는 `Canvas`나 일반 뷰로
  그립니다. Swift Charts에는 극좌표나 트리맵 좌표가 없고, 화면 주사율에 맞춰 다시 그려지는 티커는
  한 번의 `Canvas` 패스로 그리는 편이 비용이 적기 때문입니다.
- `Analysis/`, `Layout/`, `Data/`에는 차트가 사용하는 값 타입과 함수가 있습니다
  (`Histogram`, `BoxPlotSummary`, `LinearRegression`, `NiceScale`, `TreemapLayout`, `Candle` 등).
  뷰 코드가 없고 `Sendable`이므로 메인 액터 밖에서 실행할 수 있습니다.
- 각 차트가 그리기 전에 하는 준비 작업(다운샘플링, 수염 범위, 캔들 몸통 너비, 워터폴 막대,
  레이더 최댓값)은 `nonisolated static` 함수에 있으며 테스트가 이 함수를 직접 호출합니다.
- `Streaming/`에는 `RingBuffer`와 `LiveSeries`가 있습니다. `LiveSeries`는 유일한 참조 타입이며
  메인 액터의 `@Observable` 클래스입니다. `Style/ChartPalette.swift`는 색상을 환경(environment)으로 전달합니다.
- CI는 macOS에서 `swift test`, iPhone 시뮬레이터에서 `xcodebuild test`를 실행하고, 예제 앱을 iOS와
  macOS용으로 빌드하며, DocC 문서를 게시합니다.

로컬에서 테스트를 실행하려면 다음과 같이 하세요.

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIDataVisualization \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## 로드맵

- 패키지를 Swift Package Index에 추가하기. `.spi.yml`은 이미 저장소에 있습니다.
- `TimeSeriesChart`의 시간 축에서 핀치 줌 지원.
- Swift Charts가 지원하는 visionOS를 테스트하고 활성화하기.

## 기여하기

기여를 환영합니다. pull request를 열기 전에 [기여 가이드](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/CONTRIBUTING.md)와 [행동 강령](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md)을 읽어 주세요. 보안 문제는 [보안 정책](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md)에 따라 비공개로 제보해 주세요.

## 라이선스

MIT 라이선스로 배포됩니다. 자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
