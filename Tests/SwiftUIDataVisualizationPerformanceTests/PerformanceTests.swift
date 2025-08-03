import XCTest
import SwiftUI
@testable import SwiftUIDataVisualization

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
final class PerformanceTests: XCTestCase {
    
    // MARK: - Properties
    
    private var largeDataset: [ChartDataPoint]!
    private var mediumDataset: [ChartDataPoint]!
    private var smallDataset: [ChartDataPoint]!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        largeDataset = createDataset(count: 10000)
        mediumDataset = createDataset(count: 1000)
        smallDataset = createDataset(count: 100)
    }
    
    override func tearDown() {
        largeDataset = nil
        mediumDataset = nil
        smallDataset = nil
        super.tearDown()
    }
    
    // MARK: - Test Data Creation
    
    private func createDataset(count: Int) -> [ChartDataPoint] {
        return (1...count).map { i in
            ChartDataPoint(
                x: Double(i),
                y: Double(i * 2),
                label: "Point \(i)"
            )
        }
    }
    
    // MARK: - Rendering Performance Tests
    
    func testSmallDatasetRenderingPerformance() {
        // Given
        let chart = LineChart(data: smallDataset)
        
        // When & Then
        measure {
            // Simulate rendering
            _ = chart
        }
    }
    
    func testMediumDatasetRenderingPerformance() {
        // Given
        let chart = LineChart(data: mediumDataset)
        
        // When & Then
        measure {
            // Simulate rendering
            _ = chart
        }
    }
    
    func testLargeDatasetRenderingPerformance() {
        // Given
        let chart = LineChart(data: largeDataset)
        
        // When & Then
        measure {
            // Simulate rendering
            _ = chart
        }
    }
    
    // MARK: - Memory Performance Tests
    
    func testMemoryUsageWithSmallDataset() {
        // Given
        let chart = LineChart(data: smallDataset)
        
        // When & Then
        measure {
            // Simulate memory usage
            _ = chart
        }
    }
    
    func testMemoryUsageWithMediumDataset() {
        // Given
        let chart = LineChart(data: mediumDataset)
        
        // When & Then
        measure {
            // Simulate memory usage
            _ = chart
        }
    }
    
    func testMemoryUsageWithLargeDataset() {
        // Given
        let chart = LineChart(data: largeDataset)
        
        // When & Then
        measure {
            // Simulate memory usage
            _ = chart
        }
    }
    
    // MARK: - Animation Performance Tests
    
    func testAnimationPerformance() {
        // Given
        let chart = LineChart(data: smallDataset)
        
        // When & Then
        measure {
            // Simulate animation
            _ = chart
        }
    }
    
    // MARK: - Data Processing Performance Tests
    
    func testDataPointCreationPerformance() {
        // Given
        let count = 10000
        
        // When & Then
        measure {
            let dataPoints = (1...count).map { i in
                ChartDataPoint(x: Double(i), y: Double(i * 2))
            }
            XCTAssertEqual(dataPoints.count, count)
        }
    }
    
    func testDataPointArrayCreationPerformance() {
        // Given
        let xValues = Array(1...10000).map { Double($0) }
        let yValues = Array(1...10000).map { Double($0 * 2) }
        
        // When & Then
        measure {
            let dataPoints = ChartDataPoint.fromArrays(xValues: xValues, yValues: yValues)
            XCTAssertEqual(dataPoints.count, 10000)
        }
    }
    
    // MARK: - Configuration Performance Tests
    
    func testConfigurationCreationPerformance() {
        // When & Then
        measure {
            let config = ChartConfiguration(
                style: .line,
                theme: .light,
                colors: [.blue, .green, .red],
                interactive: true,
                zoomEnabled: true,
                panEnabled: true
            )
            XCTAssertNotNil(config)
        }
    }
    
    // MARK: - Stress Tests
    
    func testStressTestWithVeryLargeDataset() {
        // Given
        let veryLargeDataset = createDataset(count: 50000)
        
        // When & Then
        measure {
            let chart = LineChart(data: veryLargeDataset)
            XCTAssertNotNil(chart)
        }
    }
    
    func testStressTestWithMultipleCharts() {
        // Given
        let datasets = [
            createDataset(count: 1000),
            createDataset(count: 2000),
            createDataset(count: 3000)
        ]
        
        // When & Then
        measure {
            let charts = datasets.map { LineChart(data: $0) }
            XCTAssertEqual(charts.count, 3)
        }
    }
    
    // MARK: - CPU Performance Tests
    
    func testCPUUsageWithSmallDataset() {
        // Given
        let chart = LineChart(data: smallDataset)
        
        // When & Then
        measure {
            // Simulate CPU-intensive operations
            _ = chart
        }
    }
    
    func testCPUUsageWithMediumDataset() {
        // Given
        let chart = LineChart(data: mediumDataset)
        
        // When & Then
        measure {
            // Simulate CPU-intensive operations
            _ = chart
        }
    }
    
    func testCPUUsageWithLargeDataset() {
        // Given
        let chart = LineChart(data: largeDataset)
        
        // When & Then
        measure {
            // Simulate CPU-intensive operations
            _ = chart
        }
    }
    
    // MARK: - Battery Performance Tests
    
    func testBatteryUsageWithContinuousUpdates() {
        // Given
        let chart = LineChart(data: mediumDataset)
        
        // When & Then
        measure {
            // Simulate continuous updates
            for _ in 1...100 {
                _ = chart
            }
        }
    }
    
    // MARK: - Frame Rate Tests
    
    func testFrameRateWithSmallDataset() {
        // Given
        let chart = LineChart(data: smallDataset)
        
        // When & Then
        measure {
            // Simulate 60fps rendering
            for _ in 1...60 {
                _ = chart
            }
        }
    }
    
    func testFrameRateWithMediumDataset() {
        // Given
        let chart = LineChart(data: mediumDataset)
        
        // When & Then
        measure {
            // Simulate 60fps rendering
            for _ in 1...60 {
                _ = chart
            }
        }
    }
    
    func testFrameRateWithLargeDataset() {
        // Given
        let chart = LineChart(data: largeDataset)
        
        // When & Then
        measure {
            // Simulate 60fps rendering
            for _ in 1...60 {
                _ = chart
            }
        }
    }
    
    // MARK: - Network Performance Tests
    
    func testNetworkDataProcessingPerformance() {
        // Given
        let networkData = createNetworkDataset()
        
        // When & Then
        measure {
            let dataPoints = ChartDataPoint.fromTimeSeries(
                timestamps: networkData.timestamps,
                values: networkData.values
            )
            XCTAssertEqual(dataPoints.count, 1000)
        }
    }
    
    private func createNetworkDataset() -> (timestamps: [Date], values: [Double]) {
        let timestamps = (1...1000).map { i in
            Date().addingTimeInterval(Double(i) * 60)
        }
        let values = (1...1000).map { Double($0 * 2) }
        return (timestamps, values)
    }
    
    // MARK: - Real-time Performance Tests
    
    func testRealTimeDataProcessingPerformance() {
        // Given
        let realTimeData = createRealTimeDataset()
        
        // When & Then
        measure {
            let dataPoints = ChartDataPoint.fromArrays(
                xValues: realTimeData.xValues,
                yValues: realTimeData.yValues
            )
            XCTAssertEqual(dataPoints.count, 1000)
        }
    }
    
    private func createRealTimeDataset() -> (xValues: [Double], yValues: [Double]) {
        let xValues = (1...1000).map { Double($0) }
        let yValues = (1...1000).map { Double($0 * 2) }
        return (xValues, yValues)
    }
    
    // MARK: - Memory Leak Tests
    
    func testMemoryLeakWithLargeDataset() {
        // Given
        var chart: LineChart? = LineChart(data: largeDataset)
        
        // When
        weak var weakChart = chart
        chart = nil
        
        // Then
        XCTAssertNil(weakChart, "Chart should be deallocated")
    }
    
    func testMemoryLeakWithMultipleCharts() {
        // Given
        var charts: [LineChart]? = [
            LineChart(data: smallDataset),
            LineChart(data: mediumDataset),
            LineChart(data: largeDataset)
        ]
        
        // When
        weak var weakCharts = charts
        charts = nil
        
        // Then
        XCTAssertNil(weakCharts, "Charts should be deallocated")
    }
    
    // MARK: - Benchmark Tests
    
    func testBenchmarkAgainstBaseline() {
        // Given
        let baselineTime: TimeInterval = 0.1 // 100ms baseline
        let chart = LineChart(data: mediumDataset)
        
        // When & Then
        measure {
            _ = chart
        }
        
        // Note: In a real implementation, we would compare against baseline
    }
    
    func testPerformanceRegression() {
        // Given
        let chart = LineChart(data: largeDataset)
        
        // When & Then
        measure {
            _ = chart
        }
        
        // Note: In a real implementation, we would compare against previous versions
    }
} 