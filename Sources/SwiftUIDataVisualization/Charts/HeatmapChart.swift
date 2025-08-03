import SwiftUI

/// A heatmap chart that displays data as a matrix of colored cells.
///
/// This chart type is perfect for showing data density and correlations.
/// It supports multiple color schemes, normalization, and interactive features.
///
/// - Example:
/// ```swift
/// HeatmapChart(data: matrixData)
///     .chartStyle(.heatmap)
///     .colorScale(.viridis)
/// ```
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct HeatmapChart: View {
    
    // MARK: - Properties
    
    /// Matrix data to display
    private let data: [[Double]]
    
    /// Chart configuration
    private let configuration: ChartConfiguration
    
    /// Chart dimensions
    @State private var chartSize: CGSize = .zero
    
    /// Animation progress
    @State private var animationProgress: Double = 0
    
    /// Selected cell
    @State private var selectedCell: (row: Int, col: Int)?
    
    /// Color scale type
    private let colorScale: ColorScaleType
    
    /// Row labels
    private let rowLabels: [String]?
    
    /// Column labels
    private let columnLabels: [String]?
    
    // MARK: - Initialization
    
    /// Creates a new heatmap chart with data and configuration.
    ///
    /// - Parameters:
    ///   - data: 2D array of data values
    ///   - configuration: Chart configuration options
    ///   - colorScale: Type of color scale to use
    ///   - rowLabels: Optional row labels
    ///   - columnLabels: Optional column labels
    public init(
        data: [[Double]],
        configuration: ChartConfiguration = ChartConfiguration(),
        colorScale: ColorScaleType = .viridis,
        rowLabels: [String]? = nil,
        columnLabels: [String]? = nil
    ) {
        self.data = data
        self.configuration = configuration
        self.colorScale = colorScale
        self.rowLabels = rowLabels
        self.columnLabels = columnLabels
    }
    
    /// Creates a new heatmap chart with data and style.
    ///
    /// - Parameters:
    ///   - data: 2D array of data values
    ///   - style: Chart style
    ///   - colorScale: Type of color scale to use
    public init(
        data: [[Double]],
        style: ChartStyle = .heatmap,
        colorScale: ColorScaleType = .viridis
    ) {
        self.data = data
        self.configuration = ChartConfiguration().withStyle(style)
        self.colorScale = colorScale
        self.rowLabels = nil
        self.columnLabels = nil
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                backgroundColor
                
                // Chart content
                chartContent
                    .frame(width: geometry.size.width, height: geometry.size.height)
                
                // Labels
                if let rowLabels = rowLabels {
                    rowLabelsView(labels: rowLabels)
                }
                if let columnLabels = columnLabels {
                    columnLabelsView(labels: columnLabels)
                }
                
                // Tooltip
                if configuration.tooltipEnabled && selectedCell != nil {
                    tooltipView
                }
            }
            .onAppear {
                chartSize = geometry.size
                startAnimation()
            }
            .onChange(of: geometry.size) { newSize in
                chartSize = newSize
            }
            .gesture(
                TapGesture()
                    .onEnded { _ in
                        handleTap()
                    }
            )
        }
        .background(configuration.backgroundColor)
        .border(configuration.borderColor, width: configuration.borderWidth)
        .cornerRadius(configuration.cornerRadius)
        .shadow(
            color: configuration.shadow.color,
            radius: configuration.shadow.radius,
            x: configuration.shadow.x,
            y: configuration.shadow.y
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(configuration.accessibility.label ?? "Heatmap Chart")
        .accessibilityHint(configuration.accessibility.hint ?? "Shows data density as colored cells")
        .accessibilityValue(configuration.accessibility.value ?? "\(data.count) rows, \(data.first?.count ?? 0) columns")
        .accessibilityAddTraits(configuration.accessibility.traits)
    }
    
    // MARK: - Chart Components
    
    /// Background view
    private var backgroundColor: some View {
        Rectangle()
            .fill(configuration.backgroundColor)
            .ignoresSafeArea()
    }
    
    /// Chart content view
    private var chartContent: some View {
        ZStack {
            // Heatmap cells
            ForEach(0..<data.count, id: \.self) { row in
                ForEach(0..<data[row].count, id: \.self) { col in
                    cellView(value: data[row][col], row: row, col: col)
                }
            }
        }
    }
    
    /// Individual cell view
    private func cellView(value: Double, row: Int, col: Int) -> some View {
        let cellRect = calculateCellRect(row: row, col: col)
        let color = getColorForValue(value)
        let isSelected = selectedCell?.row == row && selectedCell?.col == col
        
        return Rectangle()
            .fill(color)
            .frame(width: cellRect.width, height: cellRect.height)
            .position(cellRect.midX, cellRect.midY)
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: selectedCell)
            .onTapGesture {
                handleCellTap(row: row, col: col)
            }
    }
    
    /// Row labels view
    private func rowLabelsView(labels: [String]) -> some View {
        VStack(spacing: 0) {
            ForEach(0..<labels.count, id: \.self) { index in
                Text(labels[index])
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(height: calculateCellHeight())
                    .padding(.trailing, 8)
            }
        }
        .position(x: 50, y: chartSize.height / 2)
    }
    
    /// Column labels view
    private func columnLabelsView(labels: [String]) -> some View {
        HStack(spacing: 0) {
            ForEach(0..<labels.count, id: \.self) { index in
                Text(labels[index])
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(width: calculateCellWidth())
                    .rotationEffect(.degrees(-45))
                    .padding(.bottom, 8)
            }
        }
        .position(x: chartSize.width / 2, y: chartSize.height - 30)
    }
    
    /// Tooltip view
    private var tooltipView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let selectedCell = selectedCell {
                let value = data[selectedCell.row][selectedCell.col]
                Text("Value: \(String(format: "%.2f", value))")
                    .font(.caption)
                Text("Row: \(selectedCell.row)")
                    .font(.caption)
                Text("Column: \(selectedCell.col)")
                    .font(.caption)
                if let rowLabels = rowLabels, selectedCell.row < rowLabels.count {
                    Text("Row Label: \(rowLabels[selectedCell.row])")
                        .font(.caption)
                }
                if let columnLabels = columnLabels, selectedCell.col < columnLabels.count {
                    Text("Column Label: \(columnLabels[selectedCell.col])")
                        .font(.caption)
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(6)
        .shadow(radius: 2)
        .position(calculateTooltipPosition())
    }
    
    // MARK: - Calculation Methods
    
    /// Calculates cell rectangle for a specific row and column
    private func calculateCellRect(row: Int, col: Int) -> CGRect {
        let cellWidth = calculateCellWidth()
        let cellHeight = calculateCellHeight()
        
        let x = 60 + CGFloat(col) * cellWidth + cellWidth / 2
        let y = CGFloat(row) * cellHeight + cellHeight / 2
        
        return CGRect(x: x - cellWidth / 2, y: y - cellHeight / 2, width: cellWidth, height: cellHeight)
    }
    
    /// Calculates cell width
    private func calculateCellWidth() -> CGFloat {
        let maxCols = data.map { $0.count }.max() ?? 1
        return (chartSize.width - 120) / CGFloat(maxCols)
    }
    
    /// Calculates cell height
    private func calculateCellHeight() -> CGFloat {
        return (chartSize.height - 60) / CGFloat(data.count)
    }
    
    /// Gets color for a specific value
    private func getColorForValue(_ value: Double) -> Color {
        let minValue = data.flatMap { $0 }.min() ?? 0
        let maxValue = data.flatMap { $0 }.max() ?? 1
        let normalizedValue = (value - minValue) / (maxValue - minValue)
        
        switch colorScale {
        case .viridis:
            return Color(
                hue: 0.6 + normalizedValue * 0.4,
                saturation: 0.8,
                brightness: 0.8
            )
        case .plasma:
            return Color(
                hue: 0.1 + normalizedValue * 0.8,
                saturation: 0.9,
                brightness: 0.7
            )
        case .inferno:
            return Color(
                hue: 0.0 + normalizedValue * 0.6,
                saturation: 0.9,
                brightness: 0.6
            )
        case .magma:
            return Color(
                hue: 0.8 + normalizedValue * 0.2,
                saturation: 0.8,
                brightness: 0.7
            )
        case .cividis:
            return Color(
                hue: 0.5 + normalizedValue * 0.3,
                saturation: 0.7,
                brightness: 0.8
            )
        }
    }
    
    /// Calculates tooltip position
    private func calculateTooltipPosition() -> CGPoint {
        guard let selectedCell = selectedCell else { return .zero }
        let cellRect = calculateCellRect(row: selectedCell.row, col: selectedCell.col)
        return CGPoint(x: cellRect.midX, y: cellRect.minY - 30)
    }
    
    // MARK: - Interaction Methods
    
    /// Handles tap gesture
    private func handleTap() {
        // Implement tap logic
    }
    
    /// Handles cell tap
    private func handleCellTap(row: Int, col: Int) {
        if configuration.selectionEnabled {
            selectedCell = selectedCell?.row == row && selectedCell?.col == col ? nil : (row: row, col: col)
        }
    }
    
    // MARK: - Animation Methods
    
    /// Starts the animation
    private func startAnimation() {
        guard configuration.animationsEnabled else {
            animationProgress = 1.0
            return
        }
        
        withAnimation(configuration.animation ?? .easeInOut(duration: configuration.animationDuration)) {
            animationProgress = 1.0
        }
    }
}

// MARK: - Supporting Types

/// Color scale types for heatmaps
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum ColorScaleType {
    case viridis
    case plasma
    case inferno
    case magma
    case cividis
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct HeatmapChart_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData = [
            [1.0, 2.0, 3.0],
            [4.0, 5.0, 6.0],
            [7.0, 8.0, 9.0]
        ]
        
        HeatmapChart(
            data: sampleData,
            rowLabels: ["Row 1", "Row 2", "Row 3"],
            columnLabels: ["Col 1", "Col 2", "Col 3"]
        )
        .frame(width: 300, height: 300)
        .padding()
    }
} 