import CoreGraphics
import Testing
@testable import SwiftUIDataVisualization

@Suite("Treemap layout")
struct TreemapLayoutTests {
    private let tolerance: CGFloat = 1e-9

    private func area(_ rect: CGRect) -> CGFloat { rect.width * rect.height }

    // The worked example from Bruls et al.: values 6, 6, 4, 3, 2, 2, 1 in a 6 × 4 rectangle.
    @Test func reproducesThePaperExample() {
        let tiles = TreemapLayout.squarify([6, 6, 4, 3, 2, 2, 1], in: CGRect(x: 0, y: 0, width: 6, height: 4))
        // The two sixes form the first column, 3 wide and 2 high each.
        #expect(tiles[0] == CGRect(x: 0, y: 0, width: 3, height: 2))
        #expect(tiles[1] == CGRect(x: 0, y: 2, width: 3, height: 2))
        // Then 4 and 3 share a row across the top of the remaining 3 × 4.
        #expect(abs(tiles[2].height - 7.0 / 3.0) < tolerance)
        #expect(abs(tiles[2].minY) < tolerance)
        #expect(abs(tiles[3].minX - tiles[2].maxX) < tolerance)
    }

    @Test func tileAreasAreProportionalToTheValues() {
        let values: [Double] = [50, 20, 15, 10, 4, 1]
        let rect = CGRect(x: 10, y: 20, width: 300, height: 200)
        let tiles = TreemapLayout.squarify(values, in: rect)
        let total = values.reduce(0, +)
        for (value, tile) in zip(values, tiles) {
            let expected = CGFloat(value / total) * area(rect)
            #expect(abs(area(tile) - expected) < 1e-6)
        }
    }

    @Test func tilesStayInsideAndDoNotOverlap() {
        let values = (1...40).map { Double(($0 * 37) % 23 + 1) }
        let rect = CGRect(x: 0, y: 0, width: 390, height: 260)
        let tiles = TreemapLayout.squarify(values, in: rect)
        let bounds = rect.insetBy(dx: -1e-6, dy: -1e-6)
        for (offset, tile) in tiles.enumerated() {
            #expect(bounds.contains(tile))
            for other in tiles[(offset + 1)...] {
                let overlap = tile.intersection(other)
                #expect(overlap.isNull || area(overlap) < 1e-6)
            }
        }
        #expect(abs(tiles.map(area).reduce(0, +) - area(rect)) < 1e-6)
    }

    @Test func tilesAreReasonablySquare() {
        let values = (1...12).map(Double.init)
        let tiles = TreemapLayout.squarify(values, in: CGRect(x: 0, y: 0, width: 400, height: 300))
        let worst = tiles.map { max($0.width / $0.height, $0.height / $0.width) }.max() ?? .infinity
        // Slicing the rectangle into 12 strips instead would give a ratio of 49 for the smallest.
        #expect(worst < 4)
    }

    @Test func invalidValuesGetEmptyTiles() {
        let rect = CGRect(x: 5, y: 5, width: 100, height: 100)
        let tiles = TreemapLayout.squarify([0, 10, -3, .nan, 30], in: rect)
        let empty = CGRect(x: 5, y: 5, width: 0, height: 0)
        #expect(tiles[0] == empty)
        #expect(tiles[2] == empty)
        #expect(tiles[3] == empty)
        #expect(abs(area(tiles[1]) + area(tiles[4]) - area(rect)) < 1e-6)
    }

    @Test func emptyRectOrNoPositiveValue() {
        #expect(TreemapLayout.squarify([1, 2], in: .zero) == [.zero, .zero])
        #expect(TreemapLayout.squarify([0, 0], in: CGRect(x: 0, y: 0, width: 10, height: 10)).allSatisfy { $0.isEmpty })
        #expect(TreemapLayout.squarify([], in: CGRect(x: 0, y: 0, width: 10, height: 10)).isEmpty)
    }
}
