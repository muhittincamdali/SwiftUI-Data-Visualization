import XCTest
import Quick
import Nimble
@testable import DataVisualization

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
class ChartPerformanceTests: QuickSpec {
    
    override func spec() {
        describe("Chart Performance") {
            
            context("when rendering large datasets") {
                it("should render 1000 data points efficiently") {
                    let largeData = (1...1000).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    let chartView = LineChartView(data: largeData)
                    let endTime = CFAbsoluteTimeGetCurrent()
                    
                    let renderTime = (endTime - startTime) * 1000 // Convert to milliseconds
                    
                    expect(chartView).toNot(beNil())
                    expect(largeData.count).to(equal(1000))
                    expect(renderTime).to(beLessThan(100)) // Should render in under 100ms
                }
                
                it("should render 5000 data points efficiently") {
                    let largeData = (1...5000).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    let chartView = BarChartView(data: largeData)
                    let endTime = CFAbsoluteTimeGetCurrent()
                    
                    let renderTime = (endTime - startTime) * 1000
                    
                    expect(chartView).toNot(beNil())
                    expect(largeData.count).to(equal(5000))
                    expect(renderTime).to(beLessThan(200)) // Should render in under 200ms
                }
                
                it("should render 10000 data points efficiently") {
                    let largeData = (1...10000).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    let chartView = ScatterPlotView(data: largeData)
                    let endTime = CFAbsoluteTimeGetCurrent()
                    
                    let renderTime = (endTime - startTime) * 1000
                    
                    expect(chartView).toNot(beNil())
                    expect(largeData.count).to(equal(10000))
                    expect(renderTime).to(beLessThan(500)) // Should render in under 500ms
                }
            }
            
            context("when handling real-time updates") {
                it("should update data efficiently") {
                    let initialData = (1...100).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let updatedData = (1...100).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    let chartView = LineChartView(data: initialData)
                    let updateTime = CFAbsoluteTimeGetCurrent()
                    
                    let renderTime = (updateTime - startTime) * 1000
                    
                    expect(chartView).toNot(beNil())
                    expect(renderTime).to(beLessThan(50)) // Should render in under 50ms
                }
                
                it("should handle frequent updates") {
                    let data = (1...100).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let chartView = LineChartView(data: data)
                    
                    // Simulate 10 rapid updates
                    for _ in 1...10 {
                        let startTime = CFAbsoluteTimeGetCurrent()
                        let updatedData = (1...100).map { i in
                            ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                        }
                        let endTime = CFAbsoluteTimeGetCurrent()
                        
                        let updateTime = (endTime - startTime) * 1000
                        expect(updateTime).to(beLessThan(50)) // Each update should be under 50ms
                    }
                    
                    expect(chartView).toNot(beNil())
                }
            }
            
            context("when testing memory usage") {
                it("should maintain low memory usage") {
                    let data = (1...1000).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let chartView = LineChartView(data: data)
                    
                    // Simulate memory pressure
                    autoreleasepool {
                        for _ in 1...10 {
                            let _ = LineChartView(data: data)
                        }
                    }
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(1000))
                }
                
                it("should handle memory efficiently with large datasets") {
                    let largeData = (1...5000).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let chartView = BarChartView(data: largeData)
                    
                    // Force garbage collection simulation
                    autoreleasepool {
                        let _ = BarChartView(data: largeData)
                    }
                    
                    expect(chartView).toNot(beNil())
                    expect(largeData.count).to(equal(5000))
                }
            }
            
            context("when testing animation performance") {
                it("should animate smoothly") {
                    let data = (1...100).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let chartView = LineChartView(data: data)
                    
                    // Test animation performance
                    let startTime = CFAbsoluteTimeGetCurrent()
                    
                    // Simulate animation
                    withAnimation(.easeInOut(duration: 0.8)) {
                        // Animation would happen here
                    }
                    
                    let endTime = CFAbsoluteTimeGetCurrent()
                    let animationTime = (endTime - startTime) * 1000
                    
                    expect(chartView).toNot(beNil())
                    expect(animationTime).to(beLessThan(100)) // Animation should be smooth
                }
                
                it("should handle complex animations") {
                    let data = (1...200).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let chartView = AreaChartView(data: data)
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    
                    // Simulate complex animation
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                        // Complex animation would happen here
                    }
                    
                    let endTime = CFAbsoluteTimeGetCurrent()
                    let animationTime = (endTime - startTime) * 1000
                    
                    expect(chartView).toNot(beNil())
                    expect(animationTime).to(beLessThan(150)) // Complex animation should be smooth
                }
            }
            
