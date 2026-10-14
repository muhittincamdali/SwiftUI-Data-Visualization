<!-- i18n-source: README.md@ece7cb3e7fa54e87d5352d3b54f37e863a76405d status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-ru-light.svg" alt="SwiftUI Data Visualization: Статистические, финансовые и живые графики для SwiftUI на iOS и macOS на основе Swift Charts."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions/workflows/ci.yml/badge.svg" alt="Статус CI"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-light.svg" alt="Последняя версия: v1.0.0"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-light.svg" alt="Поддерживаемые платформы: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-light.svg" alt="Версия языка: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-light.svg" alt="Лицензия: MIT"></picture></a>
</p>

<p align="center">
<a href="#быстрый-старт"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-ru-light.svg" alt="Начать"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-ru-light.svg" alt="Документация"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/tree/master/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-ru-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-ru-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-ru-light.svg" alt="Примеры"></picture></a>
</p>

> Это перевод README на английском языке. Если они расходятся, актуальна английская версия.

<!-- brand:end -->

Swift-пакет с представлениями графиков для SwiftUI на iOS 17+ и macOS 14+, построенный на Swift Charts. Он охватывает графики, которые Swift Charts оставляет вам: временные ряды с десятками тысяч точек, гистограммы, «ящики с усами», линии тренда, японские свечи, каскадные диаграммы, тепловые карты, радарные диаграммы, древовидные карты (treemap) и биржевые ленты в реальном времени. Кроме того, пакет открывает анализ, который за ними стоит, поэтому его можно использовать в собственном `Chart`. У пакета нет зависимостей.

## Основные возможности

- **10 представлений графиков** — `TimeSeriesChart`, `HistogramChart`, `BoxPlotChart`, `ScatterChart`,
  `CandlestickChart`, `WaterfallChart`, `HeatmapChart`, `RadarChart`, `TreemapChart` и
  `LiveTickerChart`. Каждое принимает простые типы-значения, и ему нужен только frame.
- **Большие данные и данные в реальном времени** — `TimeSeriesChart` сокращает каждый ряд до 1 000 точек
  алгоритмом Largest-Triangle-Three-Buckets, поэтому 50 000 измерений на ряд остаются плавными; график
  можно прокручивать по временному окну, и он сообщает выбранную дату. `LiveSeries` хранит последние
  значения в кольцевом буфере для `LiveTickerChart`.
- **Анализ открыт** — `Histogram` (Sturges, Freedman–Diaconis, фиксированная ширина или фиксированное число),
  `BoxPlotSummary` (усы Тьюки), `Statistics`, `LinearRegression`, `MovingAverage`,
  деления осей `NiceScale`, `TreemapLayout` (squarified), `Candle.aggregate` и `Downsampling`.
- **Безопасность при любых входных данных** — нечисловые и бесконечные значения отбрасываются, диапазоны
  около `Double.greatestFiniteMagnitude` и субнормальные диапазоны остаются конечными, а число делений,
  интервалов (bin), буферов и экспортов ограничено сверху. Отдельный набор тестов подаёт в каждое
  вычисление `nan`, бесконечность, `Int.max` и экстремальные диапазоны.
- **Доступность** — представления на основе Swift Charts получают навигацию VoiceOver и Audio Graphs
  с понятными подписями для интервалов, ящиков, свечей и шагов; представления на основе Canvas
  (радар, treemap, лента) добавляют `AudioGraphDescriptor`. Встроена палитра, безопасная для людей с
  нарушением цветового зрения.
- **Протестировано** — 160 тестов Swift Testing в 31 наборе, которые выполняются на macOS и в симуляторе
  iPhone, включая внеэкранный рендеринг каждого примера из README в светлой и тёмной темах.
- **Примеры использования, которые компилируются** — каждый пример ниже взят из
  [примера приложения](Examples/ChartGallery), которое CI собирает для iOS и macOS.

### Что входит в пакет

| Область                | Типы                                                                                          |
| ---------------------- | --------------------------------------------------------------------------------------------- |
| Временные ряды         | `TimeSeriesChart`, `TimeSeries`, `TimeSeriesPoint`, `MovingAverage`, `Downsampling`            |
| Статистика             | `HistogramChart`, `Histogram`, `BoxPlotChart`, `BoxPlotSummary`, `ScatterChart`, `LinearRegression`, `Statistics` |
| Финансы                | `CandlestickChart`, `Candle`, `WaterfallChart`, `WaterfallStep`                               |
| Сетки и фигуры         | `HeatmapChart`, `HeatmapCell`, `RadarChart`, `RadarGeometry`, `TreemapChart`, `TreemapLayout` |
| Данные в реальном времени | `LiveTickerChart`, `LiveSeries`, `RingBuffer`                                              |
| Общее                  | `ChartPalette` и `.chartPalette(_:)`, `NiceScale`, `ChartExport`, `AudioGraphDescriptor`    |

