import Charts
import SwiftUI

/// One value for a row and a column of a heatmap.
public struct HeatmapCell: Identifiable, Hashable, Sendable {
    /// The column label, on the horizontal axis.
    public var column: String
    /// The row label, on the vertical axis.
    public var row: String
    /// The value that sets the cell's color.
    public var value: Double

    /// The cell's position; a chart should have one cell per row and column.
    public var id: [String] { [column, row] }

    /// Creates a cell.
    public init(column: String, row: String, value: Double) {
        self.column = column
        self.row = row
        self.value = value
    }
}

/// A grid of colored cells, such as activity by weekday and hour.
///
/// ```swift
/// HeatmapChart(cells, valueLabel: "Commits", showsValues: true)
///     .frame(height: 220)
/// ```
///
/// Cell colors blend through the palette's ``ChartPalette/gradient`` from the smallest to the
/// largest value, and the chart shows that scale as its legend. Rows and columns appear in the
/// order their labels first occur. Cells whose value is not finite are left out, so they show
/// as gaps; values beyond ±1e307 take the color at that limit.
public struct HeatmapChart: View {
    private let cells: [HeatmapCell]
    private let valueLabel: String
    private let showsValues: Bool

    @Environment(\.chartPalette) private var palette

    /// Creates a heatmap.
    ///
    /// - Parameters:
    ///   - cells: The cells to draw.
    ///   - valueLabel: The name of the value, shown on the color legend.
    ///   - showsValues: Whether each cell prints its value.
    public init(_ cells: [HeatmapCell], valueLabel: String = "Value", showsValues: Bool = false) {
        self.cells = cells
        self.valueLabel = valueLabel
        self.showsValues = showsValues
    }

    public var body: some View {
        let finite = cells.filter(\.value.isFinite)
        let range = Self.valueRange(finite)
        Chart(finite) { cell in
            RectangleMark(
                x: .value("Column", cell.column),
                y: .value("Row", cell.row),
                width: .ratio(0.94),
                height: .ratio(0.9)
            )
                .foregroundStyle(by: .value(valueLabel, ChartValues.clamped(cell.value)))
                .annotation(position: .overlay) {
                    if showsValues {
                        Text(cell.value, format: .number.precision(.significantDigits(1...3)))
                            .font(.caption2)
                            .foregroundStyle(Self.isDark(cell.value, in: range) ? Color.white : Color.primary)
                    }
                }
                .accessibilityLabel("\(cell.row), \(cell.column)")
                .accessibilityValue(cell.value.formatted(.number.precision(.significantDigits(1...6))))
        }
        .chartForegroundStyleScale(range: Gradient(colors: palette.gradient))
        .chartXScale(domain: Self.labels(finite.map(\.column)))
        .chartYScale(domain: Self.labels(finite.map(\.row)))
        // The cells are the grid; axis lines would only cross them.
        .chartXAxis { AxisMarks { _ in AxisValueLabel() } }
        .chartYAxis { AxisMarks(position: .leading) { _ in AxisValueLabel() } }
    }

    /// The smallest and the largest value, or `nil` without cells.
    nonisolated static func valueRange(_ cells: [HeatmapCell]) -> ClosedRange<Double>? {
        guard let low = cells.map(\.value).min(), let high = cells.map(\.value).max() else { return nil }
        return low...high
    }

    /// Whether a cell's color is in the darker half of the gradient, where its value is
    /// printed in white.
    nonisolated static func isDark(_ value: Double, in range: ClosedRange<Double>?) -> Bool {
        guard let range else { return false }
        let span = range.upperBound / 2 - range.lowerBound / 2
        guard span > 0 else { return false }
        return (value / 2 - range.lowerBound / 2) / span > 0.55
    }

    /// The distinct labels in the order they first occur.
    nonisolated static func labels(_ labels: [String]) -> [String] {
        var seen = Set<String>()
        return labels.filter { seen.insert($0).inserted }
    }
}
