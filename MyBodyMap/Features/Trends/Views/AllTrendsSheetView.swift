//
//  AllTrendsSheetView.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct AllTrendsSheetView: View {
    @Bindable var store: StoreOf<TrendsFeature>
    @State private var selectedField: String?
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
   
    var body: some View {
        DragAndDropGridView(
            store: store.scope(
                state: \.dragState,
                action: \.dragAndDrop
            ),
            columns: columns,
            itemView: { item, isDragging in
                TrendGridIconView(trend: item)
                    .opacity(isDragging ? 0.6 : 1)
                    .scaleEffect(isDragging ? 1.07 : 1)
                    .onTapGesture {
                        selectedField = item.field 
                    }
            }
        )
        .navigationTitle("Все тренды")
        .background(Color("BGColor"))
        .sheet(item: $selectedField) { field in
            TrendModalFeatureView(
                store: Store(
                    initialState: TrendModalFeature.State(field: field),
                    reducer: { TrendModalFeature() }
                )
            )
        }
    }
}
