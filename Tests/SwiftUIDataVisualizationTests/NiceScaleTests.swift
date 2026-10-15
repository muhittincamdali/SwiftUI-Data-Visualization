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

    @Test(arguments: [2, 3])
    func fewTicksOverASpanNear1e308CoverTheData(_ count: Int) {
        // The nice step was 2e308, which overflowed and gave the unit scale 0...1.
        let scale = NiceScale(lower: -6e74, upper: 1e308, desiredTickCount: count)
        #expect(scale.step == 1e308)
        #expect(scale.lowerBound <= -6e74 && scale.upperBound >= 1e308)
    }

    @Test func boundsThatUnderflowToZeroMoveOutByOneStep() {
        // -1e-300 / 1e31 underflows to -0.0, which used to become the lower bound.
        let negative = NiceScale(lower: -1e-300, upper: 1e31)
        #expect(negative.lowerBound == -negative.step)
        let positive = NiceScale(lower: -1e31, upper: 1e-300)
        #expect(positive.upperBound == positive.step)
    }

    /// Every pair of these bounds, at every tick count, gives a finite scale that covers both.
    @Test(arguments: [2, 3, 4, 5, 100])
    func everyPairOfExtremeBoundsIsCovered(_ count: Int) {
        let huge = Double.greatestFiniteMagnitude
        let bounds: [Double] = [
            -huge, -1.5e308, -1e308, -6e74, -1, -1e-300, -5e-324, 0, 5e-324, 1e-300, 1, 1e31, 1e300, 1e308, huge,
        ]
        for lower in bounds {
            for upper in bounds {
                let scale = NiceScale(lower: lower, upper: upper, desiredTickCount: count)
                #expect(scale.step > 0 && scale.step.isFinite, "\(lower)...\(upper)")
                #expect(scale.lowerBound <= min(lower, upper) && scale.upperBound >= max(lower, upper), "\(lower)...\(upper)")
                #expect(scale.ticks.allSatisfy { $0.isFinite }, "\(lower)...\(upper)")
            }
        }
    }
}
