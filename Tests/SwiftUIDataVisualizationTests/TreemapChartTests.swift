import CoreGraphics
import Testing
@testable import SwiftUIDataVisualization

@Suite("Treemap chart")
struct TreemapChartTests {
    @Test func itemsAreIdentifiedByLabel() {
        #expect(TreemapItem("Photos", value: 4).id == "Photos")
    }
}
