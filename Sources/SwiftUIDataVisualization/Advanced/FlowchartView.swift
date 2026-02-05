// FlowchartView.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Flowchart Data Models

/// Represents a node in the flowchart
public struct FlowchartNode: Identifiable, Equatable {
    public let id: UUID
    public let title: String
    public let subtitle: String?
    public let type: NodeType
    public let position: CGPoint
    public let size: CGSize
    public let color: Color
    public let icon: String?
    
    public enum NodeType: String, CaseIterable {
        case start
        case end
        case process
        case decision
        case data
        case connector
        case custom
    }
    
    public init(
        id: UUID = UUID(),
        title: String,
        subtitle: String? = nil,
        type: NodeType = .process,
        position: CGPoint = .zero,
        size: CGSize = CGSize(width: 150, height: 60),
        color: Color = .blue,
        icon: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.type = type
        self.position = position
        self.size = size
        self.color = color
        self.icon = icon
    }
    
    public static func == (lhs: FlowchartNode, rhs: FlowchartNode) -> Bool {
        lhs.id == rhs.id
    }
}

/// Represents a connection between two nodes
public struct FlowchartConnection: Identifiable, Equatable {
    public let id: UUID
    public let fromNodeId: UUID
    public let toNodeId: UUID
    public let label: String?
    public let style: ConnectionStyle
    public let color: Color
    
    public enum ConnectionStyle {
        case straight
        case curved
        case orthogonal
        case dashed
    }
    
    public init(
        id: UUID = UUID(),
        from: UUID,
        to: UUID,
        label: String? = nil,
        style: ConnectionStyle = .curved,
        color: Color = .gray
    ) {
        self.id = id
        self.fromNodeId = from
        self.toNodeId = to
        self.label = label
        self.style = style
        self.color = color
    }
    
    public static func == (lhs: FlowchartConnection, rhs: FlowchartConnection) -> Bool {
        lhs.id == rhs.id
    }
}

/// Configuration for flowchart appearance
public struct FlowchartConfiguration {
    public var gridSize: CGFloat
    public var snapToGrid: Bool
    public var showGrid: Bool
    public var arrowSize: CGFloat
    public var connectionLineWidth: CGFloat
    public var allowDragging: Bool
    public var animationDuration: Double
    
    public init(
        gridSize: CGFloat = 20,
        snapToGrid: Bool = true,
        showGrid: Bool = false,
        arrowSize: CGFloat = 10,
        connectionLineWidth: CGFloat = 2,
        allowDragging: Bool = true,
        animationDuration: Double = 0.3
    ) {
        self.gridSize = gridSize
        self.snapToGrid = snapToGrid
        self.showGrid = showGrid
        self.arrowSize = arrowSize
        self.connectionLineWidth = connectionLineWidth
        self.allowDragging = allowDragging
        self.animationDuration = animationDuration
    }
}

// MARK: - Flowchart View

/// A flexible, interactive flowchart visualization
public struct FlowchartView: View {
    @Binding private var nodes: [FlowchartNode]
    @Binding private var connections: [FlowchartConnection]
    private let configuration: FlowchartConfiguration
    private let onNodeTap: ((FlowchartNode) -> Void)?
    private let onNodeDrag: ((FlowchartNode, CGPoint) -> Void)?
    
    @State private var selectedNode: FlowchartNode?
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var animationProgress: CGFloat = 0
    
