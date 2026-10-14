import Foundation
import Testing
@testable import SwiftUIDataVisualization

@Suite("Heatmap chart")
struct HeatmapChartTests {
    @Test func labelsKeepTheirFirstOrderWithoutDuplicates() {
        #expect(HeatmapChart.labels(["Tue", "Mon", "Tue", "Wed", "Mon"]) == ["Tue", "Mon", "Wed"])
        #expect(HeatmapChart.labels([]).isEmpty)
    }

    @Test func valuesInTheDarkerHalfArePrintedInWhite() {
        let range = HeatmapChart.valueRange([
            HeatmapCell(column: "a", row: "1", value: 0),
            HeatmapCell(column: "b", row: "1", value: 10),
        ])
        #expect(range == 0...10)
        #expect(HeatmapChart.isDark(9, in: range))
        #expect(!HeatmapChart.isDark(3, in: range))
        #expect(!HeatmapChart.isDark(5, in: 5...5))
        #expect(!HeatmapChart.isDark(5, in: nil))
        #expect(HeatmapChart.isDark(.greatestFiniteMagnitude, in: -.greatestFiniteMagnitude ... .greatestFiniteMagnitude))
    }

    @Test func cellIdentityIsColumnAndRow() {
        let cell = HeatmapCell(column: "9", row: "Mon", value: 3)
        #expect(cell.id == ["9", "Mon"])
        #expect(cell.id != HeatmapCell(column: "Mon", row: "9", value: 3).id)
    }
}
