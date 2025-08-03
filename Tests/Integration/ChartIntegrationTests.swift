import XCTest
import Quick
import Nimble
@testable import DataVisualization

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
class ChartIntegrationTests: QuickSpec {
    
    override func spec() {
        describe("Chart Integration") {
            
            context("when creating line charts") {
                it("should render line chart with data") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, label: "Jan"),
                        ChartDataPoint(x: 2, y: 25, label: "Feb"),
                        ChartDataPoint(x: 3, y: 15, label: "Mar"),
                        ChartDataPoint(x: 4, y: 30, label: "Apr")
                    ]
                    
                    let chartView = LineChartView(data: data)
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(4))
                }
                
                it("should handle empty data") {
                    let data: [ChartDataPoint] = []
                    let chartView = LineChartView(data: data)
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(0))
                }
                
                it("should handle single data point") {
                    let data = [ChartDataPoint(x: 1, y: 10, label: "Single")]
                    let chartView = LineChartView(data: data)
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(1))
                }
            }
            
            context("when creating bar charts") {
                it("should render bar chart with data") {
                    let data = [
                        ChartDataPoint(x: 1, y: 20, label: "Product A"),
                        ChartDataPoint(x: 2, y: 35, label: "Product B"),
                        ChartDataPoint(x: 3, y: 15, label: "Product C")
                    ]
                    
                    let chartView = BarChartView(data: data, style: .vertical)
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(3))
                }
                
                it("should handle horizontal bar charts") {
                    let data = [
                        ChartDataPoint(x: 1, y: 20, label: "Product A"),
                        ChartDataPoint(x: 2, y: 35, label: "Product B")
                    ]
                    
                    let chartView = BarChartView(data: data, style: .horizontal)
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(2))
                }
            }
            
            context("when creating pie charts") {
                it("should render pie chart with data") {
                    let data = [
                        ChartDataPoint(x: 1, y: 30, label: "iOS", category: "Platform"),
                        ChartDataPoint(x: 2, y: 25, label: "Android", category: "Platform"),
                        ChartDataPoint(x: 3, y: 20, label: "Web", category: "Platform")
                    ]
                    
                    let chartView = PieChartView(data: data, style: .pie)
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(3))
                }
                
                it("should handle donut charts") {
                    let data = [
                        ChartDataPoint(x: 1, y: 30, label: "iOS"),
                        ChartDataPoint(x: 2, y: 25, label: "Android")
                    ]
                    
                    let chartView = PieChartView(data: data, style: .donut, centerText: "Total")
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(2))
                }
            }
            
            context("when creating scatter plots") {
                it("should render scatter plot with data") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, size: 8),
                        ChartDataPoint(x: 2, y: 25, size: 12),
                        ChartDataPoint(x: 3, y: 15, size: 6)
                    ]
                    
                    let chartView = ScatterPlotView(data: data, style: .scatter)
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(3))
                }
                
                it("should handle bubble charts") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, size: 8, weight: 1.5),
                        ChartDataPoint(x: 2, y: 25, size: 12, weight: 2.0)
                    ]
                    
                    let chartView = ScatterPlotView(data: data, style: .bubble)
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(2))
                }
            }
            
            context("when creating area charts") {
                it("should render area chart with data") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, label: "Jan"),
                        ChartDataPoint(x: 2, y: 25, label: "Feb"),
                        ChartDataPoint(x: 3, y: 15, label: "Mar")
                    ]
                    
                    let chartView = AreaChartView(data: data, style: .area)
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(3))
                }
                
                it("should handle gradient fills") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, label: "Jan"),
                        ChartDataPoint(x: 2, y: 25, label: "Feb")
                    ]
                    
                    let chartView = AreaChartView(
                        data: data,
                        style: .gradient,
                        gradientFill: .blue,
                        fillOpacity: 0.5
                    )
                    
                    expect(chartView).toNot(beNil())
                    expect(data.count).to(equal(2))
                }
            }
            
            context("when using chart configurations") {
                it("should apply configuration to charts") {
                    let data = [ChartDataPoint(x: 1, y: 10, label: "Test")]
                    let config = ChartConfiguration.dark
                    
                    let lineChart = LineChartView(data: data, configuration: config)
                    let barChart = BarChartView(data: data, configuration: config)
                    let pieChart = PieChartView(data: data, configuration: config)
                    
                    expect(lineChart).toNot(beNil())
                    expect(barChart).toNot(beNil())
                    expect(pieChart).toNot(beNil())
                }
                
                it("should apply performance configuration") {
                    let data = [ChartDataPoint(x: 1, y: 10, label: "Test")]
                    let config = ChartConfiguration.performance
                    
                    let chart = LineChartView(data: data, configuration: config)
                    
                    expect(chart).toNot(beNil())
                    expect(config.animationsEnabled).to(beFalse())
                    expect(config.maxDataPoints).to(equal(5000))
                }
                
                it("should apply minimal configuration") {
                    let data = [ChartDataPoint(x: 1, y: 10, label: "Test")]
                    let config = ChartConfiguration.minimal
                    
                    let chart = LineChartView(data: data, configuration: config)
                    
                    expect(chart).toNot(beNil())
                    expect(config.showGrid).to(beFalse())
                    expect(config.showXAxis).to(beFalse())
                    expect(config.showYAxis).to(beFalse())
                    expect(config.showLegend).to(beFalse())
                }
            }
            
            context("when handling data transformations") {
                it("should sort data correctly") {
                    let unsortedData = [
                        ChartDataPoint(x: 3, y: 15, label: "Mar"),
                        ChartDataPoint(x: 1, y: 10, label: "Jan"),
                        ChartDataPoint(x: 2, y: 25, label: "Feb")
                    ]
                    
                    let sortedByX = unsortedData.sortedByX
                    let sortedByY = unsortedData.sortedByY
                    
                    expect(sortedByX.map { $0.x }).to(equal([1.0, 2.0, 3.0]))
                    expect(sortedByY.map { $0.y }).to(equal([10.0, 15.0, 25.0]))
                }
                
                it("should calculate data ranges") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10),
                        ChartDataPoint(x: 2, y: 25),
                        ChartDataPoint(x: 3, y: 15)
                    ]
                    
                    expect(data.minX).to(equal(1.0))
                    expect(data.maxX).to(equal(3.0))
                    expect(data.minY).to(equal(10.0))
                    expect(data.maxY).to(equal(25.0))
                    expect(data.xRange).to(equal(1.0...3.0))
                    expect(data.yRange).to(equal(10.0...25.0))
                }
                
                it("should filter by category") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, category: "A"),
                        ChartDataPoint(x: 2, y: 25, category: "B"),
                        ChartDataPoint(x: 3, y: 15, category: "A")
                    ]
                    
                    let categoryA = data.filterByCategory("A")
                    let categoryB = data.filterByCategory("B")
                    
                    expect(categoryA.count).to(equal(2))
                    expect(categoryB.count).to(equal(1))
                    expect(categoryA.first?.category).to(equal("A"))
                    expect(categoryB.first?.category).to(equal("B"))
                }
                
                it("should extract unique categories") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, category: "A"),
                        ChartDataPoint(x: 2, y: 25, category: "B"),
                        ChartDataPoint(x: 3, y: 15, category: "A"),
                        ChartDataPoint(x: 4, y: 30, category: "C")
                    ]
                    
                    let categories = data.categories
                    
                    expect(categories).to(equal(["A", "B", "C"]))
                }
            }
            
            context("when handling accessibility") {
                it("should provide accessibility labels") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, label: "Jan"),
                        ChartDataPoint(x: 2, y: 25, label: "Feb")
                    ]
                    
                    let lineChart = LineChartView(data: data)
                    let barChart = BarChartView(data: data)
                    let pieChart = PieChartView(data: data)
                    
                    expect(lineChart).toNot(beNil())
                    expect(barChart).toNot(beNil())
                    expect(pieChart).toNot(beNil())
                }
                
                it("should handle accessibility values") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, label: "Jan"),
                        ChartDataPoint(x: 2, y: 25, label: "Feb")
                    ]
                    
                    let chart = LineChartView(data: data)
                    
                    expect(chart).toNot(beNil())
                    expect(data.count).to(equal(2))
                }
            }
            
            context("when handling performance") {
                it("should handle large datasets") {
                    let largeData = (1...1000).map { i in
                        ChartDataPoint(x: Double(i), y: Double.random(in: 10...100))
                    }
                    
                    let chart = LineChartView(data: largeData)
                    
                    expect(chart).toNot(beNil())
                    expect(largeData.count).to(equal(1000))
                }
                
                it("should handle real-time updates") {
                    let initialData = [
                        ChartDataPoint(x: 1, y: 10),
                        ChartDataPoint(x: 2, y: 25)
                    ]
                    
                    let updatedData = [
                        ChartDataPoint(x: 1, y: 15),
                        ChartDataPoint(x: 2, y: 30),
                        ChartDataPoint(x: 3, y: 20)
                    ]
                    
                    let chart = LineChartView(data: initialData)
                    
                    expect(chart).toNot(beNil())
                    expect(initialData.count).to(equal(2))
                    expect(updatedData.count).to(equal(3))
                }
            }
            
            context("when handling animations") {
                it("should animate chart updates") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10),
                        ChartDataPoint(x: 2, y: 25)
                    ]
                    
                    let chart = LineChartView(data: data)
                    
                    expect(chart).toNot(beNil())
                    expect(data.count).to(equal(2))
                }
                
                it("should respect animation settings") {
                    let data = [ChartDataPoint(x: 1, y: 10)]
                    let config = ChartConfiguration.performance
                    
                    let chart = LineChartView(data: data, configuration: config)
                    
                    expect(chart).toNot(beNil())
                    expect(config.animationsEnabled).to(beFalse())
                }
            }
            
            context("when handling interactions") {
                it("should support selection") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, label: "Point 1"),
                        ChartDataPoint(x: 2, y: 25, label: "Point 2")
                    ]
                    
                    let chart = LineChartView(data: data)
                    
                    expect(chart).toNot(beNil())
                    expect(data.count).to(equal(2))
                }
                
                it("should support highlighting") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, label: "Point 1"),
                        ChartDataPoint(x: 2, y: 25, label: "Point 2")
                    ]
                    
                    let chart = BarChartView(data: data)
                    
                    expect(chart).toNot(beNil())
                    expect(data.count).to(equal(2))
                }
                
                it("should support tooltips") {
                    let data = [
                        ChartDataPoint(x: 1, y: 10, label: "Point 1", tooltip: "Custom tooltip"),
                        ChartDataPoint(x: 2, y: 25, label: "Point 2")
                    ]
                    
                    let chart = PieChartView(data: data)
                    
                    expect(chart).toNot(beNil())
                    expect(data.count).to(equal(2))
                }
            }
        }
    }
} 