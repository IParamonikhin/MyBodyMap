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
    public init(store: StoreOf<TrendModalFeature>) { self.store = store }

    public var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CardView {
                    if store.trends.isEmpty {
                        Text("Нет данных для графика")
                            .foregroundColor(.secondary)
                            .frame(height: 120)
                    } else {
                        TrendsChart(fieldTrends: store.trends)
                            .frame(height: 160)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                List {
                    ForEach(store.trends) { trend in
                        HStack {
                            Text(trend.date, style: .date)
                            Spacer()
                            Text(trend.formatValue)
                                .bold()
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { idx in
                        store.send(.delete(idx))
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("История")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") {
                        // Закрытие через parent, если нужно
                    }
                }
            }
        }
        .onAppear { store.send(.onAppear) }
        .alert(store: $store.alert)
    }
}
