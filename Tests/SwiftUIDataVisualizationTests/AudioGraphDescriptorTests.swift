import Accessibility
import Testing
@testable import SwiftUIDataVisualization

@Suite("Audio Graph descriptor")
struct AudioGraphDescriptorTests {
    @Test func categoricalDescriptorKeepsCategoriesAndValues() throws {
        let descriptor = AudioGraphDescriptor(
            title: "Skills",
            categories: ["Speed", "Power", "Range"],
            series: [.init(name: "A", values: [3, 9, 6]), .init(name: "B", values: [5, 2, .nan])]
        ).makeChartDescriptor()

        #expect(descriptor.title == "Skills")
        let xAxis = try #require(descriptor.xAxis as? AXCategoricalDataAxisDescriptor)
        #expect(xAxis.categoryOrder == ["Speed", "Power", "Range"])
        #expect(descriptor.yAxis?.range == 2...9)
        #expect(descriptor.series.map(\.name) == ["A", "B"])
        // AXDataPointValue exposes its payload to Swift only through the refined `__` accessors.
        #expect(descriptor.series[0].dataPoints.map(\.xValue.__category) == ["Speed", "Power", "Range"])
        #expect(descriptor.series[0].dataPoints.map { $0.yValue?.__number } == [3, 9, 6])
        // The nan value is left out rather than read as a number.
        #expect(descriptor.series[1].dataPoints.count == 2)
    }

    @Test func numericDescriptorNumbersPositionsFromOne() throws {
        let descriptor = AudioGraphDescriptor(
            title: "Live",
            series: [.init(name: "Price", values: [10, 12, 11])]
        ).makeChartDescriptor()

        let xAxis = try #require(descriptor.xAxis as? AXNumericDataAxisDescriptor)
        #expect(xAxis.range == 1...3)
        #expect(descriptor.series[0].dataPoints.map(\.xValue.__number) == [1, 2, 3])
        #expect(descriptor.series[0].isContinuous)
    }

    @Test func valueRangeHandlesFlatAndEmptyData() {
        #expect(AudioGraphDescriptor(title: "", series: [.init(name: "", values: [4, 4])]).valueRange == 3...5)
        #expect(AudioGraphDescriptor(title: "", series: []).valueRange == 0...1)
    }

    @Test func valuesAreReadWithAtMostTwoDecimals() {
        #expect(AudioGraphDescriptor.describe(3) == 3.formatted(.number.precision(.fractionLength(0...2))))
        #expect(!AudioGraphDescriptor.describe(1.23456).contains("456"))
    }
}
