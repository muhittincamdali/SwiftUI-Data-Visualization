// DataTransformer.swift
// SwiftUI-Data-Visualization
//
// Created by Muhittin Camdali
// Copyright © 2025 All rights reserved.

import SwiftUI
import Combine

// MARK: - Data Transformer Protocol

/// Protocol for data transformation operations
public protocol DataTransformable {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input) -> Output
}

// MARK: - Chart Data Transformer

/// Transforms raw data into chart-ready formats
public struct ChartDataTransformer<T> {
    
    // MARK: - Aggregation Functions
    
    /// Sum values by a grouping key
    public static func sum<K: Hashable, V: Numeric>(
        data: [T],
        groupBy: KeyPath<T, K>,
        valueKey: KeyPath<T, V>
    ) -> [(key: K, value: V)] {
        var groups: [K: V] = [:]
        
        for item in data {
            let key = item[keyPath: groupBy]
            let value = item[keyPath: valueKey]
            groups[key, default: V.zero] = groups[key, default: V.zero] + value
        }
        
        return groups.map { (key: $0.key, value: $0.value) }
    }
    
    /// Average values by a grouping key
    public static func average<K: Hashable>(
        data: [T],
        groupBy: KeyPath<T, K>,
        valueKey: KeyPath<T, Double>
    ) -> [(key: K, value: Double)] {
        var groups: [K: [Double]] = [:]
        
        for item in data {
            let key = item[keyPath: groupBy]
            let value = item[keyPath: valueKey]
            groups[key, default: []].append(value)
        }
        
        return groups.map { (key: $0.key, value: $0.value.reduce(0, +) / Double($0.value.count)) }
    }
    
    /// Count occurrences by a grouping key
    public static func count<K: Hashable>(
        data: [T],
        groupBy: KeyPath<T, K>
    ) -> [(key: K, count: Int)] {
        var counts: [K: Int] = [:]
        
        for item in data {
            let key = item[keyPath: groupBy]
            counts[key, default: 0] += 1
        }
        
        return counts.map { (key: $0.key, count: $0.value) }
    }
    
    // MARK: - Time Series Functions
    
    /// Group data by date component
    public static func groupByDate(
        data: [T],
        dateKey: KeyPath<T, Date>,
        valueKey: KeyPath<T, Double>,
        component: Calendar.Component,
        aggregation: AggregationType = .sum
    ) -> [(date: Date, value: Double)] {
        let calendar = Calendar.current
        var groups: [Date: [Double]] = [:]
        
        for item in data {
            let date = item[keyPath: dateKey]
            let value = item[keyPath: valueKey]
            let truncatedDate = calendar.dateInterval(of: component, for: date)?.start ?? date
            groups[truncatedDate, default: []].append(value)
        }
        
        return groups.map { key, values in
            let aggregatedValue: Double
            switch aggregation {
            case .sum:
                aggregatedValue = values.reduce(0, +)
            case .average:
                aggregatedValue = values.reduce(0, +) / Double(values.count)
            case .min:
                aggregatedValue = values.min() ?? 0
            case .max:
                aggregatedValue = values.max() ?? 0
            case .count:
                aggregatedValue = Double(values.count)
            }
            return (date: key, value: aggregatedValue)
        }.sorted { $0.date < $1.date }
    }
    
    /// Calculate moving average
    public static func movingAverage(
        data: [(date: Date, value: Double)],
        windowSize: Int
    ) -> [(date: Date, value: Double)] {
        guard windowSize > 0 && data.count >= windowSize else { return data }
        
        var result: [(date: Date, value: Double)] = []
        
        for i in (windowSize - 1)..<data.count {
            let window = Array(data[(i - windowSize + 1)...i])
            let average = window.map { $0.value }.reduce(0, +) / Double(windowSize)
            result.append((date: data[i].date, value: average))
        }
        
        return result
    }
    
