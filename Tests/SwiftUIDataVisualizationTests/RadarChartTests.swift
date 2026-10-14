import CoreGraphics
import Testing
@testable import SwiftUIDataVisualization

@Suite("Radar chart")
struct RadarChartTests {
    @Test func valuesAreFittedToTheAxisCount() {
        #expect(RadarChart.fitted([1, 2], to: 4) == [1, 2, 0, 0])
        #expect(RadarChart.fitted([1, 2, 3, 4, 5], to: 3) == [1, 2, 3])
        #expect(RadarChart.fitted([1], to: 0).isEmpty)
    }

    @Test func explicitMaximumWinsWhenItIsUsable() {
        let series = [RadarChart.Series(name: "A", values: [3, 7])]
        #expect(RadarChart.resolvedMaximum(10, series: series) == 10)
        #expect(RadarChart.resolvedMaximum(0, series: series) == 8)
        #expect(RadarChart.resolvedMaximum(.infinity, series: series) == 8)
        #expect(RadarChart.resolvedMaximum(.nan, series: series) == 8)
    }

    @Test func automaticMaximumRoundsTheLargestValueUp() {
        #expect(RadarChart.resolvedMaximum(nil, series: [.init(name: "A", values: [42, .infinity, 13])]) == 50)
        #expect(RadarChart.resolvedMaximum(nil, series: [.init(name: "A", values: [-3, .nan])]) == 1)
        #expect(RadarChart.resolvedMaximum(nil, series: []) == 1)
    }

    @Test func polygonPathHasOneCornerPerValue() {
        let path = RadarChart.polygonPath([1, 1, 1, 1], maximum: 1, center: CGPoint(x: 50, y: 50), radius: 10)
        #expect(path.boundingRect == CGRect(x: 40, y: 40, width: 20, height: 20))
    }
}
