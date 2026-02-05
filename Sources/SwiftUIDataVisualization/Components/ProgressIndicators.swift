// ProgressIndicators.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI

// MARK: - Progress Data Model

/// Configuration for progress indicators
public struct ProgressConfiguration {
    public var animationDuration: Double
    public var showPercentage: Bool
    public var showLabel: Bool
    public var trackColor: Color
    public var gradientColors: [Color]?
    
    public init(
        animationDuration: Double = 0.8,
        showPercentage: Bool = true,
        showLabel: Bool = true,
        trackColor: Color = Color.gray.opacity(0.2),
        gradientColors: [Color]? = nil
    ) {
        self.animationDuration = animationDuration
        self.showPercentage = showPercentage
        self.showLabel = showLabel
        self.trackColor = trackColor
        self.gradientColors = gradientColors
    }
}

// MARK: - Circular Progress

/// A circular progress indicator with customizable appearance
public struct CircularProgressView: View {
    let value: Double
    let total: Double
    let label: String?
    let color: Color
    let lineWidth: CGFloat
    let configuration: ProgressConfiguration
    
    @State private var animatedValue: Double = 0
    
    public init(
        value: Double,
        total: Double = 100,
        label: String? = nil,
        color: Color = .blue,
        lineWidth: CGFloat = 12,
        configuration: ProgressConfiguration = ProgressConfiguration()
    ) {
        self.value = value
        self.total = total
        self.label = label
        self.color = color
        self.lineWidth = lineWidth
        self.configuration = configuration
    }
    
    private var progress: Double {
        min(max(animatedValue / total, 0), 1)
    }
    
    public var body: some View {
        ZStack {
            // Track
            Circle()
                .stroke(configuration.trackColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            
            // Progress
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    configuration.gradientColors != nil ?
                    AngularGradient(colors: configuration.gradientColors!, center: .center) :
                    AngularGradient(colors: [color, color.opacity(0.7)], center: .center),
                    style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .shadow(color: color.opacity(0.3), radius: 4)
            
            // Center content
            VStack(spacing: 4) {
                if configuration.showPercentage {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: lineWidth * 2, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                }
                
                if configuration.showLabel, let label = label {
                    Text(label)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedValue = value
            }
        }
        .onChange(of: value) { newValue in
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedValue = newValue
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label ?? "Progress"): \(Int(progress * 100)) percent")
    }
}

// MARK: - Linear Progress

/// A linear progress bar with customizable appearance
public struct LinearProgressView: View {
    let value: Double
    let total: Double
    let label: String?
    let color: Color
    let height: CGFloat
    let configuration: ProgressConfiguration
    
    @State private var animatedValue: Double = 0
    
    public init(
        value: Double,
        total: Double = 100,
        label: String? = nil,
        color: Color = .blue,
        height: CGFloat = 8,
        configuration: ProgressConfiguration = ProgressConfiguration()
    ) {
        self.value = value
        self.total = total
        self.label = label
        self.color = color
        self.height = height
        self.configuration = configuration
    }
    
    private var progress: Double {
        min(max(animatedValue / total, 0), 1)
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if configuration.showLabel || configuration.showPercentage {
                HStack {
                    if configuration.showLabel, let label = label {
                        Text(label)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    if configuration.showPercentage {
                        Text("\(Int(progress * 100))%")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Track
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(configuration.trackColor)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(
                            configuration.gradientColors != nil ?
                            LinearGradient(colors: configuration.gradientColors!, startPoint: .leading, endPoint: .trailing) :
                            LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .leading, endPoint: .trailing)
                        )
                        .frame(width: geometry.size.width * progress)
                        .shadow(color: color.opacity(0.3), radius: 2)
                }
            }
            .frame(height: height)
        }
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedValue = value
            }
        }
        .onChange(of: value) { newValue in
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedValue = newValue
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label ?? "Progress"): \(Int(progress * 100)) percent")
    }
}

// MARK: - Segmented Progress

/// A segmented progress indicator showing multiple steps
public struct SegmentedProgressView: View {
    let currentStep: Int
    let totalSteps: Int
    let labels: [String]?
    let colors: [Color]
    let configuration: ProgressConfiguration
    
    @State private var animatedStep: Int = 0
    
    public init(
        currentStep: Int,
        totalSteps: Int,
        labels: [String]? = nil,
        colors: [Color] = [.blue],
        configuration: ProgressConfiguration = ProgressConfiguration()
    ) {
        self.currentStep = currentStep
        self.totalSteps = totalSteps
        self.labels = labels
        self.colors = colors
        self.configuration = configuration
    }
    
