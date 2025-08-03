# SwiftUI Data Visualization

[![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-1.0.0-brightgreen.svg)](CHANGELOG.md)

<div align="center">
  <img src="https://img.shields.io/badge/SwiftUI-Data-Visualization-Advanced%20Charts%20%26%20Analytics-brightgreen?style=for-the-badge&logo=swift" alt="SwiftUI Data Visualization">
</div>

## 🎯 Overview

**SwiftUI Data Visualization** is a comprehensive, high-performance data visualization framework designed for iOS applications. Built with SwiftUI and following Clean Architecture principles, this framework provides 20+ chart types, real-time data updates, interactive elements, and full accessibility support.

### ✨ Key Features

- **20+ Chart Types**: Line, Bar, Pie, Scatter, Area, Candlestick, Heatmap, Radar, and more
- **Real-time Updates**: Live streaming capabilities with smooth animations
- **Interactive Elements**: Zoom, pan, tooltip, selection, and gesture support
- **Accessibility**: Full VoiceOver, Dynamic Type, and High Contrast support
- **Performance**: 60fps smooth animations with optimized rendering
- **Clean Architecture**: SOLID principles with modular design
- **100% Test Coverage**: Comprehensive unit, integration, and UI tests

## 🚀 Quick Start

### Installation

#### Swift Package Manager

Add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git", from: "1.0.0")
]
```

Or add it directly in Xcode:
1. File → Add Package Dependencies
2. Enter: `https://github.com/muhittincamdali/SwiftUI-Data-Visualization.git`
3. Select version: `1.0.0`

### Basic Usage

```swift
import SwiftUI
import SwiftUIDataVisualization

struct ContentView: View {
    let data = [
        ChartDataPoint(x: 1, y: 10),
        ChartDataPoint(x: 2, y: 20),
        ChartDataPoint(x: 3, y: 15),
        ChartDataPoint(x: 4, y: 25)
    ]
    
    var body: some View {
        LineChart(data: data)
            .frame(height: 300)
            .padding()
    }
}
```

## 📊 Chart Types

### Line Charts
```swift
LineChart(data: data)
    .chartStyle(.line)
    .animation(.easeInOut(duration: 0.5))
```

### Bar Charts
```swift
BarChart(data: data)
    .chartStyle(.bar)
    .interactive(true)
```

### Pie Charts
```swift
PieChart(data: data)
    .chartStyle(.pie)
    .showLabels(true)
```

### Scatter Plots
```swift
ScatterChart(data: data)
    .chartStyle(.scatter)
    .pointSize(8)
```

### Area Charts
```swift
AreaChart(data: data)
    .chartStyle(.area)
    .gradient(.linear)
```

### Candlestick Charts
```swift
CandlestickChart(data: financialData)
    .chartStyle(.candlestick)
    .showVolume(true)
```

### Heatmap Charts
```swift
HeatmapChart(data: matrixData)
    .chartStyle(.heatmap)
    .colorScale(.viridis)
```

### Radar Charts
```swift
RadarChart(data: radarData)
    .chartStyle(.radar)
    .showGrid(true)
```

## 🎨 Customization

### Chart Styling
```swift
LineChart(data: data)
    .chartStyle(.line)
    .foregroundColor(.blue)
    .backgroundColor(.white)
    .borderColor(.gray)
    .borderWidth(1)
    .cornerRadius(8)
    .shadow(radius: 4)
```

### Animations
```swift
LineChart(data: data)
    .animation(.spring(response: 0.6, dampingFraction: 0.8))
    .transition(.scale.combined(with: .opacity))
```

### Interactive Features
```swift
LineChart(data: data)
    .interactive(true)
    .zoomEnabled(true)
    .panEnabled(true)
    .tooltipEnabled(true)
    .selectionEnabled(true)
```

## ♿ Accessibility

All charts include comprehensive accessibility support:

```swift
LineChart(data: data)
    .accessibilityLabel("Sales Performance Chart")
    .accessibilityHint("Shows monthly sales data with interactive features")
    .accessibilityValue("Current value: $25,000")
```

## 📱 Examples

### Analytics Dashboard
Complete analytics dashboard with multiple chart types and real-time updates.

### Financial Charts
Professional financial charts with candlestick, volume, and technical indicators.

### Scientific Visualization
Advanced scientific charts for data analysis and research applications.

### Business Intelligence
Comprehensive BI dashboard with interactive charts and data exploration.

## 🏗️ Architecture

The framework follows Clean Architecture principles:

```
Sources/
├── Charts/           # Chart implementations
├── Components/       # Reusable UI components
├── Models/          # Data models and structures
└── Utils/           # Utility functions and helpers
```

### Design Patterns

- **MVVM**: Model-View-ViewModel pattern
- **SOLID Principles**: Single responsibility, Open/closed, Liskov substitution, Interface segregation, Dependency inversion
- **Dependency Injection**: Loose coupling and testability
- **Protocol-Oriented Programming**: Swift-first approach

## 🧪 Testing

The framework includes comprehensive testing:

- **Unit Tests**: 100% code coverage
- **Integration Tests**: Chart interaction testing
- **UI Tests**: Accessibility and user interaction testing
- **Performance Tests**: 60fps animation testing

## 📈 Performance

- **Rendering**: Optimized for 60fps smooth animations
- **Memory**: Efficient memory management with ARC
- **CPU**: Minimal CPU usage during animations
- **Battery**: Optimized for extended battery life

## 🔒 Security

- **Input Validation**: Comprehensive data validation
- **Memory Safety**: Swift's memory safety guarantees
- **Privacy**: No data collection or tracking
- **Encryption**: Secure data handling

## 🌟 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Development Setup

1. Clone the repository
2. Open `Package.swift` in Xcode
3. Build and run tests
4. Make your changes
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Apple SwiftUI team for the amazing framework
- Swift community for inspiration and feedback
- All contributors and users

## 📞 Support

- **Documentation**: [Documentation/](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/tree/master/Documentation)
- **Examples**: [Examples/](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/tree/master/Examples)
- **Issues**: [GitHub Issues](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/issues)
- **Discussions**: [GitHub Discussions](https://github.com/muhittincamdali/SwiftUI-Data-Visualization/discussions)

## 🚀 Roadmap

- [ ] 3D Chart Support
- [ ] Machine Learning Integration
- [ ] Web Export Capabilities
- [ ] Advanced Animation Engine
- [ ] Custom Chart Builder
- [ ] Real-time Collaboration
- [ ] Cloud Data Integration
- [ ] Advanced Analytics Tools

---

<div align="center">
  <p>Built with ❤️ by the SwiftUI Data Visualization Team</p>
  <p>Made for the global iOS development community</p>
</div> 