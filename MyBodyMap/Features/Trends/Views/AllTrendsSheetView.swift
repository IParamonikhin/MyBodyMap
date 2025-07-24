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
    var body: some View {
        DragAndDropGridView(
            store: store.scope(
                state: \.dragState,
                action: TrendsFeature.Action.dragAndDrop
            ),
            itemView: { item, isDragging in
                TrendGridIconView(trend: item)
                    .opacity(isDragging ? 0.6 : 1)
                    .scaleEffect(isDragging ? 1.07 : 1)
            }
        )
        .navigationTitle("Все тренды")
        .background(Color("BGColor"))
    }
}