    /// Calculate cumulative sum
    public static func cumulativeSum(
        data: [(date: Date, value: Double)]
    ) -> [(date: Date, value: Double)] {
        var cumulative: Double = 0
        return data.map { item in
            cumulative += item.value
            return (date: item.date, value: cumulative)
        }
    }
    
    // MARK: - Normalization Functions
    
    /// Normalize values to 0-1 range
    public static func normalize(
        data: [T],
        valueKey: KeyPath<T, Double>
    ) -> [(item: T, normalizedValue: Double)] {
        let values = data.map { $0[keyPath: valueKey] }
        guard let minVal = values.min(), let maxVal = values.max(), maxVal > minVal else {
            return data.map { (item: $0, normalizedValue: 0.5) }
        }
        
        let range = maxVal - minVal
        return data.map { item in
            let normalized = (item[keyPath: valueKey] - minVal) / range
            return (item: item, normalizedValue: normalized)
        }
    }
    
    /// Normalize to percentage of total
    public static func toPercentage(
        data: [T],
        valueKey: KeyPath<T, Double>
    ) -> [(item: T, percentage: Double)] {
        let total = data.map { $0[keyPath: valueKey] }.reduce(0, +)
        guard total > 0 else {
            return data.map { (item: $0, percentage: 0) }
        }
        
        return data.map { item in
            let percentage = (item[keyPath: valueKey] / total) * 100
            return (item: item, percentage: percentage)
        }
    }
    
    // MARK: - Statistical Functions
    
    /// Calculate statistics for numeric data
    public static func statistics(
        data: [T],
        valueKey: KeyPath<T, Double>
    ) -> DataStatistics {
        let values = data.map { $0[keyPath: valueKey] }
        let sorted = values.sorted()
        
        let count = Double(values.count)
        let sum = values.reduce(0, +)
        let mean = count > 0 ? sum / count : 0
        let min = sorted.first ?? 0
        let max = sorted.last ?? 0
        
        // Median
        let median: Double
        if sorted.isEmpty {
            median = 0
        } else if sorted.count % 2 == 0 {
            median = (sorted[sorted.count / 2 - 1] + sorted[sorted.count / 2]) / 2
        } else {
            median = sorted[sorted.count / 2]
        }
        
        // Standard deviation
        let variance = count > 0 ? values.map { pow($0 - mean, 2) }.reduce(0, +) / count : 0
        let stdDev = sqrt(variance)
        
        return DataStatistics(
            count: Int(count),
            sum: sum,
            mean: mean,
            median: median,
            min: min,
            max: max,
            standardDeviation: stdDev,
            variance: variance
        )
    }
}

// MARK: - Supporting Types

public enum AggregationType {
    case sum
    case average
    case min
    case max
    case count
}

public struct DataStatistics {
    public let count: Int
    public let sum: Double
    public let mean: Double
    public let median: Double
    public let min: Double
    public let max: Double
    public let standardDeviation: Double
    public let variance: Double
}

// MARK: - Reactive Data Source

/// A reactive data source for real-time chart updates
@available(iOS 14.0, macOS 11.0, *)
public class ReactiveDataSource<T>: ObservableObject {
    @Published public private(set) var data: [T] = []
    @Published public private(set) var isLoading: Bool = false
    @Published public private(set) var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    private var refreshTimer: Timer?
    
    public init() {}
    
    /// Load data from an async source
    public func load(from publisher: AnyPublisher<[T], Error>) {
        isLoading = true
        error = nil
        
        publisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let err) = completion {
                        self?.error = err
                    }
                },
                receiveValue: { [weak self] data in
                    self?.data = data
                }
            )
            .store(in: &cancellables)
    }
    
    /// Set up automatic refresh
    public func startAutoRefresh(interval: TimeInterval, fetch: @escaping () -> AnyPublisher<[T], Error>) {
        stopAutoRefresh()
        
        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.load(from: fetch())
        }
    }
    
    /// Stop automatic refresh
    public func stopAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = nil
    }
    
    /// Update data manually
    public func update(_ newData: [T]) {
        self.data = newData
    }
    
    /// Append new data
    public func append(_ items: [T]) {
        self.data.append(contentsOf: items)
    }
    
    /// Clear all data
    public func clear() {
        self.data = []
    }
    
    deinit {
        stopAutoRefresh()
    }
}

