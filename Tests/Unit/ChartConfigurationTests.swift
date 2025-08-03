import XCTest
import Quick
import Nimble
@testable import DataVisualization

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
class ChartConfigurationTests: QuickSpec {
    
    override func spec() {
        describe("ChartConfiguration") {
            
            context("when initialized with default values") {
                it("should create configuration with correct defaults") {
                    let config = ChartConfiguration()
                    
                    expect(config.theme).to(equal(.light))
                    expect(config.colorPalette.count).to(equal(8))
                    expect(config.backgroundColor).to(equal(.clear))
                    expect(config.borderColor).to(equal(.gray.opacity(0.3)))
                    expect(config.borderWidth).to(equal(1.0))
                    expect(config.showGrid).to(beTrue())
                    expect(config.gridColor).to(equal(.gray.opacity(0.2)))
                    expect(config.gridWidth).to(equal(1.0))
                    expect(config.gridStyle).to(equal(.solid))
                    expect(config.showXAxis).to(beTrue())
                    expect(config.showYAxis).to(beTrue())
                    expect(config.axisColor).to(equal(.gray))
                    expect(config.axisWidth).to(equal(1.0))
                    expect(config.axisLabelFont).to(equal(.caption))
                    expect(config.axisLabelColor).to(equal(.primary))
                    expect(config.showLegend).to(beTrue())
                    expect(config.legendPosition).to(equal(.bottom))
                    expect(config.legendFont).to(equal(.caption))
                    expect(config.legendTextColor).to(equal(.primary))
                    expect(config.animationsEnabled).to(beTrue())
                    expect(config.updateAnimationDuration).to(equal(0.3))
                    expect(config.entranceAnimationDuration).to(equal(0.8))
                    expect(config.zoomEnabled).to(beTrue())
                    expect(config.panEnabled).to(beTrue())
                    expect(config.tooltipsEnabled).to(beTrue())
                    expect(config.selectionEnabled).to(beTrue())
                    expect(config.highlightingEnabled).to(beTrue())
                    expect(config.maxDataPoints).to(equal(10000))
                    expect(config.useLazyLoading).to(beTrue())
                    expect(config.memoryLimit).to(equal(150))
                    expect(config.gpuAcceleration).to(beTrue())
                    expect(config.voiceOverEnabled).to(beTrue())
                    expect(config.dynamicTypeEnabled).to(beTrue())
                    expect(config.highContrastEnabled).to(beTrue())
                    expect(config.respectReducedMotion).to(beTrue())
                }
            }
            
            context("when initialized with custom values") {
                it("should create configuration with custom values") {
                    let customConfig = ChartConfiguration(
                        theme: .dark,
                        colorPalette: [.red, .blue, .green],
                        backgroundColor: .black,
                        borderColor: .white,
                        borderWidth: 2.0,
                        showGrid: false,
                        gridColor: .red,
                        gridWidth: 3.0,
                        gridStyle: .dashed,
                        showXAxis: false,
                        showYAxis: false,
                        axisColor: .blue,
                        axisWidth: 4.0,
                        axisLabelFont: .title,
                        axisLabelColor: .yellow,
                        showLegend: false,
                        legendPosition: .top,
                        legendFont: .headline,
                        legendTextColor: .orange,
                        animation: .easeInOut(duration: 1.0),
                        animationsEnabled: false,
                        updateAnimationDuration: 0.5,
                        entranceAnimationDuration: 1.5,
                        zoomEnabled: false,
                        panEnabled: false,
                        tooltipsEnabled: false,
                        selectionEnabled: false,
                        highlightingEnabled: false,
                        maxDataPoints: 5000,
                        useLazyLoading: false,
                        memoryLimit: 100,
                        gpuAcceleration: false,
                        voiceOverEnabled: false,
                        dynamicTypeEnabled: false,
                        highContrastEnabled: false,
                        respectReducedMotion: false
                    )
                    
                    expect(customConfig.theme).to(equal(.dark))
                    expect(customConfig.colorPalette.count).to(equal(3))
                    expect(customConfig.backgroundColor).to(equal(.black))
                    expect(customConfig.borderColor).to(equal(.white))
                    expect(customConfig.borderWidth).to(equal(2.0))
                    expect(customConfig.showGrid).to(beFalse())
                    expect(customConfig.gridColor).to(equal(.red))
                    expect(customConfig.gridWidth).to(equal(3.0))
                    expect(customConfig.gridStyle).to(equal(.dashed))
                    expect(customConfig.showXAxis).to(beFalse())
                    expect(customConfig.showYAxis).to(beFalse())
                    expect(customConfig.axisColor).to(equal(.blue))
                    expect(customConfig.axisWidth).to(equal(4.0))
                    expect(customConfig.axisLabelFont).to(equal(.title))
                    expect(customConfig.axisLabelColor).to(equal(.yellow))
                    expect(customConfig.showLegend).to(beFalse())
                    expect(customConfig.legendPosition).to(equal(.top))
                    expect(customConfig.legendFont).to(equal(.headline))
                    expect(customConfig.legendTextColor).to(equal(.orange))
                    expect(customConfig.animationsEnabled).to(beFalse())
                    expect(customConfig.updateAnimationDuration).to(equal(0.5))
                    expect(customConfig.entranceAnimationDuration).to(equal(1.5))
                    expect(customConfig.zoomEnabled).to(beFalse())
                    expect(customConfig.panEnabled).to(beFalse())
                    expect(customConfig.tooltipsEnabled).to(beFalse())
                    expect(customConfig.selectionEnabled).to(beFalse())
                    expect(customConfig.highlightingEnabled).to(beFalse())
                    expect(customConfig.maxDataPoints).to(equal(5000))
                    expect(customConfig.useLazyLoading).to(beFalse())
                    expect(customConfig.memoryLimit).to(equal(100))
                    expect(customConfig.gpuAcceleration).to(beFalse())
                    expect(customConfig.voiceOverEnabled).to(beFalse())
                    expect(customConfig.dynamicTypeEnabled).to(beFalse())
                    expect(customConfig.highContrastEnabled).to(beFalse())
                    expect(customConfig.respectReducedMotion).to(beFalse())
                }
            }
            
            context("convenience initializers") {
                it("should create dark theme configuration") {
                    let darkConfig = ChartConfiguration.dark
                    
                    expect(darkConfig.theme).to(equal(.dark))
                    expect(darkConfig.backgroundColor).to(equal(Color(.systemGray6)))
                    expect(darkConfig.borderColor).to(equal(.gray.opacity(0.5)))
                    expect(darkConfig.gridColor).to(equal(.gray.opacity(0.3)))
                    expect(darkConfig.axisColor).to(equal(.gray))
                    expect(darkConfig.axisLabelColor).to(equal(.white))
                    expect(darkConfig.legendTextColor).to(equal(.white))
                }
                
                it("should create light theme configuration") {
                    let lightConfig = ChartConfiguration.light
                    
                    expect(lightConfig.theme).to(equal(.light))
                    expect(lightConfig.backgroundColor).to(equal(.white))
                    expect(lightConfig.borderColor).to(equal(.gray.opacity(0.3)))
                    expect(lightConfig.gridColor).to(equal(.gray.opacity(0.2)))
                    expect(lightConfig.axisColor).to(equal(.gray))
                    expect(lightConfig.axisLabelColor).to(equal(.black))
                    expect(lightConfig.legendTextColor).to(equal(.black))
                }
                
                it("should create minimal configuration") {
                    let minimalConfig = ChartConfiguration.minimal
                    
                    expect(minimalConfig.showGrid).to(beFalse())
                    expect(minimalConfig.showXAxis).to(beFalse())
                    expect(minimalConfig.showYAxis).to(beFalse())
                    expect(minimalConfig.showLegend).to(beFalse())
                }
                
                it("should create performance configuration") {
                    let performanceConfig = ChartConfiguration.performance
                    
                    expect(performanceConfig.animationsEnabled).to(beFalse())
                    expect(performanceConfig.maxDataPoints).to(equal(5000))
                    expect(performanceConfig.useLazyLoading).to(beTrue())
                    expect(performanceConfig.memoryLimit).to(equal(100))
                    expect(performanceConfig.gpuAcceleration).to(beTrue())
                }
            }
            
            context("mutating methods") {
                it("should update theme") {
                    let originalConfig = ChartConfiguration()
                    let updatedConfig = originalConfig.withTheme(.dark)
                    
                    expect(originalConfig.theme).to(equal(.light))
                    expect(updatedConfig.theme).to(equal(.dark))
                }
                
                it("should update color palette") {
                    let originalConfig = ChartConfiguration()
                    let newPalette = [.red, .blue, .green]
                    let updatedConfig = originalConfig.withColorPalette(newPalette)
                    
                    expect(originalConfig.colorPalette.count).to(equal(8))
                    expect(updatedConfig.colorPalette).to(equal(newPalette))
                }
                
                it("should update animation") {
                    let originalConfig = ChartConfiguration()
                    let newAnimation = Animation.easeInOut(duration: 1.0)
                    let updatedConfig = originalConfig.withAnimation(newAnimation)
                    
                    expect(updatedConfig.animation).to(equal(newAnimation))
                }
                
                it("should disable animations") {
                    let originalConfig = ChartConfiguration()
                    let updatedConfig = originalConfig.withoutAnimations()
                    
                    expect(originalConfig.animationsEnabled).to(beTrue())
                    expect(updatedConfig.animationsEnabled).to(beFalse())
                }
                
                it("should disable interactions") {
                    let originalConfig = ChartConfiguration()
                    let updatedConfig = originalConfig.withoutInteractions()
                    
                    expect(originalConfig.zoomEnabled).to(beTrue())
                    expect(originalConfig.panEnabled).to(beTrue())
                    expect(originalConfig.tooltipsEnabled).to(beTrue())
                    expect(originalConfig.selectionEnabled).to(beTrue())
                    expect(originalConfig.highlightingEnabled).to(beTrue())
                    
                    expect(updatedConfig.zoomEnabled).to(beFalse())
                    expect(updatedConfig.panEnabled).to(beFalse())
                    expect(updatedConfig.tooltipsEnabled).to(beFalse())
                    expect(updatedConfig.selectionEnabled).to(beFalse())
                    expect(updatedConfig.highlightingEnabled).to(beFalse())
                }
            }
            
            context("equality") {
                it("should be equal when all properties match") {
                    let config1 = ChartConfiguration()
                    let config2 = ChartConfiguration()
                    
                    expect(config1).to(equal(config2))
                }
                
                it("should not be equal when properties differ") {
                    let config1 = ChartConfiguration()
                    let config2 = ChartConfiguration(theme: .dark)
                    
                    expect(config1).toNot(equal(config2))
                }
            }
            
            context("codable") {
                it("should encode and decode correctly") {
                    let originalConfig = ChartConfiguration(
                        theme: .dark,
                        colorPalette: [.red, .blue, .green],
                        backgroundColor: .black,
                        borderColor: .white,
                        borderWidth: 2.0,
                        showGrid: false,
                        gridColor: .red,
                        gridWidth: 3.0,
                        gridStyle: .dashed,
                        showXAxis: false,
                        showYAxis: false,
                        axisColor: .blue,
                        axisWidth: 4.0,
                        axisLabelFont: .title,
                        axisLabelColor: .yellow,
                        showLegend: false,
                        legendPosition: .top,
                        legendFont: .headline,
                        legendTextColor: .orange,
                        animation: .easeInOut(duration: 1.0),
                        animationsEnabled: false,
                        updateAnimationDuration: 0.5,
                        entranceAnimationDuration: 1.5,
                        zoomEnabled: false,
                        panEnabled: false,
                        tooltipsEnabled: false,
                        selectionEnabled: false,
                        highlightingEnabled: false,
                        maxDataPoints: 5000,
                        useLazyLoading: false,
                        memoryLimit: 100,
                        gpuAcceleration: false,
                        voiceOverEnabled: false,
                        dynamicTypeEnabled: false,
                        highContrastEnabled: false,
                        respectReducedMotion: false
                    )
                    
                    let encoder = JSONEncoder()
                    let decoder = JSONDecoder()
                    
                    do {
                        let data = try encoder.encode(originalConfig)
                        let decodedConfig = try decoder.decode(ChartConfiguration.self, from: data)
                        
                        expect(decodedConfig.theme).to(equal(originalConfig.theme))
                        expect(decodedConfig.backgroundColor).to(equal(originalConfig.backgroundColor))
                        expect(decodedConfig.borderColor).to(equal(originalConfig.borderColor))
                        expect(decodedConfig.borderWidth).to(equal(originalConfig.borderWidth))
                        expect(decodedConfig.showGrid).to(equal(originalConfig.showGrid))
                        expect(decodedConfig.gridColor).to(equal(originalConfig.gridColor))
                        expect(decodedConfig.gridWidth).to(equal(originalConfig.gridWidth))
                        expect(decodedConfig.gridStyle).to(equal(originalConfig.gridStyle))
                        expect(decodedConfig.showXAxis).to(equal(originalConfig.showXAxis))
                        expect(decodedConfig.showYAxis).to(equal(originalConfig.showYAxis))
                        expect(decodedConfig.axisColor).to(equal(originalConfig.axisColor))
                        expect(decodedConfig.axisWidth).to(equal(originalConfig.axisWidth))
                        expect(decodedConfig.axisLabelColor).to(equal(originalConfig.axisLabelColor))
                        expect(decodedConfig.showLegend).to(equal(originalConfig.showLegend))
                        expect(decodedConfig.legendPosition).to(equal(originalConfig.legendPosition))
                        expect(decodedConfig.legendTextColor).to(equal(originalConfig.legendTextColor))
                        expect(decodedConfig.animationsEnabled).to(equal(originalConfig.animationsEnabled))
                        expect(decodedConfig.updateAnimationDuration).to(equal(originalConfig.updateAnimationDuration))
                        expect(decodedConfig.entranceAnimationDuration).to(equal(originalConfig.entranceAnimationDuration))
                        expect(decodedConfig.zoomEnabled).to(equal(originalConfig.zoomEnabled))
                        expect(decodedConfig.panEnabled).to(equal(originalConfig.panEnabled))
                        expect(decodedConfig.tooltipsEnabled).to(equal(originalConfig.tooltipsEnabled))
                        expect(decodedConfig.selectionEnabled).to(equal(originalConfig.selectionEnabled))
                        expect(decodedConfig.highlightingEnabled).to(equal(originalConfig.highlightingEnabled))
                        expect(decodedConfig.maxDataPoints).to(equal(originalConfig.maxDataPoints))
                        expect(decodedConfig.useLazyLoading).to(equal(originalConfig.useLazyLoading))
                        expect(decodedConfig.memoryLimit).to(equal(originalConfig.memoryLimit))
                        expect(decodedConfig.gpuAcceleration).to(equal(originalConfig.gpuAcceleration))
                        expect(decodedConfig.voiceOverEnabled).to(equal(originalConfig.voiceOverEnabled))
                        expect(decodedConfig.dynamicTypeEnabled).to(equal(originalConfig.dynamicTypeEnabled))
                        expect(decodedConfig.highContrastEnabled).to(equal(originalConfig.highContrastEnabled))
                        expect(decodedConfig.respectReducedMotion).to(equal(originalConfig.respectReducedMotion))
                    } catch {
                        fail("Failed to encode/decode: \(error)")
                    }
                }
            }
        }
        
        describe("Supporting Types") {
            context("ChartTheme") {
                it("should have all cases") {
                    expect(ChartTheme.allCases.count).to(equal(3))
                    expect(ChartTheme.allCases).to(contain(.light))
                    expect(ChartTheme.allCases).to(contain(.dark))
                    expect(ChartTheme.allCases).to(contain(.custom))
                }
            }
            
            context("GridStyle") {
                it("should have all cases") {
                    expect(GridStyle.allCases.count).to(equal(3))
                    expect(GridStyle.allCases).to(contain(.solid))
                    expect(GridStyle.allCases).to(contain(.dashed))
                    expect(GridStyle.allCases).to(contain(.dotted))
                }
            }
            
            context("LegendPosition") {
                it("should have all cases") {
                    expect(LegendPosition.allCases.count).to(equal(5))
                    expect(LegendPosition.allCases).to(contain(.top))
                    expect(LegendPosition.allCases).to(contain(.bottom))
                    expect(LegendPosition.allCases).to(contain(.left))
                    expect(LegendPosition.allCases).to(contain(.right))
                    expect(LegendPosition.allCases).to(contain(.none))
                }
            }
        }
    }
} 