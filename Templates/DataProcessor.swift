// MARK: - Data Processor Template
// SwiftUI-Data-Visualization Framework
// Created by Muhittin Camdali

import Foundation

// MARK: - Data Processor Protocol

/// Protocol for data processing operations
public protocol DataProcessorProtocol {
    associatedtype Input
    associatedtype Output
    
    /// Process input data
    func process(_ input: Input) throws -> Output
    
    /// Validate input data
    func validate(_ input: Input) throws
}

// MARK: - Chart Data Processor

/// Processor for chart data preparation
public final class ChartDataProcessor: @unchecked Sendable {
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Aggregation
    
    /// Aggregate data by category
    public func aggregate(
        _ values: [Double],
        labels: [String],
        by aggregation: AggregationType
    ) -> [(label: String, value: Double)] {
        var grouped: [String: [Double]] = [:]
        
        for (index, label) in labels.enumerated() {
            if index < values.count {
                grouped[label, default: []].append(values[index])
            }
        }
        
        return grouped.map { label, groupValues in
            let aggregatedValue: Double
            switch aggregation {
            case .sum:
                aggregatedValue = groupValues.reduce(0, +)
            case .average:
                aggregatedValue = groupValues.reduce(0, +) / Double(groupValues.count)
            case .min:
                aggregatedValue = groupValues.min() ?? 0
            case .max:
                aggregatedValue = groupValues.max() ?? 0
            case .count:
                aggregatedValue = Double(groupValues.count)
            case .median:
                let sorted = groupValues.sorted()
                let mid = sorted.count / 2
                aggregatedValue = sorted.count % 2 == 0 
                    ? (sorted[mid - 1] + sorted[mid]) / 2 
                    : sorted[mid]
            }
            return (label, aggregatedValue)
        }.sorted { $0.label < $1.label }
    }
    
    /// Group data by time interval
    public func groupByTime(
        _ values: [Double],
        dates: [Date],
        interval: TimeInterval
    ) -> [(date: Date, value: Double)] {
        var grouped: [Date: [Double]] = [:]
        
        for (index, date) in dates.enumerated() {
            let groupDate = Date(timeIntervalSinceReferenceDate: 
                floor(date.timeIntervalSinceReferenceDate / interval) * interval)
            if index < values.count {
                grouped[groupDate, default: []].append(values[index])
            }
        }
        
        return grouped.map { date, groupValues in
            (date, groupValues.reduce(0, +) / Double(groupValues.count))
        }.sorted { $0.date < $1.date }
    }
    
    // MARK: - Normalization
    
    /// Normalize values to 0-1 range
    public func normalize(_ values: [Double]) -> [Double] {
        guard let minValue = values.min(),
              let maxValue = values.max(),
              maxValue != minValue else {
            return values.map { _ in 0.5 }
        }
        
        return values.map { ($0 - minValue) / (maxValue - minValue) }
    }
    
    /// Standardize values (z-score)
    public func standardize(_ values: [Double]) -> [Double] {
        let mean = values.reduce(0, +) / Double(values.count)
        let variance = values.reduce(0) { $0 + pow($1 - mean, 2) } / Double(values.count)
        let stdDev = sqrt(variance)
        
        guard stdDev != 0 else {
            return values.map { _ in 0 }
        }
        
        return values.map { ($0 - mean) / stdDev }
    }
    
    // MARK: - Transformation
    
    /// Apply moving average
    public func movingAverage(_ values: [Double], window: Int) -> [Double] {
        guard window > 0, values.count >= window else {
            return values
        }
        
        var result: [Double] = []
        
        for i in 0..<values.count {
            let start = max(0, i - window + 1)
            let end = i + 1
            let windowValues = Array(values[start..<end])
            let average = windowValues.reduce(0, +) / Double(windowValues.count)
            result.append(average)
        }
        
        return result
    }
    
    /// Apply exponential smoothing
    public func exponentialSmoothing(_ values: [Double], alpha: Double) -> [Double] {
        guard !values.isEmpty else { return [] }
        
        var smoothed: [Double] = [values[0]]
        
        for i in 1..<values.count {
            let newValue = alpha * values[i] + (1 - alpha) * smoothed[i - 1]
            smoothed.append(newValue)
        }
        
        return smoothed
    }
    
    /// Calculate cumulative sum
    public func cumulativeSum(_ values: [Double]) -> [Double] {
        var cumsum: [Double] = []
        var total: Double = 0
        
        for value in values {
            total += value
            cumsum.append(total)
        }
        
        return cumsum
    }
    
    /// Calculate percentage change
    public func percentageChange(_ values: [Double]) -> [Double] {
        guard values.count > 1 else { return [] }
        
        var changes: [Double] = [0]
        
        for i in 1..<values.count {
            let previous = values[i - 1]
            let change = previous != 0 ? (values[i] - previous) / previous * 100 : 0
            changes.append(change)
        }
        
        return changes
    }
    
