import CoreGraphics

/// Splits a rectangle into tiles whose areas are proportional to a list of values.
///
/// Uses the squarified algorithm (Bruls, Huizing and van Wijk, "Squarified Treemaps", 2000),
/// which lays out the largest values first and keeps the tiles as close to squares as it can,
/// so they are easy to compare and to label. ``TreemapChart`` draws its tiles with it.
public enum TreemapLayout {
    /// The tile for each value, in the order of `values`.
    ///
    /// Tiles cover `rect` without overlapping. Values that are zero, negative or not finite get
    /// an empty rectangle at the origin of `rect`, as does every value when `rect` is empty or
    /// not finite.
    public static func squarify(_ values: [Double], in rect: CGRect) -> [CGRect] {
        let emptyTile = CGRect(origin: rect.origin.isFinite ? rect.origin : .zero, size: .zero)
        var tiles = Array(repeating: emptyTile, count: values.count)
        let positive = values.indices.filter { values[$0].isFinite && values[$0] > 0 }
        let area = Double(rect.width) * Double(rect.height)
        guard
            let largest = positive.map({ values[$0] }).max(),
            rect.width > 0, rect.height > 0, area.isFinite, rect.origin.isFinite
        else { return tiles }

        // Dividing by the largest value first keeps the total finite for values near
        // Double.greatestFiniteMagnitude.
        let total = positive.reduce(0) { $0 + values[$1] / largest }
        let scale = area / total
        // Positive values, largest first, with their areas scaled to the rectangle.
        let items = positive
            .sorted { values[$0] > values[$1] }
            .map { (index: $0, area: values[$0] / largest * scale) }

        var remaining = rect
        var row: [(index: Int, area: Double)] = []
        for item in items {
            let side = Double(min(remaining.width, remaining.height))
            if row.isEmpty || worstAspectRatio(row + [item], side: side) <= worstAspectRatio(row, side: side) {
                row.append(item)
            } else {
                place(row, in: &remaining, tiles: &tiles)
                row = [item]
            }
        }
        place(row, in: &remaining, tiles: &tiles)
        return tiles
    }

    /// The largest width-to-height (or height-to-width) ratio in a row laid along `side`.
    static func worstAspectRatio(_ row: [(index: Int, area: Double)], side: Double) -> Double {
        let sum = row.reduce(0) { $0 + $1.area }
        guard sum > 0, side > 0, let largest = row.map(\.area).max(), let smallest = row.map(\.area).min() else {
            return .infinity
        }
        let sideSquared = side * side
        let sumSquared = sum * sum
        return max(sideSquared * largest / sumSquared, sumSquared / (sideSquared * smallest))
    }

    /// Lays `row` along the shorter side of `remaining` and removes the strip it fills.
    private static func place(_ row: [(index: Int, area: Double)], in remaining: inout CGRect, tiles: inout [CGRect]) {
        let sum = row.reduce(0) { $0 + $1.area }
        guard sum > 0 else { return }
        if remaining.width >= remaining.height {
            // A column on the left, filled from the top.
            let width = CGFloat(sum) / remaining.height
            var y = remaining.minY
            for item in row {
                let height = CGFloat(item.area) / width
                tiles[item.index] = CGRect(x: remaining.minX, y: y, width: width, height: height)
                y += height
            }
            remaining = CGRect(x: remaining.minX + width, y: remaining.minY,
                               width: max(remaining.width - width, 0), height: remaining.height)
        } else {
            // A row along the top, filled from the left.
            let height = CGFloat(sum) / remaining.width
            var x = remaining.minX
            for item in row {
                let width = CGFloat(item.area) / height
                tiles[item.index] = CGRect(x: x, y: remaining.minY, width: width, height: height)
                x += width
            }
            remaining = CGRect(x: remaining.minX, y: remaining.minY + height,
                               width: remaining.width, height: max(remaining.height - height, 0))
        }
    }
}

extension CGPoint {
    /// Whether both coordinates are finite.
    fileprivate var isFinite: Bool { x.isFinite && y.isFinite }
}
