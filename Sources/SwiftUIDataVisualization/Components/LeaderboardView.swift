// LeaderboardView.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Leaderboard Data Models

/// Represents an entry in the leaderboard
public struct LeaderboardEntry: Identifiable, Equatable {
    public let id: UUID
    public let rank: Int
    public let name: String
    public let subtitle: String?
    public let score: Double
    public let previousRank: Int?
    public let avatarURL: URL?
    public let avatarInitials: String?
    public let color: Color
    public let badge: Badge?
    public let metadata: [String: String]
    
    public enum Badge: String {
        case gold = "🥇"
        case silver = "🥈"
        case bronze = "🥉"
        case crown = "👑"
        case star = "⭐"
        case fire = "🔥"
        case rocket = "🚀"
    }
    
    public var rankChange: RankChange {
        guard let previous = previousRank else { return .same }
        if rank < previous { return .up(previous - rank) }
        if rank > previous { return .down(rank - previous) }
        return .same
    }
    
    public enum RankChange {
        case up(Int)
        case down(Int)
        case same
    }
    
    public init(
        id: UUID = UUID(),
        rank: Int,
        name: String,
        subtitle: String? = nil,
        score: Double,
        previousRank: Int? = nil,
        avatarURL: URL? = nil,
        avatarInitials: String? = nil,
        color: Color = .blue,
        badge: Badge? = nil,
        metadata: [String: String] = [:]
    ) {
        self.id = id
        self.rank = rank
        self.name = name
        self.subtitle = subtitle
        self.score = score
        self.previousRank = previousRank
        self.avatarURL = avatarURL
        self.avatarInitials = avatarInitials ?? String(name.prefix(2))
        self.color = color
        self.badge = badge
        self.metadata = metadata
    }
    
    public static func == (lhs: LeaderboardEntry, rhs: LeaderboardEntry) -> Bool {
        lhs.id == rhs.id
    }
}

/// Configuration for leaderboard appearance
public struct LeaderboardConfiguration {
    public var style: LeaderboardStyle
    public var showRankChange: Bool
    public var showProgressBar: Bool
    public var showTopThreeSpecial: Bool
    public var scoreFormatter: ((Double) -> String)?
    public var animationDuration: Double
    public var maxVisibleEntries: Int?
    
    public enum LeaderboardStyle {
        case standard
        case compact
        case card
        case podium
    }
    
    public init(
        style: LeaderboardStyle = .standard,
        showRankChange: Bool = true,
        showProgressBar: Bool = true,
        showTopThreeSpecial: Bool = true,
        scoreFormatter: ((Double) -> String)? = nil,
        animationDuration: Double = 0.4,
        maxVisibleEntries: Int? = nil
    ) {
        self.style = style
        self.showRankChange = showRankChange
        self.showProgressBar = showProgressBar
        self.showTopThreeSpecial = showTopThreeSpecial
        self.scoreFormatter = scoreFormatter
        self.animationDuration = animationDuration
        self.maxVisibleEntries = maxVisibleEntries
    }
}

// MARK: - Leaderboard View

/// A customizable leaderboard visualization
public struct LeaderboardView: View {
    @Binding private var entries: [LeaderboardEntry]
    private let configuration: LeaderboardConfiguration
    private let onEntryTap: ((LeaderboardEntry) -> Void)?
    
    @State private var selectedEntry: LeaderboardEntry?
    @State private var animationProgress: CGFloat = 0
    
    private var visibleEntries: [LeaderboardEntry] {
        if let max = configuration.maxVisibleEntries {
            return Array(entries.prefix(max))
        }
        return entries
    }
    
    private var maxScore: Double {
        entries.map { $0.score }.max() ?? 1
    }
    
