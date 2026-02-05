// OrgChartView.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Org Chart Data Models

/// Represents a person/position in the org chart
public struct OrgChartPerson: Identifiable, Equatable {
    public let id: UUID
    public let name: String
    public let title: String
    public let department: String?
    public let imageURL: URL?
    public let color: Color
    public var subordinates: [OrgChartPerson]
    public var isExpanded: Bool
    public let metadata: [String: String]
    
    public init(
        id: UUID = UUID(),
        name: String,
        title: String,
        department: String? = nil,
        imageURL: URL? = nil,
        color: Color = .blue,
        subordinates: [OrgChartPerson] = [],
        isExpanded: Bool = true,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.name = name
        self.title = title
        self.department = department
        self.imageURL = imageURL
        self.color = color
        self.subordinates = subordinates
        self.isExpanded = isExpanded
        self.metadata = metadata
    }
    
    public static func == (lhs: OrgChartPerson, rhs: OrgChartPerson) -> Bool {
        lhs.id == rhs.id
    }
}

/// Configuration for org chart appearance
public struct OrgChartConfiguration {
    public var cardWidth: CGFloat
    public var cardHeight: CGFloat
    public var horizontalSpacing: CGFloat
    public var verticalSpacing: CGFloat
    public var connectionLineWidth: CGFloat
    public var showImages: Bool
    public var showDepartment: Bool
    public var cardStyle: CardStyle
    public var animationDuration: Double
    
    public enum CardStyle {
        case standard
        case compact
        case detailed
        case minimal
    }
    
    public init(
        cardWidth: CGFloat = 180,
        cardHeight: CGFloat = 100,
        horizontalSpacing: CGFloat = 30,
        verticalSpacing: CGFloat = 60,
        connectionLineWidth: CGFloat = 2,
        showImages: Bool = true,
        showDepartment: Bool = true,
        cardStyle: CardStyle = .standard,
        animationDuration: Double = 0.3
    ) {
        self.cardWidth = cardWidth
        self.cardHeight = cardHeight
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.connectionLineWidth = connectionLineWidth
        self.showImages = showImages
        self.showDepartment = showDepartment
        self.cardStyle = cardStyle
        self.animationDuration = animationDuration
    }
}

// MARK: - Org Chart View

/// An organizational chart visualization with hierarchy support
public struct OrgChartView: View {
    @Binding private var rootPerson: OrgChartPerson
    private let configuration: OrgChartConfiguration
    private let onPersonTap: ((OrgChartPerson) -> Void)?
    
    @State private var selectedPerson: OrgChartPerson?
    @State private var scale: CGFloat = 1.0
    @State private var animationProgress: CGFloat = 0
    
    public init(
        rootPerson: Binding<OrgChartPerson>,
        configuration: OrgChartConfiguration = OrgChartConfiguration(),
        onPersonTap: ((OrgChartPerson) -> Void)? = nil
    ) {
        self._rootPerson = rootPerson
        self.configuration = configuration
        self.onPersonTap = onPersonTap
    }
    
    public var body: some View {
        ScrollView([.horizontal, .vertical], showsIndicators: false) {
            VStack(spacing: 0) {
                OrgChartNodeView(
                    person: $rootPerson,
                    configuration: configuration,
                    selectedPerson: $selectedPerson,
                    animationProgress: animationProgress,
                    level: 0,
                    onPersonTap: handlePersonTap
                )
            }
            .padding(40)
            .scaleEffect(scale)
        }
        .gesture(
            MagnificationGesture()
                .onChanged { value in
                    scale = max(0.3, min(2.0, value))
                }
        )
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animationProgress = 1
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Organization chart headed by \(rootPerson.name)")
    }
    
    private func handlePersonTap(_ person: OrgChartPerson) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedPerson = person
        }
        onPersonTap?(person)
    }
}

// MARK: - Org Chart Node View

private struct OrgChartNodeView: View {
    @Binding var person: OrgChartPerson
    let configuration: OrgChartConfiguration
    @Binding var selectedPerson: OrgChartPerson?
    let animationProgress: CGFloat
    let level: Int
    let onPersonTap: (OrgChartPerson) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Person card
            PersonCardView(
                person: person,
                isSelected: selectedPerson?.id == person.id,
                configuration: configuration,
                animationProgress: animationProgress
            )
            .onTapGesture { onPersonTap(person) }
            
            // Connection and subordinates
            if person.isExpanded && !person.subordinates.isEmpty {
                // Vertical line down
                Rectangle()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: configuration.connectionLineWidth, height: configuration.verticalSpacing / 2)
                    .opacity(Double(animationProgress))
                
                // Horizontal line across
                HStack(spacing: 0) {
                    ForEach(person.subordinates.indices, id: \.self) { index in
                        if index > 0 {
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(height: configuration.connectionLineWidth)
                                .opacity(Double(animationProgress))
                        }
                        
                        VStack(spacing: 0) {
                            // Vertical line to child
                            Rectangle()
                                .fill(Color.gray.opacity(0.4))
                                .frame(width: configuration.connectionLineWidth, height: configuration.verticalSpacing / 2)
                                .opacity(Double(animationProgress))
                            
                            // Child node
                            OrgChartNodeView(
                                person: .constant(person.subordinates[index]),
                                configuration: configuration,
                                selectedPerson: $selectedPerson,
                                animationProgress: animationProgress,
                                level: level + 1,
                                onPersonTap: onPersonTap
                            )
                        }
                        .frame(minWidth: configuration.cardWidth + configuration.horizontalSpacing)
                    }
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .scale(scale: 0.8)),
                    removal: .opacity.combined(with: .scale(scale: 0.8))
                ))
            }
            
            // Expansion indicator
            if !person.subordinates.isEmpty {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        person.isExpanded.toggle()
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: person.isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        Text("\(person.subordinates.count)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                    .padding(.vertical, 4)
                }
                .opacity(Double(animationProgress))
            }
        }
    }
}

