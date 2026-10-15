<!-- i18n-source: README.md@5307a07778c46b7b0b0dfbd0a75b40a96a09d513 status=reviewed -->
<!-- brand:start -->

<p align="center"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/banner-fr-light.svg" alt="SwiftUI Data Visualization: Graphiques statistiques, financiers et en direct pour SwiftUI sur iOS et macOS, basés sur Swift Charts."></picture></p>

<!-- lang-selector:start -->
<p align="center"><a href="README.md">English</a> · <a href="README.tr.md">Türkçe</a> · <a href="README.zh-CN.md">简体中文</a> · <a href="README.ja.md">日本語</a> · <a href="README.ko.md">한국어</a> · <a href="README.es.md">Español</a> · <a href="README.de.md">Deutsch</a> · <a href="README.fr.md">Français</a> · <a href="README.pt-BR.md">Português (Brasil)</a> · <a href="README.ru.md">Русский</a></p>
<!-- lang-selector:end -->

<p align="center">
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions/workflows/ci.yml"><img src="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/actions/workflows/ci.yml/badge.svg" alt="État de la CI"></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/releases"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-version-light.svg" alt="Dernière version: v2.0.1"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-platforms-light.svg" alt="Plateformes prises en charge: iOS 17+ · macOS 14+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/Package.swift"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-language-light.svg" alt="Version du langage: Swift 6.2+"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/LICENSE"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/badge-license-light.svg" alt="Licence: MIT"></picture></a>
</p>

<p align="center">
<a href="#démarrage-rapide"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-start-fr-light.svg" alt="Commencer"></picture></a>
<a href="https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-docs-fr-light.svg" alt="Documentation"></picture></a>
<a href="https://github.com/muhittincamdali/SwiftUI-Data-Visualization/tree/master/Examples"><picture><source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-fr-dark.svg"><source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-fr-light.svg"><img src="https://raw.githubusercontent.com/muhittincamdali/SwiftUI-Data-Visualization/master/.github/brand/button-examples-fr-light.svg" alt="Exemples"></picture></a>
</p>

> Ceci est une traduction du README anglais. En cas de différence, la version anglaise fait foi.

<!-- brand:end -->

Un paquet Swift de vues de graphiques pour SwiftUI sur iOS 17+ et macOS 14+, construit sur Swift Charts. Il couvre les graphiques que Swift Charts vous laisse réaliser vous-même (séries temporelles de plusieurs dizaines de milliers de points, histogrammes, boîtes à moustaches, courbes de tendance, chandeliers, cascades, cartes de chaleur, graphiques en radar, treemaps et cotations en direct) et rend publique l’analyse qui les sous-tend, de sorte que vous pouvez l’utiliser dans votre propre `Chart`. Le paquet n’a aucune dépendance.

## Points forts

- **10 vues de graphiques** — `TimeSeriesChart`, `HistogramChart`, `BoxPlotChart`, `ScatterChart`,
  `CandlestickChart`, `WaterfallChart`, `HeatmapChart`, `RadarChart`, `TreemapChart` et
  `LiveTickerChart`. Chacune prend de simples types valeur et n’a besoin que d’un frame.
- **Données volumineuses et en direct** — `TimeSeriesChart` réduit chaque série à 1 000 points avec
  Largest-Triangle-Three-Buckets, si bien que 50 000 mesures par série restent fluides ; il peut défiler
  dans une fenêtre de temps et indiquer la date sélectionnée. `LiveSeries` conserve les dernières
  valeurs dans un tampon circulaire pour `LiveTickerChart`.
- **L’analyse est publique** — `Histogram` (Sturges, Freedman–Diaconis, largeur fixe ou nombre fixe),
  `BoxPlotSummary` (moustaches de Tukey), `Statistics`, `LinearRegression`, `MovingAverage`,
  les graduations d’axe de `NiceScale`, `TreemapLayout` (squarified), `Candle.aggregate` et `Downsampling`.
