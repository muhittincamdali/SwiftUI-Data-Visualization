import Foundation
import Testing
@testable import SwiftUIDataVisualization

@Suite("Waterfall chart")
struct WaterfallChartTests {
    @Test func changesFloatOnTheRunningTotal() {
        let bars = WaterfallChart.bars(for: [
            WaterfallStep("Revenue", 420),
            WaterfallStep("Costs", -260),
            WaterfallStep("Tax", -40),
            .total("Profit"),
        ])
        #expect(bars.map(\.start) == [0, 420, 160, 0])
        #expect(bars.map(\.end) == [420, 160, 120, 120])
        #expect(bars.map(\.kind) == [.increase, .decrease, .decrease, .total])
    }

    @Test func nonFiniteAndOverflowingChangesAreSkipped() {
        let huge = Double.greatestFiniteMagnitude
        let bars = WaterfallChart.bars(for: [
            WaterfallStep("A", 10),
            WaterfallStep("Bad", .nan),
            WaterfallStep("Big", huge),
            WaterfallStep("Bigger", huge),
            .total("Sum"),
        ])
        #expect(bars.map(\.label) == ["A", "Big", "Sum"])
        #expect(bars.allSatisfy { $0.start.isFinite && $0.end.isFinite })
    }

    @Test func totalsDoNotChangeTheRunningTotal() {
        let bars = WaterfallChart.bars(for: [WaterfallStep("A", 5), .total("T1"), WaterfallStep("B", 3), .total("T2")])
        #expect(bars.map(\.end) == [5, 5, 8, 8])
        #expect(WaterfallStep.total("X").isTotal)
    }

    @Test func descriptionShowsTheSignedChange() {
        let bar = WaterfallChart.bars(for: [WaterfallStep("A", 10), WaterfallStep("B", -4)])[1]
        #expect(WaterfallChart.describe(bar).hasPrefix("-4"))
    }
}