## Быстрый старт

**1. Добавьте пакет**

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git
```

Вставьте его в поле поиска в правом верхнем углу окна. Оставьте **Dependency Rule** равным **Up to Next Major Version** от `2.0.0` и нажмите **Add Package**. В следующем окне выберите таргет вашего приложения рядом с **SwiftUIDataVisualization** и снова нажмите **Add Package**.

**2. Импортируйте модуль**

```swift
import SwiftUIDataVisualization
```

Добавьте эту строку в начало Swift-файла, где вы рисуете график, под `import SwiftUI`.

**3. Используйте**

В новом приложении Xcode (**File › New › Project… › App**) замените всё содержимое `ContentView.swift` на:

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

Нажмите **Run** (⌘R). Приложение покажет синюю линию за последние семь дней; коснитесь линии (на Mac — наведите на неё курсор), чтобы увидеть дату и число шагов.

## Установка

### Swift Package Manager

В Xcode выберите **File › Add Package Dependencies…** и введите адрес репозитория:

```text
https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git
```

Или добавьте его в `dependencies` вашего `Package.swift`:

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

Версия 2.0.0 (октябрь 2026 года) — первый релиз описанных здесь графиков. У предыдущего релиза, 1.0.0, был другой API, который не собирался в современных версиях Xcode; 2.0.0 также включает работу SwiftUI-Charts-Pro, который будет заархивирован. Изменения, в том числе несовместимые, перечислены в [CHANGELOG.md](CHANGELOG.md).

## Использование

Примеры ниже скопированы из
[`Examples/ChartGallery/ChartGallery/ReadmeSamples.swift`](Examples/ChartGallery/ChartGallery/ReadmeSamples.swift).
Пример приложения и набор тестов компилируют этот файл.

### Временные ряды

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

Пунктирные линии — скользящие средние по 2 000 измерений. Передайте `style: .area`, чтобы залить область под линиями.

### Прокрутка, выбор и экспорт

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

### Статистика

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

Без `binning` гистограмма выбирает ширину интервала по правилу Sturges или Freedman–Diaconis — по тому, которое даёт больше интервалов. Ящик с усами отмечает как выбросы значения, выходящие за 1,5 межквартильного размаха.

### Линия тренда

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

### Финансы

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

### Тепловая карта

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

### Радар и treemap

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

### Данные в реальном времени

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

### Цвета

```swift
struct ColorblindSafeCharts: View {
    var body: some View {
        LatencyReport()
            .chartPalette(.colorblindSafe)
    }
}
```

Все графики, находящиеся ниже модификатора, используют эту палитру. Палитра по умолчанию, `.ocean`, — это синяя палитра со скриншотов; свою можно создать через `ChartPalette(series:positive:negative:neutral:gradient:)`.

## Демо

| Светлая тема                                                   | Тёмная тема                                                  |
| -------------------------------------------------------------- | ------------------------------------------------------------ |
| ![Временные ряды, светлая тема](docs/images/time-series-light.png) | ![Временные ряды, тёмная тема](docs/images/time-series-dark.png) |
| ![Статистика, светлая тема](docs/images/statistics-light.png)  | ![Статистика, тёмная тема](docs/images/statistics-dark.png)  |
| ![Линия тренда, светлая тема](docs/images/trend-line-light.png) | ![Линия тренда, тёмная тема](docs/images/trend-line-dark.png) |
| ![Финансы, светлая тема](docs/images/finance-light.png)        | ![Финансы, тёмная тема](docs/images/finance-dark.png)        |
| ![Тепловая карта, светлая тема](docs/images/heatmap-light.png) | ![Тепловая карта, тёмная тема](docs/images/heatmap-dark.png) |
| ![Радар и treemap, светлая тема](docs/images/radar-treemap-light.png) | ![Радар и treemap, тёмная тема](docs/images/radar-treemap-dark.png) |

Изображения отрисованы в симуляторе iOS по примерам из раздела «Использование» с помощью
[`Tests/SwiftUIDataVisualizationTests/RenderTests.swift`](Tests/SwiftUIDataVisualizationTests/RenderTests.swift)
и [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

Экраны временных рядов и данных в реальном времени из примера приложения, снятые в симуляторе iPhone скриптом
[`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh):

