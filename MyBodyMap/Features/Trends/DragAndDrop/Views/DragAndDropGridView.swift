//
//  DragAndDropGridView.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct DragAndDropGridView<Content: View>: View {
    @Bindable var store: StoreOf<DragAndDropFeature>
    let columns: [GridItem]
    let itemView: (TrendItem, Bool) -> Content

    public init(
        store: StoreOf<DragAndDropFeature>,
        columns: [GridItem],
        @ViewBuilder itemView: @escaping (TrendItem, Bool) -> Content
    ) {
        self.store = store
        self.columns = columns
        self.itemView = itemView
    }

    public var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(Array(store.items.enumerated()), id: \.1.id) { idx, item in
                GridItemView(
                    item: item,
                    isDragging: store.draggingItem == item,
                    idx: idx,
                    store: store,
                    itemView: itemView
                )
            }
        }
        .animation(.default, value: store.items)
    }
}

private struct GridItemView<Content: View>: View {
    let item: TrendItem
    let isDragging: Bool
    let idx: Int
    let store: StoreOf<DragAndDropFeature>
    let itemView: (TrendItem, Bool) -> Content

    var body: some View {
        itemView(item, isDragging)
            .opacity(isDragging ? 0.7 : 1)
            .scaleEffect(isDragging ? 1.09 : 1)
            .draggable(item)
            .dropDestination(for: TrendItem.self) { droppedItems, _ in
                guard let dropped = droppedItems.first,
                      let from = store.items.firstIndex(of: dropped),
                      from != idx
                else { return false }
                store.send(.moveItem(from: IndexSet(integer: from), to: idx))
                store.send(.dragEnded)
                return true
            }
    }
}
