// NetworkGraphView.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Network Graph Data Models

/// Represents a node in the network graph
public struct NetworkNode: Identifiable, Equatable {
    public let id: UUID
    public let label: String
    public let value: Double
    public let group: String?
    public let color: Color
    public let icon: String?
    public var position: CGPoint
    public let metadata: [String: Any]
    
    public init(
        id: UUID = UUID(),
        label: String,
        value: Double = 1.0,
        group: String? = nil,
        color: Color = .blue,
        icon: String? = nil,
        position: CGPoint = .zero,
        metadata: [String: Any] = [:]
    ) {
        self.id = id
        self.label = label
        self.value = value
        self.group = group
        self.color = color
        self.icon = icon
        self.position = position
        self.metadata = metadata
    }
    
    public static func == (lhs: NetworkNode, rhs: NetworkNode) -> Bool {
        lhs.id == rhs.id
    }
}

/// Represents an edge connecting two nodes
public struct NetworkEdge: Identifiable, Equatable {
    public let id: UUID
    public let sourceId: UUID
    public let targetId: UUID
    public let weight: Double
    public let label: String?
    public let color: Color
    public let style: EdgeStyle
    
    public enum EdgeStyle {
        case solid
        case dashed
        case dotted
        case animated
    }
    
    public init(
        id: UUID = UUID(),
        source: UUID,
        target: UUID,
        weight: Double = 1.0,
        label: String? = nil,
        color: Color = .gray,
        style: EdgeStyle = .solid
    ) {
        self.id = id
        self.sourceId = source
        self.targetId = target
        self.weight = weight
        self.label = label
        self.color = color
        self.style = style
    }
    
    public static func == (lhs: NetworkEdge, rhs: NetworkEdge) -> Bool {
        lhs.id == rhs.id
    }
}

/// Configuration for network graph appearance
public struct NetworkGraphConfiguration {
    public var nodeMinSize: CGFloat
    public var nodeMaxSize: CGFloat
    public var edgeMinWidth: CGFloat
    public var edgeMaxWidth: CGFloat
    public var showLabels: Bool
    public var showEdgeLabels: Bool
    public var forceStrength: Double
    public var centerForce: Double
    public var repulsionForce: Double
    public var linkDistance: CGFloat
    public var animationDuration: Double
    public var enablePhysics: Bool
    
    public init(
        nodeMinSize: CGFloat = 30,
        nodeMaxSize: CGFloat = 80,
        edgeMinWidth: CGFloat = 1,
        edgeMaxWidth: CGFloat = 5,
        showLabels: Bool = true,
        showEdgeLabels: Bool = false,
        forceStrength: Double = 0.1,
        centerForce: Double = 0.05,
        repulsionForce: Double = 100,
        linkDistance: CGFloat = 100,
        animationDuration: Double = 0.3,
        enablePhysics: Bool = true
    ) {
        self.nodeMinSize = nodeMinSize
        self.nodeMaxSize = nodeMaxSize
        self.edgeMinWidth = edgeMinWidth
        self.edgeMaxWidth = edgeMaxWidth
        self.showLabels = showLabels
        self.showEdgeLabels = showEdgeLabels
        self.forceStrength = forceStrength
        self.centerForce = centerForce
        self.repulsionForce = repulsionForce
        self.linkDistance = linkDistance
        self.animationDuration = animationDuration
        self.enablePhysics = enablePhysics
    }
}

// MARK: - Network Graph View

/// A force-directed network graph visualization
public struct NetworkGraphView: View {
    @Binding private var nodes: [NetworkNode]
    @Binding private var edges: [NetworkEdge]
    private let configuration: NetworkGraphConfiguration
    private let onNodeTap: ((NetworkNode) -> Void)?
    private let onEdgeTap: ((NetworkEdge) -> Void)?
    
    @State private var selectedNode: NetworkNode?
    @State private var selectedEdge: NetworkEdge?
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var animationProgress: CGFloat = 0
    @State private var physicsTimer: Timer?
    
