import Foundation
import Testing
@testable import SwiftUIDataVisualization

@Suite("Downsampling")
struct DownsamplingTests {
    private func points(_ ys: [Double]) -> [PlotPoint] {
        ys.enumerated().map { PlotPoint(x: Double($0.offset), y: $0.element) }
    }

    @Test func picksTheLargestTriangleInEachBucket() {
        // Buckets of two: {1, 2} and {3, 4}. Point 2 forms the larger triangle with point 0 and
        // the average of {3, 4}; point 3 forms the larger one with point 2 and the last point.
        let input = points([0, 1, 0, 5, 0, 0])
        let output = Downsampling.largestTriangleThreeBuckets(input, threshold: 4)
        #expect(output.map(\.x) == [0, 2, 3, 5])
    }

    @Test func keepsEndpointsAndReturnsExactlyThresholdPoints() {
        let input = points((0..<10_000).map { sin(Double($0) / 150) * 40 + Double($0 % 7) })
        let output = Downsampling.largestTriangleThreeBuckets(input, threshold: 500)
        #expect(output.count == 500)
        #expect(output.first == input.first)
        #expect(output.last == input.last)
        #expect(zip(output, output.dropFirst()).allSatisfy { $0.x < $1.x })
    }

    @Test func keepsIsolatedPeaksAndDips() {
        var ys = Array(repeating: 0.0, count: 2_000)
        ys[537] = 100
        ys[1_401] = -80
        let output = Downsampling.largestTriangleThreeBuckets(points(ys), threshold: 40)
        #expect(output.contains(PlotPoint(x: 537, y: 100)))
        #expect(output.contains(PlotPoint(x: 1_401, y: -80)))
    }

    @Test func shortInputIsReturnedUnchanged() {
        let input = points([3, 1, 4, 1, 5])
        #expect(Downsampling.largestTriangleThreeBuckets(input, threshold: 5) == input)
        #expect(Downsampling.largestTriangleThreeBuckets(input, threshold: 100) == input)
    }

    @Test func thresholdsBelowThreeKeepTheEnds() {
        let input = points([3, 1, 4, 1, 5])
        #expect(Downsampling.largestTriangleThreeBuckets(input, threshold: 2).map(\.x) == [0, 4])
        #expect(Downsampling.largestTriangleThreeBuckets(input, threshold: 1).map(\.x) == [0])
        #expect(Downsampling.largestTriangleThreeBuckets(input, threshold: 0).isEmpty)
    }

    @Test func timeSeriesPointsUseTheSameSelection() {
        let ys = (0..<300).map { Double(($0 * 7_919) % 97) }
        let start = Date(timeIntervalSinceReferenceDate: 0)
        let series = TimeSeries(name: "A", values: ys, start: start, interval: 1)
        let fromDates = Downsampling.largestTriangleThreeBuckets(series.points, threshold: 30)
        let fromPoints = Downsampling.largestTriangleThreeBuckets(points(ys), threshold: 30)
        #expect(fromDates.map(\.value) == fromPoints.map(\.y))
        #expect(fromDates.map { $0.date.timeIntervalSince(start) } == fromPoints.map(\.x))
    }
}
