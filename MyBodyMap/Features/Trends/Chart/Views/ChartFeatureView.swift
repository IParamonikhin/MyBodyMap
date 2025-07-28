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

    /// Только уникальные точки по дате+значению (на случай дублей)
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

    public var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(label(for: store.field))
                        .font(.title2.bold())
                        .foregroundStyle(Color("FontColor"))
                    Spacer()
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color("TextfieldColor"))

                    if !uniqueTrends.isEmpty {
                        // Значения для оси
                        let values = uniqueTrends.map(\.value)
                        let mean = values.reduce(0, +) / Double(values.count)
                        let minValue = values.min() ?? mean
                        let maxValue = values.max() ?? mean
                        let delta = max(mean - minValue, maxValue - mean)
                        let padding = max(delta * 0.12, 0.6) // Динамический отступ
                        let lowerBound = mean - delta - padding
                        let upperBound = mean + delta + padding

                        Chart {
                            ForEach(uniqueTrends) { item in
                                LineMark(
                                    x: .value("Дата", item.date),
                                    y: .value("Значение", item.value)
                                )
                                .interpolationMethod(.linear)
                                .foregroundStyle(TrendColor.color(for: item.diff, goal: store.goal))
                                
                                PointMark(
                                    x: .value("Дата", item.date),
                                    y: .value("Значение", item.value)
                                )
                                .foregroundStyle(TrendColor.color(for: item.diff, goal: store.goal))
                            }
                        }
                        .chartYScale(domain: lowerBound...upperBound)
                        .chartXAxis {
                            AxisMarks(preset: .aligned, values: .stride(by: .day, count: 7))
                        }
                        .padding(.horizontal, 8)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .animation(.easeInOut(duration: 0.36), value: store.fieldTrends)
                    } else {
                        Text("Нет данных для графика")
                            .foregroundStyle(Color("FontColor"))
                            .frame(height: 120)
                    }
                }
                .frame(height: 160)
                HStack {
                    Text(uniqueTrends.last?.formatValue ?? "–")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color("FontColor"))
                    Spacer()
                    if let diff = uniqueTrends.last?.diff {
                        Text(diff > 0 ? "▲ \(uniqueTrends.last?.formatValueDiff ?? "")"
                                      : diff < 0 ? "▼ \(uniqueTrends.last?.formatValueDiff ?? "")"
                                      : "—")
                        .foregroundStyle(TrendColor.textColor(for: diff, goal: store.goal))
                            .font(.title2.bold())
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private func label(for field: String) -> String { field.trendLabel }
}

