// ChartExporter.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Export Format

/// Supported export formats
public enum ExportFormat {
    case png
    case jpeg(quality: CGFloat)
    case pdf
    case svg
    case csv
    case json
}

/// Export quality/resolution settings
public enum ExportQuality {
    case standard    // 1x
    case high        // 2x
    case print       // 3x
    
    var scale: CGFloat {
        switch self {
        case .standard: return 1.0
        case .high: return 2.0
        case .print: return 3.0
        }
    }
}

// MARK: - Chart Exporter

/// Utility for exporting charts to various formats
public struct ChartExporter {
    
    // MARK: - Image Export
    
    #if canImport(UIKit)
    /// Export a SwiftUI view to UIImage
    @MainActor
    public static func exportToImage<V: View>(
        view: V,
        size: CGSize,
        quality: ExportQuality = .high
    ) -> UIImage? {
        let controller = UIHostingController(rootView: view)
        let view = controller.view
        
        let targetSize = CGSize(
            width: size.width * quality.scale,
            height: size.height * quality.scale
        )
        
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        
        return renderer.image { _ in
            view?.drawHierarchy(in: CGRect(origin: .zero, size: targetSize), afterScreenUpdates: true)
        }
    }
    
    /// Export view to PNG data
    @MainActor
    public static func exportToPNG<V: View>(
        view: V,
        size: CGSize,
        quality: ExportQuality = .high
    ) -> Data? {
        guard let image = exportToImage(view: view, size: size, quality: quality) else {
            return nil
        }
        return image.pngData()
    }
    
    /// Export view to JPEG data
    @MainActor
    public static func exportToJPEG<V: View>(
        view: V,
        size: CGSize,
        quality: ExportQuality = .high,
        compressionQuality: CGFloat = 0.9
    ) -> Data? {
        guard let image = exportToImage(view: view, size: size, quality: quality) else {
            return nil
        }
        return image.jpegData(compressionQuality: compressionQuality)
    }
    #endif
    
    // MARK: - PDF Export
    
