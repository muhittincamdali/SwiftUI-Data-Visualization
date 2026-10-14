import Foundation
import Testing
@testable import SwiftUIDataVisualization

@Suite("Time series")
struct TimeSeriesTests {
    private let start = Date(timeIntervalSinceReferenceDate: 0)

    @Test func sortsPointsByDate() {
        let series = TimeSeries(name: "A", points: [
            .init(date: start.addingTimeInterval(20), value: 3),
            .init(date: start, value: 1),
            .init(date: start.addingTimeInterval(10), value: 2),
        ])
        #expect(series.points.map(\.value) == [1, 2, 3])
    }

    @Test func buildsPointsFromEvenlySpacedValues() {
        let series = TimeSeries(name: "A", values: [5, 6, 7], start: start, interval: 60)
        #expect(series.points.map(\.date) == [start, start.addingTimeInterval(60), start.addingTimeInterval(120)])
        #expect(series.points.map(\.value) == [5, 6, 7])
    }

    @Test func nearestPointPicksTheClosestDate() {
        let series = TimeSeries(name: "A", values: [10, 20, 30], start: start, interval: 10)
        #expect(series.nearestPoint(to: start.addingTimeInterval(4))?.value == 10)
        #expect(series.nearestPoint(to: start.addingTimeInterval(6))?.value == 20)
        #expect(series.nearestPoint(to: start.addingTimeInterval(14))?.value == 20)
        #expect(series.nearestPoint(to: start.addingTimeInterval(16))?.value == 30)
    }

    @Test func nearestPointPrefersTheEarlierPointOnATie() {
        let series = TimeSeries(name: "A", values: [10, 20], start: start, interval: 10)
        #expect(series.nearestPoint(to: start.addingTimeInterval(5))?.value == 10)
    }

    @Test func nearestPointClampsOutsideTheRange() {
        let series = TimeSeries(name: "A", values: [10, 20, 30], start: start, interval: 10)
        #expect(series.nearestPoint(to: start.addingTimeInterval(-500))?.value == 10)
        #expect(series.nearestPoint(to: start.addingTimeInterval(500))?.value == 30)
        #expect(series.nearestPoint(to: start.addingTimeInterval(10))?.value == 20)
    }

    @Test func nearestPointOfAnEmptySeriesIsNil() {
        #expect(TimeSeries(name: "A", points: []).nearestPoint(to: start) == nil)
    }
}
