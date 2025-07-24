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
            VStack(spacing: 20) {
                TrendsMainCardView(store: store)
                TrendsChartCardView(store: store)
            }
            .padding(.top)
            .sheet(isPresented: $store.showAllTrends) {
                AllTrendsSheetView(store: store)
            }
            .onAppear { store.send(.load) }
            .background(Color("BGColor"))
            .navigationTitle("Тренды")
        }
    }
}
