//
//  DragAndDropGridView.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct DragAndDropGridView<Item: Identifiable & Equatable, Content: View>: View {
    @Bindable var store: StoreOf<DragAndDropFeature<Item>>
    let itemView: (Item, Bool) -> Content
    let columns: [GridItem]

    public init(
        store: StoreOf<DragAndDropFeature<Item>>,
        columns: [GridItem],
        @ViewBuilder itemView: @escaping (Item, Bool) -> Content
    ) {
        self.store = store
        self.columns = columns
        self.itemView = itemView
    }

    public var body: some View {
        CardView{
            LazyVGrid(columns: columns, spacing: 16) {
                 ForEach(Array(store.items.enumerated()), id: \.1.id) { idx, item in
                     itemView(item, store.draggingID == item.id)
                         .opacity(store.draggingID == item.id ? 0.7 : 1)
                         .scaleEffect(store.draggingID == item.id ? 1.09 : 1)
                         .onDrag {
                             store.send(.dragStarted(item.id))
                             return NSItemProvider(object: NSString(string: "\(item.id)"))
                         }
                         .dropDestination(for: String.self) { dropItems, _ in
                             guard
                                 let draggingID = store.draggingID,
                                 let from = store.items.firstIndex(where: { $0.id == draggingID }),
                                 from != idx
                             else { return false }
                             store.send(.dragMoved(from: from, to: idx))
                             return true
                         }
                 }
             }
            .animation(.default, value: store.items)
            .onDrop(of: [.text], isTargeted: nil) { _, _ in
                store.send(.dragEnded)
                return true
            }
        }
    }
}
