import SwiftUI

/// A labelled value in a treemap.
public struct TreemapItem: Identifiable, Hashable, Sendable {
    /// The label printed in the tile. Labels in one chart should be unique.
    public var label: String
    /// The size of the tile; values that are not positive and finite get no tile.
    public var value: Double

    /// The item label.
    public var id: String { label }

    /// Creates an item.
    public init(_ label: String, value: Double) {
        self.label = label
        self.value = value
    }
}

/// Rectangles whose areas are proportional to their values, such as disk usage by folder or
/// revenue by product.
///
/// ```swift
/// TreemapChart([
///     TreemapItem("Photos", value: 48),
///     TreemapItem("Apps", value: 31),
///     TreemapItem("Mail", value: 6),
/// ])
/// .frame(height: 240)
/// ```
///
/// Tiles are laid out with ``TreemapLayout`` (largest first, as close to square as possible)
/// and colored from the palette in the order of the items. Each tile prints its label and value
/// when it is large enough, and VoiceOver reads every tile as a separate element.
public struct TreemapChart: View {
    private let items: [TreemapItem]
    private let showsValues: Bool
    private let title: String

    @Environment(\.chartPalette) private var palette

    /// The smallest tile, in points, that prints its label.
    nonisolated static let minimumLabelledSize = CGSize(width: 44, height: 28)

    /// Creates a treemap.
    ///
    /// - Parameters:
    ///   - items: The values to draw.
    ///   - showsValues: Whether tiles print their value under the label.
    ///   - title: The chart's name for VoiceOver.
    public init(_ items: [TreemapItem], showsValues: Bool = true, title: String = "Treemap") {
        self.items = items
        self.showsValues = showsValues
        self.title = title
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .topLeading) {
                ForEach(Self.tiles(for: items, in: proxy.size), id: \.colorIndex) { tile in
                    self.tile(tile, color: palette.color(at: tile.colorIndex))
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
        .accessibilityChartDescriptor(AudioGraphDescriptor(
            title: title,
            categories: items.map(\.label),
            series: [.init(name: title, values: items.map(\.value))]
        ))
    }

    /// One drawn tile.
    struct Tile: Equatable {
        let item: TreemapItem
        /// The item's position among all items, which picks its palette color.
        let colorIndex: Int
        /// The tile's rectangle, inset by up to one point on each side to leave a gap.
        let rect: CGRect

        /// Whether the tile is large enough to print its label.
        var isLabelled: Bool {
            rect.width >= TreemapChart.minimumLabelledSize.width && rect.height >= TreemapChart.minimumLabelledSize.height
        }
    }

    /// The tiles for `items` in a chart of `size`, in the order of the items. Items whose value is
    /// not positive and finite get no tile but keep their color index, so the colors of the
    /// other items do not shift.
    nonisolated static func tiles(for items: [TreemapItem], in size: CGSize) -> [Tile] {
        let rects = TreemapLayout.squarify(items.map(\.value), in: CGRect(origin: .zero, size: size))
        return zip(items, rects).enumerated().compactMap { index, entry in
            let (item, rect) = entry
            guard !rect.isEmpty else { return nil }
            let inset = rect.insetBy(dx: min(1, rect.width / 4), dy: min(1, rect.height / 4))
            return Tile(item: item, colorIndex: index, rect: inset)
        }
    }

    private func tile(_ tile: Tile, color: Color) -> some View {
        let item = tile.item
        let inset = tile.rect
        let labelled = tile.isLabelled
        return RoundedRectangle(cornerRadius: min(4, inset.width / 4, inset.height / 4))
            .fill(color.gradient)
            .overlay(alignment: .topLeading) {
                if labelled {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(item.label).font(.caption.weight(.semibold))
                        if showsValues {
                            Text(item.value, format: .number.precision(.significantDigits(1...4))).font(.caption2)
                        }
                    }
                    .foregroundStyle(.white)
                    .padding(4)
                }
            }
            .frame(width: inset.width, height: inset.height)
            .offset(x: inset.minX, y: inset.minY)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(item.label)
            .accessibilityValue(item.value.formatted(.number.precision(.significantDigits(1...6))))
    }
}
