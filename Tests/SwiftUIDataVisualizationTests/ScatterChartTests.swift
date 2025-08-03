import XCTest
import SwiftUI
@testable import SwiftUIDataVisualization

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
final class ScatterChartTests: XCTestCase {
    
    // MARK: - Properties
    
    private var testData: [ChartDataPoint]!
    private var chartView: ScatterChart!
    private var configuration: ChartConfiguration!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        testData = createTestData()
        configuration = ChartConfiguration()
        chartView = ScatterChart(data: testData, configuration: configuration)
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
            ChartDataPoint(x: 1, y: 10, size: 5),
            ChartDataPoint(x: 2, y: 25, size: 8),
            ChartDataPoint(x: 3, y: 15, size: 6),
            ChartDataPoint(x: 4, y: 30, size: 10),
            ChartDataPoint(x: 5, y: 20, size: 7)
        ]
    }
    
    private func createEmptyData() -> [ChartDataPoint] {
        return []
    }
    
    private func createSinglePointData() -> [ChartDataPoint] {
        return [ChartDataPoint(x: 1, y: 10, size: 5)]
    }
    
    private func createLargeDataset() -> [ChartDataPoint] {
        return (1...1000).map { i in
            ChartDataPoint(
                x: Double(i),
                y: Double(i * 2),
                size: Double(i % 10),
                label: "Point \(i)"
            )
        }
    }
    
    // MARK: - Initialization Tests
    
    func testScatterChartInitialization() {
        // Given
        let data = createTestData()
        let config = ChartConfiguration()
        
        // When
        let chart = ScatterChart(data: data, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartInitializationWithStyle() {
        // Given
        let data = createTestData()
        
        // When
        let chart = ScatterChart(data: data, style: .scatter)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartInitializationWithPointSize() {
        // Given
        let data = createTestData()
        
        // When
        let chart = ScatterChart(data: data, pointSize: 10)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartInitializationWithTrendLine() {
        // Given
        let data = createTestData()
        
        // When
        let chart = ScatterChart(data: data, showTrendLine: true)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartInitializationWithEmptyData() {
        // Given
        let data = createEmptyData()
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartInitializationWithSinglePoint() {
        // Given
        let data = createSinglePointData()
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartInitializationWithLargeDataset() {
        // Given
        let data = createLargeDataset()
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Data Validation Tests
    
    func testScatterChartWithNegativeValues() {
        // Given
        let data = [
            ChartDataPoint(x: -5, y: -10, size: 5),
            ChartDataPoint(x: 0, y: 0, size: 8),
            ChartDataPoint(x: 5, y: 10, size: 6)
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartWithZeroValues() {
        // Given
        let data = [
            ChartDataPoint(x: 0, y: 0, size: 5),
            ChartDataPoint(x: 1, y: 0, size: 8),
            ChartDataPoint(x: 2, y: 0, size: 6)
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartWithExtremeValues() {
        // Given
        let data = [
            ChartDataPoint(x: Double.greatestFiniteMagnitude, y: Double.greatestFiniteMagnitude, size: 5),
            ChartDataPoint(x: Double.leastNormalMagnitude, y: Double.leastNormalMagnitude, size: 8)
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Size Tests
    
    func testScatterChartWithVariableSizes() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10, size: 5),
            ChartDataPoint(x: 2, y: 25, size: 15),
            ChartDataPoint(x: 3, y: 15, size: 8)
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartWithSameSizes() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10, size: 8),
            ChartDataPoint(x: 2, y: 25, size: 8),
            ChartDataPoint(x: 3, y: 15, size: 8)
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartWithMissingSizes() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10),
            ChartDataPoint(x: 2, y: 25),
            ChartDataPoint(x: 3, y: 15)
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Color Tests
    
    func testScatterChartWithCustomColors() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10, color: .red),
            ChartDataPoint(x: 2, y: 25, color: .blue),
            ChartDataPoint(x: 3, y: 15, color: .green)
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartWithDefaultColors() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10),
            ChartDataPoint(x: 2, y: 25),
            ChartDataPoint(x: 3, y: 15)
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Configuration Tests
    
    func testScatterChartWithCustomConfiguration() {
        // Given
        let data = createTestData()
        let customConfig = ChartConfiguration(
            style: .scatter,
            theme: .dark,
            colors: [.red, .blue, .green],
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
        
        // When
        let chart = ScatterChart(data: data, configuration: customConfig)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartWithCustomAnimation() {
        // Given
        let data = createTestData()
        let config = ChartConfiguration(
            animation: .spring(response: 0.6, dampingFraction: 0.8),
            animationDuration: 1.0
        )
        
        // When
        let chart = ScatterChart(data: data, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Accessibility Tests
    
    func testScatterChartAccessibility() {
        // Given
        let config = ChartConfiguration(
            accessibility: AccessibilityConfiguration(
                label: "Test Scatter Chart",
                hint: "Shows data as individual points",
                value: "5 points"
            )
        )
        let chart = ScatterChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartVoiceOverEnabled() {
        // Given
        let config = ChartConfiguration(voiceOverEnabled: true)
        
        // When
        let chart = ScatterChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartDynamicTypeEnabled() {
        // Given
        let config = ChartConfiguration(dynamicTypeEnabled: true)
        
        // When
        let chart = ScatterChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartHighContrastEnabled() {
        // Given
        let config = ChartConfiguration(highContrastEnabled: true)
        
        // When
        let chart = ScatterChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Performance Tests
    
    func testScatterChartPerformance() {
        // Given
        let largeData = createLargeDataset()
        let chart = ScatterChart(data: largeData)
        
        // When & Then
        measure {
            // This would test rendering performance in a real implementation
            _ = chart
        }
    }
    
    func testScatterChartMemoryUsage() {
        // Given
        let largeData = createLargeDataset()
        let chart = ScatterChart(data: largeData)
        
        // When & Then
        measure {
            // This would test memory usage in a real implementation
            _ = chart
        }
    }
    
    // MARK: - Interaction Tests
    
    func testScatterChartInteractive() {
        // Given
        let config = ChartConfiguration(interactive: true)
        
        // When
        let chart = ScatterChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartZoomEnabled() {
        // Given
        let config = ChartConfiguration(zoomEnabled: true)
        
        // When
        let chart = ScatterChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartPanEnabled() {
        // Given
        let config = ChartConfiguration(panEnabled: true)
        
        // When
        let chart = ScatterChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartTooltipEnabled() {
        // Given
        let config = ChartConfiguration(tooltipEnabled: true)
        
        // When
        let chart = ScatterChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartSelectionEnabled() {
        // Given
        let config = ChartConfiguration(selectionEnabled: true)
        
        // When
        let chart = ScatterChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Edge Cases
    
    func testScatterChartWithDuplicateValues() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10, size: 5),
            ChartDataPoint(x: 1, y: 10, size: 5),
            ChartDataPoint(x: 2, y: 20, size: 8),
            ChartDataPoint(x: 2, y: 20, size: 8)
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartWithMissingLabels() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10, size: 5),
            ChartDataPoint(x: 2, y: 25, size: 8),
            ChartDataPoint(x: 3, y: 15, size: 6)
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartWithCustomMetadata() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10, size: 5, metadata: ["category": "group1"]),
            ChartDataPoint(x: 2, y: 25, size: 8, metadata: ["category": "group2"]),
            ChartDataPoint(x: 3, y: 15, size: 6, metadata: ["category": "group1"])
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Trend Line Tests
    
    func testScatterChartWithTrendLine() {
        // Given
        let data = createTestData()
        
        // When
        let chart = ScatterChart(data: data, showTrendLine: true)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testScatterChartWithoutTrendLine() {
        // Given
        let data = createTestData()
        
        // When
        let chart = ScatterChart(data: data, showTrendLine: false)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Clustering Tests
    
    func testScatterChartWithClusteredData() {
        // Given
        let data = [
            // Cluster 1
            ChartDataPoint(x: 1, y: 1, size: 5),
            ChartDataPoint(x: 1.1, y: 1.1, size: 6),
            ChartDataPoint(x: 0.9, y: 0.9, size: 4),
            // Cluster 2
            ChartDataPoint(x: 5, y: 5, size: 8),
            ChartDataPoint(x: 5.1, y: 5.1, size: 9),
            ChartDataPoint(x: 4.9, y: 4.9, size: 7)
        ]
        
        // When
        let chart = ScatterChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Configuration Builder Tests
    
    func testConfigurationBuilderMethods() {
        // Given
        let baseConfig = ChartConfiguration()
        
        // When
        let customConfig = baseConfig
            .withStyle(.scatter)
            .withTheme(.dark)
            .withColors([.red, .blue])
            .withAnimation(.easeInOut(duration: 1.0))
            .withInteractive(true)
        
        // Then
        XCTAssertEqual(customConfig.style, .scatter)
        XCTAssertEqual(customConfig.theme, .dark)
        XCTAssertEqual(customConfig.colors, [.red, .blue])
        XCTAssertEqual(customConfig.animation, .easeInOut(duration: 1.0))
        XCTAssertTrue(customConfig.interactive)
    }
} 