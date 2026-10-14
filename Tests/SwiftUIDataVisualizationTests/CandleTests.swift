import Foundation
import Testing
@testable import SwiftUIDataVisualization

@Suite("Candles")
struct CandleTests {
    private let minute = Date(timeIntervalSinceReferenceDate: 60 * 1_000)

    private func tick(_ seconds: Double, _ value: Double) -> TimeSeriesPoint {
        TimeSeriesPoint(date: minute.addingTimeInterval(seconds), value: value)
    }

    @Test func aggregatesTicksIntoOneCandlePerPeriod() {
        let ticks = [tick(1, 10), tick(20, 14), tick(40, 8), tick(59, 11), tick(61, 11.5), tick(90, 12)]
        let candles = Candle.aggregate(ticks, interval: 60)
        #expect(candles == [
            Candle(date: minute, open: 10, high: 14, low: 8, close: 11),
            Candle(date: minute.addingTimeInterval(60), open: 11.5, high: 12, low: 11.5, close: 12),
        ])
    }

    @Test func sortsTicksButKeepsTheOrderOfEqualDates() {
        let ticks = [tick(30, 5), tick(10, 7), tick(30, 6)]
        let candle = Candle.aggregate(ticks, interval: 60)[0]
        #expect(candle.open == 7)
        #expect(candle.close == 6)
    }

    @Test func skipsPeriodsWithoutTicks() {
        let candles = Candle.aggregate([tick(0, 1), tick(300, 2)], interval: 60)
        #expect(candles.map { $0.date.timeIntervalSince(minute) } == [0, 300])
    }

    @Test func periodsStartOnMultiplesOfTheInterval() {
        let candles = Candle.aggregate([tick(125, 3)], interval: 60)
        #expect(candles.first?.date == minute.addingTimeInterval(120))
    }

    @Test func invalidInputGivesNoCandles() {
        #expect(Candle.aggregate([tick(0, 1)], interval: 0).isEmpty)
        #expect(Candle.aggregate([tick(0, 1)], interval: .infinity).isEmpty)
        #expect(Candle.aggregate([tick(0, .nan)], interval: 60).isEmpty)
        #expect(Candle.aggregate([], interval: 60).isEmpty)
    }

    @Test func risingMeansCloseAtOrAboveOpen() {
        #expect(Candle(date: minute, open: 1, high: 3, low: 1, close: 2).isRising)
        #expect(Candle(date: minute, open: 2, high: 2, low: 2, close: 2).isRising)
        #expect(!Candle(date: minute, open: 2, high: 3, low: 1, close: 1).isRising)
    }
}
