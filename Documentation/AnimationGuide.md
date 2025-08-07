# Animation Guide

## Overview

The Animation Guide provides comprehensive information on creating smooth, engaging animations for charts and data visualizations. This guide covers various animation types, timing functions, and best practices for optimal user experience.

## Core Animation Components

### ChartAnimation

```swift
public struct ChartAnimation {
    public var duration: TimeInterval
    public var curve: Animation.TimingCurve
    public var delay: TimeInterval
    public var repeatCount: Int
    public var autoreverses: Bool
    public var speed: Double
    
    public static let `default` = ChartAnimation(
        duration: 1.0,
        curve: .easeInOut,
        delay: 0.0,
        repeatCount: 1,
        autoreverses: false,
        speed: 1.0
    )
}
```

### Animation Types

```swift
public enum ChartAnimationType {
    case fade
    case scale
    case slide
    case rotate
    case morph
    case bounce
    case elastic
    case custom(Animation)
}
```

## Basic Animations

### Fade Animation

```swift
struct FadeAnimationExample: View {
    @State private var isVisible = false
    
    var body: some View {
        VStack {
            LineChart(data: data)
                .opacity(isVisible ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 1.0), value: isVisible)
                .frame(height: 300)
                .padding()
            
            Button("Animate") {
                isVisible.toggle()
            }
        }
        .onAppear {
            isVisible = true
        }
    }
}
```

### Scale Animation

```swift
struct ScaleAnimationExample: View {
    @State private var isScaled = false
    
    var body: some View {
        VStack {
            BarChart(data: data)
                .scaleEffect(isScaled ? 1.0 : 0.5)
                .animation(.spring(response: 0.5, dampingFraction: 0.6), value: isScaled)
                .frame(height: 300)
                .padding()
            
            Button("Scale") {
                isScaled.toggle()
            }
        }
        .onAppear {
            isScaled = true
        }
    }
}
```

### Slide Animation

```swift
struct SlideAnimationExample: View {
    @State private var offset: CGFloat = 300
    
    var body: some View {
        VStack {
            PieChart(data: data)
                .offset(x: offset)
                .animation(.easeInOut(duration: 1.0), value: offset)
                .frame(height: 300)
                .padding()
            
            Button("Slide") {
                offset = offset == 0 ? 300 : 0
            }
        }
        .onAppear {
            offset = 0
        }
    }
}
```

## Data-Driven Animations

### Progressive Data Loading

```swift
struct ProgressiveDataAnimation: View {
    @State private var displayedData: [DataPoint] = []
    @State private var currentIndex = 0
    
    let fullData: [DataPoint]
    
    var body: some View {
        VStack {
            LineChart(data: displayedData)
                .animation(.easeInOut(duration: 0.3), value: displayedData)
                .frame(height: 300)
                .padding()
            
            Button("Load More Data") {
                addNextDataPoint()
            }
        }
        .onAppear {
            startProgressiveLoading()
        }
    }
    
    private func startProgressiveLoading() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            addNextDataPoint()
            
            if currentIndex >= fullData.count {
                timer.invalidate()
            }
        }
    }
    
    private func addNextDataPoint() {
        guard currentIndex < fullData.count else { return }
        
        displayedData.append(fullData[currentIndex])
        currentIndex += 1
    }
}
```

### Value Change Animation

```swift
struct ValueChangeAnimation: View {
    @State private var animatedData: [DataPoint] = []
    
    var body: some View {
        VStack {
            BarChart(data: animatedData)
                .animation(.easeInOut(duration: 0.5), value: animatedData)
                .frame(height: 300)
                .padding()
            
            Button("Update Values") {
                updateValues()
            }
        }
        .onAppear {
            animatedData = initialData
        }
    }
    
    private func updateValues() {
        withAnimation {
            animatedData = animatedData.map { point in
                DataPoint(x: point.x, y: Double.random(in: 10...100))
            }
        }
    }
}
```

## Advanced Animations

### Morphing Animations

