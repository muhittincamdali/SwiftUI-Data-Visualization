import Foundation
import Testing
@testable import SwiftUIDataVisualization

@Suite("Box plot chart")
struct BoxPlotChartTests {
    @Test func groupsWithoutFiniteValuesAreLeftOut() {
        let summaries = BoxPlotChart.summaries(of: [
            .init(name: "A", values: [1, 2, 3, 4]),
            .init(name: "Empty", values: []),
            .init(name: "NaN", values: [.nan]),
            .init(name: "B", values: [10]),
        ])
        #expect(summaries.map(\.name) == ["A", "B"])
        #expect(summaries[0].summary.median == 2.5)
    }

    @Test func valueAxisCoversWhiskersAndOutliersWithoutZero() throws {
        let summary = try #require(BoxPlotSummary(values: [101, 104, 108, 112, 410]))
        let domain = BoxPlotChart.valueDomain([summary])
        #expect(domain.lowerBound <= 101 && domain.lowerBound > 0)
        #expect(domain.upperBound >= 410)
        #expect(BoxPlotChart.valueDomain([]) == 0...1)
    }

    @Test func descriptionMentionsOutliersOnlyWhenThereAreSome() throws {
        let plain = try #require(BoxPlotSummary(values: [1, 2, 3, 4, 5]))
        #expect(!BoxPlotChart.describe(plain).contains("outlier"))
        let withOutlier = try #require(BoxPlotSummary(values: [1, 2, 3, 4, 100]))
        #expect(BoxPlotChart.describe(withOutlier).hasSuffix("1 outliers"))
    }
}