    public var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                ForEach(0..<totalSteps, id: \.self) { step in
                    SegmentView(
                        step: step,
                        isCompleted: step < animatedStep,
                        isCurrent: step == animatedStep,
                        color: colors[step % colors.count]
                    )
                    
                    if step < totalSteps - 1 {
                        ConnectorLine(isActive: step < animatedStep)
                    }
                }
            }
            
            if let labels = labels, !labels.isEmpty {
                HStack(spacing: 8) {
                    ForEach(0..<totalSteps, id: \.self) { step in
                        if step < labels.count {
                            Text(labels[step])
                                .font(.caption)
                                .foregroundColor(step <= animatedStep ? .primary : .secondary)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedStep = currentStep
            }
        }
        .onChange(of: currentStep) { newValue in
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedStep = newValue
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Step \(currentStep + 1) of \(totalSteps)")
    }
}

private struct SegmentView: View {
    let step: Int
    let isCompleted: Bool
    let isCurrent: Bool
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .fill(isCompleted || isCurrent ? color : Color.gray.opacity(0.3))
                .frame(width: 32, height: 32)
                .shadow(color: isCurrent ? color.opacity(0.4) : .clear, radius: 4)
            
            if isCompleted {
                Image(systemName: "checkmark")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Text("\(step + 1)")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isCurrent ? .white : .secondary)
            }
        }
    }
}

private struct ConnectorLine: View {
    let isActive: Bool
    
    var body: some View {
        Rectangle()
            .fill(isActive ? Color.blue : Color.gray.opacity(0.3))
            .frame(height: 2)
    }
}

// MARK: - Radial Progress

/// A radial progress indicator with multiple rings
public struct RadialProgressView: View {
    let values: [(label: String, value: Double, color: Color)]
    let configuration: ProgressConfiguration
    
    @State private var animatedValues: [Double] = []
    
    public init(
        values: [(label: String, value: Double, color: Color)],
        configuration: ProgressConfiguration = ProgressConfiguration()
    ) {
        self.values = values
        self.configuration = configuration
    }
    
    public var body: some View {
        ZStack {
            ForEach(values.indices, id: \.self) { index in
                let ringIndex = values.count - 1 - index
                let size = CGFloat(80 + ringIndex * 40)
                let lineWidth: CGFloat = 12
                
                ZStack {
                    // Track
                    Circle()
                        .stroke(configuration.trackColor, lineWidth: lineWidth)
                    
                    // Progress
                    Circle()
                        .trim(from: 0, to: progress(for: index))
                        .stroke(values[index].color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .shadow(color: values[index].color.opacity(0.3), radius: 3)
                }
                .frame(width: size, height: size)
            }
        }
        .onAppear {
            animatedValues = Array(repeating: 0, count: values.count)
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedValues = values.map { $0.value }
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Radial progress with \(values.count) metrics")
    }
    
    private func progress(for index: Int) -> Double {
        guard index < animatedValues.count else { return 0 }
        return min(max(animatedValues[index] / 100, 0), 1)
    }
}

// MARK: - Wave Progress

/// A wave-style progress indicator
public struct WaveProgressView: View {
    let value: Double
    let color: Color
    let configuration: ProgressConfiguration
    
    @State private var animatedValue: Double = 0
    @State private var waveOffset: CGFloat = 0
    
    public init(
        value: Double,
        color: Color = .blue,
        configuration: ProgressConfiguration = ProgressConfiguration()
    ) {
        self.value = value
        self.color = color
        self.configuration = configuration
    }
    
    private var progress: Double {
        min(max(animatedValue / 100, 0), 1)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Container
                Circle()
                    .stroke(configuration.trackColor, lineWidth: 4)
                
                // Wave
                WaveShape(progress: progress, offset: waveOffset)
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .clipShape(Circle())
                
                // Percentage
                if configuration.showPercentage {
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: geometry.size.width * 0.2, weight: .bold, design: .rounded))
                        .foregroundColor(progress > 0.5 ? .white : .primary)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedValue = value
            }
            withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                waveOffset = 360
            }
        }
        .onChange(of: value) { newValue in
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedValue = newValue
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress: \(Int(progress * 100)) percent")
    }
}

private struct WaveShape: Shape {
    var progress: Double
    var offset: CGFloat
    