```swift
struct MorphingAnimation: View {
    @State private var chartType: ChartType = .line
    
    var body: some View {
        VStack {
            Group {
                switch chartType {
                case .line:
                    LineChart(data: data)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                case .bar:
                    BarChart(data: data)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                case .pie:
                    PieChart(data: data)
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                }
            }
            .animation(.easeInOut(duration: 0.8), value: chartType)
            .frame(height: 300)
            .padding()
            
            Button("Morph Chart") {
                withAnimation {
                    chartType = chartType.next()
                }
            }
        }
    }
}

enum ChartType: CaseIterable {
    case line, bar, pie
    
    func next() -> ChartType {
        let allCases = ChartType.allCases
        let currentIndex = allCases.firstIndex(of: self) ?? 0
        let nextIndex = (currentIndex + 1) % allCases.count
        return allCases[nextIndex]
    }
}
```

### Elastic Animations

```swift
struct ElasticAnimation: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack {
            LineChart(data: data)
                .scaleEffect(isAnimating ? 1.0 : 0.8)
                .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: isAnimating)
                .frame(height: 300)
                .padding()
            
            Button("Elastic Animation") {
                isAnimating.toggle()
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}
```

## Custom Animations

### Bezier Curve Animation

```swift
struct CustomBezierAnimation: View {
    @State private var progress: CGFloat = 0
    
    var body: some View {
        VStack {
            LineChart(data: data)
                .scaleEffect(1.0 + progress * 0.2)
                .rotationEffect(.degrees(progress * 10))
                .animation(.timingCurve(0.25, 0.46, 0.45, 0.94, duration: 2.0), value: progress)
                .frame(height: 300)
                .padding()
            
            Button("Custom Animation") {
                withAnimation {
                    progress = progress == 1.0 ? 0.0 : 1.0
                }
            }
        }
    }
}
```

### Staggered Animations

```swift
struct StaggeredAnimation: View {
    @State private var animationDelays: [Double] = []
    
    var body: some View {
        VStack {
            ForEach(Array(data.enumerated()), id: \.offset) { index, point in
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 20, height: point.y * 2)
                    .scaleEffect(animationDelays[index] > 0 ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.5).delay(animationDelays[index]), value: animationDelays[index])
            }
        }
        .onAppear {
            startStaggeredAnimation()
        }
    }
    
    private func startStaggeredAnimation() {
        for index in 0..<data.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.1) {
                animationDelays[index] = 1.0
            }
        }
    }
}
```

## Performance Optimization

### Animation Performance

```swift
extension Chart {
    public func optimizeAnimationPerformance() {
        // Use GPU-accelerated animations
        let optimizedAnimation = Animation.easeInOut(duration: 1.0)
            .speed(1.0)
            .repeatCount(1, autoreverses: false)
        
        // Apply optimized animation
        self.animation(optimizedAnimation)
    }
}
```

### Memory Management

```swift
extension Chart {
    public func manageAnimationMemory() {
        // Clean up animation resources
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Clear animation cache
            self.clearAnimationCache()
        }
    }
}
```

## Best Practices

1. **Use Appropriate Timing**: Choose timing curves that match the data
2. **Keep Animations Short**: Avoid long animations that may bore users
3. **Provide Visual Feedback**: Use animations to show data changes
4. **Optimize Performance**: Use GPU-accelerated animations when possible
5. **Consider Accessibility**: Ensure animations don't interfere with accessibility
6. **Test on Different Devices**: Verify animations work on various screen sizes
7. **Use Consistent Timing**: Maintain consistent animation timing across the app
8. **Provide Animation Controls**: Allow users to disable animations if needed
9. **Smooth Transitions**: Use smooth transitions between different chart states
10. **Memory Management**: Clean up animation resources to prevent memory leaks

## Error Handling

```swift
enum AnimationError: Error {
    case invalidDuration
    case unsupportedAnimationType
    case performanceIssue
    case memoryLeak
}

extension Chart {
    public func validateAnimation(_ animation: ChartAnimation) throws {
        guard animation.duration > 0 else {
            throw AnimationError.invalidDuration
        }
        
        guard animation.duration <= 10.0 else {
            throw AnimationError.performanceIssue
        }
    }
}
```

This comprehensive Animation Guide provides everything you need to create engaging, performant animations for your charts and data visualizations.
