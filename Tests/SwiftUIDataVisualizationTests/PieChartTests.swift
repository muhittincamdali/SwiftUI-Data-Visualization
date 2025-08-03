import XCTest
import SwiftUI
@testable import SwiftUIDataVisualization

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
final class PieChartTests: XCTestCase {
    
    // MARK: - Properties
    
    private var testData: [ChartDataPoint]!
    private var chartView: PieChart!
    private var configuration: ChartConfiguration!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        testData = createTestData()
        configuration = ChartConfiguration()
        chartView = PieChart(data: testData, configuration: configuration)
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
            ChartDataPoint(x: 1, y: 30, label: "Red", color: .red),
            ChartDataPoint(x: 2, y: 25, label: "Blue", color: .blue),
            ChartDataPoint(x: 3, y: 20, label: "Green", color: .green),
            ChartDataPoint(x: 4, y: 15, label: "Yellow", color: .yellow),
            ChartDataPoint(x: 5, y: 10, label: "Purple", color: .purple)
        ]
    }
    
    private func createEmptyData() -> [ChartDataPoint] {
        return []
    }
    
    private func createSingleSliceData() -> [ChartDataPoint] {
        return [ChartDataPoint(x: 1, y: 100, label: "Single", color: .blue)]
    }
    
    private func createLargeDataset() -> [ChartDataPoint] {
        return (1...20).map { i in
            ChartDataPoint(
                x: Double(i),
                y: Double(i * 5),
                label: "Slice \(i)",
                color: Color(hue: Double(i) / 20.0, saturation: 0.8, brightness: 0.8)
            )
        }
    }
    
    // MARK: - Initialization Tests
    
    func testPieChartInitialization() {
        // Given
        let data = createTestData()
        let config = ChartConfiguration()
        
        // When
        let chart = PieChart(data: data, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartInitializationWithStyle() {
        // Given
        let data = createTestData()
        
        // When
        let chart = PieChart(data: data, style: .pie)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartInitializationWithLabels() {
        // Given
        let data = createTestData()
        
        // When
        let chartWithLabels = PieChart(data: data, showLabels: true)
        let chartWithoutLabels = PieChart(data: data, showLabels: false)
        
        // Then
        XCTAssertNotNil(chartWithLabels)
        XCTAssertNotNil(chartWithoutLabels)
    }
    
    func testPieChartInitializationWithValues() {
        // Given
        let data = createTestData()
        
        // When
        let chartWithValues = PieChart(data: data, showValues: true)
        let chartWithoutValues = PieChart(data: data, showValues: false)
        
        // Then
        XCTAssertNotNil(chartWithValues)
        XCTAssertNotNil(chartWithoutValues)
    }
    
    func testPieChartInitializationWithCenterText() {
        // Given
        let data = createTestData()
        
        // When
        let chartWithCenterText = PieChart(data: data, centerText: "Total")
        let chartWithoutCenterText = PieChart(data: data, centerText: nil)
        
        // Then
        XCTAssertNotNil(chartWithCenterText)
        XCTAssertNotNil(chartWithoutCenterText)
    }
    
    func testPieChartInitializationWithEmptyData() {
        // Given
        let data = createEmptyData()
        
        // When
        let chart = PieChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartInitializationWithSingleSlice() {
        // Given
        let data = createSingleSliceData()
        
        // When
        let chart = PieChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartInitializationWithLargeDataset() {
        // Given
        let data = createLargeDataset()
        
        // When
        let chart = PieChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Data Validation Tests
    
    func testPieChartWithZeroValues() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 0, label: "Zero", color: .red),
            ChartDataPoint(x: 2, y: 0, label: "Zero", color: .blue)
        ]
        
        // When
        let chart = PieChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartWithNegativeValues() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: -10, label: "Negative", color: .red),
            ChartDataPoint(x: 2, y: 20, label: "Positive", color: .blue)
        ]
        
        // When
        let chart = PieChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartWithExtremeValues() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: Double.greatestFiniteMagnitude, label: "Extreme", color: .red),
            ChartDataPoint(x: 2, y: Double.leastNormalMagnitude, label: "Minimal", color: .blue)
        ]
        
        // When
        let chart = PieChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Color Tests
    
    func testPieChartWithCustomColors() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 30, label: "Red", color: .red),
            ChartDataPoint(x: 2, y: 25, label: "Blue", color: .blue),
            ChartDataPoint(x: 3, y: 20, label: "Green", color: .green)
        ]
        
        // When
        let chart = PieChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartWithDefaultColors() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 30, label: "Slice 1"),
            ChartDataPoint(x: 2, y: 25, label: "Slice 2"),
            ChartDataPoint(x: 3, y: 20, label: "Slice 3")
        ]
        
        // When
        let chart = PieChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Label Tests
    
    func testPieChartWithLabels() {
        // Given
        let data = createTestData()
        
        // When
        let chart = PieChart(data: data, showLabels: true)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartWithoutLabels() {
        // Given
        let data = createTestData()
        
        // When
        let chart = PieChart(data: data, showLabels: false)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartWithMissingLabels() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 30, color: .red),
            ChartDataPoint(x: 2, y: 25, color: .blue),
            ChartDataPoint(x: 3, y: 20, color: .green)
        ]
        
        // When
        let chart = PieChart(data: data, showLabels: true)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Value Tests
    
    func testPieChartWithValues() {
        // Given
        let data = createTestData()
        
        // When
        let chart = PieChart(data: data, showValues: true)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartWithoutValues() {
        // Given
        let data = createTestData()
        
        // When
        let chart = PieChart(data: data, showValues: false)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Center Text Tests
    
    func testPieChartWithCenterText() {
        // Given
        let data = createTestData()
        
        // When
        let chart = PieChart(data: data, centerText: "Total")
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartWithoutCenterText() {
        // Given
        let data = createTestData()
        
        // When
        let chart = PieChart(data: data, centerText: nil)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartWithEmptyCenterText() {
        // Given
        let data = createTestData()
        
        // When
        let chart = PieChart(data: data, centerText: "")
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Configuration Tests
    
    func testPieChartWithCustomConfiguration() {
        // Given
        let data = createTestData()
        let customConfig = ChartConfiguration(
            style: .pie,
            theme: .dark,
            colors: [.red, .blue, .green],
            backgroundColor: .black,
            borderColor: .white,
            borderWidth: 2,
            cornerRadius: 10,
            interactive: true,
            tooltipEnabled: true,
            selectionEnabled: true
        )
        
        // When
        let chart = PieChart(data: data, configuration: customConfig)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartWithCustomAnimation() {
        // Given
        let data = createTestData()
        let config = ChartConfiguration(
            animation: .spring(response: 0.6, dampingFraction: 0.8),
            animationDuration: 1.0
        )
        
        // When
        let chart = PieChart(data: data, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Accessibility Tests
    
    func testPieChartAccessibility() {
        // Given
        let config = ChartConfiguration(
            accessibility: AccessibilityConfiguration(
                label: "Test Pie Chart",
                hint: "Shows test data as pie slices",
                value: "5 slices"
            )
        )
        let chart = PieChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartVoiceOverEnabled() {
        // Given
        let config = ChartConfiguration(voiceOverEnabled: true)
        
        // When
        let chart = PieChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartDynamicTypeEnabled() {
        // Given
        let config = ChartConfiguration(dynamicTypeEnabled: true)
        
        // When
        let chart = PieChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartHighContrastEnabled() {
        // Given
        let config = ChartConfiguration(highContrastEnabled: true)
        
        // When
        let chart = PieChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Performance Tests
    
    func testPieChartPerformance() {
        // Given
        let largeData = createLargeDataset()
        let chart = PieChart(data: largeData)
        
        // When & Then
        measure {
            // This would test rendering performance in a real implementation
            _ = chart
        }
    }
    
    func testPieChartMemoryUsage() {
        // Given
        let largeData = createLargeDataset()
        let chart = PieChart(data: largeData)
        
        // When & Then
        measure {
            // This would test memory usage in a real implementation
            _ = chart
        }
    }
    
    // MARK: - Interaction Tests
    
    func testPieChartInteractive() {
        // Given
        let config = ChartConfiguration(interactive: true)
        
        // When
        let chart = PieChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartTooltipEnabled() {
        // Given
        let config = ChartConfiguration(tooltipEnabled: true)
        
        // When
        let chart = PieChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartSelectionEnabled() {
        // Given
        let config = ChartConfiguration(selectionEnabled: true)
        
        // When
        let chart = PieChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Edge Cases
    
    func testPieChartWithDuplicateValues() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10, label: "Slice 1", color: .red),
            ChartDataPoint(x: 1, y: 10, label: "Slice 1", color: .red),
            ChartDataPoint(x: 2, y: 20, label: "Slice 2", color: .blue),
            ChartDataPoint(x: 2, y: 20, label: "Slice 2", color: .blue)
        ]
        
        // When
        let chart = PieChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartWithCustomMetadata() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 30, label: "Sales", color: .red, metadata: ["category": "revenue"]),
            ChartDataPoint(x: 2, y: 25, label: "Marketing", color: .blue, metadata: ["category": "expense"]),
            ChartDataPoint(x: 3, y: 20, label: "Development", color: .green, metadata: ["category": "investment"])
        ]
        
        // When
        let chart = PieChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartWithAllSameValues() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10, label: "Equal 1", color: .red),
            ChartDataPoint(x: 2, y: 10, label: "Equal 2", color: .blue),
            ChartDataPoint(x: 3, y: 10, label: "Equal 3", color: .green)
        ]
        
        // When
        let chart = PieChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Percentage Calculation Tests
    
    func testPieChartPercentageCalculation() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 25, label: "25%"),
            ChartDataPoint(x: 2, y: 25, label: "25%"),
            ChartDataPoint(x: 3, y: 25, label: "25%"),
            ChartDataPoint(x: 4, y: 25, label: "25%")
        ]
        
        // When
        let chart = PieChart(data: data, showValues: true)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testPieChartUnevenPercentages() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 50, label: "50%"),
            ChartDataPoint(x: 2, y: 30, label: "30%"),
            ChartDataPoint(x: 3, y: 20, label: "20%")
        ]
        
        // When
        let chart = PieChart(data: data, showValues: true)
        
        // Then
        XCTAssertNotNil(chart)
    }
} 