    public init(
        nodes: Binding<[FlowchartNode]>,
        connections: Binding<[FlowchartConnection]>,
        configuration: FlowchartConfiguration = FlowchartConfiguration(),
        onNodeTap: ((FlowchartNode) -> Void)? = nil,
        onNodeDrag: ((FlowchartNode, CGPoint) -> Void)? = nil
    ) {
        self._nodes = nodes
        self._connections = connections
        self.configuration = configuration
        self.onNodeTap = onNodeTap
        self.onNodeDrag = onNodeDrag
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background grid
                if configuration.showGrid {
                    GridBackground(gridSize: configuration.gridSize)
                }
                
                // Connections layer
                ForEach(connections) { connection in
                    ConnectionView(
                        connection: connection,
                        fromNode: nodes.first { $0.id == connection.fromNodeId },
                        toNode: nodes.first { $0.id == connection.toNodeId },
                        configuration: configuration,
                        animationProgress: animationProgress
                    )
                }
                
                // Nodes layer
                ForEach(nodes) { node in
                    FlowchartNodeView(
                        node: node,
                        isSelected: selectedNode?.id == node.id,
                        configuration: configuration,
                        animationProgress: animationProgress
                    )
                    .position(x: node.position.x + offset.width, y: node.position.y + offset.height)
                    .scaleEffect(scale)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedNode = node
                        }
                        onNodeTap?(node)
                    }
                    .gesture(
                        configuration.allowDragging ?
                        DragGesture()
                            .onChanged { value in
                                onNodeDrag?(node, CGPoint(x: value.location.x, y: value.location.y))
                            }
                        : nil
                    )
                }
            }
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        scale = max(0.5, min(2.0, value))
                    }
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if selectedNode == nil {
                            offset = value.translation
                        }
                    }
                    .onEnded { _ in
                        if selectedNode == nil {
                            offset = .zero
                        }
                    }
            )
        }
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animationProgress = 1
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Flowchart with \(nodes.count) nodes and \(connections.count) connections")
    }
}

// MARK: - Grid Background

private struct GridBackground: View {
    let gridSize: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let columns = Int(geometry.size.width / gridSize)
                let rows = Int(geometry.size.height / gridSize)
                
                for col in 0...columns {
                    let x = CGFloat(col) * gridSize
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                for row in 0...rows {
                    let y = CGFloat(row) * gridSize
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
        }
    }
}

// MARK: - Flowchart Node View

private struct FlowchartNodeView: View {
    let node: FlowchartNode
    let isSelected: Bool
    let configuration: FlowchartConfiguration
    let animationProgress: CGFloat
    
