//
//  TrendsFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct TrendsFeatureView: View {
    @Bindable var store: StoreOf<TrendsFeature>
    public init(store: StoreOf<TrendsFeature>) { self.store = store }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    TrendsMainCard(store: store)
                        .padding(.horizontal, 16)
                    TrendsChartCard(store: store)
                        .padding(.horizontal, 16)
                }
                .padding(.top)
            }
            .background(Color("backgroundColor"))
            .navigationTitle("Тренды")
            .sheet(isPresented: $store.showAllTrends) {
                AllTrendsSheetView(store: store)
            }
            .onAppear { store.send(.load) }
        }
        .tabItem { Label("Тренды", systemImage: "chart.line.uptrend.xyaxis") }
    }

    // --- статические методы
    static func formatValueStatic(_ value: Double?) -> String {
        guard let v = value else { return "–" }
        return String(format: "%.1f", v)
    }
    static func labelStatic(for field: String) -> String {
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
    static func colorStatic(for field: String) -> Color {
        switch field {
        case "weight": return .purple
        case "chest": return .blue
        case "waist": return .yellow
        case "biceps", "calf": return .green
        case "buttocks": return .red
        case "thigh": return .orange
        default: return .white
        }
    }
}

//import SwiftUI
//import Charts
//import ComposableArchitecture
//
//public struct TrendsFeatureView: View {
//    @Bindable var store: StoreOf<TrendsFeature>
//
//    public init(store: StoreOf<TrendsFeature>) { self.store = store }
//
//    public var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 20) {
//                    TrendsMainCard(store: store)
//                        .padding(.horizontal, 16)
//                    TrendsChartCard(store: store)
//                        .padding(.horizontal, 16)
//                }
//                .padding(.top)
//            }
//            .background(Color("backgroundColor"))
//            .navigationTitle("Тренды")
//            .sheet(isPresented: $store.showAllTrends) {
//                AllTrendsSheetView(store: store)
//            }
//            .onAppear { store.send(.load) }
//        }
//        .tabItem { Label("Тренды", systemImage: "chart.line.uptrend.xyaxis") }
//    }
//}
//
//// --- 1. Отдельная карта с графиком
//struct TrendsChartCard: View {
//    @Bindable var store: StoreOf<TrendsFeature>
//    var body: some View {
//        CardView {
//            VStack(alignment: .leading) {
//                Text(label(for: store.selectedField)).font(.title2.bold())
//                    .foregroundStyle(Color("textfieldColor"))
//                if !store.fieldTrends.isEmpty {
//                    TrendsChart(fieldTrends: store.fieldTrends)
//                        .frame(height: 120)
//                        .padding(.vertical, 4)
//                }
//                HStack {
//                    Text(formatValue(store.fieldTrends.last?.value))
//                        .font(.largeTitle.bold())
//                        .foregroundStyle(Color("textfieldColor"))
//                    Spacer()
//                    if let diff = store.fieldTrends.last?.diff {
//                        Text(diff > 0 ? "▲ \(formatValue(diff))" : diff < 0 ? "▼ \(formatValue(abs(diff)))" : "—")
//                            .foregroundColor(diff > 0 ? .green : diff < 0 ? .red : .gray)
//                            .font(.title2.bold())
//                    }
//                }
//            }
//
//            .background(Color("bodyColor"))
//        }
//    }
//    private func label(for field: String) -> String {
//        TrendsFeatureView.labelStatic(for: field)
//    }
//    private func formatValue(_ value: Double?) -> String {
//        TrendsFeatureView.formatValueStatic(value)
//    }
//}
//
//// --- 2. Chart вынесен отдельно
//struct TrendsChart: View {
//    let fieldTrends: [TrendItem]
//    var body: some View {
//        Chart(fieldTrends) { item in
//            LineMark(
//                x: .value("Date", item.date),
//                y: .value("Value", item.value)
//            )
//            .interpolationMethod(.catmullRom)
//            .foregroundStyle(Gradient(colors: [.green, .blue]))
//        }
//        .foregroundStyle(Color("textfieldColor"))
//    }
//}
//
//// --- 3. Основная карточка трендов
//struct TrendsMainCard: View {
//    @Bindable var store: StoreOf<TrendsFeature>
//    @Namespace private var trendNamespace
//
//    // Сетка: 3 в ряд
//    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 3)
//
//    var body: some View {
//        CardView {
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Избранные измерения")
//                    .font(.headline)
//                    .foregroundColor(Color("textfieldColor"))
//                    .padding(.leading, 4)
//
//                LazyVGrid(columns: columns, spacing: 12) {
//                    ForEach(store.mainTrends.prefix(6)) { trend in
//                        TrendGridIconView(trend: trend)
//                            .matchedGeometryEffect(id: trend.id, in: trendNamespace)
//                            .onTapGesture {
//                                store.send(.selectField(trend.field))
//                            }
//                    }
//                }
//                .padding(.top, 4)
//                .padding(.bottom, 2)
//
//                HStack {
//                    Spacer()
//                    Button("Другие") {
//                        store.send(.showAllTrends(true))
//                    }
//                    .font(.subheadline)
//                    .foregroundColor(Color("textfieldColor"))
//                    .padding(.top, 4)
//                }
//            }
//        }
//    }
//}
//
//// --- 4. CardView
//struct CardView<Content: View>: View {
//    let content: () -> Content
//    var body: some View {
//        VStack {
//            content()
//        }
//        .padding()
//        .background(Color("bodyColor"))
//        .cornerRadius(20)
//        .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 2)
//    }
//}
//
//
//struct AllTrendsSheetView: View {
//    @Bindable var store: StoreOf<TrendsFeature>
//    @Namespace private var trendNamespace
//    @Environment(\.editMode) private var editMode
//
//    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 3)
//    @State private var isEditing: Bool = false
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 16) {
//                    ForEach(store.allTrends) { trend in
//                        TrendGridIconView(trend: trend)
//                            .matchedGeometryEffect(id: trend.id, in: trendNamespace)
//                            .onTapGesture {
//                                if !isEditing { store.send(.selectField(trend.field)) }
//                            }
//                            .onLongPressGesture {
//                                withAnimation { isEditing = true }
//                                // Обновить editMode для EditButton
//                                DispatchQueue.main.async {
//                                    editMode?.wrappedValue = .active
//                                }
//                            }
//                            .draggable(isEditing ? trend.field : nil)
//                    }
//                    .onMove { indices, newOffset in
//                        store.send(.mainTrendsReordered(indices, newOffset))
//                    }
//                }
//                .padding(16)
//            }
//            .background(Color("backgroundColor"))
//            .navigationTitle("Все тренды")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    if isEditing {
//                        Button("Готово") {
//                            withAnimation { isEditing = false }
//                            editMode?.wrappedValue = .inactive
//                        }
//                    } else {
//                        EditButton()
//                            .onTapGesture {
//                                withAnimation { isEditing = true }
//                            }
//                    }
//                }
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Закрыть") { store.send(.showAllTrends(false)) }
//                }
//            }
//        }
//    }
//}
//
//struct TrendGridIconView: View {
//    let trend: TrendItem
//
//    var body: some View {
//        VStack(spacing: 6) {
//            Text(TrendsFeatureView.labelStatic(for: trend.field))
//                .font(.caption)
//                .fontWeight(.semibold)
//                .multilineTextAlignment(.center)
//                .foregroundColor(.primary)
//                .lineLimit(2)
//                .frame(maxWidth: 72)
//            Text(TrendsFeatureView.formatValueStatic(trend.value))
//                .font(.headline)
//            if trend.diff != 0 {
//                Text(trend.diff > 0 ? "▲ \(TrendsFeatureView.formatValueStatic(abs(trend.diff)))"
//                                    : "▼ \(TrendsFeatureView.formatValueStatic(abs(trend.diff)))")
//                    .font(.caption2)
//                    .foregroundColor(trend.diff > 0 ? .green : .red)
//            } else {
//                Text("—")
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//            }
//        }
//        .frame(width: 90, height: 120)
//        .background(
//            RoundedRectangle(cornerRadius: 20)
//                .fill(backgroundColor(for: trend.diff))
//        )
//        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
//        .padding(2)
//    }
//
//    private func backgroundColor(for diff: Double) -> Color {
//        if diff > 0 {
//            return Color.green.opacity(0.15)
//        } else if diff < 0 {
//            return Color.red.opacity(0.15)
//        } else {
//            return Color(.systemGray5).opacity(0.35) // или .ultraThinMaterial для iOS 15+
//        }
//    }
//}
//
//// --- 6. Статические методы для format/label/color (чтобы использовать вне структуры TrendsFeatureView)
//extension TrendsFeatureView {
//    static func formatValueStatic(_ value: Double?) -> String {
//        guard let v = value else { return "–" }
//        return String(format: "%.1f", v)
//    }
//    static func labelStatic(for field: String) -> String {
//        switch field {
//        case "weight": return "Вес"
//        case "chest": return "Грудь"
//        case "waist": return "Талия"
//        case "forearm": return "Предплечье"
//        case "biceps": return "Бицепс"
//        case "neck": return "Шея"
//        case "shoulders": return "Плечи"
//        case "thigh": return "Бедро"
//        case "buttocks": return "Ягодицы"
//        case "calf": return "Икра"
//        case "stomach": return "Живот"
//        case "height": return "Рост"
//        case "fatPercent": return "% Жира"
//        default: return field
//        }
//    }
//    static func colorStatic(for field: String) -> Color {
//        switch field {
//        case "weight": return .purple
//        case "chest": return .blue
//        case "waist": return .yellow
//        case "biceps", "calf": return .green
//        case "buttocks": return .red
//        case "thigh": return .orange
//        default: return .white
//        }
//    }
//}

//
//#Preview {
//    TrendsFeatureView()
//}