    public init(
        entries: Binding<[LeaderboardEntry]>,
        configuration: LeaderboardConfiguration = LeaderboardConfiguration(),
        onEntryTap: ((LeaderboardEntry) -> Void)? = nil
    ) {
        self._entries = entries
        self.configuration = configuration
        self.onEntryTap = onEntryTap
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if configuration.style == .podium && configuration.showTopThreeSpecial {
                podiumView
            }
            
            ScrollView {
                LazyVStack(spacing: configuration.style == .card ? 12 : 0) {
                    ForEach(Array(visibleEntries.enumerated()), id: \.element.id) { index, entry in
                        // Skip top 3 if showing podium
                        if !(configuration.style == .podium && configuration.showTopThreeSpecial && index < 3) {
                            entryRow(entry, index: index)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedEntry = entry
                                    }
                                    onEntryTap?(entry)
                                }
                        }
                    }
                }
                .padding(configuration.style == .card ? 16 : 0)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animationProgress = 1
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Leaderboard with \(entries.count) entries")
    }
    
    // MARK: - Podium View
    
    private var podiumView: some View {
        HStack(alignment: .bottom, spacing: 8) {
            // 2nd place
            if visibleEntries.count > 1 {
                podiumEntry(visibleEntries[1], height: 90, medal: "🥈")
            }
            
            // 1st place
            if visibleEntries.count > 0 {
                podiumEntry(visibleEntries[0], height: 120, medal: "🥇")
            }
            
            // 3rd place
            if visibleEntries.count > 2 {
                podiumEntry(visibleEntries[2], height: 70, medal: "🥉")
            }
        }
        .padding()
        .opacity(Double(animationProgress))
    }
    
    private func podiumEntry(_ entry: LeaderboardEntry, height: CGFloat, medal: String) -> some View {
        VStack(spacing: 8) {
            // Avatar
            ZStack {
                Circle()
                    .fill(entry.color.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Text(entry.avatarInitials ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(entry.color)
            }
            .overlay(
                Text(medal)
                    .font(.title2)
                    .offset(x: 25, y: -25)
            )
            
            // Name
            Text(entry.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
            
            // Score
            Text(formatScore(entry.score))
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Podium
            RoundedRectangle(cornerRadius: 8)
                .fill(
                    LinearGradient(
                        colors: [entry.color.opacity(0.8), entry.color.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: height)
                .overlay(
                    Text("#\(entry.rank)")
                        .font(.headline)
                        .foregroundColor(.white)
                )
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Entry Row
    
    @ViewBuilder
    private func entryRow(_ entry: LeaderboardEntry, index: Int) -> some View {
        switch configuration.style {
        case .standard:
            standardRow(entry, index: index)
        case .compact:
            compactRow(entry, index: index)
        case .card:
            cardRow(entry, index: index)
        case .podium:
            standardRow(entry, index: index)
        }
    }
    
    private func standardRow(_ entry: LeaderboardEntry, index: Int) -> some View {
        HStack(spacing: 12) {
            // Rank
            rankView(entry)
            
            // Avatar
            avatarView(entry)
            
            // Name and subtitle
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(entry.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if let badge = entry.badge {
                        Text(badge.rawValue)
                            .font(.caption)
                    }
                }
                
                if let subtitle = entry.subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Rank change
            if configuration.showRankChange {
                rankChangeView(entry.rankChange)
            }
            
            // Score
            VStack(alignment: .trailing, spacing: 2) {
                Text(formatScore(entry.score))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                if configuration.showProgressBar {
                    ProgressBar(value: entry.score / maxScore, color: entry.color)
                        .frame(width: 60, height: 4)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(selectedEntry?.id == entry.id ? entry.color.opacity(0.1) : Color.clear)
        .overlay(
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(height: 1),
            alignment: .bottom
        )
        .opacity(Double(animationProgress))
        .offset(x: (1 - animationProgress) * 30)
        .animation(.easeOut(duration: configuration.animationDuration).delay(Double(index) * 0.05), value: animationProgress)
    }
    
    private func compactRow(_ entry: LeaderboardEntry, index: Int) -> some View {
        HStack(spacing: 8) {
            Text("#\(entry.rank)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(entry.rank <= 3 ? rankColor(entry.rank) : .secondary)
                .frame(width: 30)
            
            Text(entry.name)
                .font(.subheadline)
                .foregroundColor(.primary)
                .lineLimit(1)
            
            Spacer()
            
            Text(formatScore(entry.score))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(index % 2 == 1 ? Color.gray.opacity(0.05) : Color.clear)
        .opacity(Double(animationProgress))
    }
    
    private func cardRow(_ entry: LeaderboardEntry, index: Int) -> some View {
        HStack(spacing: 12) {
            rankView(entry)
            avatarView(entry)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(entry.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    if let badge = entry.badge {
                        Text(badge.rawValue)
                    }
                }
                
                if configuration.showProgressBar {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.gray.opacity(0.2))
                            
                            RoundedRectangle(cornerRadius: 2)
                                .fill(entry.color)
                                .frame(width: geometry.size.width * (entry.score / maxScore))
                        }
                    }
                    .frame(height: 6)
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text(formatScore(entry.score))
                    .font(.headline)
                    .foregroundColor(.primary)
                
                if configuration.showRankChange {
                    rankChangeView(entry.rankChange)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: entry.color.opacity(selectedEntry?.id == entry.id ? 0.3 : 0.1), radius: 6, y: 2)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(selectedEntry?.id == entry.id ? entry.color : Color.clear, lineWidth: 2)
        )
        .opacity(Double(animationProgress))
        .scaleEffect(animationProgress)
        .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(Double(index) * 0.05), value: animationProgress)
    }
    
    // MARK: - Helper Views
    
    private func rankView(_ entry: LeaderboardEntry) -> some View {
        ZStack {
            if configuration.showTopThreeSpecial && entry.rank <= 3 {
                Circle()
                    .fill(rankColor(entry.rank).opacity(0.2))
                    .frame(width: 32, height: 32)
                
                Text(rankMedal(entry.rank))
                    .font(.system(size: 16))
            } else {
                Text("#\(entry.rank)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .frame(width: 32)
            }
        }
    }
    
    private func avatarView(_ entry: LeaderboardEntry) -> some View {
        ZStack {
            Circle()
                .fill(entry.color.opacity(0.2))
                .frame(width: 44, height: 44)
            
            Text(entry.avatarInitials ?? "")
                .font(.headline)
                .foregroundColor(entry.color)
        }
    }
    
    private func rankChangeView(_ change: LeaderboardEntry.RankChange) -> some View {
        HStack(spacing: 2) {
            switch change {
            case .up(let positions):
                Image(systemName: "arrow.up")
                    .font(.caption2)
                Text("+\(positions)")
                    .font(.caption)
            case .down(let positions):
                Image(systemName: "arrow.down")
                    .font(.caption2)
                Text("-\(positions)")
                    .font(.caption)
            case .same:
                Image(systemName: "minus")
                    .font(.caption2)
            }
        }
        .foregroundColor(rankChangeColor(change))
    }
    
    // MARK: - Helper Methods
    
    private func formatScore(_ score: Double) -> String {
        if let formatter = configuration.scoreFormatter {
            return formatter(score)
        }
        if score >= 1_000_000 {
            return String(format: "%.1fM", score / 1_000_000)
        } else if score >= 1_000 {
            return String(format: "%.1fK", score / 1_000)
        }
        return String(format: "%.0f", score)
    }
    
    private func rankColor(_ rank: Int) -> Color {
        switch rank {
        case 1: return .yellow
        case 2: return .gray
        case 3: return .orange
        default: return .blue
        }
    }
    
    private func rankMedal(_ rank: Int) -> String {
        switch rank {
        case 1: return "🥇"
        case 2: return "🥈"
        case 3: return "🥉"
        default: return ""
        }
    }
    
    private func rankChangeColor(_ change: LeaderboardEntry.RankChange) -> Color {
        switch change {
        case .up: return .green
        case .down: return .red
        case .same: return .gray
        }
    }
}

// MARK: - Progress Bar

private struct ProgressBar: View {
    let value: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.gray.opacity(0.2))
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(color)
                    .frame(width: geometry.size.width * min(max(value, 0), 1))
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct LeaderboardView_Previews: PreviewProvider {
    static var entries: [LeaderboardEntry] = [
        LeaderboardEntry(rank: 1, name: "Alice Johnson", subtitle: "Level 42", score: 15420, previousRank: 2, color: .purple, badge: .crown),
        LeaderboardEntry(rank: 2, name: "Bob Smith", subtitle: "Level 40", score: 14200, previousRank: 1, color: .blue, badge: .fire),
        LeaderboardEntry(rank: 3, name: "Carol Davis", subtitle: "Level 39", score: 13800, previousRank: 3, color: .green),
        LeaderboardEntry(rank: 4, name: "David Wilson", subtitle: "Level 38", score: 12500, previousRank: 6, color: .orange),
        LeaderboardEntry(rank: 5, name: "Eva Martinez", subtitle: "Level 37", score: 11200, previousRank: 4, color: .red)
    ]
    
    static var previews: some View {
        LeaderboardView(
            entries: .constant(entries),
            configuration: LeaderboardConfiguration(style: .podium)
        )
    }
}
#endif
