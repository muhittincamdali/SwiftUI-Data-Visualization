// MindMapView.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Mind Map Data Models

/// Represents a node in the mind map
public struct MindMapNode: Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let subtitle: String?
    public let icon: String?
    public let color: Color
    public var children: [MindMapNode]
    public var isExpanded: Bool
    
    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        color: Color = .blue,
        children: [MindMapNode] = [],
        isExpanded: Bool = true
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.children = children
        self.isExpanded = isExpanded
    }
    
    public static func == (lhs: MindMapNode, rhs: MindMapNode) -> Bool {
        lhs.id == rhs.id
    }
}

/// Configuration for mind map appearance
public struct MindMapConfiguration {
    public var nodeSpacing: CGFloat
    public var levelSpacing: CGFloat
    public var connectionStyle: ConnectionStyle
    public var nodeStyle: NodeStyle
    public var showExpansionIndicator: Bool
    public var animationDuration: Double
    public var layout: LayoutDirection
    
    public enum ConnectionStyle {
        case curved
        case straight
        case orthogonal
    }
    
    public enum NodeStyle {
        case rounded
        case bubble
        case minimal
        case card
    }
    
    public enum LayoutDirection {
        case horizontal
        case radial
        case tree
    }
    
    public init(
        nodeSpacing: CGFloat = 60,
        levelSpacing: CGFloat = 120,
        connectionStyle: ConnectionStyle = .curved,
        nodeStyle: NodeStyle = .rounded,
        showExpansionIndicator: Bool = true,
        animationDuration: Double = 0.3,
        layout: LayoutDirection = .horizontal
    ) {
        self.nodeSpacing = nodeSpacing
        self.levelSpacing = levelSpacing
        self.connectionStyle = connectionStyle
        self.nodeStyle = nodeStyle
        self.showExpansionIndicator = showExpansionIndicator
        self.animationDuration = animationDuration
        self.layout = layout
    }
}

// MARK: - Mind Map View

/// An interactive mind map visualization with expandable nodes
public struct MindMapView: View {
    @Binding private var rootNode: MindMapNode
    private let configuration: MindMapConfiguration
    private let onNodeTap: ((MindMapNode) -> Void)?
    
    @State private var selectedNode: MindMapNode?
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var animationProgress: CGFloat = 0
    
    public init(
        rootNode: Binding<MindMapNode>,
        configuration: MindMapConfiguration = MindMapConfiguration(),
        onNodeTap: ((MindMapNode) -> Void)? = nil
    ) {
        self._rootNode = rootNode
        self.configuration = configuration
        self.onNodeTap = onNodeTap
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                ZStack {
                    switch configuration.layout {
                    case .horizontal:
                        HorizontalMindMapLayout(
                            node: $rootNode,
                            configuration: configuration,
                            selectedNode: $selectedNode,
                            animationProgress: animationProgress,
                            onNodeTap: handleNodeTap
                        )
                    case .radial:
                        RadialMindMapLayout(
                            node: $rootNode,
                            configuration: configuration,
                            selectedNode: $selectedNode,
                            animationProgress: animationProgress,
                            center: CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2),
                            onNodeTap: handleNodeTap
                        )
                    case .tree:
                        TreeMindMapLayout(
                            node: $rootNode,
                            configuration: configuration,
                            selectedNode: $selectedNode,
                            animationProgress: animationProgress,
                            onNodeTap: handleNodeTap
                        )
                    }
                }
                .scaleEffect(scale)
                .offset(offset)
                .frame(minWidth: geometry.size.width * 2, minHeight: geometry.size.height * 2)
            }
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = max(0.3, min(3.0, value))
                    }
            )
        }
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animationProgress = 1
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Mind map with root: \(rootNode.title)")
    }
    
    private func handleNodeTap(_ node: MindMapNode) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            selectedNode = node
        }
        onNodeTap?(node)
    }
}

// MARK: - Horizontal Layout

private struct HorizontalMindMapLayout: View {
    @Binding var node: MindMapNode
    let configuration: MindMapConfiguration
    @Binding var selectedNode: MindMapNode?
    let animationProgress: CGFloat
    let onNodeTap: (MindMapNode) -> Void
    let level: Int
    
