// ComparisonTable.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Comparison Data Models

/// Represents a row in the comparison table
public struct ComparisonRow: Identifiable {
    public let id: UUID
    public let feature: String
    public let values: [ComparisonValue]
    public let category: String?
    
    public init(
        id: UUID = UUID(),
        feature: String,
        values: [ComparisonValue],
        category: String? = nil
    ) {
        self.id = id
        self.feature = feature
        self.values = values
        self.category = category
    }
}

/// Represents a value in comparison (can be text, boolean, or rating)
public enum ComparisonValue {
    case text(String)
    case boolean(Bool)
    case rating(Int, maxRating: Int)
    case price(Double, currency: String)
    case icon(String, color: Color)
    case custom(AnyView)
    
    public static func text(_ value: String) -> ComparisonValue {
        .text(value)
    }
    
    public static func check(_ value: Bool) -> ComparisonValue {
        .boolean(value)
    }
    
    public static func stars(_ value: Int, of max: Int = 5) -> ComparisonValue {
        .rating(value, maxRating: max)
    }
    
    public static func price(_ value: Double, currency: String = "$") -> ComparisonValue {
        .price(value, currency: currency)
    }
}

/// Represents a column (item being compared)
public struct ComparisonColumn: Identifiable {
    public let id: UUID
    public let title: String
    public let subtitle: String?
    public let icon: String?
    public let color: Color
    public let isHighlighted: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        color: Color = .blue,
        isHighlighted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.isHighlighted = isHighlighted
    }
}

/// Configuration for comparison table appearance
public struct ComparisonTableConfiguration {
    public var style: TableStyle
    public var showRowDividers: Bool
    public var showColumnDividers: Bool
    public var alternateRowColors: Bool
    public var stickyHeader: Bool
    public var stickyFeatureColumn: Bool
    public var animationDuration: Double
    
    public enum TableStyle {
        case standard
        case card
        case minimal
        case striped
    }
    
    public init(
        style: TableStyle = .standard,
        showRowDividers: Bool = true,
        showColumnDividers: Bool = false,
        alternateRowColors: Bool = true,
        stickyHeader: Bool = true,
        stickyFeatureColumn: Bool = true,
        animationDuration: Double = 0.3
    ) {
        self.style = style
        self.showRowDividers = showRowDividers
        self.showColumnDividers = showColumnDividers
        self.alternateRowColors = alternateRowColors
        self.stickyHeader = stickyHeader
        self.stickyFeatureColumn = stickyFeatureColumn
        self.animationDuration = animationDuration
    }
}

// MARK: - Comparison Table View

/// A feature comparison table for products/plans
public struct ComparisonTable: View {
    let columns: [ComparisonColumn]
    let rows: [ComparisonRow]
    let configuration: ComparisonTableConfiguration
    let onColumnTap: ((ComparisonColumn) -> Void)?
    
    @State private var selectedColumn: ComparisonColumn?
    @State private var animationProgress: CGFloat = 0
    
    public init(
        columns: [ComparisonColumn],
        rows: [ComparisonRow],
        configuration: ComparisonTableConfiguration = ComparisonTableConfiguration(),
        onColumnTap: ((ComparisonColumn) -> Void)? = nil
    ) {
        self.columns = columns
        self.rows = rows
        self.configuration = configuration
        self.onColumnTap = onColumnTap
    }
    
