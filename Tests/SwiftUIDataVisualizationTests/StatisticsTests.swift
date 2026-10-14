import Testing
@testable import SwiftUIDataVisualization

@Suite("Statistics")
struct StatisticsTests {
    private let oneToTen: [Double] = [7, 1, 10, 4, 2, 9, 3, 8, 6, 5]

    @Test func meanAndMedian() {
        #expect(Statistics.mean(oneToTen) == 5.5)
        #expect(Statistics.median(oneToTen) == 5.5)
        #expect(Statistics.median([3, 1, 2]) == 2)
    }

    // Reference values from NumPy's default `percentile` (linear interpolation).
    @Test func quantilesInterpolateBetweenRanks() {
        #expect(Statistics.quantile(oneToTen, 0.25) == 3.25)
        #expect(Statistics.quantile(oneToTen, 0.75) == 7.75)
        #expect(Statistics.quantile(oneToTen, 0.9) == 9.1)
        #expect(Statistics.quantile([10, 20], 0.5) == 15)
    }

    @Test func quantileClampsTheProbability() {
        #expect(Statistics.quantile(oneToTen, -1) == 1)
        #expect(Statistics.quantile(oneToTen, 2) == 10)
        #expect(Statistics.quantile(oneToTen, .nan) == nil)
    }

    @Test func varianceAndStandardDeviation() {
        let values: [Double] = [2, 4, 4, 4, 5, 5, 7, 9]
        #expect(Statistics.variance(values, sample: false) == 4)
        #expect(Statistics.standardDeviation(values, sample: false) == 2)
        #expect(Statistics.variance(values) == 32.0 / 7.0)
    }

    @Test func sampleVarianceNeedsTwoValues() {
        #expect(Statistics.variance([4]) == nil)
        #expect(Statistics.variance([4], sample: false) == 0)
    }

    @Test func nonFiniteValuesAreIgnored() {
        #expect(Statistics.mean([1, .nan, 3, .infinity]) == 2)
        #expect(Statistics.median([.nan, 8]) == 8)
    }

    @Test func emptyInputGivesNil() {
        #expect(Statistics.mean([]) == nil)
        #expect(Statistics.median([.nan]) == nil)
        #expect(Statistics.quantile([], 0.5) == nil)
        #expect(Statistics.standardDeviation([]) == nil)
    }
}

@Suite("Box plot summary")
struct BoxPlotSummaryTests {
    @Test func summarizesWithoutOutliers() throws {
        let summary = try #require(BoxPlotSummary(values: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]))
        #expect(summary.firstQuartile == 3.25)
        #expect(summary.median == 5.5)
        #expect(summary.thirdQuartile == 7.75)
        #expect(summary.interquartileRange == 4.5)
        #expect(summary.lowerWhisker == 1)
        #expect(summary.upperWhisker == 10)
        #expect(summary.outliers.isEmpty)
    }

    @Test func separatesOutliersBeyondTukeyFences() throws {
        // Q1 = 2, Q3 = 4, IQR = 2, so the fences are -1 and 7.
        let summary = try #require(BoxPlotSummary(values: [100, 1, 2, 3, 4, -20]))
        #expect(summary.outliers == [-20, 100])
        #expect(summary.lowerWhisker == 1)
        #expect(summary.upperWhisker == 4)
    }

    @Test func aValueOnTheFenceIsNotAnOutlier() throws {
        // Q1 = 2, Q3 = 4, upper fence = 7.
        let summary = try #require(BoxPlotSummary(values: [1, 2, 3, 4, 7]))
        #expect(summary.firstQuartile == 2)
        #expect(summary.thirdQuartile == 4)
        #expect(summary.outliers.isEmpty)
        #expect(summary.upperWhisker == 7)
    }

    @Test func singleValueCollapsesTheBox() throws {
        let summary = try #require(BoxPlotSummary(values: [42]))
        #expect(summary.firstQuartile == 42)
        #expect(summary.thirdQuartile == 42)
        #expect(summary.lowerWhisker == 42)
        #expect(summary.upperWhisker == 42)
        #expect(summary.outliers.isEmpty)
    }

    @Test func noFiniteValueGivesNil() {
        #expect(BoxPlotSummary(values: []) == nil)
        #expect(BoxPlotSummary(values: [.nan, .infinity]) == nil)
    }
}