    init(
        node: Binding<MindMapNode>,
        configuration: MindMapConfiguration,
        selectedNode: Binding<MindMapNode?>,
        animationProgress: CGFloat,
        onNodeTap: @escaping (MindMapNode) -> Void,
        level: Int = 0
    ) {
        self._node = node
        self.configuration = configuration
        self._selectedNode = selectedNode
        self.animationProgress = animationProgress
        self.onNodeTap = onNodeTap
        self.level = level
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: configuration.levelSpacing) {
            // Current node
            MindMapNodeView(
                node: node,
                isSelected: selectedNode?.id == node.id,
                configuration: configuration,
                animationProgress: animationProgress,
                level: level
            )
            .onTapGesture { onNodeTap(node) }
            
            // Children
            if node.isExpanded && !node.children.isEmpty {
                VStack(alignment: .leading, spacing: configuration.nodeSpacing) {
                    ForEach(node.children.indices, id: \.self) { index in
                        HorizontalMindMapLayout(
                            node: .constant(node.children[index]),
                            configuration: configuration,
                            selectedNode: $selectedNode,
                            animationProgress: animationProgress,
                            onNodeTap: onNodeTap,
                            level: level + 1
                        )
                    }
                }
                .transition(.asymmetric(
                    insertion: .scale.combined(with: .opacity),
                    removal: .scale.combined(with: .opacity)
                ))
            }
        }
    }
}

// MARK: - Radial Layout

private struct RadialMindMapLayout: View {
    @Binding var node: MindMapNode
    let configuration: MindMapConfiguration
    @Binding var selectedNode: MindMapNode?
    let animationProgress: CGFloat
    let center: CGPoint
    let onNodeTap: (MindMapNode) -> Void
    
    var body: some View {
        ZStack {
            // Root node at center
            MindMapNodeView(
                node: node,
                isSelected: selectedNode?.id == node.id,
                configuration: configuration,
                animationProgress: animationProgress,
                level: 0
            )
            .position(center)
            .onTapGesture { onNodeTap(node) }
            
            // Children in radial layout
            if node.isExpanded && !node.children.isEmpty {
                ForEach(Array(node.children.enumerated()), id: \.element.id) { index, child in
                    let angle = (2 * .pi / Double(node.children.count)) * Double(index) - .pi / 2
                    let radius = configuration.levelSpacing
                    let position = CGPoint(
                        x: center.x + CGFloat(cos(angle)) * radius,
                        y: center.y + CGFloat(sin(angle)) * radius
                    )
                    
                    // Connection line
                    Path { path in
                        path.move(to: center)
                        path.addLine(to: position)
                    }
                    .stroke(child.color.opacity(0.3), lineWidth: 2)
                    .opacity(Double(animationProgress))
                    
                    // Child node
                    MindMapNodeView(
                        node: child,
                        isSelected: selectedNode?.id == child.id,
                        configuration: configuration,
                        animationProgress: animationProgress,
                        level: 1
                    )
                    .position(position)
                    .onTapGesture { onNodeTap(child) }
                }
            }
        }
    }
}

// MARK: - Tree Layout

private struct TreeMindMapLayout: View {
    @Binding var node: MindMapNode
    let configuration: MindMapConfiguration
    @Binding var selectedNode: MindMapNode?
    let animationProgress: CGFloat
    let onNodeTap: (MindMapNode) -> Void
    let level: Int
    
    init(
        node: Binding<MindMapNode>,
        configuration: MindMapConfiguration,
        selectedNode: Binding<MindMapNode?>,
        animationProgress: CGFloat,
        onNodeTap: @escaping (MindMapNode) -> Void,
        level: Int = 0
    ) {
        self._node = node
        self.configuration = configuration
        self._selectedNode = selectedNode
        self.animationProgress = animationProgress
        self.onNodeTap = onNodeTap
        self.level = level
    }
    
