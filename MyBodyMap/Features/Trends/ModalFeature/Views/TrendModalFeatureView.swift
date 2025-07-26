//
//  TrendModalFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 25.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct TrendModalFeatureView: View {
    @Bindable var store: StoreOf<TrendModalFeature>
    @Environment(\.dismiss) var dismiss

    public init(store: StoreOf<TrendModalFeature>) { self.store = store }
    
    public var body: some View {
        let reversedTrends = Array(store.trends.reversed())
        NavigationStack {
            ZStack{
                Color("BGColor").ignoresSafeArea()
                VStack(spacing: 0) {
                    CardView {
                        ChartFeatureView(store: store.scope(state: \.chart, action: \.chart))
                            .frame(height: 200)
                            .padding(.top)
                        
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                    CardView {
                        List {
                            ForEach(reversedTrends) { trend in
                                HStack {
                                    Text(trend.date, style: .date)
                                    Spacer()
                                    Text(trend.formatValue).bold()
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete { idx in
                                let original = idx.map { store.trends.count - 1 - $0 }
                                store.send(.delete(IndexSet(original)))
                            }
                        }
                        .listStyle(.plain)
                        .padding(.top)
                    }
                    .padding(.horizontal, 16)
                }
                .navigationTitle(store.field.capitalized)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Закрыть") { dismiss() }
                    }
                }
                .alert($store.scope(state: \.alert, action: \.alert))
            }
        }
    }
}

//import SwiftUI
//import ComposableArchitecture
//
//public struct TrendModalFeatureView: View {
//    @Bindable var store: StoreOf<TrendModalFeature>
//    public init(store: StoreOf<TrendModalFeature>) { self.store = store }
//
//    public var body: some View {
//        NavigationStack {
//            VStack(spacing: 0) {
//                CardView {
//                    ChartFeatureView(store: store.scope(state: \.chart, action: \.chart))
//                        .frame(height: 160)
//                }
//                .padding(.horizontal)
//                .padding(.top)
//                
//                CardView {
//                    List {
//                        ForEach(store.trends) { trend in
//                            HStack {
//                                Text(trend.date, style: .date)
//                                Spacer()
//                                Text(trend.formatValue)
//                                    .bold()
//                            }
//                            .padding(.vertical, 4)
//                        }
//                        .onDelete { idx in
//                            store.send(.delete(idx))
//                        }
//                    }
//                    .listStyle(.plain)
//                }
//                .padding(.horizontal)
//                .padding(.top)
//                
//            }
//            .navigationTitle("История")
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Закрыть") {
//                        // Закрытие через parent, если нужно
//                    }
//                }
//            }
//        }
//        .onAppear { store.send(.onAppear) }
//        .alert($store, state: \.alert)
//    }
//}
