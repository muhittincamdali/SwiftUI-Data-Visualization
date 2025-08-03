import SwiftUI
import SwiftUIDataVisualization

/// A comprehensive analytics dashboard showcasing multiple chart types.
///
/// This example demonstrates how to create a professional analytics dashboard
/// with various chart types, real-time data updates, and interactive features.
///
/// - Example:
/// ```swift
/// AnalyticsDashboard()
///     .frame(maxWidth: .infinity, maxHeight: .infinity)
/// ```
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct AnalyticsDashboard: View {
    
    // MARK: - Properties
    
    /// Sales data for line chart
    @State private var salesData: [ChartDataPoint] = []
    
    /// Revenue data for bar chart
    @State private var revenueData: [ChartDataPoint] = []
    
    /// Market share data for pie chart
    @State private var marketShareData: [ChartDataPoint] = []
    
    /// User engagement data for area chart
    @State private var engagementData: [ChartDataPoint] = []
    
    /// Performance metrics
    @State private var metrics = DashboardMetrics()
    
    /// Selected time period
    @State private var selectedPeriod: TimePeriod = .month
    
    /// Real-time data timer
    @State private var dataTimer: Timer?
    
    // MARK: - Body
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerView
                    
                    // Metrics cards
                    metricsView
                    
                    // Charts grid
                    chartsGrid
                    
                    // Real-time updates
                    realTimeUpdatesView
                }
                .padding()
            }
            .navigationTitle("Analytics Dashboard")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    periodPicker
                }
            }
        }
        .onAppear {
            loadInitialData()
            startRealTimeUpdates()
        }
        .onDisappear {
            stopRealTimeUpdates()
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Business Analytics")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Comprehensive data visualization and insights")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                Label("Last updated: \(Date().formatted(date: .abbreviated, time: .shortened))", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Button("Refresh") {
                    refreshData()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    // MARK: - Metrics View
    
    private var metricsView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            MetricCard(
                title: "Total Revenue",
                value: "$\(metrics.totalRevenue, specifier: "%.1f")M",
                change: metrics.revenueChange,
                icon: "dollarsign.circle.fill",
                color: .green
            )
            
            MetricCard(
                title: "Active Users",
                value: "\(metrics.activeUsers)",
                change: metrics.usersChange,
                icon: "person.2.fill",
                color: .blue
            )
            
            MetricCard(
                title: "Conversion Rate",
                value: "\(metrics.conversionRate, specifier: "%.1f")%",
                change: metrics.conversionChange,
                icon: "chart.line.uptrend.xyaxis",
                color: .orange
            )
            
            MetricCard(
                title: "Customer Satisfaction",
                value: "\(metrics.satisfaction, specifier: "%.1f")/5",
                change: metrics.satisfactionChange,
                icon: "star.fill",
                color: .yellow
            )
        }
    }
    
    // MARK: - Charts Grid
    
    private var chartsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 20) {
            // Sales Trend Chart
            ChartCard(title: "Sales Trend", subtitle: "Monthly sales performance") {
                LineChart(data: salesData)
                    .chartStyle(.line)
                    .interactive(true)
                    .animation(.easeInOut(duration: 0.8))
                    .frame(height: 200)
            }
            
            // Revenue by Category
            ChartCard(title: "Revenue by Category", subtitle: "Revenue distribution") {
                BarChart(data: revenueData)
                    .chartStyle(.bar)
                    .interactive(true)
                    .animation(.easeInOut(duration: 0.8))
                    .frame(height: 200)
            }
            
            // Market Share
            ChartCard(title: "Market Share", subtitle: "Competitive analysis") {
                PieChart(data: marketShareData)
                    .chartStyle(.pie)
                    .showLabels(true)
                    .animation(.easeInOut(duration: 1.0))
                    .frame(height: 200)
            }
            
            // User Engagement
            ChartCard(title: "User Engagement", subtitle: "Daily active users") {
                AreaChart(data: engagementData)
                    .chartStyle(.area)
                    .gradient(.linear)
                    .animation(.easeInOut(duration: 0.8))
                    .frame(height: 200)
            }
        }
    }
    
    // MARK: - Real-time Updates View
    
    private var realTimeUpdatesView: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Real-time Updates")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Circle()
                    .fill(Color.green)
                    .frame(width: 8, height: 8)
                Text("Live")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(metrics.recentUpdates, id: \.id) { update in
                        UpdateCard(update: update)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    // MARK: - Period Picker
    
    private var periodPicker: some View {
        Picker("Time Period", selection: $selectedPeriod) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                Text(period.displayName).tag(period)
            }
        }
        .pickerStyle(.menu)
        .onChange(of: selectedPeriod) { _ in
            loadDataForPeriod()
        }
    }
    
    // MARK: - Data Loading
    
    private func loadInitialData() {
        loadDataForPeriod()
    }
    
    private func loadDataForPeriod() {
        // Generate sample data based on selected period
        salesData = generateSalesData()
        revenueData = generateRevenueData()
        marketShareData = generateMarketShareData()
        engagementData = generateEngagementData()
        metrics = generateMetrics()
    }
    
    private func refreshData() {
        withAnimation(.easeInOut(duration: 0.5)) {
            loadDataForPeriod()
        }
    }
    
    private func startRealTimeUpdates() {
        dataTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            updateRealTimeData()
        }
    }
    
    private func stopRealTimeUpdates() {
        dataTimer?.invalidate()
        dataTimer = nil
    }
    
    private func updateRealTimeData() {
        withAnimation(.easeInOut(duration: 0.3)) {
            // Update metrics with new values
            metrics.updateWithRealTimeData()
            
            // Add new data points to charts
            addNewDataPoints()
        }
    }
    
    // MARK: - Data Generation
    
    private func generateSalesData() -> [ChartDataPoint] {
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        return months.enumerated().map { index, month in
            ChartDataPoint(
                x: Double(index + 1),
                y: Double.random(in: 100...500),
                label: month
            )
        }
    }
    
    private func generateRevenueData() -> [ChartDataPoint] {
        let categories = ["Product A", "Product B", "Product C", "Product D"]
        return categories.enumerated().map { index, category in
            ChartDataPoint(
                x: Double(index + 1),
                y: Double.random(in: 50...200),
                label: category
            )
        }
    }
    
    private func generateMarketShareData() -> [ChartDataPoint] {
        return [
            ChartDataPoint(x: 1, y: 35, label: "Our Company", color: .blue),
            ChartDataPoint(x: 2, y: 25, label: "Competitor A", color: .red),
            ChartDataPoint(x: 3, y: 20, label: "Competitor B", color: .green),
            ChartDataPoint(x: 4, y: 15, label: "Competitor C", color: .orange),
            ChartDataPoint(x: 5, y: 5, label: "Others", color: .gray)
        ]
    }
    
    private func generateEngagementData() -> [ChartDataPoint] {
        let days = (1...30).map { "Day \($0)" }
        return days.enumerated().map { index, day in
            ChartDataPoint(
                x: Double(index + 1),
                y: Double.random(in: 1000...5000),
                label: day
            )
        }
    }
    
    private func generateMetrics() -> DashboardMetrics {
        return DashboardMetrics()
    }
    
    private func addNewDataPoints() {
        // Add new data points to existing charts
        if let lastPoint = salesData.last {
            let newPoint = ChartDataPoint(
                x: lastPoint.x + 1,
                y: Double.random(in: 100...500),
                label: "New"
            )
            salesData.append(newPoint)
        }
    }
}