    #if canImport(UIKit)
    /// Export view to PDF data
    @MainActor
    public static func exportToPDF<V: View>(
        view: V,
        size: CGSize,
        title: String? = nil,
        author: String? = nil
    ) -> Data? {
        let controller = UIHostingController(rootView: view)
        let targetView = controller.view!
        
        targetView.bounds = CGRect(origin: .zero, size: size)
        targetView.backgroundColor = .white
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: size))
        
        let data = pdfRenderer.pdfData { context in
            context.beginPage()
            targetView.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
        }
        
        return data
    }
    #endif
    
    // MARK: - Data Export
    
    /// Export data to CSV format
    public static func exportToCSV<T>(
        data: [T],
        columns: [(name: String, keyPath: KeyPath<T, CustomStringConvertible>)],
        separator: String = ",",
        includeHeader: Bool = true
    ) -> String {
        var lines: [String] = []
        
        // Header
        if includeHeader {
            let header = columns.map { $0.name }.joined(separator: separator)
            lines.append(header)
        }
        
        // Data rows
        for item in data {
            let values = columns.map { column in
                let value = item[keyPath: column.keyPath]
                let stringValue = String(describing: value)
                // Escape values containing separator or quotes
                if stringValue.contains(separator) || stringValue.contains("\"") {
                    return "\"\(stringValue.replacingOccurrences(of: "\"", with: "\"\""))\""
                }
                return stringValue
            }
            lines.append(values.joined(separator: separator))
        }
        
        return lines.joined(separator: "\n")
    }
    
    /// Export data to JSON format
    public static func exportToJSON<T: Encodable>(
        data: [T],
        prettyPrinted: Bool = true
    ) -> String? {
        let encoder = JSONEncoder()
        if prettyPrinted {
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        }
        
        guard let jsonData = try? encoder.encode(data) else {
            return nil
        }
        
        return String(data: jsonData, encoding: .utf8)
    }
    
    // MARK: - SVG Export (Basic)
    
    /// Generate basic SVG for simple charts
    public static func exportToSVG(
        size: CGSize,
        backgroundColor: String = "#ffffff",
        content: String
    ) -> String {
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <svg xmlns="http://www.w3.org/2000/svg" 
             width="\(Int(size.width))" 
             height="\(Int(size.height))" 
             viewBox="0 0 \(Int(size.width)) \(Int(size.height))">
            <rect width="100%" height="100%" fill="\(backgroundColor)"/>
            \(content)
        </svg>
        """
    }
    
    /// Generate SVG line path
    public static func svgLinePath(
        points: [(x: CGFloat, y: CGFloat)],
        stroke: String = "#007AFF",
        strokeWidth: CGFloat = 2,
        fill: String = "none"
    ) -> String {
        guard !points.isEmpty else { return "" }
        
        var pathData = "M \(points[0].x) \(points[0].y)"
        for point in points.dropFirst() {
            pathData += " L \(point.x) \(point.y)"
        }
        
        return """
        <path d="\(pathData)" 
              stroke="\(stroke)" 
              stroke-width="\(strokeWidth)" 
              fill="\(fill)" 
              stroke-linecap="round" 
              stroke-linejoin="round"/>
        """
    }
    
    /// Generate SVG bar
    public static func svgBar(
        x: CGFloat,
        y: CGFloat,
        width: CGFloat,
        height: CGFloat,
        fill: String = "#007AFF",
        cornerRadius: CGFloat = 4
    ) -> String {
        """
        <rect x="\(x)" y="\(y)" width="\(width)" height="\(height)" 
              fill="\(fill)" rx="\(cornerRadius)" ry="\(cornerRadius)"/>
        """
    }
    
    /// Generate SVG circle/point
    public static func svgCircle(
        cx: CGFloat,
        cy: CGFloat,
        r: CGFloat,
        fill: String = "#007AFF",
        stroke: String? = nil,
        strokeWidth: CGFloat = 1
    ) -> String {
        var circle = "<circle cx=\"\(cx)\" cy=\"\(cy)\" r=\"\(r)\" fill=\"\(fill)\""
        if let stroke = stroke {
            circle += " stroke=\"\(stroke)\" stroke-width=\"\(strokeWidth)\""
        }
        circle += "/>"
        return circle
    }
    
    /// Generate SVG text
    public static func svgText(
        x: CGFloat,
        y: CGFloat,
        text: String,
        fontSize: CGFloat = 12,
        fill: String = "#000000",
        anchor: String = "middle"
    ) -> String {
        """
        <text x="\(x)" y="\(y)" font-size="\(fontSize)" fill="\(fill)" text-anchor="\(anchor)">\(text)</text>
        """
    }
}

// MARK: - Export Configuration

/// Configuration for chart export
public struct ExportConfiguration {
    public var format: ExportFormat
    public var quality: ExportQuality
    public var size: CGSize
    public var backgroundColor: Color
    public var includeTitle: Bool
    public var includeLegend: Bool
    public var includeTimestamp: Bool
    public var title: String?
    public var author: String?
    
    public init(
        format: ExportFormat = .png,
        quality: ExportQuality = .high,
        size: CGSize = CGSize(width: 800, height: 600),
        backgroundColor: Color = .white,
        includeTitle: Bool = true,
        includeLegend: Bool = true,
        includeTimestamp: Bool = false,
        title: String? = nil,
        author: String? = nil
    ) {
        self.format = format
        self.quality = quality
        self.size = size
        self.backgroundColor = backgroundColor
        self.includeTitle = includeTitle
        self.includeLegend = includeLegend
        self.includeTimestamp = includeTimestamp
        self.title = title
        self.author = author
    }
}

// MARK: - Share Sheet

#if canImport(UIKit)
/// Share sheet for exported content
public struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    public init(items: [Any]) {
        self.items = items
    }
    
    public func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

/// View modifier for export functionality
extension View {
    public func exportable(
        configuration: ExportConfiguration = ExportConfiguration(),
        onExport: @escaping (Data?) -> Void
    ) -> some View {
        self.modifier(ExportableModifier(configuration: configuration, onExport: onExport))
    }
}

private struct ExportableModifier: ViewModifier {
    let configuration: ExportConfiguration
    let onExport: (Data?) -> Void
    
    @State private var showingShareSheet = false
    @State private var exportedData: Data?
    
    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button(action: exportAsPNG) {
                    Label("Export as PNG", systemImage: "photo")
                }
                Button(action: exportAsPDF) {
                    Label("Export as PDF", systemImage: "doc")
                }
            }
            .sheet(isPresented: $showingShareSheet) {
                if let data = exportedData {
                    ShareSheet(items: [data])
                }
            }
    }
    
    private func exportAsPNG() {
        // Export logic would go here
        onExport(nil)
    }
    
    private func exportAsPDF() {
        // Export logic would go here
        onExport(nil)
    }
}
#endif

// MARK: - Preview

#if DEBUG
struct ChartExporter_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Chart Exporter")
                .font(.title)
            
            Text("Export your charts to PNG, PDF, SVG, CSV, or JSON")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
#endif