- **Sûr avec toute entrée** — les valeurs non finies et les dates hors des années 1 à 4001 sont
  écartées, les valeurs finies au-delà de ±1e307 sont dessinées à cette limite,
  les plages proches de `Double.greatestFiniteMagnitude` et les plages subnormales
  restent finies, et le nombre de graduations, les classes (bins), les tampons, les fenêtres de
  défilement et les exports ont des limites supérieures. Une suite de tests dédiée fournit `nan`,
  l’infini, `Int.max`, des plages extrêmes et des dates extrêmes aux types d’analyse et aux
  graphiques.
- **Accessible** — les vues basées sur Swift Charts bénéficient de la navigation VoiceOver et des
  Audio Graphs, avec des libellés lisibles pour les classes, les boîtes, les chandeliers et les étapes ;
  les vues dessinées sans Swift Charts (radar, treemap, cotations) joignent un `AudioGraphDescriptor`. Une palette
  adaptée au daltonisme est intégrée.
- **Testé** — 188 tests Swift Testing répartis en 33 suites, exécutés sur macOS et dans un simulateur
  d’iPhone, y compris des rendus hors écran de chaque exemple du README en mode clair et sombre.
- **Des exemples d’utilisation qui compilent** — chaque exemple ci-dessous provient de l’[app d’exemple](Examples/ChartGallery),
  que la CI compile pour iOS et macOS.

### Contenu

| Domaine               | Types                                                                                         |
| --------------------- | --------------------------------------------------------------------------------------------- |
| Séries temporelles    | `TimeSeriesChart`, `TimeSeries`, `TimeSeriesPoint`, `MovingAverage`, `Downsampling`            |
| Statistiques          | `HistogramChart`, `Histogram`, `BoxPlotChart`, `BoxPlotSummary`, `ScatterChart`, `LinearRegression`, `Statistics` |
| Finance               | `CandlestickChart`, `Candle`, `WaterfallChart`, `WaterfallStep`                               |
| Grilles et formes     | `HeatmapChart`, `HeatmapCell`, `RadarChart`, `RadarGeometry`, `TreemapChart`, `TreemapLayout` |
| Données en direct     | `LiveTickerChart`, `LiveSeries`, `RingBuffer`                                                 |
| Commun                | `ChartPalette` et `.chartPalette(_:)`, `NiceScale`, `ChartExport`, `AudioGraphDescriptor`    |

## Démarrage rapide

