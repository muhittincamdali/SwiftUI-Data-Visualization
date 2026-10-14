import Charts
import SwiftUI

/// One step of a waterfall: a change, or a total of the changes so far.
public struct WaterfallStep: Hashable, Sendable {
    /// The label under the bar. Labels in one chart should be unique.
    public var label: String
    /// The change; ignored for a total.
    public var value: Double
    /// Whether the bar shows the running total instead of a change.
    public var isTotal: Bool

    /// Creates a change of `value`.
    public init(_ label: String, _ value: Double) {
        self.label = label
        self.value = value
        self.isTotal = false
    }

    /// A bar from zero to the sum of the changes before it.
    public static func total(_ label: String) -> WaterfallStep {
        var step = WaterfallStep(label, 0)
        step.isTotal = true
        return step
    }
}

/// How a list of changes adds up, such as revenue minus costs down to profit.
///
/// ```swift
/// WaterfallChart([
///     WaterfallStep("Revenue", 420),
///     WaterfallStep("Costs", -260),
///     WaterfallStep("Tax", -40),
///     .total("Profit"),
/// ])
/// ```
///
/// Each change floats from the running total before it to the one after it, in the palette's
/// ``ChartPalette/positive`` or ``ChartPalette/negative`` color; totals rise from zero in
/// ``ChartPalette/neutral``. Changes that are not finite are left out.
public struct WaterfallChart: View {
    /// A bar as drawn: where it starts and ends, and what it shows.
    public struct Bar: Hashable, Sendable {
        /// What a bar shows.
        public enum Kind: Hashable, Sendable {
            /// A change of zero or more.
            case increase
            /// A negative change.
            case decrease
            /// A running total drawn from zero.
            case total
        }

        /// The step's label.
        public let label: String
        /// The running total before the step (zero for a total).
        public let start: Double
        /// The running total after the step.
        public let end: Double
        /// Whether the bar is an increase, a decrease or a total.
        public let kind: Kind
    }

    private let steps: [WaterfallStep]
    private let valueLabel: String

    @Environment(\.chartPalette) private var palette

    /// Creates a waterfall of `steps`, in their order.
    public init(_ steps: [WaterfallStep], valueLabel: String = "Value") {
        self.steps = steps
        self.valueLabel = valueLabel
    }

    public var body: some View {
        Chart(Array(Self.bars(for: steps).enumerated()), id: \.offset) { _, bar in
            BarMark(
                x: .value("Step", bar.label),
                yStart: .value(valueLabel, bar.start),
                yEnd: .value(valueLabel, bar.end),
                width: .ratio(0.6)
            )
            .foregroundStyle(color(for: bar.kind))
            .accessibilityLabel(bar.label)
            .accessibilityValue(Self.describe(bar))
        }
        .chartYAxisLabel(valueLabel)
    }

    private func color(for kind: Bar.Kind) -> Color {
        switch kind {
        case .increase: palette.positive
        case .decrease: palette.negative
        case .total: palette.neutral
        }
    }

    /// The bars for `steps`: each change starts at the running total and moves it; each total
    /// spans zero to the running total.
    public nonisolated static func bars(for steps: [WaterfallStep]) -> [Bar] {
        var runningTotal = 0.0
        var bars: [Bar] = []
        for step in steps {
            if step.isTotal {
                bars.append(Bar(label: step.label, start: 0, end: runningTotal, kind: .total))
                continue
            }
            let end = runningTotal + step.value
            guard step.value.isFinite, end.isFinite else { continue }
            bars.append(Bar(label: step.label, start: runningTotal, end: end, kind: step.value < 0 ? .decrease : .increase))
            runningTotal = end
        }
        return bars
    }

    /// The bar's change or total as VoiceOver reads it.
    nonisolated static func describe(_ bar: Bar) -> String {
        let format = FloatingPointFormatStyle<Double>.number.precision(.fractionLength(0...2))
        switch bar.kind {
        case .total:
            return "total \(bar.end.formatted(format))"
        case .increase, .decrease:
            let change = (bar.end - bar.start).formatted(format.sign(strategy: .always()))
            return "\(change), to \(bar.end.formatted(format))"
        }
    }
}
