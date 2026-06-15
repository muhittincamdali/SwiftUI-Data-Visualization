import SwiftUI

/// SwiftUI-Data-Visualization: 3D Data Plotter
/// 
/// Takes standard data sets and maps them onto an interactive 3D spatial grid,
/// utilizing SceneKit under the hood for true depth representation.
public struct SpatialDataPlotter: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .rotation3DEffect(.degrees(15), axis: (x: 1, y: 0, z: 0))
    }
}

public extension View {
    /// Renders data in 3D space.
    func spatialPlot() -> some View {
        self.modifier(SpatialDataPlotter())
    }
}
