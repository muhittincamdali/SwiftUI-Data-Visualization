import Testing
@testable import SwiftUIDataVisualization

@Suite("Linear regression")
struct LinearRegressionTests {
    @Test func fitsAnExactLine() throws {
        let points = (0..<5).map { PlotPoint(x: Double($0), y: 3 * Double($0) - 2) }
        let fit = try #require(LinearRegression(points: points))
        #expect(abs(fit.slope - 3) < 1e-12)
        #expect(abs(fit.intercept + 2) < 1e-12)
        #expect(abs(fit.rSquared - 1) < 1e-12)
        #expect(abs(fit.predict(10) - 28) < 1e-12)
    }

    // Reference: numpy.polyfit(x, y, 1) and numpy.corrcoef(x, y)[0, 1] ** 2.
    @Test func matchesReferenceValuesForNoisyData() throws {
        let points = [PlotPoint(x: 1, y: 2), .init(x: 2, y: 4), .init(x: 3, y: 5), .init(x: 4, y: 4), .init(x: 5, y: 5)]
        let fit = try #require(LinearRegression(points: points))
        #expect(abs(fit.slope - 0.6) < 1e-12)
        #expect(abs(fit.intercept - 2.2) < 1e-12)
        #expect(abs(fit.rSquared - 0.6) < 1e-12)
    }

    @Test func horizontalDataFitsWithRSquaredOne() throws {
        let fit = try #require(LinearRegression(points: [.init(x: 1, y: 7), .init(x: 2, y: 7), .init(x: 9, y: 7)]))
        #expect(fit.slope == 0)
        #expect(fit.intercept == 7)
        #expect(fit.rSquared == 1)
    }

    @Test func verticalOrTooFewPointsGiveNil() {
        #expect(LinearRegression(points: [.init(x: 1, y: 1)]) == nil)
        #expect(LinearRegression(points: [.init(x: 2, y: 1), .init(x: 2, y: 5)]) == nil)
        #expect(LinearRegression(points: [.init(x: 1, y: 1), .init(x: .nan, y: 5)]) == nil)
    }
}

@Suite("Moving average")
struct MovingAverageTests {
    @Test func simpleAverageLeavesTheFirstWindowEmpty() {
        let averages = MovingAverage.simple([1, 2, 3, 4, 5, 6], window: 3)
        #expect(averages == [nil, nil, 2, 3, 4, 5])
    }

    @Test func simpleAverageMatchesABruteForceMean() {
        let values = (0..<500).map { Double(($0 * 37) % 101) * 0.1 }
        let window = 7
        let averages = MovingAverage.simple(values, window: window)
        for index in (window - 1)..<values.count {
            let expected = values[(index - window + 1)...index].reduce(0, +) / Double(window)
            #expect(abs((averages[index] ?? .nan) - expected) < 1e-9)
        }
    }

    @Test func simpleAverageEdgeCases() {
        #expect(MovingAverage.simple([1, 2], window: 3) == [nil, nil])
        #expect(MovingAverage.simple([4, 8], window: 0) == [4, 8])
        #expect(MovingAverage.simple([], window: 2).isEmpty)
    }

    @Test func exponentialAverageWeighsRecentValues() {
        #expect(MovingAverage.exponential([10, 20, 20], smoothing: 0.5) == [10, 15, 17.5])
        #expect(MovingAverage.exponential([10, 20], smoothing: 1) == [10, 20])
        #expect(MovingAverage.exponential([10, 20], smoothing: 0) == [10, 10])
        #expect(MovingAverage.exponential([10, 20], smoothing: 3) == [10, 20])
        #expect(MovingAverage.exponential([], smoothing: 0.5).isEmpty)
    }
}