    // MARK: - Statistics
    
    /// Calculate basic statistics
    public func statistics(_ values: [Double]) -> Statistics {
        guard !values.isEmpty else {
            return Statistics(
                count: 0, sum: 0, mean: 0, median: 0,
                min: 0, max: 0, range: 0, variance: 0, standardDeviation: 0
            )
        }
        
        let sorted = values.sorted()
        let count = Double(values.count)
        let sum = values.reduce(0, +)
        let mean = sum / count
        
        let mid = sorted.count / 2
        let median = sorted.count % 2 == 0
            ? (sorted[mid - 1] + sorted[mid]) / 2
            : sorted[mid]
        
        let minVal = sorted.first!
        let maxVal = sorted.last!
        let range = maxVal - minVal
        
        let variance = values.reduce(0) { $0 + pow($1 - mean, 2) } / count
        let stdDev = sqrt(variance)
        
        return Statistics(
            count: Int(count),
            sum: sum,
            mean: mean,
            median: median,
            min: minVal,
            max: maxVal,
            range: range,
            variance: variance,
            standardDeviation: stdDev
        )
    }
    
    /// Calculate percentile
    public func percentile(_ values: [Double], percentile: Double) -> Double {
        guard !values.isEmpty else { return 0 }
        
        let sorted = values.sorted()
        let index = (percentile / 100) * Double(sorted.count - 1)
        let lower = Int(floor(index))
        let upper = Int(ceil(index))
        
        if lower == upper {
            return sorted[lower]
        }
        
        return sorted[lower] + (sorted[upper] - sorted[lower]) * (index - Double(lower))
    }
    
    // MARK: - Outlier Detection
    
    /// Detect outliers using IQR method
    public func detectOutliers(_ values: [Double], multiplier: Double = 1.5) -> [Int] {
        let q1 = percentile(values, percentile: 25)
        let q3 = percentile(values, percentile: 75)
        let iqr = q3 - q1
        
        let lowerBound = q1 - multiplier * iqr
        let upperBound = q3 + multiplier * iqr
        
        var outlierIndices: [Int] = []
        
        for (index, value) in values.enumerated() {
            if value < lowerBound || value > upperBound {
                outlierIndices.append(index)
            }
        }
        
        return outlierIndices
    }
    
    /// Remove outliers
    public func removeOutliers(_ values: [Double], multiplier: Double = 1.5) -> [Double] {
        let outlierIndices = Set(detectOutliers(values, multiplier: multiplier))
        return values.enumerated()
            .filter { !outlierIndices.contains($0.offset) }
            .map { $0.element }
    }
    
    // MARK: - Binning
    
    /// Create histogram bins
    public func histogram(_ values: [Double], bins: Int) -> [(range: ClosedRange<Double>, count: Int)] {
        guard let minVal = values.min(), let maxVal = values.max(), bins > 0 else {
            return []
        }
        
        let binWidth = (maxVal - minVal) / Double(bins)
        var histogram: [(range: ClosedRange<Double>, count: Int)] = []
        
        for i in 0..<bins {
            let lower = minVal + Double(i) * binWidth
            let upper = i == bins - 1 ? maxVal : minVal + Double(i + 1) * binWidth
            let count = values.filter { $0 >= lower && $0 <= upper }.count
            histogram.append((lower...upper, count))
        }
        
        return histogram
    }
}

// MARK: - Aggregation Type

public enum AggregationType: String, CaseIterable, Sendable {
    case sum = "Sum"
    case average = "Average"
    case min = "Minimum"
    case max = "Maximum"
    case count = "Count"
    case median = "Median"
}

// MARK: - Statistics

public struct Statistics: Sendable {
    public let count: Int
    public let sum: Double
    public let mean: Double
    public let median: Double
    public let min: Double
    public let max: Double
    public let range: Double
    public let variance: Double
    public let standardDeviation: Double
}

// MARK: - Usage Example

/*
 let processor = ChartDataProcessor()
 
 // Basic statistics
 let values = [10.0, 20.0, 30.0, 40.0, 50.0]
 let stats = processor.statistics(values)
 print("Mean: \(stats.mean), StdDev: \(stats.standardDeviation)")
 
 // Normalization
 let normalized = processor.normalize(values)
 print("Normalized: \(normalized)")
 
 // Moving average
 let smoothed = processor.movingAverage(values, window: 3)
 print("Smoothed: \(smoothed)")
 
 // Aggregation
 let labels = ["A", "A", "B", "B", "C"]
 let aggregated = processor.aggregate(values, labels: labels, by: .sum)
 print("Aggregated: \(aggregated)")
 */
