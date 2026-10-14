import SwiftUI
import SwiftUIDataVisualization

/// One screen per README sample, so each sample can be tried on a device or the simulator.
struct GalleryView: View {
    enum Sample: String, CaseIterable, Identifiable {
        case quickStart = "Quick start"
        case timeSeries = "Time series"
        case statistics = "Statistics"
        case trendLine = "Trend line"
        case finance = "Finance"
        case heatmap = "Heatmap"
        case radarAndTreemap = "Radar and treemap"
        case liveData = "Live data"
        case colors = "Color-blind safe colors"

        var id: Self { self }

        /// The sample whose case name is `name`, such as `"finance"`.
        static func named(_ name: String) -> Sample? {
            allCases.first { String(describing: $0) == name }
        }

        var systemImage: String {
            switch self {
            case .quickStart: "star"
            case .timeSeries: "chart.xyaxis.line"
            case .statistics: "chart.bar"
            case .trendLine: "chart.dots.scatter"
            case .finance: "chart.bar.xaxis"
            case .heatmap: "square.grid.3x3.fill"
            case .radarAndTreemap: "hexagon"
            case .liveData: "waveform.path.ecg"
            case .colors: "eyedropper"
            }
        }

        @MainActor @ViewBuilder
        var screen: some View {
            switch self {
            case .quickStart: ContentView()
            case .timeSeries: ServerLoad()
            case .statistics: LatencyReport()
            case .trendLine: HeightWeight()
            case .finance: PriceAndProfit()
            case .heatmap: CommitActivity()
            case .radarAndTreemap: ProfileAndStorage()
            case .liveData: LiveLoad()
            case .colors: ColorblindSafeCharts()
            }
        }
    }

    /// `-sample <case name>` on the command line opens that screen, for example
    /// `-sample finance`. `scripts/capture-example-screens.sh` uses it for the screenshots.
    @State private var path: [Sample] = UserDefaults.standard.string(forKey: "sample")
        .flatMap(Sample.named)
        .map { [$0] } ?? []

    var body: some View {
        NavigationStack(path: $path) {
            List(Sample.allCases) { sample in
                NavigationLink(value: sample) {
                    Label(sample.rawValue, systemImage: sample.systemImage)
                }
            }
            .navigationTitle("Data Visualization")
            .navigationDestination(for: Sample.self) { sample in
                ScrollView {
                    sample.screen
                        .frame(maxWidth: 600)
                        .frame(maxWidth: .infinity)
                }
                .navigationTitle(sample.rawValue)
            }
        }
    }
}

#Preview {
    GalleryView()
}
