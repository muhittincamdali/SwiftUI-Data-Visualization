import Foundation
import Testing
@testable import SwiftUIDataVisualization

@Suite("Histogram chart")
struct HistogramChartTests {
    @Test func barsAreInsetInsideTheirBin() {
        let bar = HistogramChart.barRange(for: .init(lowerBound: 0, upperBound: 10, count: 3))
        #expect(bar == 0.2...9.8)
    }

    @Test func zeroWidthAndExtremeBinsAreNotInset() {
        #expect(HistogramChart.barRange(for: .init(lowerBound: 5, upperBound: 5, count: 1)) == 5...5)
        let huge = Double.greatestFiniteMagnitude
        let bar = HistogramChart.barRange(for: .init(lowerBound: -huge, upperBound: huge, count: 1))
        #expect(bar.lowerBound.isFinite && bar.upperBound.isFinite)
        #expect(bar.lowerBound > -huge && bar.upperBound < huge)
    }
}
