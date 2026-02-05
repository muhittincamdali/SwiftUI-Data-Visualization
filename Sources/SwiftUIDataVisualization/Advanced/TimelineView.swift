// TimelineView.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Timeline Data Models

/// Represents a single event on the timeline
public struct TimelineEvent: Identifiable, Equatable {
    public let id: UUID
    public let date: Date
    public let title: String
    public let subtitle: String?
    public let icon: String?
    public let color: Color
    public let metadata: [String: String]
    
    public init(
        id: UUID = UUID(),
        date: Date,
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        color: Color = .blue,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.color = color
        self.metadata = metadata
    }
    
    public static func == (lhs: TimelineEvent, rhs: TimelineEvent) -> Bool {
        lhs.id == rhs.id
    }
}

/// Configuration for timeline appearance
public struct TimelineConfiguration {
    public var lineWidth: CGFloat
    public var nodeSize: CGFloat
    public var spacing: CGFloat
    public var dateFormat: String
    public var showConnectors: Bool
    public var animationDuration: Double
    public var orientation: TimelineOrientation
    public var style: TimelineStyle
    
    public init(
        lineWidth: CGFloat = 2,
        nodeSize: CGFloat = 12,
        spacing: CGFloat = 24,
        dateFormat: String = "MMM dd, yyyy",
        showConnectors: Bool = true,
        animationDuration: Double = 0.3,
        orientation: TimelineOrientation = .vertical,
        style: TimelineStyle = .modern
    ) {
        self.lineWidth = lineWidth
        self.nodeSize = nodeSize
        self.spacing = spacing
        self.dateFormat = dateFormat
        self.showConnectors = showConnectors
        self.animationDuration = animationDuration
        self.orientation = orientation
        self.style = style
    }
}

public enum TimelineOrientation {
    case vertical
    case horizontal
}

public enum TimelineStyle {
    case modern
    case classic
    case minimal
    case alternating
}

// MARK: - Timeline View

/// A beautiful, customizable timeline visualization
public struct TimelineView: View {
    @Binding private var events: [TimelineEvent]
    private let configuration: TimelineConfiguration
    private let onEventTap: ((TimelineEvent) -> Void)?
    
    @State private var selectedEvent: TimelineEvent?
    @State private var animationProgress: CGFloat = 0
    
    public init(
        events: Binding<[TimelineEvent]>,
        configuration: TimelineConfiguration = TimelineConfiguration(),
        onEventTap: ((TimelineEvent) -> Void)? = nil
    ) {
        self._events = events
        self.configuration = configuration
        self.onEventTap = onEventTap
    }
    