// MARK: - Person Card View

private struct PersonCardView: View {
    let person: OrgChartPerson
    let isSelected: Bool
    let configuration: OrgChartConfiguration
    let animationProgress: CGFloat
    
    var body: some View {
        Group {
            switch configuration.cardStyle {
            case .standard:
                standardCard
            case .compact:
                compactCard
            case .detailed:
                detailedCard
            case .minimal:
                minimalCard
            }
        }
        .frame(width: configuration.cardWidth, height: cardHeight)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: person.color.opacity(isSelected ? 0.4 : 0.15), radius: isSelected ? 12 : 6, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(person.color, lineWidth: isSelected ? 3 : 0)
        )
        .opacity(Double(animationProgress))
        .scaleEffect(animationProgress)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(person.name), \(person.title)")
        .accessibilityHint(person.subordinates.isEmpty ? "No direct reports" : "\(person.subordinates.count) direct reports")
    }
    
    private var cardHeight: CGFloat {
        switch configuration.cardStyle {
        case .standard: return configuration.cardHeight
        case .compact: return configuration.cardHeight * 0.7
        case .detailed: return configuration.cardHeight * 1.3
        case .minimal: return configuration.cardHeight * 0.5
        }
    }
    
    private var standardCard: some View {
        VStack(spacing: 8) {
            HStack(spacing: 12) {
                if configuration.showImages {
                    avatarView
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(person.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(person.title)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
            }
            
            if configuration.showDepartment, let dept = person.department {
                HStack {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(person.color)
                        .frame(width: 3, height: 16)
                    
                    Text(dept)
                        .font(.caption)
                        .foregroundColor(person.color)
                    
                    Spacer()
                }
            }
        }
        .padding(12)
    }
    
    private var compactCard: some View {
        HStack(spacing: 8) {
            if configuration.showImages {
                avatarView
                    .scaleEffect(0.8)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(person.name)
                    .font(.system(size: 13, weight: .semibold))
                    .lineLimit(1)
                
                Text(person.title)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
        }
        .padding(10)
    }
    
    private var detailedCard: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                if configuration.showImages {
                    avatarView
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(person.name)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.primary)
                    
                    Text(person.title)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Divider()
            
            if configuration.showDepartment, let dept = person.department {
                HStack {
                    Image(systemName: "building.2")
                        .font(.caption)
                        .foregroundColor(person.color)
                    Text(dept)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            
            if !person.metadata.isEmpty {
                HStack {
                    ForEach(Array(person.metadata.prefix(2).keys.sorted()), id: \.self) { key in
                        if let value = person.metadata[key] {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(key)
                                    .font(.system(size: 9))
                                    .foregroundColor(.secondary)
                                Text(value)
                                    .font(.system(size: 11, weight: .medium))
                            }
                            if key != Array(person.metadata.prefix(2).keys.sorted()).last {
                                Spacer()
                            }
                        }
                    }
                }
            }
        }
        .padding(14)
    }
    
    private var minimalCard: some View {
        VStack(spacing: 4) {
            Text(person.name)
                .font(.system(size: 13, weight: .semibold))
                .lineLimit(1)
            
            Text(person.title)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .padding(8)
    }
    
    private var avatarView: some View {
        ZStack {
            Circle()
                .fill(person.color.opacity(0.2))
                .frame(width: 40, height: 40)
            
            if let _ = person.imageURL {
                // AsyncImage would go here in real implementation
                Text(String(person.name.prefix(1)))
                    .font(.headline)
                    .foregroundColor(person.color)
            } else {
                Text(String(person.name.prefix(1)))
                    .font(.headline)
                    .foregroundColor(person.color)
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct OrgChartView_Previews: PreviewProvider {
    static var sampleOrg: OrgChartPerson {
        OrgChartPerson(
            name: "Sarah Chen",
            title: "CEO",
            department: "Executive",
            color: .blue,
            subordinates: [
                OrgChartPerson(
                    name: "Michael Park",
                    title: "CTO",
                    department: "Technology",
                    color: .purple,
                    subordinates: [
                        OrgChartPerson(name: "Emma Davis", title: "Lead Engineer", department: "Engineering", color: .orange),
                        OrgChartPerson(name: "James Wilson", title: "DevOps Lead", department: "Infrastructure", color: .orange)
                    ]
                ),
                OrgChartPerson(
                    name: "Lisa Johnson",
                    title: "CFO",
                    department: "Finance",
                    color: .green,
                    subordinates: [
                        OrgChartPerson(name: "David Brown", title: "Controller", department: "Accounting", color: .teal)
                    ]
                ),
                OrgChartPerson(
                    name: "Robert Taylor",
                    title: "CMO",
                    department: "Marketing",
                    color: .red
                )
            ]
        )
    }
    
    static var previews: some View {
        OrgChartView(rootPerson: .constant(sampleOrg))
    }
}
#endif
