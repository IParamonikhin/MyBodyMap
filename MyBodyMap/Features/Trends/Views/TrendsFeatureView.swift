//
//  TrendsFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import SwiftUI
import ComposableArchitecture

//public struct TrendsFeatureView: View {
//    @Bindable var store: StoreOf<TrendsFeature>
//    public init(store: StoreOf<TrendsFeature>) { self.store = store }
//    public var body: some View {
//        NavigationStack {
//            ScrollView {
//                VStack(spacing: 20) {
//                    TrendsChartCard(store: store)
//                        .padding(.horizontal, 16)
//                    CardView {
//                        HStack {
//                            ForEach(store.mainTrends) { trend in
//                                TrendGridIconView(trend: trend)
//                                    .onTapGesture { store.send(.selectField(trend.field)) }
//                            }
//                            Spacer()
//                            Button("Другие") { store.send(.showAllTrends(true)) }
//                                .foregroundColor(Color("FontColor"))
//                        }
//                    }
//                    .padding(.horizontal, 16)
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


//import SwiftUI
//import ComposableArchitecture
//
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
            .background(Color("BGColor"))
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


//
//#Preview {
//    TrendsFeatureView()
//}