    public var body: some View {
        Group {
            switch configuration.orientation {
            case .vertical:
                verticalTimeline
            case .horizontal:
                horizontalTimeline
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animationProgress = 1
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Timeline with \(events.count) events")
    }
    
    private var verticalTimeline: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                    TimelineEventRow(
                        event: event,
                        isLast: index == events.count - 1,
                        isSelected: selectedEvent?.id == event.id,
                        configuration: configuration,
                        style: configuration.style,
                        alternateAlignment: configuration.style == .alternating && index % 2 == 1,
                        animationProgress: animationProgress
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedEvent = event
                        }
                        onEventTap?(event)
                    }
                }
            }
            .padding()
        }
    }
    
    private var horizontalTimeline: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: configuration.spacing) {
                ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                    HorizontalTimelineNode(
                        event: event,
                        isLast: index == events.count - 1,
                        isSelected: selectedEvent?.id == event.id,
                        configuration: configuration,
                        animationProgress: animationProgress
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedEvent = event
                        }
                        onEventTap?(event)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Timeline Event Row

private struct TimelineEventRow: View {
    let event: TimelineEvent
    let isLast: Bool
    let isSelected: Bool
    let configuration: TimelineConfiguration
    let style: TimelineStyle
    let alternateAlignment: Bool
    let animationProgress: CGFloat
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = configuration.dateFormat
        return formatter
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if alternateAlignment {
                eventContent
                    .frame(maxWidth: .infinity, alignment: .trailing)
                nodeAndLine
            } else {
                nodeAndLine
                eventContent
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .opacity(Double(animationProgress))
        .offset(x: alternateAlignment ? (1 - animationProgress) * 20 : (animationProgress - 1) * 20)
    }
    
    private var nodeAndLine: some View {
        VStack(spacing: 0) {
            // Node
            ZStack {
                Circle()
                    .fill(event.color.opacity(0.2))
                    .frame(width: configuration.nodeSize * 2, height: configuration.nodeSize * 2)
                    .scaleEffect(isSelected ? 1.2 : 1.0)
                
                Circle()
                    .fill(event.color)
                    .frame(width: configuration.nodeSize, height: configuration.nodeSize)
                
                if let icon = event.icon {
                    Image(systemName: icon)
                        .font(.system(size: configuration.nodeSize * 0.6))
                        .foregroundColor(.white)
                }
            }
            
            // Connector line
            if !isLast && configuration.showConnectors {
                Rectangle()
                    .fill(event.color.opacity(0.3))
                    .frame(width: configuration.lineWidth)
                    .frame(height: configuration.spacing * 3)
            }
        }
    }
    
    private var eventContent: some View {
        VStack(alignment: alternateAlignment ? .trailing : .leading, spacing: 4) {
            Text(dateFormatter.string(from: event.date))
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(event.title)
                .font(.headline)
                .foregroundColor(.primary)
            
            if let subtitle = event.subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            if !event.metadata.isEmpty {
                metadataView
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(isSelected ? event.color.opacity(0.1) : Color.clear)
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(event.title), \(dateFormatter.string(from: event.date))")
        .accessibilityHint(event.subtitle ?? "")
    }
    
    private var metadataView: some View {
        VStack(alignment: alternateAlignment ? .trailing : .leading, spacing: 2) {
            ForEach(Array(event.metadata.keys.sorted()), id: \.self) { key in
                if let value = event.metadata[key] {
                    HStack(spacing: 4) {
                        Text(key + ":")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        Text(value)
                            .font(.caption2)
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .padding(.top, 4)
    }
}

// MARK: - Horizontal Timeline Node

private struct HorizontalTimelineNode: View {
    let event: TimelineEvent
    let isLast: Bool
    let isSelected: Bool
    let configuration: TimelineConfiguration
    let animationProgress: CGFloat
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = configuration.dateFormat
        return formatter
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Event content
            VStack(spacing: 4) {
                Text(event.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                
                if let subtitle = event.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
            }
            .frame(width: 120)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? event.color.opacity(0.15) : Color(.systemBackground))
                    .shadow(color: event.color.opacity(0.2), radius: isSelected ? 8 : 4)
            )
            
            // Node and connector
            HStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(event.color)
                        .frame(width: configuration.nodeSize, height: configuration.nodeSize)
                    
                    if let icon = event.icon {
                        Image(systemName: icon)
                            .font(.system(size: configuration.nodeSize * 0.5))
                            .foregroundColor(.white)
                    }
                }
                
                if !isLast && configuration.showConnectors {
                    Rectangle()
                        .fill(event.color.opacity(0.3))
                        .frame(width: 40, height: configuration.lineWidth)
                }
            }
            
            // Date
            Text(dateFormatter.string(from: event.date))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .opacity(Double(animationProgress))
        .scaleEffect(animationProgress)
    }
}

// MARK: - Preview

#if DEBUG
struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        TimelineView(
            events: .constant([
                TimelineEvent(
                    date: Date().addingTimeInterval(-86400 * 30),
                    title: "Project Started",
                    subtitle: "Initial planning and requirements gathering",
                    icon: "star.fill",
                    color: .blue
                ),
                TimelineEvent(
                    date: Date().addingTimeInterval(-86400 * 20),
                    title: "Design Phase",
                    subtitle: "UI/UX design completed",
                    icon: "paintbrush.fill",
                    color: .purple
                ),
                TimelineEvent(
                    date: Date().addingTimeInterval(-86400 * 10),
                    title: "Development",
                    subtitle: "Core features implemented",
                    icon: "hammer.fill",
                    color: .orange
                ),
                TimelineEvent(
                    date: Date(),
                    title: "Launch",
                    subtitle: "Product released to production",
                    icon: "rocket.fill",
                    color: .green
                )
            ])
        )
    }
}
#endif
