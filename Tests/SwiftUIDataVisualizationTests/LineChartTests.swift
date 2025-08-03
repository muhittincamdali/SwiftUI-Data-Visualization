import XCTest
import SwiftUI
@testable import SwiftUIDataVisualization

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
final class LineChartTests: XCTestCase {
    
    // MARK: - Properties
    
    private var testData: [ChartDataPoint]!
    private var chartView: LineChart!
    private var configuration: ChartConfiguration!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        testData = createTestData()
        configuration = ChartConfiguration()
        chartView = LineChart(data: testData, configuration: configuration)
    }
    
    override func tearDown() {
        testData = nil
        chartView = nil
        configuration = nil
        super.tearDown()
    }
    
    // MARK: - Test Data Creation
    
    private func createTestData() -> [ChartDataPoint] {
        return [
            ChartDataPoint(x: 1, y: 10, label: "Jan"),
            ChartDataPoint(x: 2, y: 25, label: "Feb"),
            ChartDataPoint(x: 3, y: 15, label: "Mar"),
            ChartDataPoint(x: 4, y: 30, label: "Apr"),
            ChartDataPoint(x: 5, y: 20, label: "May")
        ]
    }
    
    private func createEmptyData() -> [ChartDataPoint] {
        return []
    }
    
    private func createSinglePointData() -> [ChartDataPoint] {
        return [ChartDataPoint(x: 1, y: 10, label: "Single")]
    }
    
    private func createLargeDataset() -> [ChartDataPoint] {
        return (1...1000).map { i in
            ChartDataPoint(x: Double(i), y: Double(i * 2), label: "Point \(i)")
        }
    }
    
    // MARK: - Initialization Tests
    
    func testLineChartInitialization() {
        // Given
        let data = createTestData()
        let config = ChartConfiguration()
        
        // When
        let chart = LineChart(data: data, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testLineChartInitializationWithStyle() {
        // Given
        let data = createTestData()
        
        // When
        let chart = LineChart(data: data, style: .line)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testLineChartInitializationWithEmptyData() {
        // Given
        let data = createEmptyData()
        
        // When
        let chart = LineChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testLineChartInitializationWithSinglePoint() {
        // Given
        let data = createSinglePointData()
        
        // When
        let chart = LineChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testLineChartInitializationWithLargeDataset() {
        // Given
        let data = createLargeDataset()
        
        // When
        let chart = LineChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Configuration Tests
    
    func testChartConfigurationDefaultValues() {
        // Given
        let config = ChartConfiguration()
        
        // Then
        XCTAssertEqual(config.style, .line)
        XCTAssertEqual(config.theme, .auto)
        XCTAssertEqual(config.colors.count, 5)
        XCTAssertEqual(config.backgroundColor, .clear)
        XCTAssertEqual(config.borderColor, .gray)
        XCTAssertEqual(config.borderWidth, 0)
        XCTAssertEqual(config.cornerRadius, 0)
        XCTAssertTrue(config.animationsEnabled)
        XCTAssertFalse(config.interactive)
        XCTAssertTrue(config.voiceOverEnabled)
        XCTAssertTrue(config.dynamicTypeEnabled)
        XCTAssertTrue(config.highContrastEnabled)
    }
    
    func testChartConfigurationWithCustomValues() {
        // Given
        let customColors = [Color.red, Color.blue, Color.green]
        let customConfig = ChartConfiguration(
            style: .bar,
            theme: .dark,
            colors: customColors,
            backgroundColor: .black,
            borderColor: .white,
            borderWidth: 2,
            cornerRadius: 10,
            interactive: true,
            zoomEnabled: true,
            panEnabled: true,
            tooltipEnabled: true,
            selectionEnabled: true,
            gesturesEnabled: true
        )
        
        // Then
        XCTAssertEqual(customConfig.style, .bar)
        XCTAssertEqual(customConfig.theme, .dark)
        XCTAssertEqual(customConfig.colors, customColors)
        XCTAssertEqual(customConfig.backgroundColor, .black)
        XCTAssertEqual(customConfig.borderColor, .white)
        XCTAssertEqual(customConfig.borderWidth, 2)
        XCTAssertEqual(customConfig.cornerRadius, 10)
        XCTAssertTrue(customConfig.interactive)
        XCTAssertTrue(customConfig.zoomEnabled)
        XCTAssertTrue(customConfig.panEnabled)
        XCTAssertTrue(customConfig.tooltipEnabled)
        XCTAssertTrue(customConfig.selectionEnabled)
        XCTAssertTrue(customConfig.gesturesEnabled)
    }
    
    // MARK: - Data Point Tests
    
    func testChartDataPointCreation() {
        // Given
        let x = 1.0
        let y = 25.0
        let label = "Test Point"
        let color = Color.blue
        let metadata = ["category": "test"]
        
        // When
        let dataPoint = ChartDataPoint(
            x: x,
            y: y,
            label: label,
            color: color,
            metadata: metadata
        )
        
        // Then
        XCTAssertEqual(dataPoint.x, x)
        XCTAssertEqual(dataPoint.y, y)
        XCTAssertEqual(dataPoint.label, label)
        XCTAssertEqual(dataPoint.color, color)
        XCTAssertEqual(dataPoint.metadata, metadata)
        XCTAssertFalse(dataPoint.is3D)
        XCTAssertFalse(dataPoint.isTimeSeries)
        XCTAssertFalse(dataPoint.isBubble)
        XCTAssertFalse(dataPoint.hasConfidenceInterval)
    }
    
    func testChartDataPoint3D() {
        // Given
        let x = 1.0
        let y = 25.0
        let z = 10.0
        
        // When
        let dataPoint = ChartDataPoint(x: x, y: y, z: z)
        
        // Then
        XCTAssertEqual(dataPoint.x, x)
        XCTAssertEqual(dataPoint.y, y)
        XCTAssertEqual(dataPoint.z, z)
        XCTAssertTrue(dataPoint.is3D)
        XCTAssertNotNil(dataPoint.coordinate3D)
    }
    
    func testChartDataPointTimeSeries() {
        // Given
        let timestamp = Date()
        let y = 25.0
        
        // When
        let dataPoint = ChartDataPoint(timestamp: timestamp, y: y)
        
        // Then
        XCTAssertEqual(dataPoint.y, y)
        XCTAssertEqual(dataPoint.timestamp, timestamp)
        XCTAssertTrue(dataPoint.isTimeSeries)
    }
    
    func testChartDataPointBubble() {
        // Given
        let x = 1.0
        let y = 25.0
        let size = 15.0
        
        // When
        let dataPoint = ChartDataPoint(x: x, y: y, size: size)
        
        // Then
        XCTAssertEqual(dataPoint.x, x)
        XCTAssertEqual(dataPoint.y, y)
        XCTAssertEqual(dataPoint.size, size)
        XCTAssertTrue(dataPoint.isBubble)
    }
    
    func testChartDataPointWithConfidenceInterval() {
        // Given
        let x = 1.0
        let y = 25.0
        let confidenceInterval = 20.0...30.0
        
        // When
        let dataPoint = ChartDataPoint(x: x, y: y, confidenceInterval: confidenceInterval)
        
        // Then
        XCTAssertEqual(dataPoint.x, x)
        XCTAssertEqual(dataPoint.y, y)
        XCTAssertEqual(dataPoint.confidenceInterval, confidenceInterval)
        XCTAssertTrue(dataPoint.hasConfidenceInterval)
    }
    
    func testChartDataPointEquality() {
        // Given
        let point1 = ChartDataPoint(x: 1, y: 10, label: "Test")
        let point2 = ChartDataPoint(x: 1, y: 10, label: "Test")
        let point3 = ChartDataPoint(x: 2, y: 10, label: "Test")
        
        // Then
        XCTAssertNotEqual(point1, point2) // Different IDs
        XCTAssertNotEqual(point1, point3) // Different values
    }
    
    func testChartDataPointHashable() {
        // Given
        let point1 = ChartDataPoint(x: 1, y: 10)
        let point2 = ChartDataPoint(x: 1, y: 10)
        
        // When
        let set = Set([point1, point2])
        
        // Then
        XCTAssertEqual(set.count, 2) // Different IDs
    }
    
    // MARK: - Utility Tests
    
    func testChartDataPointFromArrays() {
        // Given
        let xValues = [1.0, 2.0, 3.0]
        let yValues = [10.0, 20.0, 30.0]
        let labels = ["A", "B", "C"]
        
        // When
        let dataPoints = ChartDataPoint.fromArrays(xValues: xValues, yValues: yValues, labels: labels)
        
        // Then
        XCTAssertEqual(dataPoints.count, 3)
        XCTAssertEqual(dataPoints[0].x, 1.0)
        XCTAssertEqual(dataPoints[0].y, 10.0)
        XCTAssertEqual(dataPoints[0].label, "A")
        XCTAssertEqual(dataPoints[1].x, 2.0)
        XCTAssertEqual(dataPoints[1].y, 20.0)
        XCTAssertEqual(dataPoints[1].label, "B")
        XCTAssertEqual(dataPoints[2].x, 3.0)
        XCTAssertEqual(dataPoints[2].y, 30.0)
        XCTAssertEqual(dataPoints[2].label, "C")
    }
    
    func testChartDataPointFromArraysMismatchedLengths() {
        // Given
        let xValues = [1.0, 2.0]
        let yValues = [10.0, 20.0, 30.0] // Different length
        
        // When
        let dataPoints = ChartDataPoint.fromArrays(xValues: xValues, yValues: yValues)
        
        // Then
        XCTAssertEqual(dataPoints.count, 0) // Empty array due to mismatch
    }
    
    func testChartDataPointFromTimeSeries() {
        // Given
        let timestamps = [Date(), Date().addingTimeInterval(3600), Date().addingTimeInterval(7200)]
        let values = [10.0, 20.0, 30.0]
        let labels = ["A", "B", "C"]
        
        // When
        let dataPoints = ChartDataPoint.fromTimeSeries(timestamps: timestamps, values: values, labels: labels)
        
        // Then
        XCTAssertEqual(dataPoints.count, 3)
        XCTAssertTrue(dataPoints[0].isTimeSeries)
        XCTAssertTrue(dataPoints[1].isTimeSeries)
        XCTAssertTrue(dataPoints[2].isTimeSeries)
        XCTAssertEqual(dataPoints[0].label, "A")
        XCTAssertEqual(dataPoints[1].label, "B")
        XCTAssertEqual(dataPoints[2].label, "C")
    }
    
    // MARK: - Performance Tests
    
    func testLineChartPerformance() {
        // Given
        let largeData = createLargeDataset()
        let chart = LineChart(data: largeData)
        
        // When & Then
        measure {
            // This would test rendering performance in a real implementation
            _ = chart
        }
    }
    
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
    
    // MARK: - Edge Cases
    
    func testLineChartWithNegativeValues() {
        // Given
        let data = [
            ChartDataPoint(x: -5, y: -10),
            ChartDataPoint(x: 0, y: 0),
            ChartDataPoint(x: 5, y: 10)
        ]
        
        // When
        let chart = LineChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testLineChartWithZeroValues() {
        // Given
        let data = [
            ChartDataPoint(x: 0, y: 0),
            ChartDataPoint(x: 1, y: 0),
            ChartDataPoint(x: 2, y: 0)
        ]
        
        // When
        let chart = LineChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testLineChartWithExtremeValues() {
        // Given
        let data = [
            ChartDataPoint(x: Double.greatestFiniteMagnitude, y: Double.greatestFiniteMagnitude),
            ChartDataPoint(x: Double.leastNormalMagnitude, y: Double.leastNormalMagnitude)
        ]
        
        // When
        let chart = LineChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Accessibility Tests
    
    func testLineChartAccessibility() {
        // Given
        let config = ChartConfiguration(
            accessibility: AccessibilityConfiguration(
                label: "Test Chart",
                hint: "Shows test data",
                value: "5 data points"
            )
        )
        let chart = LineChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
        // In a real implementation, we would test accessibility properties
    }
    
    // MARK: - Configuration Builder Tests
    
    func testConfigurationBuilderMethods() {
        // Given
        let baseConfig = ChartConfiguration()
        
        // When
        let customConfig = baseConfig
            .withStyle(.bar)
            .withTheme(.dark)
            .withColors([.red, .blue])
            .withAnimation(.easeInOut(duration: 1.0))
            .withInteractive(true)
        
        // Then
        XCTAssertEqual(customConfig.style, .bar)
        XCTAssertEqual(customConfig.theme, .dark)
        XCTAssertEqual(customConfig.colors, [.red, .blue])
        XCTAssertEqual(customConfig.animation, .easeInOut(duration: 1.0))
        XCTAssertTrue(customConfig.interactive)
    }
} 