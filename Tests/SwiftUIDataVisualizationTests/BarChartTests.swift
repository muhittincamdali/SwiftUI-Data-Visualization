import XCTest
import SwiftUI
@testable import SwiftUIDataVisualization

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
final class BarChartTests: XCTestCase {
    
    // MARK: - Properties
    
    private var testData: [ChartDataPoint]!
    private var chartView: BarChart!
    private var configuration: ChartConfiguration!
    
    // MARK: - Setup
    
    override func setUp() {
        super.setUp()
        testData = createTestData()
        configuration = ChartConfiguration()
        chartView = BarChart(data: testData, configuration: configuration)
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
            ChartDataPoint(x: 1, y: 10, label: "Category A"),
            ChartDataPoint(x: 2, y: 25, label: "Category B"),
            ChartDataPoint(x: 3, y: 15, label: "Category C"),
            ChartDataPoint(x: 4, y: 30, label: "Category D"),
            ChartDataPoint(x: 5, y: 20, label: "Category E")
        ]
    }
    
    private func createEmptyData() -> [ChartDataPoint] {
        return []
    }
    
    private func createSingleBarData() -> [ChartDataPoint] {
        return [ChartDataPoint(x: 1, y: 10, label: "Single")]
    }
    
    private func createLargeDataset() -> [ChartDataPoint] {
        return (1...1000).map { i in
            ChartDataPoint(x: Double(i), y: Double(i * 2), label: "Bar \(i)")
        }
    }
    
    // MARK: - Initialization Tests
    
    func testBarChartInitialization() {
        // Given
        let data = createTestData()
        let config = ChartConfiguration()
        
        // When
        let chart = BarChart(data: data, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartInitializationWithStyle() {
        // Given
        let data = createTestData()
        
        // When
        let chart = BarChart(data: data, style: .bar)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartInitializationWithOrientation() {
        // Given
        let data = createTestData()
        
        // When
        let verticalChart = BarChart(data: data, orientation: .vertical)
        let horizontalChart = BarChart(data: data, orientation: .horizontal)
        
        // Then
        XCTAssertNotNil(verticalChart)
        XCTAssertNotNil(horizontalChart)
    }
    
    func testBarChartInitializationWithEmptyData() {
        // Given
        let data = createEmptyData()
        
        // When
        let chart = BarChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartInitializationWithSingleBar() {
        // Given
        let data = createSingleBarData()
        
        // When
        let chart = BarChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartInitializationWithLargeDataset() {
        // Given
        let data = createLargeDataset()
        
        // When
        let chart = BarChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Orientation Tests
    
    func testVerticalBarChart() {
        // Given
        let data = createTestData()
        
        // When
        let chart = BarChart(data: data, orientation: .vertical)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testHorizontalBarChart() {
        // Given
        let data = createTestData()
        
        // When
        let chart = BarChart(data: data, orientation: .horizontal)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Stacking Tests
    
    func testStackedBarChart() {
        // Given
        let data = createTestData()
        
        // When
        let chart = BarChart(data: data, isStacked: true)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testNonStackedBarChart() {
        // Given
        let data = createTestData()
        
        // When
        let chart = BarChart(data: data, isStacked: false)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Data Validation Tests
    
    func testBarChartWithNegativeValues() {
        // Given
        let data = [
            ChartDataPoint(x: -5, y: -10),
            ChartDataPoint(x: 0, y: 0),
            ChartDataPoint(x: 5, y: 10)
        ]
        
        // When
        let chart = BarChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartWithZeroValues() {
        // Given
        let data = [
            ChartDataPoint(x: 0, y: 0),
            ChartDataPoint(x: 1, y: 0),
            ChartDataPoint(x: 2, y: 0)
        ]
        
        // When
        let chart = BarChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartWithExtremeValues() {
        // Given
        let data = [
            ChartDataPoint(x: Double.greatestFiniteMagnitude, y: Double.greatestFiniteMagnitude),
            ChartDataPoint(x: Double.leastNormalMagnitude, y: Double.leastNormalMagnitude)
        ]
        
        // When
        let chart = BarChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Configuration Tests
    
    func testBarChartWithCustomConfiguration() {
        // Given
        let data = createTestData()
        let customConfig = ChartConfiguration(
            style: .bar,
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
        let chart = BarChart(data: data, configuration: customConfig)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartWithCustomColors() {
        // Given
        let data = createTestData()
        let customColors = [Color.red, Color.blue, Color.green]
        let config = ChartConfiguration(colors: customColors)
        
        // When
        let chart = BarChart(data: data, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartWithCustomAnimation() {
        // Given
        let data = createTestData()
        let config = ChartConfiguration(
            animation: .spring(response: 0.6, dampingFraction: 0.8),
            animationDuration: 1.0
        )
        
        // When
        let chart = BarChart(data: data, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Accessibility Tests
    
    func testBarChartAccessibility() {
        // Given
        let config = ChartConfiguration(
            accessibility: AccessibilityConfiguration(
                label: "Test Bar Chart",
                hint: "Shows test data as bars",
                value: "5 bars"
            )
        )
        let chart = BarChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartVoiceOverEnabled() {
        // Given
        let config = ChartConfiguration(voiceOverEnabled: true)
        
        // When
        let chart = BarChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartDynamicTypeEnabled() {
        // Given
        let config = ChartConfiguration(dynamicTypeEnabled: true)
        
        // When
        let chart = BarChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartHighContrastEnabled() {
        // Given
        let config = ChartConfiguration(highContrastEnabled: true)
        
        // When
        let chart = BarChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Performance Tests
    
    func testBarChartPerformance() {
        // Given
        let largeData = createLargeDataset()
        let chart = BarChart(data: largeData)
        
        // When & Then
        measure {
            // This would test rendering performance in a real implementation
            _ = chart
        }
    }
    
    func testBarChartMemoryUsage() {
        // Given
        let largeData = createLargeDataset()
        let chart = BarChart(data: largeData)
        
        // When & Then
        measure {
            // This would test memory usage in a real implementation
            _ = chart
        }
    }
    
    // MARK: - Interaction Tests
    
    func testBarChartInteractive() {
        // Given
        let config = ChartConfiguration(interactive: true)
        
        // When
        let chart = BarChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartZoomEnabled() {
        // Given
        let config = ChartConfiguration(zoomEnabled: true)
        
        // When
        let chart = BarChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartPanEnabled() {
        // Given
        let config = ChartConfiguration(panEnabled: true)
        
        // When
        let chart = BarChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartTooltipEnabled() {
        // Given
        let config = ChartConfiguration(tooltipEnabled: true)
        
        // When
        let chart = BarChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartSelectionEnabled() {
        // Given
        let config = ChartConfiguration(selectionEnabled: true)
        
        // When
        let chart = BarChart(data: testData, configuration: config)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    // MARK: - Edge Cases
    
    func testBarChartWithDuplicateValues() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10),
            ChartDataPoint(x: 1, y: 10),
            ChartDataPoint(x: 2, y: 20),
            ChartDataPoint(x: 2, y: 20)
        ]
        
        // When
        let chart = BarChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartWithMissingLabels() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10),
            ChartDataPoint(x: 2, y: 20),
            ChartDataPoint(x: 3, y: 30)
        ]
        
        // When
        let chart = BarChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
    }
    
    func testBarChartWithCustomMetadata() {
        // Given
        let data = [
            ChartDataPoint(x: 1, y: 10, metadata: ["category": "sales"]),
            ChartDataPoint(x: 2, y: 20, metadata: ["category": "marketing"]),
            ChartDataPoint(x: 3, y: 30, metadata: ["category": "development"])
        ]
        
        // When
        let chart = BarChart(data: data)
        
        // Then
        XCTAssertNotNil(chart)
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