    var body: some View {
        VStack(spacing: configuration.levelSpacing) {
            // Current node
            MindMapNodeView(
                node: node,
                isSelected: selectedNode?.id == node.id,
                configuration: configuration,
                animationProgress: animationProgress,
                level: level
            )
            .onTapGesture { onNodeTap(node) }
            
            // Children
            if node.isExpanded && !node.children.isEmpty {
                HStack(alignment: .top, spacing: configuration.nodeSpacing) {
                    ForEach(node.children.indices, id: \.self) { index in
                        TreeMindMapLayout(
                            node: .constant(node.children[index]),
                            configuration: configuration,
                            selectedNode: $selectedNode,
                            animationProgress: animationProgress,
                            onNodeTap: onNodeTap,
                            level: level + 1
                        )
                    }
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
            }
        }
    }
}

// MARK: - Mind Map Node View

private struct MindMapNodeView: View {
    let node: MindMapNode
    let isSelected: Bool
    let configuration: MindMapConfiguration
    let animationProgress: CGFloat
    let level: Int
    
    private var nodeSize: CGFloat {
        max(80, 120 - CGFloat(level * 15))
    }
    
    var body: some View {
        VStack(spacing: 4) {
            if let icon = node.icon {
                Image(systemName: icon)
                    .font(.system(size: level == 0 ? 24 : 18))
                    .foregroundColor(node.color)
            }
            
            Text(node.title)
                .font(level == 0 ? .headline : .subheadline)
                .fontWeight(level == 0 ? .bold : .medium)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            if let subtitle = node.subtitle {
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            // Expansion indicator
            if configuration.showExpansionIndicator && !node.children.isEmpty {
                HStack(spacing: 2) {
                    Image(systemName: node.isExpanded ? "chevron.down.circle.fill" : "chevron.right.circle.fill")
                        .font(.caption)
                        .foregroundColor(node.color.opacity(0.6))
                    Text("\(node.children.count)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(12)
        .frame(minWidth: nodeSize, minHeight: nodeSize * 0.6)
        .background(nodeBackground)
        .opacity(Double(animationProgress))
        .scaleEffect(animationProgress)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(node.title)
        .accessibilityHint(node.children.isEmpty ? "No children" : "\(node.children.count) children, \(node.isExpanded ? "expanded" : "collapsed")")
    }
    
    @ViewBuilder
    private var nodeBackground: some View {
        switch configuration.nodeStyle {
        case .rounded:
            RoundedRectangle(cornerRadius: 12)
                .fill(node.color.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(node.color, lineWidth: isSelected ? 3 : 2)
                )
                .shadow(color: node.color.opacity(isSelected ? 0.4 : 0.2), radius: isSelected ? 8 : 4)
            
        case .bubble:
            Capsule()
                .fill(node.color.opacity(0.2))
                .overlay(Capsule().stroke(node.color, lineWidth: isSelected ? 3 : 1.5))
                .shadow(color: node.color.opacity(0.3), radius: 6)
            
        case .minimal:
            Rectangle()
                .fill(Color.clear)
                .overlay(
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(node.color)
                        .offset(y: 20)
                )
            
        case .card:
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(node.color.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 4, y: 2)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct MindMapView_Previews: PreviewProvider {
    static var sampleNode: MindMapNode {
        MindMapNode(
            title: "Project",
            icon: "folder.fill",
            color: .blue,
            children: [
                MindMapNode(
                    title: "Design",
                    icon: "paintbrush.fill",
                    color: .purple,
                    children: [
                        MindMapNode(title: "UI/UX", color: .purple),
                        MindMapNode(title: "Branding", color: .purple)
                    ]
                ),
                MindMapNode(
                    title: "Development",
                    icon: "hammer.fill",
                    color: .orange,
                    children: [
                        MindMapNode(title: "Frontend", color: .orange),
                        MindMapNode(title: "Backend", color: .orange),
                        MindMapNode(title: "Mobile", color: .orange)
                    ]
                ),
                MindMapNode(
                    title: "Marketing",
                    icon: "megaphone.fill",
                    color: .green
                )
            ]
        )
    }
    
    static var previews: some View {
        MindMapView(rootNode: .constant(sampleNode))
    }
}
#endif
