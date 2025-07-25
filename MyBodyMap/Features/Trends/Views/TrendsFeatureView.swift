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
            ZStack{
                Color("BGColor").ignoresSafeArea()
                VStack(spacing: 20) {
                    TrendsMainCardView(
                        store: store.scope(
                            state: \.mainCardState,
                            action: \.mainCard
                        ), onShowAll: { store.send(.showAllTrends(true)) }
                    )
                    ChartFeatureView(
                        store: store.scope(
                            state: \.chartState,
                            action: \.chart
                        )
                    )
                }
                .padding(.top)
                .sheet(isPresented: $store.showAllTrends) {
                    AllTrendsSheetView(store: store)
                }
                .onDisappear {
                    store.send(.updateTrendsOrder(store.dragState.items.map(\.id)))
                }
                .onAppear { store.send(.load) }
                .background(Color("BGColor"))
                .navigationTitle("Тренды")
            }
        }
    }
}
