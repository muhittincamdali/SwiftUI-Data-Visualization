import Testing
@testable import SwiftUIDataVisualization

@Suite("Histogram")
struct HistogramTests {
    @Test func fixedWidthBinsAlignToMultiplesOfTheWidth() {
        let histogram = Histogram(values: (0..<100).map(Double.init), binning: .width(10))
        #expect(histogram.bins.count == 10)
        #expect(histogram.bins.allSatisfy { $0.count == 10 })
        #expect(histogram.bins.first?.lowerBound == 0)
        #expect(histogram.bins.last?.upperBound == 100)
    }

    @Test func theLastBinIncludesItsUpperBound() {
        let histogram = Histogram(values: [0, 5, 10], binning: .width(5))
        #expect(histogram.bins.map(\.count) == [1, 2])
        #expect(histogram.bins.map(\.upperBound) == [5, 10])
    }

    @Test func decimalEdgesDoNotMisplaceValues() {
        // 0.3 / 0.1 is 2.9999999999999996 in floating point; 0.3 still belongs to 0.3..<0.4.
        let values = (0...9).map { Double($0) / 10 }
        let histogram = Histogram(values: values, binning: .width(0.1))
        #expect(histogram.bins.map(\.lowerBound) == [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8])
        #expect(histogram.bins.map(\.count) == [1, 1, 1, 1, 1, 1, 1, 1, 2])
    }

    @Test func exactBinCountSpansTheData() {
        let histogram = Histogram(values: [0, 1, 4, 6, 9, 10], binning: .count(4))
        #expect(histogram.bins.map(\.lowerBound) == [0, 2.5, 5, 7.5])
        #expect(histogram.bins.map(\.count) == [2, 1, 1, 2])
        #expect(Histogram(values: [1, 2], binning: .count(0)).bins.count == 1)
    }

    @Test func sturgesUsesLogOfTheSampleSize() {
        #expect(Histogram.sturgesCount(100) == 8)
        #expect(Histogram.sturgesCount(1) == 1)
        let histogram = Histogram(values: (0..<100).map(Double.init), binning: .sturges)
        // 99 / 8 ≈ 12.4 rounds to a step of 10.
        #expect(histogram.bins.count == 10)
        #expect(histogram.totalCount == 100)
    }

    @Test func freedmanDiaconisFallsBackWhenTheIQRIsZero() {
        let values: [Double] = [5, 5, 5, 5, 5, 5, 5, 9]
        #expect(Histogram.freedmanDiaconisCount(sorted: values) == nil)
        #expect(Histogram(values: values, binning: .freedmanDiaconis) == Histogram(values: values, binning: .sturges))
    }

    @Test func automaticBinsAreContiguousWithRoundEdges() {
        let values = (0..<1_000).map { Double(($0 * 7_919) % 1_000) / 3 }
        let histogram = Histogram(values: values)
        #expect(histogram.totalCount == 1_000)
        for (bin, next) in zip(histogram.bins, histogram.bins.dropFirst()) {
            #expect(bin.upperBound == next.lowerBound)
        }
        let width = histogram.bins[0].upperBound - histogram.bins[0].lowerBound
        #expect([1, 2, 5, 10, 20, 50].contains(width))
    }

    @Test func invalidWidthCountsAsAutomatic() {
        let values = (0..<50).map(Double.init)
        #expect(Histogram(values: values, binning: .width(0)) == Histogram(values: values))
        #expect(Histogram(values: values, binning: .width(.nan)) == Histogram(values: values))
    }

    @Test func tinyWidthIsCappedAtTheMaximumBinCount() {
        let histogram = Histogram(values: [0, 0.5, 1], binning: .width(1e-9))
        #expect(histogram.bins.count == Histogram.maximumBinCount)
        #expect(histogram.totalCount == 3)
    }

    @Test func identicalValuesShareOneBin() {
        let histogram = Histogram(values: [4, 4, 4])
        #expect(histogram.bins == [.init(lowerBound: 3.5, upperBound: 4.5, count: 3)])
    }

    @Test func emptyAndNonFiniteInput() {
        #expect(Histogram(values: []).bins.isEmpty)
        #expect(Histogram(values: [.nan, .infinity]).bins.isEmpty)
        #expect(Histogram(values: [1, .nan, 2, 3]).totalCount == 3)
    }
}
