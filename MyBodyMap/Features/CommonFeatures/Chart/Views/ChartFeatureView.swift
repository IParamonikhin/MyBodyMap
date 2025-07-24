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
    public var body: some View {
        Chart(store.items) { item in
            LineMark(
                x: .value("Дата", item.date),
                y: .value("Значение", item.value)
            )
            .foregroundStyle(item.diff > 0 ? .green : .red)
        }
        .frame(height: 120)
    }
}


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