**1. Ajouter le paquet**

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git
```

Collez-la dans le champ de recherche en haut à droite de la fenêtre. Laissez **Dependency Rule** sur **Up to Next Major Version** à partir de `2.0.1`, puis cliquez sur **Add Package**. Dans la fenêtre suivante, choisissez la cible de votre app à côté de **SwiftUIDataVisualization** et cliquez de nouveau sur **Add Package**.

**2. Importer le module**

```swift
import SwiftUIDataVisualization
```

Placez cette ligne en haut du fichier Swift où vous dessinez un graphique, sous `import SwiftUI`.

**3. L’utiliser**

Dans une nouvelle app Xcode (**File › New › Project… › App**), remplacez tout le contenu de `ContentView.swift` par :

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

Appuyez sur **Run** (⌘R). L’app affiche une ligne bleue des sept derniers jours ; touchez la ligne (ou survolez-la sur le Mac) pour voir la date et le nombre de pas.

## Installation

### Swift Package Manager

Dans Xcode, choisissez **File › Add Package Dependencies…** et saisissez l’URL du dépôt :

```text
https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git
```

Ou ajoutez-le aux `dependencies` de votre `Package.swift` :

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

La version 2.0.0 (octobre 2026) est la première version des graphiques décrits ici. La précédente, la 1.0.0, avait une API différente qui ne compilait pas avec les versions actuelles de Xcode ; la 2.0.0 reprend aussi le travail de SwiftUI-Charts-Pro, qui va être archivé. [CHANGELOG.md](CHANGELOG.md) énumère les changements, y compris ceux qui cassent la compatibilité.

## Utilisation

Les exemples ci-dessous sont copiés depuis
[`Examples/ChartGallery/ChartGallery/ReadmeSamples.swift`](Examples/ChartGallery/ChartGallery/ReadmeSamples.swift).
L’app d’exemple et la suite de tests compilent toutes deux ce fichier.

### Séries temporelles

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

Les lignes en pointillés sont les moyennes mobiles sur 2 000 mesures. Passez `style: .area` pour remplir l’espace sous les lignes.

### Défilement, sélection et export

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

### Statistiques

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

Sans `binning`, l’histogramme choisit la largeur des classes avec la règle de Sturges ou celle de Freedman–Diaconis, selon celle qui donne le plus de classes. La boîte à moustaches signale comme valeurs aberrantes celles qui dépassent 1,5 fois l’écart interquartile.

### Courbe de tendance

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

### Finance

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

### Carte de chaleur

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

### Radar et treemap

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

### Données en direct

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

### Couleurs

```swift
struct ColorblindSafeCharts: View {
    var body: some View {
        LatencyReport()
            .chartPalette(.colorblindSafe)
    }
}
```

Tous les graphiques placés sous le modificateur utilisent la palette. La palette par défaut, `.ocean`, est la palette bleue des captures d’écran ; créez la vôtre avec `ChartPalette(series:positive:negative:neutral:gradient:)`.

## Démo

| Clair                                                          | Sombre                                                       |
| -------------------------------------------------------------- | ------------------------------------------------------------ |
| ![Séries temporelles, clair](docs/images/time-series-light.png) | ![Séries temporelles, sombre](docs/images/time-series-dark.png) |
| ![Statistiques, clair](docs/images/statistics-light.png)       | ![Statistiques, sombre](docs/images/statistics-dark.png)     |
| ![Courbe de tendance, clair](docs/images/trend-line-light.png) | ![Courbe de tendance, sombre](docs/images/trend-line-dark.png) |
| ![Finance, clair](docs/images/finance-light.png)               | ![Finance, sombre](docs/images/finance-dark.png)             |
| ![Carte de chaleur, clair](docs/images/heatmap-light.png)      | ![Carte de chaleur, sombre](docs/images/heatmap-dark.png)    |
| ![Radar et treemap, clair](docs/images/radar-treemap-light.png) | ![Radar et treemap, sombre](docs/images/radar-treemap-dark.png) |

Les images sont rendues dans le simulateur iOS à partir des exemples de la section Utilisation par
[`Tests/SwiftUIDataVisualizationTests/RenderTests.swift`](Tests/SwiftUIDataVisualizationTests/RenderTests.swift)
et [`scripts/generate-screenshots.sh`](scripts/generate-screenshots.sh).

Les écrans de séries temporelles et de données en direct de l’app d’exemple, capturés dans un simulateur d’iPhone par
[`scripts/capture-example-screens.sh`](scripts/capture-example-screens.sh) :

| Séries temporelles                                               | Données en direct                                            |
| ---------------------------------------------------------------- | ------------------------------------------------------------ |
| ![Écran des séries temporelles, clair](docs/images/example-timeSeries-light.png) | ![Écran des données en direct, clair](docs/images/example-liveData-light.png) |
| ![Écran des séries temporelles, sombre](docs/images/example-timeSeries-dark.png) | ![Écran des données en direct, sombre](docs/images/example-liveData-dark.png) |

Pour essayer vous-même les graphiques, ouvrez `ChartGallery.xcodeproj` dans [`Examples/ChartGallery`](Examples/ChartGallery) avec Xcode, choisissez un simulateur d’iPhone ou **My Mac**, puis appuyez sur **Run**. L’app propose un écran par exemple ci-dessus ; [Examples/README.md](Examples/README.md) donne les détails.

## Documentation

Documentation de référence et articles :

- [Référence de l’API](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/)
  (DocC, publiée sur GitHub Pages depuis `master`)
- Générez-la en local dans Xcode avec **Product › Build Documentation**, ou en ligne de commande :

```sh
xcodebuild docbuild -scheme SwiftUIDataVisualization -destination 'generic/platform=macOS'
```

## Guides

- [Getting Started](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/gettingstarted)
  — ajouter le paquet, dessiner un premier graphique, associer vos propres données et définir une palette
  ([source](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/GettingStarted.md)).
- [Choosing a Chart](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/choosingachart)
  — quel graphique répond à quelle question, et les statistiques qui les sous-tendent
  ([source](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/ChoosingAChart.md)).
- [Large and Live Data](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/largeandlivedata)
  — réduction d’échantillonnage, défilement dans de longs historiques, valeurs en direct et limites d’entrée
  ([source](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/LargeAndLiveData.md)).
- [Accessible Charts](https://muhittincamdali.github.io/SwiftUI-Data-Visualization/documentation/swiftuidatavisualization/accessiblecharts)
  — ce que VoiceOver lit pour chaque graphique, et la palette adaptée au daltonisme
  ([source](Sources/SwiftUIDataVisualization/SwiftUIDataVisualization.docc/AccessibleCharts.md)).

## Prérequis

| Plateforme | Version minimale      |
| ---------- | --------------------- |
| iOS        | 17                    |
| macOS      | 14                    |
| Chaîne d’outils | Swift 6.2 · Xcode 26+ |

La CI compile avec le Xcode par défaut de l’image de runner `macos-26` de GitHub. Le paquet est développé avec Xcode 27.

## Architecture

- `Sources/SwiftUIDataVisualization/Charts/` contient un fichier par vue de graphique. Sept d’entre
  elles sont des `Chart` de Swift Charts ; `RadarChart`, `TreemapChart` et `LiveTickerChart` dessinent avec
  `Canvas` ou de simples vues, car Swift Charts n’a pas de coordonnées polaires ni de treemap, et des
  cotations redessinées à la fréquence d’affichage coûtent moins cher en un seul passage de `Canvas`.
- `Analysis/`, `Layout/` et `Data/` contiennent les types valeur et les fonctions que les graphiques
  utilisent (`Histogram`, `BoxPlotSummary`, `LinearRegression`, `NiceScale`, `TreemapLayout`, `Candle`, …).
  Ils ne contiennent pas de code de vue et sont `Sendable`, donc ils peuvent s’exécuter hors de l’acteur principal.
- La préparation que chaque graphique effectue avant de dessiner (réduction d’échantillonnage, domaines
  des moustaches, largeurs des corps de chandeliers, barres de cascade, maximum du radar) se trouve dans
  des fonctions `nonisolated static` que les tests appellent directement.
- `Streaming/` contient `RingBuffer` et `LiveSeries`, le seul type référence, une classe `@Observable`
  sur l’acteur principal. `Style/ChartPalette.swift` transmet les couleurs par l’environnement (environment).
- La CI exécute `swift test` sur macOS et `xcodebuild test` dans un simulateur d’iPhone, compile l’app
  d’exemple pour iOS et macOS, et publie la documentation DocC.

Exécutez les tests en local :

```sh
swift test                                    # macOS
xcodebuild test -scheme SwiftUIDataVisualization \
  -destination 'platform=iOS Simulator,name=iPhone 17'
```

## Feuille de route

- Ajouter le paquet au Swift Package Index ; `.spi.yml` est déjà dans le dépôt.
- Zoom par pincement sur l’axe temporel de `TimeSeriesChart`.
- Tester et activer visionOS, que Swift Charts prend en charge.

## Contribuer

Les contributions sont les bienvenues. Lisez le [guide de contribution](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/blob/master/CONTRIBUTING.md) et le [code de conduite](https://github.com/muhittincamdali/.github/blob/main/CODE_OF_CONDUCT.md) avant d’ouvrir une pull request. Signalez les problèmes de sécurité en privé, comme indiqué dans la [politique de sécurité](https://github.com/muhittincamdali/.github/blob/main/SECURITY.md).

## Licence

Publié sous licence MIT. Voir [LICENSE](LICENSE).