    public init(
        nodes: Binding<[NetworkNode]>,
        edges: Binding<[NetworkEdge]>,
        configuration: NetworkGraphConfiguration = NetworkGraphConfiguration(),
        onNodeTap: ((NetworkNode) -> Void)? = nil,
        onEdgeTap: ((NetworkEdge) -> Void)? = nil
    ) {
        self._nodes = nodes
        self._edges = edges
        self.configuration = configuration
        self.onNodeTap = onNodeTap
        self.onEdgeTap = onEdgeTap
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Edges layer
                ForEach(edges) { edge in
                    if let sourceNode = nodes.first(where: { $0.id == edge.sourceId }),
                       let targetNode = nodes.first(where: { $0.id == edge.targetId }) {
                        NetworkEdgeView(
                            edge: edge,
                            source: sourceNode,
                            target: targetNode,
                            isSelected: selectedEdge?.id == edge.id,
                            configuration: configuration,
                            animationProgress: animationProgress
                        )
                        .onTapGesture {
                            withAnimation { selectedEdge = edge }
                            onEdgeTap?(edge)
                        }
                    }
                }
                
                // Nodes layer
                ForEach(nodes) { node in
                    NetworkNodeView(
                        node: node,
                        isSelected: selectedNode?.id == node.id,
                        configuration: configuration,
                        animationProgress: animationProgress,
                        maxValue: nodes.map { $0.value }.max() ?? 1
                    )
                    .position(adjustedPosition(node.position, in: geometry.size))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                updateNodePosition(node, to: value.location, in: geometry.size)
                            }
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedNode = node
                        }
                        onNodeTap?(node)
                    }
                }
            }
            .scaleEffect(scale)
            .offset(offset)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = max(0.3, min(3.0, value))
                    }
            )
            .simultaneousGesture(
                DragGesture()
                    .onChanged { value in
                        if selectedNode == nil {
                            offset = value.translation
                        }
                    }
                    .onEnded { _ in
                        offset = .zero
                    }
            )
            .onAppear {
                initializePositions(in: geometry.size)
                withAnimation(.easeOut(duration: configuration.animationDuration)) {
                    animationProgress = 1
                }
                if configuration.enablePhysics {
                    startPhysicsSimulation(in: geometry.size)
                }
            }
            .onDisappear {
                physicsTimer?.invalidate()
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Network graph with \(nodes.count) nodes and \(edges.count) connections")
    }
    
    private func adjustedPosition(_ position: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: position.x + offset.width,
            y: position.y + offset.height
        )
    }
    
    private func initializePositions(in size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius = min(size.width, size.height) * 0.35
        
        for i in nodes.indices {
            if nodes[i].position == .zero {
                let angle = (2 * .pi / Double(nodes.count)) * Double(i)
                nodes[i].position = CGPoint(
                    x: center.x + CGFloat(cos(angle)) * radius,
                    y: center.y + CGFloat(sin(angle)) * radius
                )
            }
        }
    }
    
    private func updateNodePosition(_ node: NetworkNode, to position: CGPoint, in size: CGSize) {
        if let index = nodes.firstIndex(where: { $0.id == node.id }) {
            nodes[index].position = position
        }
    }
    
    private func startPhysicsSimulation(in size: CGSize) {
        physicsTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { _ in
            applyForces(in: size)
        }
    }
    
    private func applyForces(in size: CGSize) {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        // Apply forces to each node
        for i in nodes.indices {
            var forceX: CGFloat = 0
            var forceY: CGFloat = 0
            
            // Center force
            forceX += (center.x - nodes[i].position.x) * CGFloat(configuration.centerForce)
            forceY += (center.y - nodes[i].position.y) * CGFloat(configuration.centerForce)
            
            // Repulsion from other nodes
            for j in nodes.indices where i != j {
                let dx = nodes[i].position.x - nodes[j].position.x
                let dy = nodes[i].position.y - nodes[j].position.y
                let distance = max(sqrt(dx * dx + dy * dy), 1)
                let force = CGFloat(configuration.repulsionForce) / (distance * distance)
                forceX += (dx / distance) * force
                forceY += (dy / distance) * force
            }
            
            // Attraction along edges
            for edge in edges {
                if edge.sourceId == nodes[i].id {
                    if let target = nodes.first(where: { $0.id == edge.targetId }) {
                        let dx = target.position.x - nodes[i].position.x
                        let dy = target.position.y - nodes[i].position.y
                        let distance = sqrt(dx * dx + dy * dy)
                        let force = (distance - configuration.linkDistance) * CGFloat(configuration.forceStrength)
                        forceX += (dx / max(distance, 1)) * force
                        forceY += (dy / max(distance, 1)) * force
                    }
                } else if edge.targetId == nodes[i].id {
                    if let source = nodes.first(where: { $0.id == edge.sourceId }) {
                        let dx = source.position.x - nodes[i].position.x
                        let dy = source.position.y - nodes[i].position.y
                        let distance = sqrt(dx * dx + dy * dy)
                        let force = (distance - configuration.linkDistance) * CGFloat(configuration.forceStrength)
                        forceX += (dx / max(distance, 1)) * force
                        forceY += (dy / max(distance, 1)) * force
                    }
                }
            }
            
            // Apply forces
            nodes[i].position.x += forceX * 0.1
            nodes[i].position.y += forceY * 0.1
            
            // Keep within bounds
            nodes[i].position.x = max(50, min(size.width - 50, nodes[i].position.x))
            nodes[i].position.y = max(50, min(size.height - 50, nodes[i].position.y))
        }
    }
}

// MARK: - Network Node View

private struct NetworkNodeView: View {
    let node: NetworkNode
    let isSelected: Bool
    let configuration: NetworkGraphConfiguration
    let animationProgress: CGFloat
    let maxValue: Double
    
