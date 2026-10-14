import CoreGraphics
import Testing
@testable import SwiftUIDataVisualization

@Suite("Treemap chart")
struct TreemapChartTests {
    private let size = CGSize(width: 200, height: 120)

    @Test func itemsAreIdentifiedByLabel() {
        #expect(TreemapItem("Photos", value: 4).id == "Photos")
    }

    @Test func everyUsableItemGetsATileInsideTheChart() {
        let items = [TreemapItem("Photos", value: 48), TreemapItem("Apps", value: 31), TreemapItem("Mail", value: 6)]
        let tiles = TreemapChart.tiles(for: items, in: size)
        #expect(tiles.map(\.item) == items)
        #expect(tiles.map(\.colorIndex) == [0, 1, 2])
        let bounds = CGRect(origin: .zero, size: size)
        #expect(tiles.allSatisfy { bounds.contains($0.rect) && !$0.rect.isEmpty })
    }

    @Test func largerValuesGetLargerTiles() {
        let items = [TreemapItem("A", value: 1), TreemapItem("B", value: 6), TreemapItem("C", value: 3)]
        let areas = TreemapChart.tiles(for: items, in: size).map { $0.rect.width * $0.rect.height }
        #expect(areas[1] > areas[2] && areas[2] > areas[0])
    }

    @Test func tilesLeaveAGapBetweenThem() {
        let items = (1...6).map { TreemapItem("\($0)", value: Double($0)) }
        let tiles = TreemapChart.tiles(for: items, in: size)
        for (index, tile) in tiles.enumerated() {
            for other in tiles[(index + 1)...] {
                #expect(!tile.rect.intersects(other.rect), "\(tile.item.label) overlaps \(other.item.label)")
            }
        }
    }

    @Test func unusableValuesGetNoTileButKeepTheColorsOfTheOthers() {
        let items = [
            TreemapItem("A", value: 4), TreemapItem("Zero", value: 0), TreemapItem("NaN", value: .nan),
            TreemapItem("Negative", value: -3), TreemapItem("D", value: 2),
        ]
        let tiles = TreemapChart.tiles(for: items, in: size)
        #expect(tiles.map(\.item.label) == ["A", "D"])
        #expect(tiles.map(\.colorIndex) == [0, 4])
    }

    @Test func onlyTilesLargeEnoughForTextAreLabelled() {
        let tiles = TreemapChart.tiles(for: [TreemapItem("Big", value: 1_000), TreemapItem("Tiny", value: 1)], in: size)
        #expect(tiles.map(\.isLabelled) == [true, false])
    }

    @Test(arguments: [CGSize.zero, CGSize(width: 200, height: 0), CGSize(width: 0, height: 50)])
    func chartsWithoutRoomDrawNoTiles(_ size: CGSize) {
        #expect(TreemapChart.tiles(for: [TreemapItem("A", value: 1)], in: size).isEmpty)
    }
}
