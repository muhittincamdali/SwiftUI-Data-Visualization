import CoreGraphics
import Foundation
import Testing
@testable import SwiftUIDataVisualization

// Inputs at the edges of Double and Int: each of these used to trap on an Int(_:) conversion of
// nan or infinity, allocate without bound, or return nan coordinates.

private let huge = Double.greatestFiniteMagnitude
private let subnormal = Double.leastNonzeroMagnitude

@Suite("Extreme inputs: nice scale")
struct NiceScaleExtremeTests {
    @Test(arguments: [Int.max, 1_000_000, 101])
    func hugeTickCountsAreClamped(_ count: Int) {
        let scale = NiceScale(lower: 0, upper: 100, desiredTickCount: count)
        #expect(scale == NiceScale(lower: 0, upper: 100, desiredTickCount: NiceScale.tickCountRange.upperBound))
        #expect(scale.ticks.count == 101)
    }

    @Test func negativeTickCountsCountAsTwo() {
        #expect(NiceScale(lower: 0, upper: 100, desiredTickCount: .min) == NiceScale(lower: 0, upper: 100, desiredTickCount: 2))
    }

    @Test(arguments: [(-huge, huge), (0, huge), (-huge, 0), (-huge, -huge / 2), (1e308, huge)] as [(Double, Double)])
    func rangesThatOverflowStayFinite(_ bounds: (Double, Double)) {
        let scale = NiceScale(lower: bounds.0, upper: bounds.1)
        #expect(scale.step > 0 && scale.step.isFinite)
        #expect(scale.lowerBound.isFinite && scale.upperBound.isFinite)
        #expect(scale.lowerBound <= bounds.0 && scale.upperBound >= bounds.1)
        let ticks = scale.ticks
        #expect(ticks.count >= 2 && ticks.count <= NiceScale.maximumTickCount)
        #expect(ticks.allSatisfy { $0.isFinite })
        #expect(ticks == ticks.sorted())
    }

    @Test(arguments: [huge, -huge, 1e300, 5])
    func equalExtremeBoundsGetAUsableRange(_ value: Double) {
        let scale = NiceScale(lower: value, upper: value)
        // At ±greatestFiniteMagnitude one bound can only equal the value.
        #expect(scale.lowerBound <= value && scale.upperBound >= value)
        #expect(scale.lowerBound < scale.upperBound)
        #expect(scale.ticks.count >= 2)
        #expect(scale.ticks.allSatisfy { $0.isFinite })
    }

    @Test(arguments: [(0, subnormal), (0, Double.leastNormalMagnitude), (1e-310, 3e-310), (-subnormal, subnormal)] as [(Double, Double)])
    func subnormalRangesStayFiniteAndCoverTheData(_ bounds: (Double, Double)) {
        let scale = NiceScale(lower: bounds.0, upper: bounds.1)
        #expect(scale.step > 0 && scale.step.isFinite)
        #expect(scale.lowerBound <= bounds.0 && scale.upperBound >= bounds.1)
        let ticks = scale.ticks
        #expect(ticks.count >= 2 && ticks.count <= NiceScale.maximumTickCount)
        #expect(ticks.allSatisfy { $0.isFinite })
    }

    @Test func niceNumberNeverOverflowsOrUnderflows() {
        #expect(NiceScale.niceNumber(huge, rounded: false) == huge)
        #expect(NiceScale.niceNumber(.infinity, rounded: true) == 1)
        #expect(NiceScale.niceNumber(.nan, rounded: true) == 1)
        #expect(NiceScale.niceNumber(subnormal, rounded: true) > 0)
    }
}

@Suite("Extreme inputs: histogram")
struct HistogramExtremeTests {
    static let binnings: [Histogram.Binning] = [
        .automatic, .sturges, .freedmanDiaconis, .count(1), .count(7), .count(.max), .width(1), .width(1e-300),
    ]

    @Test(arguments: binnings)
    func rangesThatOverflowAreCountedCompletely(_ binning: Histogram.Binning) {
        let values = [-huge, -1, 0, 1, huge / 2, huge]
        let histogram = Histogram(values: values, binning: binning)
        #expect(histogram.totalCount == values.count)
        #expect(histogram.bins.count <= Histogram.maximumBinCount)
        #expect(histogram.bins.allSatisfy { $0.lowerBound.isFinite && $0.upperBound.isFinite })
        #expect(histogram.bins.allSatisfy { $0.lowerBound <= $0.upperBound })
        #expect(histogram.bins.first?.lowerBound ?? .nan <= -huge)
        #expect(histogram.bins.last?.upperBound ?? .nan >= huge)
    }

    @Test func tinyWidthOverAWideRangeIsCappedAndReachesTheMaximum() {
        let histogram = Histogram(values: [0, 1e12], binning: .width(1e-10))
        #expect(histogram.bins.count == Histogram.maximumBinCount)
        #expect(histogram.bins.last?.upperBound == 1e12)
        #expect(histogram.bins.last?.count == 1)
        #expect(histogram.totalCount == 2)
    }

    @Test(arguments: [huge, -huge, 1e300])
    func identicalExtremeValuesShareOneNonEmptyBin(_ value: Double) {
        let bins = Histogram(values: [value, value]).bins
        #expect(bins.count == 1)
        #expect(bins[0].lowerBound < bins[0].upperBound)
        #expect(bins[0].count == 2)
    }

    @Test func subnormalRangeIsCounted() {
        let histogram = Histogram(values: [0, subnormal, 2 * subnormal, 3 * subnormal])
        #expect(histogram.totalCount == 4)
        #expect(histogram.bins.allSatisfy { $0.lowerBound.isFinite && $0.upperBound.isFinite })
    }

    @Test func clampedCountNeverTraps() {
        #expect(Histogram.clampedCount(.nan, upTo: 10) == 10)
        #expect(Histogram.clampedCount(.infinity, upTo: 10) == 10)
        #expect(Histogram.clampedCount(-.infinity, upTo: 10) == 1)
        #expect(Histogram.clampedCount(1e300, upTo: 10) == 10)
        #expect(Histogram.clampedCount(3.2, upTo: 10) == 4)
    }
}