| Временные ряды                                                   | Данные в реальном времени                                    |
| ---------------------------------------------------------------- | ------------------------------------------------------------ |
| ![Экран временных рядов, светлая тема](docs/images/example-timeSeries-light.png) | ![Экран данных в реальном времени, светлая тема](docs/images/example-liveData-light.png) |
| ![Экран временных рядов, тёмная тема](docs/images/example-timeSeries-dark.png)   | ![Экран данных в реальном времени, тёмная тема](docs/images/example-liveData-dark.png)   |

Чтобы попробовать графики самостоятельно, откройте в Xcode `ChartGallery.xcodeproj` из [`Examples/ChartGallery`](Examples/ChartGallery), выберите симулятор iPhone или **My Mac** и нажмите **Run**. В приложении по одному экрану на каждый пример выше; подробности — в [Examples/README.md](Examples/README.md).

## Документация

Справочник и статьи:

- [Справочник API](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/)
  (DocC, публикуется на GitHub Pages из ветки `master`)
- Соберите его локально в Xcode через **Product › Build Documentation** или из командной строки:

```sh
xcodebuild docbuild -scheme SwiftUIDataVisualization -destination 'generic/platform=macOS'
```

## Руководства

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/gettingstarted)
  — как добавить пакет, нарисовать первый график, сопоставить свои данные и задать палитру
  ([исходник](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/GettingStarted.md)).
- [Choosing a Chart](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/choosingachart)
  — какой график отвечает на какой вопрос и какая статистика за ними стоит
  ([исходник](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/ChoosingAChart.md)).
- [Large and Live Data](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/largeandlivedata)
  — сокращение числа точек, прокрутка длинных историй, значения в реальном времени и ограничения на входные данные
  ([исходник](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/LargeAndLiveData.md)).
- [Accessible Charts](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/accessiblecharts)
  — что VoiceOver зачитывает для каждого графика и палитра, безопасная для людей с нарушением цветового зрения
  ([исходник](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/AccessibleCharts.md)).

## Требования

| Платформа | Минимальная версия    |
| --------- | --------------------- |
| iOS       | 17                    |
| macOS     | 14                    |
| Инструменты | Swift 6.2 · Xcode 26+ |

CI собирает проект с Xcode по умолчанию из образа раннера `macos-26` на GitHub. Пакет разрабатывается в Xcode 27.

## Архитектура

- В `Sources/SwiftUIDataVisualization/Charts/` лежит по одному файлу на каждое представление графика.
  Семь из них — это `Chart` из Swift Charts; `RadarChart`, `TreemapChart` и `LiveTickerChart` рисуют
  через `Canvas` или простые представления, потому что в Swift Charts нет полярных координат и
  координат treemap, а лента, перерисовываемая с частотой обновления экрана, обходится дешевле за один
  проход `Canvas`.
- В `Analysis/`, `Layout/` и `Data/` находятся типы-значения и функции, которыми пользуются графики
  (`Histogram`, `BoxPlotSummary`, `LinearRegression`, `NiceScale`, `TreemapLayout`, `Candle` и другие).
  В них нет кода представлений, и они `Sendable`, поэтому могут выполняться вне главного актора.
- Подготовка, которую каждый график выполняет перед отрисовкой (сокращение числа точек, области усов,
  ширина тел свечей, столбцы каскада, максимум радара), вынесена в функции `nonisolated static`,
  которые тесты вызывают напрямую.
- В `Streaming/` находятся `RingBuffer` и `LiveSeries` — единственный ссылочный тип, класс `@Observable`
  на главном акторе. `Style/ChartPalette.swift` передаёт цвета через окружение (environment).
- CI запускает `swift test` на macOS и `xcodebuild test` в симуляторе iPhone, собирает пример
  приложения для iOS и macOS и публикует документацию DocC.

Запустить тесты локально:

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIDataVisualization \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## План развития

- Добавить пакет в Swift Package Index; `.spi.yml` уже есть в репозитории.
- Масштабирование щипком по оси времени в `TimeSeriesChart`.
- Протестировать и включить visionOS, которую поддерживает Swift Charts.

## Участие в разработке

Мы рады вашему участию. Перед открытием pull request прочитайте [руководство для участников](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/CONTRIBUTING.md) и [кодекс поведения](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md). О проблемах безопасности сообщайте конфиденциально, как описано в [политике безопасности](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Лицензия

Распространяется по лицензии MIT. Подробнее — в файле [LICENSE](LICENSE).
