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


//struct DropViewDelegate: DropDelegate {
//    let item: TrendItem
//    @Binding var items: [TrendItem]
//    @Binding var draggingItem: TrendItem?
//
//    func performDrop(info: DropInfo) -> Bool {
//        guard let draggingItem = draggingItem else { return false }
//        if let fromIndex = items.firstIndex(of: draggingItem),
//           let toIndex = items.firstIndex(of: item),
//           fromIndex != toIndex {
//            items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
//        }
//        self.draggingItem = nil
//        return true
//    }
//}
//import SwiftUI
//import ComposableArchitecture
//
//public struct DragAndDropGridView<Item: Identifiable & Equatable, Content: View>: View {
//    @Bindable var store: StoreOf<DragAndDropFeature<Item>>
//    let itemView: (Item, Bool) -> Content
//    let columns: [GridItem]
//
//    public init(
//        store: StoreOf<DragAndDropFeature<Item>>,
//        columns: [GridItem],
//        @ViewBuilder itemView: @escaping (Item, Bool) -> Content
//    ) {
//        self.store = store
//        self.columns = columns
//        self.itemView = itemView
//    }
//
//    public var body: some View {
//        CardView{
//            LazyVGrid(columns: columns, spacing: 16) {
//                 ForEach(Array(store.items.enumerated()), id: \.1.id) { idx, item in
//                     itemView(item, store.draggingID == item.id)
//                         .opacity(store.draggingID == item.id ? 0.7 : 1)
//                         .scaleEffect(store.draggingID == item.id ? 1.09 : 1)
//                         .onDrag {
//                             store.send(.dragStarted(item.id))
//                             return NSItemProvider(object: NSString(string: "\(item.id)"))
//                         }
//                         .dropDestination(for: String.self) { dropItems, _ in
//                             guard
//                                 let draggingID = store.draggingID,
//                                 let from = store.items.firstIndex(where: { $0.id == draggingID }),
//                                 from != idx
//                             else { return false }
//                             store.send(.dragMoved(from: from, to: idx))
//                             return true
//                         }
//                 }
//             }
//            .animation(.default, value: store.items)
//            .onDrop(of: [.text], isTargeted: nil) { _, _ in
//                store.send(.dragEnded)
//                return true
//            }
//        }
//    }
//}
