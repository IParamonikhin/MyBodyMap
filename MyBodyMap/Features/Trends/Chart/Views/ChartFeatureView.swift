//
//  ChartFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import SwiftUI
import ComposableArchitecture
import Charts

public struct ChartFeatureView: View {
    @Bindable var store: StoreOf<ChartFeature>
    
    public init(store: StoreOf<ChartFeature>) { self.store = store }
    
    private let weekInSeconds: TimeInterval = 60 * 60 * 24 * 7
    
    public var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                Text(label(for: store.field))
                    .font(.title2.bold())
                    .foregroundStyle(Color("FontColor"))
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color("TextfieldColor"))
                    if uniqueTrends.isEmpty {
                        noDataView
                    } else {
                        chartView
                    }
                }
                HStack {
                    Text(uniqueTrends.last?.formatValue ?? "–")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color("FontColor"))
                    Spacer()
                    if let lastTrend = uniqueTrends.last {
                        Text(lastTrend.diff > 0 ? "▲ \(lastTrend.formatValueDiff)"
                             : lastTrend.diff < 0 ? "▼ \(lastTrend.formatValueDiff)"
                             : "—")
                        .foregroundStyle(TrendColor.textColor(for: lastTrend.diff, goal: store.goal))
                        .font(.title2.bold())
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private var chartView: some View {
        let (lowerBound, upperBound) = chartYScaleDomain
        Chart {
            ForEach(uniqueTrends) { item in
                LineMark(
                    x: .value("Дата", item.date, unit: .day),
                    y: .value("Значение", item.value)
                )
                .interpolationMethod(.monotone)
                .foregroundStyle(TrendColor.color(for: item.diff, goal: store.goal))
                PointMark(
                    x: .value("Дата", item.date, unit: .day),
                    y: .value("Значение", item.value)
                )
                .foregroundStyle(TrendColor.color(for: item.diff, goal: store.goal))
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: weekInSeconds)
        .chartScrollPosition(initialX: uniqueTrends.last?.date ?? Date())
        .chartYScale(domain: lowerBound...upperBound)
        .chartXAxis {
            AxisMarks(values: .stride(by: .day)) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel() {
                    if let date = value.as(Date.self) {
                        Text(date, format: .dateTime.weekday(.narrow))
                            .font(.caption)
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .animation(.easeInOut(duration: 0.36), value: store.fieldTrends)
        .frame(height: 160)
    }
    
    @ViewBuilder
    private var noDataView: some View {
        Text("Нет данных для графика")
            .foregroundStyle(Color("FontColor"))
            .frame(height: 120)
    }
    
    private var uniqueTrends: [TrendItem] {
        var seen = Set<String>()
        var result: [TrendItem] = []
        for item in store.fieldTrends {
            let key = "\(item.date.timeIntervalSince1970)_\(item.value)"
            if !seen.contains(key) {
                seen.insert(key)
                result.append(item)
            }
        }
        return result
    }
    
    private var chartYScaleDomain: (lower: Double, upper: Double) {
        let values = uniqueTrends.map(\.value)
        guard !values.isEmpty, let minValue = values.min(), let maxValue = values.max() else {
            return (0, 100)
        }
        let padding = (maxValue - minValue) * 0.15
        let lowerBound = max(0, minValue - padding)
        let upperBound = maxValue + padding
        if lowerBound == upperBound {
            return (lowerBound - 5, upperBound + 5)
        }
        return (lowerBound, upperBound)
    }
    
    private func label(for field: String) -> String { field.trendLabel }
}