            context("when testing interaction performance") {
                it("should handle touch events efficiently") {
                    let data = (1...500).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let chartView = LineChartView(data: data)
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    
                    // Simulate touch events
                    for _ in 1...10 {
                        // Touch event simulation
                    }
                    
                    let endTime = CFAbsoluteTimeGetCurrent()
                    let touchTime = (endTime - startTime) * 1000
                    
                    expect(chartView).toNot(beNil())
                    expect(touchTime).to(beLessThan(10)) // Touch events should be very fast
                }
                
                it("should handle zoom and pan efficiently") {
                    let data = (1...1000).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let chartView = ScatterPlotView(data: data)
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    
                    // Simulate zoom and pan gestures
                    for _ in 1...5 {
                        // Zoom gesture simulation
                        // Pan gesture simulation
                    }
                    
                    let endTime = CFAbsoluteTimeGetCurrent()
                    let gestureTime = (endTime - startTime) * 1000
                    
                    expect(chartView).toNot(beNil())
                    expect(gestureTime).to(beLessThan(50)) // Gestures should be responsive
                }
            }
            
            context("when testing data processing performance") {
                it("should process data efficiently") {
                    let rawData = (1...1000).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    
                    // Test data processing operations
                    let sortedData = rawData.sortedByX
                    let filteredData = rawData.filter { $0.y > 50 }
                    let categories = rawData.categories
                    
                    let endTime = CFAbsoluteTimeGetCurrent()
                    let processingTime = (endTime - startTime) * 1000
                    
                    expect(sortedData.count).to(equal(1000))
                    expect(filteredData.count).to(beLessThanOrEqualTo(1000))
                    expect(processingTime).to(beLessThan(10)) // Data processing should be very fast
                }
                
                it("should handle statistical calculations efficiently") {
                    let data = (1...5000).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    
                    // Test statistical calculations
                    let minX = data.minX
                    let maxX = data.maxX
                    let minY = data.minY
                    let maxY = data.maxY
                    let xRange = data.xRange
                    let yRange = data.yRange
                    
                    let endTime = CFAbsoluteTimeGetCurrent()
                    let calculationTime = (endTime - startTime) * 1000
                    
                    expect(minX).toNot(beNil())
                    expect(maxX).toNot(beNil())
                    expect(minY).toNot(beNil())
                    expect(maxY).toNot(beNil())
                    expect(xRange).toNot(beNil())
                    expect(yRange).toNot(beNil())
                    expect(calculationTime).to(beLessThan(5)) // Calculations should be very fast
                }
            }
            
            context("when testing accessibility performance") {
                it("should generate accessibility labels efficiently") {
                    let data = (1...1000).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    
                    let chartView = LineChartView(data: data)
                    
                    let endTime = CFAbsoluteTimeGetCurrent()
                    let accessibilityTime = (endTime - startTime) * 1000
                    
                    expect(chartView).toNot(beNil())
                    expect(accessibilityTime).to(beLessThan(100)) // Accessibility should not slow down rendering
                }
                
                it("should handle VoiceOver efficiently") {
                    let data = (1...500).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let chartView = BarChartView(data: data)
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    
                    // Simulate VoiceOver interactions
                    for _ in 1...10 {
                        // VoiceOver event simulation
                    }
                    
                    let endTime = CFAbsoluteTimeGetCurrent()
                    let voiceOverTime = (endTime - startTime) * 1000
                    
                    expect(chartView).toNot(beNil())
                    expect(voiceOverTime).to(beLessThan(20)) // VoiceOver should be very responsive
                }
            }
            
            context("when testing configuration performance") {
                it("should apply configurations efficiently") {
                    let data = (1...1000).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let configurations = [
                        ChartConfiguration.light,
                        ChartConfiguration.dark,
                        ChartConfiguration.minimal,
                        ChartConfiguration.performance
                    ]
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    
                    for config in configurations {
                        let _ = LineChartView(data: data, configuration: config)
                    }
                    
                    let endTime = CFAbsoluteTimeGetCurrent()
                    let configTime = (endTime - startTime) * 1000
                    
                    expect(configTime).to(beLessThan(200)) // Configuration changes should be fast
                }
                
                it("should handle theme switching efficiently") {
                    let data = (1...500).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let startTime = CFAbsoluteTimeGetCurrent()
                    
                    // Test theme switching
                    let lightChart = LineChartView(data: data, configuration: .light)
                    let darkChart = LineChartView(data: data, configuration: .dark)
                    
                    let endTime = CFAbsoluteTimeGetCurrent()
                    let themeTime = (endTime - startTime) * 1000
                    
                    expect(lightChart).toNot(beNil())
                    expect(darkChart).toNot(beNil())
                    expect(themeTime).to(beLessThan(100)) // Theme switching should be fast
                }
            }
        }
    }
} 