//
//  MeasuresFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct MeasuresView: View {
    @Bindable var store: StoreOf<MeasuresFeature>
    public init(store: StoreOf<MeasuresFeature>) { self.store = store }
    
    public var body: some View {
        NavigationStack {
            ZStack{
                Color("BGColor").ignoresSafeArea()
                VStack(spacing: 0) {
                    BodySilhouetteView(
                        selectedField: store.selectedField,
                        onSelect: { field in store.send(.selectField(field)) },
                        gender: store.gender,
                        latestMeasures: store.latestMeasures
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 10)
                }
                .sheet(isPresented: $store.showInputModal) {
                    if let field = store.selectedField {
                        MeasureInputModal(
                            field: field,
                            value: store.latestMeasures[field.rawValue]?.value ?? 0
                        ) { val in
                            if val > 0 {
                                store.send(.addMeasure(field.rawValue, val, Date()))
                            }
                        }
                    }
                }
                .onAppear {
                    store.send(.loadAll)
                    store.send(.loadGender)
                }
            }
        }
    }
}