    private var nodeSize: CGFloat {
        let normalized = node.value / maxValue
        return configuration.nodeMinSize + CGFloat(normalized) * (configuration.nodeMaxSize - configuration.nodeMinSize)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                // Background glow
                Circle()
                    .fill(node.color.opacity(0.2))
                    .frame(width: nodeSize * 1.3, height: nodeSize * 1.3)
                    .blur(radius: isSelected ? 8 : 4)
                
                // Main circle
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [node.color.opacity(0.9), node.color],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: nodeSize
                        )
                    )
                    .frame(width: nodeSize, height: nodeSize)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.white : node.color.opacity(0.5), lineWidth: isSelected ? 3 : 1)
                    )
                    .shadow(color: node.color.opacity(0.5), radius: isSelected ? 10 : 4)
                
                // Icon or label
                if let icon = node.icon {
                    Image(systemName: icon)
                        .font(.system(size: nodeSize * 0.4))
                        .foregroundColor(.white)
                } else {
                    Text(String(node.label.prefix(2)))
                        .font(.system(size: nodeSize * 0.35, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            
            // Label below node
            if configuration.showLabels {
                Text(node.label)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(
                        Capsule()
                            .fill(Color(.systemBackground).opacity(0.8))
                    )
            }
        }
        .opacity(Double(animationProgress))
        .scaleEffect(animationProgress)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(node.label), value: \(Int(node.value))")
        .accessibilityHint(node.group ?? "")
    }
}

// MARK: - Network Edge View

private struct NetworkEdgeView: View {
    let edge: NetworkEdge
    let source: NetworkNode
    let target: NetworkNode
    let isSelected: Bool
    let configuration: NetworkGraphConfiguration
    let animationProgress: CGFloat
    
    @State private var animatedPhase: CGFloat = 0
    
    private var lineWidth: CGFloat {
        let maxWeight = 10.0
        let normalized = min(edge.weight / maxWeight, 1.0)
        return configuration.edgeMinWidth + CGFloat(normalized) * (configuration.edgeMaxWidth - configuration.edgeMinWidth)
    }
    
    var body: some View {
        ZStack {
            // Edge line
            Path { path in
                path.move(to: source.position)
                path.addLine(to: target.position)
            }
            .stroke(
                edge.color,
                style: StrokeStyle(
                    lineWidth: lineWidth,
                    lineCap: .round,
                    dash: dashPattern,
                    dashPhase: edge.style == .animated ? animatedPhase : 0
                )
            )
            .opacity(Double(animationProgress) * (isSelected ? 1.0 : 0.6))
            
            // Edge label
            if configuration.showEdgeLabels, let label = edge.label {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(4)
                    .background(Color(.systemBackground).opacity(0.9))
                    .cornerRadius(4)
                    .position(midpoint)
            }
            
            // Arrow head
            ArrowHead(from: source.position, to: target.position, size: 8 + lineWidth)
                .fill(edge.color)
                .opacity(Double(animationProgress) * (isSelected ? 1.0 : 0.6))
        }
        .onAppear {
            if edge.style == .animated {
                withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
                    animatedPhase = 20
                }
            }
        }
    }
    
    private var dashPattern: [CGFloat] {
        switch edge.style {
        case .solid:
            return []
        case .dashed:
            return [10, 5]
        case .dotted:
            return [2, 4]
        case .animated:
            return [10, 10]
        }
    }
    
    private var midpoint: CGPoint {
        CGPoint(
            x: (source.position.x + target.position.x) / 2,
            y: (source.position.y + target.position.y) / 2
        )
    }
}

// MARK: - Arrow Head Shape

private struct ArrowHead: Shape {
    let from: CGPoint
    let to: CGPoint
    let size: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let angle = atan2(to.y - from.y, to.x - from.x)
        let arrowPoint = to
        
        return Path { path in
            path.move(to: arrowPoint)
            path.addLine(to: CGPoint(
                x: arrowPoint.x - size * cos(angle - .pi / 6),
                y: arrowPoint.y - size * sin(angle - .pi / 6)
            ))
            path.addLine(to: CGPoint(
                x: arrowPoint.x - size * cos(angle + .pi / 6),
                y: arrowPoint.y - size * sin(angle + .pi / 6)
            ))
            path.closeSubpath()
        }
    }
}

// MARK: - Preview

#if DEBUG
struct NetworkGraphView_Previews: PreviewProvider {
    static var nodes: [NetworkNode] = [
        NetworkNode(label: "User", value: 10, group: "core", color: .blue, icon: "person.fill"),
        NetworkNode(label: "API", value: 8, group: "core", color: .purple, icon: "cloud.fill"),
        NetworkNode(label: "Database", value: 6, group: "storage", color: .green, icon: "cylinder.fill"),
        NetworkNode(label: "Cache", value: 4, group: "storage", color: .orange, icon: "memorychip"),
        NetworkNode(label: "Analytics", value: 5, group: "services", color: .red, icon: "chart.bar.fill")
    ]
    
    static var edges: [NetworkEdge] {
        [
            NetworkEdge(source: nodes[0].id, target: nodes[1].id, weight: 5, label: "requests"),
            NetworkEdge(source: nodes[1].id, target: nodes[2].id, weight: 8),
            NetworkEdge(source: nodes[1].id, target: nodes[3].id, weight: 6, style: .dashed),
            NetworkEdge(source: nodes[1].id, target: nodes[4].id, weight: 3, style: .animated)
        ]
    }
    
    static var previews: some View {
        NetworkGraphView(
            nodes: .constant(nodes),
            edges: .constant(edges)
        )
        .frame(height: 400)
    }
}
#endif
