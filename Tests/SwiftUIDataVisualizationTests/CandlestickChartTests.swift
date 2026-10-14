import Foundation
import Testing
@testable import SwiftUIDataVisualization

@Suite("Candlestick chart")
struct CandlestickChartTests {
    private let date = Date(timeIntervalSinceReferenceDate: 0)

    @Test func validCandlesEncloseOpenAndClose() {
        #expect(Candle(date: date, open: 10, high: 12, low: 9, close: 11).isValid)
        #expect(Candle(date: date, open: 10, high: 10, low: 10, close: 10).isValid)
        #expect(!Candle(date: date, open: 10, high: 9, low: 8, close: 9.5).isValid)
        #expect(!Candle(date: date, open: 10, high: 12, low: 10.5, close: 11).isValid)
        #expect(!Candle(date: date, open: .nan, high: 12, low: 9, close: 11).isValid)
        #expect(!Candle(date: date, open: 10, high: .infinity, low: 9, close: 11).isValid)
    }

    @Test func aggregatedCandlesAreValid() {
        let ticks = (0..<500).map { TimeSeriesPoint(date: date.addingTimeInterval(Double($0) * 7), value: sin(Double($0)) * 5 + 100) }
        #expect(Candle.aggregate(ticks, interval: 60).allSatisfy { $0.isValid })
    }

    @Test func bodiesFillMostOfTheTypicalGap() {
        let hourly = (0..<5).map { Candle(date: date.addingTimeInterval(Double($0) * 3_600), open: 1, high: 2, low: 0, close: 1) }
        #expect(CandlestickChart.bodyHalfWidth(for: hourly) == 3_600 * 0.6 / 2)
        // One missing hour does not change the typical gap.
        let gapped = hourly.enumerated().filter { $0.offset != 2 }.map(\.element)
        #expect(CandlestickChart.bodyHalfWidth(for: gapped) == 3_600 * 0.6 / 2)
    }

    @Test func singleCandleUsesADay() {
        let single = [Candle(date: date, open: 1, high: 2, low: 0, close: 1)]
        #expect(CandlestickChart.bodyHalfWidth(for: single) == 86_400 * 0.6 / 2)
        #expect(CandlestickChart.bodyHalfWidth(for: single + single) == 86_400 * 0.6 / 2)
        #expect(CandlestickChart.bodyHalfWidth(for: []) == 86_400 * 0.6 / 2)
    }

    @Test func descriptionReadsAllFourValues() {
        let text = CandlestickChart.describe(Candle(date: date, open: 1, high: 4, low: 0.5, close: 3))
        for word in ["open", "high", "low", "close"] {
            #expect(text.contains(word))
        }
    }
}
