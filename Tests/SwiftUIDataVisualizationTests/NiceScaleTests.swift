import Testing
@testable import SwiftUIDataVisualization

@Suite("Nice scale")
struct NiceScaleTests {
    @Test func roundsBoundsOutwardToTheStep() {
        let scale = NiceScale(lower: 3, upper: 97, desiredTickCount: 6)
        #expect(scale.step == 20)
        #expect(scale.lowerBound == 0)
        #expect(scale.upperBound == 100)
        #expect(scale.ticks == [0, 20, 40, 60, 80, 100])
    }

    @Test func coversNegativeRanges() {
        let scale = NiceScale(lower: -7, upper: 13)
        #expect(scale.ticks == [-10, -5, 0, 5, 10, 15])
    }

    @Test func fractionalTicksDoNotDrift() {
        let scale = NiceScale(lower: 0, upper: 1)
        #expect(scale.step == 0.2)
        #expect(scale.ticks == [0, 0.2, 0.4, 0.6, 0.8, 1])
        #expect(NiceScale(lower: 0.1, upper: 0.32).ticks == [0.1, 0.2, 0.3, 0.4])
    }

    @Test func stepMantissaIsOneTwoOrFive() {
        let ranges: [(Double, Double)] = [(0, 7), (12, 1_234), (-0.003, 0.004), (5, 5.5), (1e6, 9e6)]
        for (lower, upper) in ranges {
            let scale = NiceScale(lower: lower, upper: upper)
            var mantissa = scale.step
            while mantissa >= 10 { mantissa /= 10 }
            while mantissa < 1 { mantissa *= 10 }
            #expect([1, 2, 5].contains(mantissa.rounded()), "step \(scale.step) for \(lower)...\(upper)")
            #expect(scale.lowerBound <= lower && scale.upperBound >= upper)
        }
    }

    @Test func acceptsReversedBounds() {
        #expect(NiceScale(lower: 97, upper: 3, desiredTickCount: 6) == NiceScale(lower: 3, upper: 97, desiredTickCount: 6))
    }

    @Test func equalBoundsGetAUsableRange() {
        let scale = NiceScale(lower: 5, upper: 5)
        #expect(scale.lowerBound < 5)
        #expect(scale.upperBound > 5)
        #expect(scale.ticks.count >= 2)
    }

    @Test func nonFiniteBoundsFallBackToUnitRange() {
        let scale = NiceScale(lower: .nan, upper: 4)
        #expect(scale.ticks == [0, 1])
    }

    @Test func tickCountBelowTwoCountsAsTwo() {
        #expect(NiceScale(lower: 0, upper: 100, desiredTickCount: 0) == NiceScale(lower: 0, upper: 100, desiredTickCount: 2))
    }
}