    var animatableData: AnimatablePair<Double, CGFloat> {
        get { AnimatablePair(progress, offset) }
        set {
            progress = newValue.first
            offset = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        let waterLevel = rect.height * (1 - progress)
        let waveHeight: CGFloat = 8
        let wavelength = rect.width / 2
        
        return Path { path in
            path.move(to: CGPoint(x: 0, y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: waterLevel))
            
            for x in stride(from: 0, through: rect.width, by: 1) {
                let relativeX = x / wavelength
                let sine = sin((relativeX + offset / 180) * .pi)
                let y = waterLevel + sine * waveHeight
                path.addLine(to: CGPoint(x: x, y: y))
            }
            
            path.addLine(to: CGPoint(x: rect.width, y: rect.height))
            path.closeSubpath()
        }
    }
}

// MARK: - Gauge Progress

/// A gauge-style progress indicator
public struct GaugeProgressView: View {
    let value: Double
    let minValue: Double
    let maxValue: Double
    let label: String?
    let color: Color
    let configuration: ProgressConfiguration
    
    @State private var animatedValue: Double = 0
    
    public init(
        value: Double,
        minValue: Double = 0,
        maxValue: Double = 100,
        label: String? = nil,
        color: Color = .blue,
        configuration: ProgressConfiguration = ProgressConfiguration()
    ) {
        self.value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.label = label
        self.color = color
        self.configuration = configuration
    }
    
    private var progress: Double {
        let range = maxValue - minValue
        return min(max((animatedValue - minValue) / range, 0), 1)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)
            
            ZStack {
                // Track
                GaugeArc(progress: 1)
                    .stroke(configuration.trackColor, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                
                // Progress
                GaugeArc(progress: progress)
                    .stroke(
                        AngularGradient(
                            colors: [color.opacity(0.5), color],
                            center: .center,
                            startAngle: .degrees(135),
                            endAngle: .degrees(135 + 270 * progress)
                        ),
                        style: StrokeStyle(lineWidth: 16, lineCap: .round)
                    )
                    .shadow(color: color.opacity(0.3), radius: 4)
                
                // Needle indicator
                NeedleView(progress: progress, size: size)
                    .foregroundColor(color)
                
                // Center content
                VStack(spacing: 4) {
                    Text(String(format: "%.0f", animatedValue))
                        .font(.system(size: size * 0.2, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    if let label = label {
                        Text(label)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .offset(y: size * 0.1)
                
                // Min/Max labels
                HStack {
                    Text(String(format: "%.0f", minValue))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(String(format: "%.0f", maxValue))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .offset(y: size * 0.35)
            }
        }
        .aspectRatio(1.5, contentMode: .fit)
        .onAppear {
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedValue = value
            }
        }
        .onChange(of: value) { newValue in
            withAnimation(.easeOut(duration: configuration.animationDuration)) {
                animatedValue = newValue
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(label ?? "Gauge"): \(Int(animatedValue))")
    }
}

private struct GaugeArc: Shape {
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY + rect.height * 0.1)
        let radius = min(rect.width, rect.height) * 0.4
        
        return Path { path in
            path.addArc(
                center: center,
                radius: radius,
                startAngle: .degrees(135),
                endAngle: .degrees(135 + 270 * progress),
                clockwise: false
            )
        }
    }
}

private struct NeedleView: View {
    let progress: Double
    let size: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .frame(width: 4, height: size * 0.25)
            Circle()
                .frame(width: 12, height: 12)
        }
        .rotationEffect(.degrees(-135 + 270 * progress))
        .offset(y: size * 0.1)
    }
}

// MARK: - Preview

#if DEBUG
struct ProgressIndicators_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 40) {
                CircularProgressView(value: 75, label: "Storage")
                    .frame(width: 120, height: 120)
                
                LinearProgressView(value: 65, label: "Download Progress")
                    .padding(.horizontal)
                
                SegmentedProgressView(
                    currentStep: 2,
                    totalSteps: 4,
                    labels: ["Cart", "Shipping", "Payment", "Confirm"]
                )
                .padding(.horizontal)
                
                RadialProgressView(values: [
                    ("Move", 80, .red),
                    ("Exercise", 60, .green),
                    ("Stand", 90, .blue)
                ])
                .frame(width: 200, height: 200)
                
                WaveProgressView(value: 65)
                    .frame(width: 120, height: 120)
                
                GaugeProgressView(value: 72, maxValue: 100, label: "Speed")
                    .frame(width: 200)
            }
            .padding()
        }
    }
}
#endif