// MARK: - Supporting Views

/// Metric card component
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct MetricCard: View {
    let title: String
    let value: String
    let change: Double
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                
                Spacer()
                
                Text(change >= 0 ? "+\(change, specifier: "%.1f")%" : "\(change, specifier: "%.1f")%")
                    .font(.caption)
                    .foregroundColor(change >= 0 ? .green : .red)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

/// Chart card component
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct ChartCard<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content
    
    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            content
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

/// Update card component
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
private struct UpdateCard: View {
    let update: DashboardUpdate
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: update.icon)
                    .foregroundColor(update.color)
                
                Spacer()
                
                Text(update.timestamp, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Text(update.message)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(2)
        }
        .padding()
        .frame(width: 200)
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .shadow(radius: 1)
    }
}

// MARK: - Supporting Types

/// Dashboard metrics
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct DashboardMetrics {
    var totalRevenue: Double = 1250.5
    var revenueChange: Double = 12.5
    var activeUsers: Int = 15420
    var usersChange: Double = 8.3
    var conversionRate: Double = 3.2
    var conversionChange: Double = -1.1
    var satisfaction: Double = 4.6
    var satisfactionChange: Double = 0.2
    var recentUpdates: [DashboardUpdate] = []
    
    mutating func updateWithRealTimeData() {
        totalRevenue += Double.random(in: -10...10)
        activeUsers += Int.random(in: -50...50)
        conversionRate += Double.random(in: -0.1...0.1)
        satisfaction += Double.random(in: -0.05...0.05)
        
        // Add new update
        let update = DashboardUpdate(
            message: "New user registered",
            icon: "person.badge.plus",
            color: .green,
            timestamp: Date()
        )
        recentUpdates.insert(update, at: 0)
        
        // Keep only last 10 updates
        if recentUpdates.count > 10 {
            recentUpdates = Array(recentUpdates.prefix(10))
        }
    }
}

/// Dashboard update
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public struct DashboardUpdate: Identifiable {
    public let id = UUID()
    let message: String
    let icon: String
    let color: Color
    let timestamp: Date
}

/// Time period enum
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public enum TimePeriod: CaseIterable {
    case day, week, month, quarter, year
    
    var displayName: String {
        switch self {
        case .day: return "Day"
        case .week: return "Week"
        case .month: return "Month"
        case .quarter: return "Quarter"
        case .year: return "Year"
        }
    }
}

// MARK: - Preview

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
struct AnalyticsDashboard_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticsDashboard()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
} 