// MARK: - Data Filter

/// Filtering utilities for chart data
public struct DataFilter<T> {
    
    /// Filter by date range
    public static func byDateRange(
        data: [T],
        dateKey: KeyPath<T, Date>,
        from startDate: Date,
        to endDate: Date
    ) -> [T] {
        data.filter { item in
            let date = item[keyPath: dateKey]
            return date >= startDate && date <= endDate
        }
    }
    
    /// Filter by numeric range
    public static func byRange(
        data: [T],
        valueKey: KeyPath<T, Double>,
        min: Double? = nil,
        max: Double? = nil
    ) -> [T] {
        data.filter { item in
            let value = item[keyPath: valueKey]
            if let minVal = min, value < minVal { return false }
            if let maxVal = max, value > maxVal { return false }
            return true
        }
    }
    
    /// Filter by string match
    public static func byString(
        data: [T],
        key: KeyPath<T, String>,
        contains searchText: String,
        caseSensitive: Bool = false
    ) -> [T] {
        guard !searchText.isEmpty else { return data }
        
        return data.filter { item in
            let value = item[keyPath: key]
            if caseSensitive {
                return value.contains(searchText)
            } else {
                return value.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    /// Filter by predicate
    public static func byPredicate(
        data: [T],
        predicate: (T) -> Bool
    ) -> [T] {
        data.filter(predicate)
    }
}

// MARK: - Data Sorter

/// Sorting utilities for chart data
public struct DataSorter<T> {
    
    /// Sort by a comparable key
    public static func sort<V: Comparable>(
        data: [T],
        by key: KeyPath<T, V>,
        ascending: Bool = true
    ) -> [T] {
        data.sorted { first, second in
            let firstValue = first[keyPath: key]
            let secondValue = second[keyPath: key]
            return ascending ? firstValue < secondValue : firstValue > secondValue
        }
    }
    
    /// Sort by multiple keys
    public static func multiSort<V1: Comparable, V2: Comparable>(
        data: [T],
        primaryKey: KeyPath<T, V1>,
        secondaryKey: KeyPath<T, V2>,
        primaryAscending: Bool = true,
        secondaryAscending: Bool = true
    ) -> [T] {
        data.sorted { first, second in
            let firstPrimary = first[keyPath: primaryKey]
            let secondPrimary = second[keyPath: primaryKey]
            
            if firstPrimary != secondPrimary {
                return primaryAscending ? firstPrimary < secondPrimary : firstPrimary > secondPrimary
            }
            
            let firstSecondary = first[keyPath: secondaryKey]
            let secondSecondary = second[keyPath: secondaryKey]
            return secondaryAscending ? firstSecondary < secondSecondary : firstSecondary > secondSecondary
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DataTransformer_Previews: PreviewProvider {
    struct SampleData {
        let date: Date
        let category: String
        let value: Double
    }
    
    static var sampleData: [SampleData] = [
        SampleData(date: Date(), category: "A", value: 100),
        SampleData(date: Date().addingTimeInterval(-86400), category: "A", value: 150),
        SampleData(date: Date().addingTimeInterval(-172800), category: "B", value: 200)
    ]
    
    static var previews: some View {
        VStack {
            Text("Data Transformer Examples")
            
            // Usage example
            let summed = ChartDataTransformer.sum(
                data: sampleData,
                groupBy: \.category,
                valueKey: \.value
            )
            
            ForEach(summed, id: \.key) { item in
                Text("\(item.key): \(item.value)")
            }
        }
    }
}
#endif
