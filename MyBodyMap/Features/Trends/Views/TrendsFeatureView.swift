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
            ZStack {
                Color("BGColor").ignoresSafeArea()
                VStack(spacing: 20) {
                    TrendsMainCardView(
                        store: store.scope(state: \.mainCard, action: \.mainCard),
                        selectedField: store.chart.field,
                        onSelectField: { field in store.send(.selectField(field)) },
                        onShowAll: { store.send(.presentAllTrendsSheetButtonTapped) }
                    )
                    ChartFeatureView(store: store.scope(state: \.chart, action: \.chart))
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Тренды")
            .foregroundStyle(Color("FontColor"))
            .navigationDestination(
                item: $store.scope(state: \.allTrendsSheet, action: \.allTrendsSheet)
            ) { allTrendsStore in
                AllTrendsSheetView(
                    store: allTrendsStore,
                    selectedField: store.chart.field
                )
            }
            .sheet(store: store.scope(state: \.$modal, action: \.modal)) { store in
                TrendModalFeatureView(store: store)
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
    
}
