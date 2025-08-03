import XCTest
import Quick
import Nimble
@testable import DataVisualization

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
class ChartDataPointTests: QuickSpec {
    
    override func spec() {
        describe("ChartDataPoint") {
            
            context("when initialized with basic values") {
                it("should create a data point with correct values") {
                    let point = ChartDataPoint(x: 1.0, y: 25.0)
                    
                    expect(point.x).to(equal(1.0))
                    expect(point.y).to(equal(25.0))
                    expect(point.z).to(beNil())
                    expect(point.label).to(beNil())
                    expect(point.color).to(beNil())
                    expect(point.size).to(beNil())
                }
                
                it("should have unique ID") {
                    let point1 = ChartDataPoint(x: 1.0, y: 25.0)
                    let point2 = ChartDataPoint(x: 1.0, y: 25.0)
                    
                    expect(point1.id).toNot(equal(point2.id))
                }
            }
            
            context("when initialized with all parameters") {
                it("should create a data point with all values") {
                    let point = ChartDataPoint(
                        x: 1.0,
                        y: 25.0,
                        z: 10.0,
                        label: "Test Point",
                        color: .red,
                        size: 8.0,
                        metadata: ["key": "value"],
                        tooltip: "Custom tooltip",
                        timestamp: Date(),
                        category: "Test Category",
                        weight: 1.5
                    )
                    
                    expect(point.x).to(equal(1.0))
                    expect(point.y).to(equal(25.0))
                    expect(point.z).to(equal(10.0))
                    expect(point.label).to(equal("Test Point"))
                    expect(point.color).to(equal(.red))
                    expect(point.size).to(equal(8.0))
                    expect(point.metadata).to(equal(["key": "value"]))
                    expect(point.tooltip).to(equal("Custom tooltip"))
                    expect(point.category).to(equal("Test Category"))
                    expect(point.weight).to(equal(1.5))
                }
            }
            
            context("when using convenience initializers") {
                it("should create data point with x, y, and label") {
                    let point = ChartDataPoint(x: 1.0, y: 25.0, label: "Test")
                    
                    expect(point.x).to(equal(1.0))
                    expect(point.y).to(equal(25.0))
                    expect(point.label).to(equal("Test"))
                }
                
                it("should create data point with x, y, label, and color") {
                    let point = ChartDataPoint(x: 1.0, y: 25.0, label: "Test", color: .blue)
                    
                    expect(point.x).to(equal(1.0))
                    expect(point.y).to(equal(25.0))
                    expect(point.label).to(equal("Test"))
                    expect(point.color).to(equal(.blue))
                }
                
                it("should create 3D data point") {
                    let point = ChartDataPoint(x: 1.0, y: 25.0, z: 10.0, label: "3D Point")
                    
                    expect(point.x).to(equal(1.0))
                    expect(point.y).to(equal(25.0))
                    expect(point.z).to(equal(10.0))
                    expect(point.label).to(equal("3D Point"))
                }
            }
            
            context("computed properties") {
                it("should return effective color") {
                    let pointWithColor = ChartDataPoint(x: 1.0, y: 25.0, color: .red)
                    let pointWithoutColor = ChartDataPoint(x: 1.0, y: 25.0)
                    
                    expect(pointWithColor.effectiveColor).to(equal(.red))
                    expect(pointWithoutColor.effectiveColor).to(equal(.blue))
                }
                
                it("should return effective size") {
                    let pointWithSize = ChartDataPoint(x: 1.0, y: 25.0, size: 12.0)
                    let pointWithoutSize = ChartDataPoint(x: 1.0, y: 25.0)
                    
                    expect(pointWithSize.effectiveSize).to(equal(12.0))
                    expect(pointWithoutSize.effectiveSize).to(equal(8.0))
                }
                
                it("should return effective tooltip") {
                    let pointWithTooltip = ChartDataPoint(x: 1.0, y: 25.0, tooltip: "Custom tooltip")
                    let pointWithoutTooltip = ChartDataPoint(x: 1.0, y: 25.0, label: "Test")
                    
                    expect(pointWithTooltip.effectiveTooltip).to(equal("Custom tooltip"))
                    expect(pointWithoutTooltip.effectiveTooltip).to(contain("Test"))
                    expect(pointWithoutTooltip.effectiveTooltip).to(contain("X: 1.00"))
                    expect(pointWithoutTooltip.effectiveTooltip).to(contain("Y: 25.00"))
                }
                
                it("should detect 3D data points") {
                    let point3D = ChartDataPoint(x: 1.0, y: 25.0, z: 10.0)
                    let point2D = ChartDataPoint(x: 1.0, y: 25.0)
                    
                    expect(point3D.is3D).to(beTrue())
                    expect(point2D.is3D).to(beFalse())
                }
                
                it("should calculate magnitude") {
                    let point = ChartDataPoint(x: 3.0, y: 4.0)
                    
                    expect(point.magnitude).to(equal(5.0))
                }
            }
            
            context("mutating methods") {
                it("should update selection state") {
                    let originalPoint = ChartDataPoint(x: 1.0, y: 25.0)
                    let selectedPoint = originalPoint.withSelection(true)
                    let deselectedPoint = originalPoint.withSelection(false)
                    
                    expect(originalPoint.isSelected).to(beFalse())
                    expect(selectedPoint.isSelected).to(beTrue())
                    expect(deselectedPoint.isSelected).to(beFalse())
                }
                
                it("should update highlight state") {
                    let originalPoint = ChartDataPoint(x: 1.0, y: 25.0)
                    let highlightedPoint = originalPoint.withHighlight(true)
                    let unhighlightedPoint = originalPoint.withHighlight(false)
                    
                    expect(originalPoint.isHighlighted).to(beFalse())
                    expect(highlightedPoint.isHighlighted).to(beTrue())
                    expect(unhighlightedPoint.isHighlighted).to(beFalse())
                }
            }
            
            context("equality") {
                it("should be equal when all properties match") {
                    let point1 = ChartDataPoint(
                        id: UUID(uuidString: "12345678-1234-1234-1234-123456789012")!,
                        x: 1.0,
                        y: 25.0,
                        label: "Test"
                    )
                    let point2 = ChartDataPoint(
                        id: UUID(uuidString: "12345678-1234-1234-1234-123456789012")!,
                        x: 1.0,
                        y: 25.0,
                        label: "Test"
                    )
                    
                    expect(point1).to(equal(point2))
                }
                
                it("should not be equal when properties differ") {
                    let point1 = ChartDataPoint(x: 1.0, y: 25.0)
                    let point2 = ChartDataPoint(x: 2.0, y: 25.0)
                    
                    expect(point1).toNot(equal(point2))
                }
            }
            
            context("codable") {
                it("should encode and decode correctly") {
                    let originalPoint = ChartDataPoint(
                        x: 1.0,
                        y: 25.0,
                        z: 10.0,
                        label: "Test Point",
                        color: .red,
                        size: 8.0,
                        metadata: ["key": "value"],
                        tooltip: "Custom tooltip",
                        timestamp: Date(),
                        category: "Test Category",
                        weight: 1.5
                    )
                    
                    let encoder = JSONEncoder()
                    let decoder = JSONDecoder()
                    
                    do {
                        let data = try encoder.encode(originalPoint)
                        let decodedPoint = try decoder.decode(ChartDataPoint.self, from: data)
                        
                        expect(decodedPoint.x).to(equal(originalPoint.x))
                        expect(decodedPoint.y).to(equal(originalPoint.y))
                        expect(decodedPoint.z).to(equal(originalPoint.z))
                        expect(decodedPoint.label).to(equal(originalPoint.label))
                        expect(decodedPoint.size).to(equal(originalPoint.size))
                        expect(decodedPoint.metadata).to(equal(originalPoint.metadata))
                        expect(decodedPoint.tooltip).to(equal(originalPoint.tooltip))
                        expect(decodedPoint.category).to(equal(originalPoint.category))
                        expect(decodedPoint.weight).to(equal(originalPoint.weight))
                    } catch {
                        fail("Failed to encode/decode: \(error)")
                    }
                }
            }
        }
        
        describe("Array extensions") {
            context("when working with data arrays") {
                let testData = [
                    ChartDataPoint(x: 1.0, y: 10.0),
                    ChartDataPoint(x: 2.0, y: 25.0),
                    ChartDataPoint(x: 3.0, y: 15.0),
                    ChartDataPoint(x: 4.0, y: 30.0)
                ]
                
                it("should calculate min and max values") {
                    expect(testData.minX).to(equal(1.0))
                    expect(testData.maxX).to(equal(4.0))
                    expect(testData.minY).to(equal(10.0))
                    expect(testData.maxY).to(equal(30.0))
                }
                
                it("should calculate ranges") {
                    expect(testData.xRange).to(equal(1.0...4.0))
                    expect(testData.yRange).to(equal(10.0...30.0))
                }
                
                it("should sort data correctly") {
                    let sortedByX = testData.sortedByX
                    let sortedByY = testData.sortedByY
                    
                    expect(sortedByX.map { $0.x }).to(equal([1.0, 2.0, 3.0, 4.0]))
                    expect(sortedByY.map { $0.y }).to(equal([10.0, 15.0, 25.0, 30.0]))
                }
                
                it("should filter by category") {
                    let categorizedData = [
                        ChartDataPoint(x: 1.0, y: 10.0, category: "A"),
                        ChartDataPoint(x: 2.0, y: 25.0, category: "B"),
                        ChartDataPoint(x: 3.0, y: 15.0, category: "A"),
                        ChartDataPoint(x: 4.0, y: 30.0, category: "B")
                    ]
                    
                    let categoryA = categorizedData.filterByCategory("A")
                    let categoryB = categorizedData.filterByCategory("B")
                    
                    expect(categoryA.count).to(equal(2))
                    expect(categoryB.count).to(equal(2))
                    expect(categoryA.first?.category).to(equal("A"))
                    expect(categoryB.first?.category).to(equal("B"))
                }
                
                it("should extract unique categories") {
                    let categorizedData = [
                        ChartDataPoint(x: 1.0, y: 10.0, category: "A"),
                        ChartDataPoint(x: 2.0, y: 25.0, category: "B"),
                        ChartDataPoint(x: 3.0, y: 15.0, category: "A"),
                        ChartDataPoint(x: 4.0, y: 30.0, category: "C")
                    ]
                    
                    let categories = categorizedData.categories
                    
                    expect(categories).to(equal(["A", "B", "C"]))
                }
            }
        }
    }
} 