    public var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            VStack(spacing: 0) {
                // Header row
                headerRow
                
                // Data rows
                ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                    if let category = row.category, shouldShowCategory(at: index) {
                        categoryHeader(category)
                    }
                    
                    dataRow(row, index: index)
                }
            }
            .padding()
        }
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animationProgress = 1
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Comparison table with \(columns.count) items and \(rows.count) features")
    }
    
    // MARK: - Header Row
    
    private var headerRow: some View {
        HStack(spacing: 0) {
            // Feature column header
            Text("Features")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
                .frame(width: 140, alignment: .leading)
                .padding(.vertical, 16)
                .padding(.horizontal, 12)
            
            // Column headers
            ForEach(columns) { column in
                columnHeader(column)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedColumn = column
                        }
                        onColumnTap?(column)
                    }
            }
        }
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1),
            alignment: .bottom
        )
    }
    
    private func columnHeader(_ column: ComparisonColumn) -> some View {
        VStack(spacing: 8) {
            if let icon = column.icon {
                ZStack {
                    Circle()
                        .fill(column.color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(column.color)
                }
            }
            
            Text(column.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            if let subtitle = column.subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .frame(width: 120)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(column.isHighlighted ? column.color.opacity(0.1) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(column.isHighlighted ? column.color : Color.clear, lineWidth: 2)
        )
        .scaleEffect(selectedColumn?.id == column.id ? 1.05 : 1.0)
    }
    
    // MARK: - Category Header
    
    private func categoryHeader(_ category: String) -> some View {
        HStack {
            Text(category)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .background(Color.gray.opacity(0.08))
    }
    
    // MARK: - Data Row
    
    private func dataRow(_ row: ComparisonRow, index: Int) -> some View {
        HStack(spacing: 0) {
            // Feature name
            Text(row.feature)
                .font(.subheadline)
                .foregroundColor(.primary)
                .frame(width: 140, alignment: .leading)
                .padding(.vertical, 14)
                .padding(.horizontal, 12)
            
            // Values
            ForEach(row.values.indices, id: \.self) { valueIndex in
                comparisonValueView(row.values[valueIndex], columnIndex: valueIndex)
                    .frame(width: 120)
                    .padding(.vertical, 14)
                
                if configuration.showColumnDividers && valueIndex < row.values.count - 1 {
                    Divider()
                }
            }
        }
        .background(rowBackground(index: index))
        .opacity(Double(animationProgress))
        .offset(x: (1 - animationProgress) * 20)
        .overlay(
            configuration.showRowDividers ?
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(height: 1)
            : nil,
            alignment: .bottom
        )
    }
    
    private func rowBackground(index: Int) -> some View {
        Group {
            if configuration.alternateRowColors && index % 2 == 1 {
                Color.gray.opacity(0.04)
            } else {
                Color.clear
            }
        }
    }
    
    // MARK: - Value Views
    
    @ViewBuilder
    private func comparisonValueView(_ value: ComparisonValue, columnIndex: Int) -> some View {
        let column = columns.indices.contains(columnIndex) ? columns[columnIndex] : nil
        
        switch value {
        case .text(let text):
            Text(text)
                .font(.subheadline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
        case .boolean(let isTrue):
            Image(systemName: isTrue ? "checkmark.circle.fill" : "xmark.circle.fill")
                .font(.title3)
                .foregroundColor(isTrue ? .green : .red.opacity(0.5))
            
        case .rating(let value, let maxRating):
            HStack(spacing: 2) {
                ForEach(0..<maxRating, id: \.self) { index in
                    Image(systemName: index < value ? "star.fill" : "star")
                        .font(.caption)
                        .foregroundColor(index < value ? .yellow : .gray.opacity(0.3))
                }
            }
            
        case .price(let amount, let currency):
            Text("\(currency)\(String(format: "%.0f", amount))")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(column?.color ?? .primary)
            
        case .icon(let iconName, let color):
            Image(systemName: iconName)
                .font(.title3)
                .foregroundColor(color)
            
        case .custom(let view):
            view
        }
    }
    
    // MARK: - Helper Methods
    
    private func shouldShowCategory(at index: Int) -> Bool {
        guard let category = rows[index].category else { return false }
        if index == 0 { return true }
        return rows[index - 1].category != category
    }
}

// MARK: - Comparison Card View

/// A card-based comparison view for 2-3 items
public struct ComparisonCardView: View {
    let items: [ComparisonItem]
    let highlightedIndex: Int?
    
    public struct ComparisonItem: Identifiable {
        public let id: UUID
        public let title: String
        public let subtitle: String?
        public let price: String?
        public let features: [String]
        public let color: Color
        public let badge: String?
        
        public init(
            id: UUID = UUID(),
            title: String,
            subtitle: String? = nil,
            price: String? = nil,
            features: [String],
            color: Color = .blue,
            badge: String? = nil
        ) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
            self.price = price
            self.features = features
            self.color = color
            self.badge = badge
        }
    }
    
    public init(items: [ComparisonItem], highlightedIndex: Int? = nil) {
        self.items = items
        self.highlightedIndex = highlightedIndex
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                comparisonCard(item, isHighlighted: index == highlightedIndex)
            }
        }
    }
    
    private func comparisonCard(_ item: ComparisonItem, isHighlighted: Bool) -> some View {
        VStack(spacing: 16) {
            // Badge
            if let badge = item.badge {
                Text(badge)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Capsule().fill(item.color))
            }
            
            // Title
            VStack(spacing: 4) {
                Text(item.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Price
            if let price = item.price {
                Text(price)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(item.color)
            }
            
            Divider()
            
            // Features
            VStack(alignment: .leading, spacing: 8) {
                ForEach(item.features, id: \.self) { feature in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                        
                        Text(feature)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                    }
                }
            }
            
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: item.color.opacity(isHighlighted ? 0.3 : 0.1), radius: isHighlighted ? 12 : 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isHighlighted ? item.color : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isHighlighted ? 1.02 : 1.0)
    }
}

// MARK: - Preview

#if DEBUG
struct ComparisonTable_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 40) {
                ComparisonTable(
                    columns: [
                        ComparisonColumn(title: "Basic", subtitle: "$9/mo", icon: "star", color: .gray),
                        ComparisonColumn(title: "Pro", subtitle: "$29/mo", icon: "star.fill", color: .blue, isHighlighted: true),
                        ComparisonColumn(title: "Enterprise", subtitle: "Custom", icon: "building.2", color: .purple)
                    ],
                    rows: [
                        ComparisonRow(feature: "Users", values: [.text("1"), .text("5"), .text("Unlimited")], category: "Limits"),
                        ComparisonRow(feature: "Storage", values: [.text("5 GB"), .text("50 GB"), .text("1 TB")]),
                        ComparisonRow(feature: "API Access", values: [.check(false), .check(true), .check(true)], category: "Features"),
                        ComparisonRow(feature: "Support", values: [.text("Email"), .text("Priority"), .text("24/7")]),
                        ComparisonRow(feature: "Rating", values: [.stars(3), .stars(4), .stars(5)])
                    ]
                )
                
                ComparisonCardView(
                    items: [
                        ComparisonCardView.ComparisonItem(
                            title: "Starter",
                            price: "$9",
                            features: ["1 User", "5 GB Storage", "Email Support"],
                            color: .gray
                        ),
                        ComparisonCardView.ComparisonItem(
                            title: "Professional",
                            price: "$29",
                            features: ["5 Users", "50 GB Storage", "Priority Support", "API Access"],
                            color: .blue,
                            badge: "Popular"
                        )
                    ],
                    highlightedIndex: 1
                )
                .padding(.horizontal)
            }
        }
    }
}
#endif
