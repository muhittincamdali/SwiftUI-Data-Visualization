import SwiftUI

/// Main entry point for the SwiftUI Data Visualization toolkit.
public enum SwiftUIDataVisualization {
    public static let version = "2.0.0"
}

/// A base protocol for visualizable data.
public protocol Visualizable: Sendable {
    var value: Double { get }
    var color: Color { get }
}
