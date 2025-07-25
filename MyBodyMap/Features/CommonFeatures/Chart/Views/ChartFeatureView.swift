//
//  ChartFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import SwiftUI
import Charts
import ComposableArchitecture

public struct ChartFeatureView: View {
    @Bindable var store: StoreOf<ChartFeature>
    public init(store: StoreOf<ChartFeature>) { self.store = store }

    public var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(label(for: store.field))
                        .font(.title2.bold())
                        .foregroundColor(Color("FontColor"))
                    Spacer()
                }

                if !store.trends.isEmpty {
                    Chart(store.trends) { item in
                        LineMark(
                            x: .value("Date", item.date),
                            y: .value("Value", item.value)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(Color.accentColor)
                    }
                    .frame(height: 120)
                } else {
                    Text("Нет данных для графика")
                        .foregroundColor(.secondary)
                        .frame(height: 120)
                }

                HStack {
                    Text(store.trends.last?.formatValue ?? "–")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color("FontColor"))
                    Spacer()
                    if let diff = store.trends.last?.diff {
                        Text(diff > 0 ? "▲ \(store.trends.last?.formatValueDiff ?? "")" :
                             diff < 0 ? "▼ \(store.trends.last?.formatValueDiff ?? "")" : "—")
                            .foregroundColor(diff > 0 ? .green : diff < 0 ? .red : .gray)
                            .font(.title2.bold())
                    }
                }
            }
        }
        .onAppear { store.send(.load) }
    }

    private func label(for field: String) -> String {
        switch field {
        case "weight": return "Вес"
        case "chest": return "Грудь"
        case "waist": return "Талия"
        case "forearm": return "Предплечье"
        case "biceps": return "Бицепс"
        case "neck": return "Шея"
        case "shoulders": return "Плечи"
        case "thigh": return "Бедро"
        case "buttocks": return "Ягодицы"
        case "calf": return "Икра"
        case "stomach": return "Живот"
        case "height": return "Рост"
        case "fatPercent": return "% Жира"
        default: return field
        }
    }
}

//import SwiftUI
//import Charts
//import ComposableArchitecture
//
//public struct ChartFeatureView: View {
//    @Bindable var store: StoreOf<ChartFeature>
//    public init(store: StoreOf<ChartFeature>) { self.store = store }
//    
//    public var body: some View {
//        CardView {
//            VStack(alignment: .leading) {
//                Text(store.fieldLabel) // Можно добавить локализацию поля
//                    .font(.title2.bold())
//                    .foregroundStyle(Color("FontColor"))
//                if !store.points.isEmpty {
//                    Chart(store.points) { item in
//                        LineMark(
//                            x: .value("Дата", item.date),
//                            y: .value("Значение", item.value)
//                        )
//                        .interpolationMethod(.catmullRom)
//                        .foregroundStyle(Gradient(colors: [.green, .blue]))
//                    }
//                    .frame(height: 120)
//                    .padding(.vertical, 4)
//                }
//                HStack {
//                    Text(store.points.last?.formatValue ?? "–")
//                        .font(.largeTitle.bold())
//                        .foregroundStyle(Color("FontColor"))
//                    Spacer()
//                    if let diff = store.points.last?.diff {
//                        Text(diff > 0 ? "▲ \(store.points.last?.formatValueDiff ?? "")"
//                                      : diff < 0 ? "▼ \(store.points.last?.formatValueDiff ?? "")" : "—")
//                            .foregroundColor(diff > 0 ? .green : diff < 0 ? .red : .gray)
//                            .font(.title2.bold())
//                    }
//                }
//            }
//        }
//    }
//}


//import SwiftUI
//import ComposableArchitecture
//
//public struct ChartFeatureView: View {
//    @Bindable var store: StoreOf<ChartFeature>
//
//    public init(store: StoreOf<ChartFeature>) {
//        self.store = store
//    }
//
//    public var body: some View {
//        VStack(alignment: .leading) {
//            if !store.title.isEmpty {
//                Text(store.title)
//                    .font(.headline)
//                    .foregroundColor(Color(store.color))
//                    .padding(.bottom, 4)
//            }
//            ChartView(data: store.data, color: Color(store.color))
//                .frame(height: 120)
//            if store.showLegend {
//                HStack {
//                    ForEach(store.data.prefix(5)) { point in
//                        if let label = point.label {
//                            Text(label)
//                                .font(.caption)
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                }
//                .padding(.top, 4)
//            }
//        }
//        .padding()
//    }
//}
//
//// ChartView — минимальная кастомная реализация line chart для SwiftUI (без зависимостей)
//struct ChartView: View {
//    let data: [ChartDataPoint]
//    let color: Color
//
//    var body: some View {
//        GeometryReader { geometry in
//            if data.count > 1 {
//                Path { path in
//                    let minY = data.map { $0.y }.min() ?? 0
//                    let maxY = data.map { $0.y }.max() ?? 1
//                    let deltaY = max(maxY - minY, 0.01)
//                    let stepX = geometry.size.width / CGFloat(data.count - 1)
//
//                    for (idx, point) in data.enumerated() {
//                        let x = CGFloat(idx) * stepX
//                        let y = geometry.size.height * CGFloat(1 - (point.y - minY) / deltaY)
//                        if idx == 0 { path.move(to: CGPoint(x: x, y: y)) }
//                        else { path.addLine(to: CGPoint(x: x, y: y)) }
//                    }
//                }
//                .stroke(color, lineWidth: 2)
//            } else {
//                // Для случая с одной точкой или пустого графика
//                EmptyView()
//            }
//        }
//    }
//}