    var body: some View {
        ZStack {
            nodeShape
                .fill(node.color.opacity(0.15))
                .overlay(nodeShape.stroke(node.color, lineWidth: isSelected ? 3 : 2))
                .shadow(color: node.color.opacity(isSelected ? 0.4 : 0.2), radius: isSelected ? 8 : 4)
            
            VStack(spacing: 4) {
                if let icon = node.icon {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(node.color)
                }
                
                Text(node.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                if let subtitle = node.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(8)
        }
        .frame(width: node.size.width, height: node.size.height)
        .opacity(Double(animationProgress))
        .scaleEffect(animationProgress)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(node.type.rawValue.capitalized): \(node.title)")
        .accessibilityHint(node.subtitle ?? "")
    }
    
    @ViewBuilder
    private var nodeShape: some Shape {
        switch node.type {
        case .start, .end:
            RoundedRectangle(cornerRadius: node.size.height / 2)
        case .process:
            RoundedRectangle(cornerRadius: 8)
        case .decision:
            Diamond()
        case .data:
            Parallelogram()
        case .connector:
            Circle()
        case .custom:
            RoundedRectangle(cornerRadius: 12)
        }
    }
}

// MARK: - Connection View

private struct ConnectionView: View {
    let connection: FlowchartConnection
    let fromNode: FlowchartNode?
    let toNode: FlowchartNode?
    let configuration: FlowchartConfiguration
    let animationProgress: CGFloat
    
    var body: some View {
        if let from = fromNode, let to = toNode {
            ZStack {
                connectionPath(from: from, to: to)
                    .stroke(
                        connection.color,
                        style: StrokeStyle(
                            lineWidth: configuration.connectionLineWidth,
                            lineCap: .round,
                            lineJoin: .round,
                            dash: connection.style == .dashed ? [5, 5] : []
                        )
                    )
                    .opacity(Double(animationProgress))
                
                // Arrow head
                arrowHead(from: from, to: to)
                    .fill(connection.color)
                    .opacity(Double(animationProgress))
                
                // Label
                if let label = connection.label {
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(4)
                        .background(Color(.systemBackground).opacity(0.8))
                        .cornerRadius(4)
                        .position(midpoint(from: from, to: to))
                        .opacity(Double(animationProgress))
                }
            }
        }
    }
    
    private func connectionPath(from: FlowchartNode, to: FlowchartNode) -> Path {
        let start = from.position
        let end = to.position
        
        return Path { path in
            path.move(to: start)
            
            switch connection.style {
            case .straight, .dashed:
                path.addLine(to: end)
            case .curved:
                let control1 = CGPoint(x: start.x, y: (start.y + end.y) / 2)
                let control2 = CGPoint(x: end.x, y: (start.y + end.y) / 2)
                path.addCurve(to: end, control1: control1, control2: control2)
            case .orthogonal:
                let midY = (start.y + end.y) / 2
                path.addLine(to: CGPoint(x: start.x, y: midY))
                path.addLine(to: CGPoint(x: end.x, y: midY))
                path.addLine(to: end)
            }
        }
    }
    
    private func arrowHead(from: FlowchartNode, to: FlowchartNode) -> Path {
        let end = to.position
        let angle = atan2(end.y - from.position.y, end.x - from.position.x)
        let size = configuration.arrowSize
        
        return Path { path in
            path.move(to: end)
            path.addLine(to: CGPoint(
                x: end.x - size * cos(angle - .pi / 6),
                y: end.y - size * sin(angle - .pi / 6)
            ))
            path.addLine(to: CGPoint(
                x: end.x - size * cos(angle + .pi / 6),
                y: end.y - size * sin(angle + .pi / 6)
            ))
            path.closeSubpath()
        }
    }
    
    private func midpoint(from: FlowchartNode, to: FlowchartNode) -> CGPoint {
        CGPoint(
            x: (from.position.x + to.position.x) / 2,
            y: (from.position.y + to.position.y) / 2
        )
    }
}

// MARK: - Custom Shapes

/// Diamond shape for decision nodes
private struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.closeSubpath()
        }
    }
}

/// Parallelogram shape for data nodes
private struct Parallelogram: Shape {
    func path(in rect: CGRect) -> Path {
        let offset = rect.width * 0.15
        return Path { path in
            path.move(to: CGPoint(x: rect.minX + offset, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - offset, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

// MARK: - Preview

#if DEBUG
struct FlowchartView_Previews: PreviewProvider {
    static var previews: some View {
        let startNode = FlowchartNode(
            title: "Start",
            type: .start,
            position: CGPoint(x: 200, y: 50),
            color: .green,
            icon: "play.fill"
        )
        let processNode = FlowchartNode(
            title: "Process Data",
            subtitle: "Transform input",
            type: .process,
            position: CGPoint(x: 200, y: 150),
            color: .blue
        )
        let decisionNode = FlowchartNode(
            title: "Valid?",
            type: .decision,
            position: CGPoint(x: 200, y: 280),
            size: CGSize(width: 100, height: 80),
            color: .orange
        )
        let endNode = FlowchartNode(
            title: "End",
            type: .end,
            position: CGPoint(x: 200, y: 400),
            color: .red,
            icon: "stop.fill"
        )
        
        FlowchartView(
            nodes: .constant([startNode, processNode, decisionNode, endNode]),
            connections: .constant([
                FlowchartConnection(from: startNode.id, to: processNode.id),
                FlowchartConnection(from: processNode.id, to: decisionNode.id),
                FlowchartConnection(from: decisionNode.id, to: endNode.id, label: "Yes")
            ]),
            configuration: FlowchartConfiguration(showGrid: true)
        )
    }
}
#endif
