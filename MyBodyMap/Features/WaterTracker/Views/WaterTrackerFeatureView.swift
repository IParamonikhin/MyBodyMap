//
//  WaterTrackerFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct WaterTrackerView: View {
    @Bindable var store: StoreOf<WaterTrackerFeature>
    public init(store: StoreOf<WaterTrackerFeature>) { self.store = store }

    public var body: some View {
        VStack(spacing: 24) {
            Text("Выпито \(Int(store.dailyIntake)) из \(Int(store.goal)) мл")
                .font(.headline)
            ProgressView(value: store.dailyIntake, total: store.goal)
                .progressViewStyle(.circular)
                .frame(width: 160, height: 160)
            HStack(spacing: 12) {
                Button("+ Стакан") { store.send(.addGlass) }
                    .buttonStyle(.borderedProminent)
                Slider(
                    value: $store.goal,
                    in: 1000...5000, step: 100
                ) {
                    Text("Цель")
                }
            }
        }
        .padding()
        .navigationTitle("Трекер воды")
        .onAppear { store.send(.load) }
    }
}
