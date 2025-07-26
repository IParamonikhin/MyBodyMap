//
//  DragAndDropFeature.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct DragAndDropFeature {
    @ObservableState
    public struct State: Equatable {
        public var items: [TrendItem]
        public var draggingItem: TrendItem?
        
        public init(items: [TrendItem]) { self.items = items }
    }

    @CasePathable
    public enum Action {
        case moveItem(from: IndexSet, to: Int)
        case dragBegan(TrendItem)
        case dragEnded
        case drop(to: TrendItem)
        case dropEntered(to: TrendItem)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .moveItem(from, to):
                state.items.move(fromOffsets: from, toOffset: to)
                return .none
            case let .dragBegan(item):
                state.draggingItem = item
                return .none
            case .dragEnded:
                state.draggingItem = nil
                return .none
            case let .drop(to: item):
                if let dragging = state.draggingItem,
                   let fromIndex = state.items.firstIndex(of: dragging),
                   let toIndex = state.items.firstIndex(of: item),
                   fromIndex != toIndex {
                    state.items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
                }
                state.draggingItem = nil
                return .none
            case let .dropEntered(to: item):
                // Можно реализовать подсветку, анимации или ничего не делать
                return .none
            }
        }
    }
}

//import ComposableArchitecture
//import Foundation
//
//@Reducer
//public struct DragAndDropFeature {
//    @ObservableState
//    public struct State: Equatable {
//        public var items: [DragAndDropItem]
//        public var dragging: Bool = false
//        public init(items: [DragAndDropItem]) {
//            self.items = items
//        }
//    }
//
//    @CasePathable
//    public enum Action: BindableAction {
//        case binding(BindingAction<State>)
//        case startDrag
//        case endDrag([DragAndDropItem])
//        case moveItem(from: Int, to: Int)
//        case drop
//    }
//
//    public var body: some ReducerOf<Self> {
//        BindingReducer()
//        Reduce { state, action in
//            switch action {
//            case .startDrag:
//                state.dragging = true
//                return .none
//            case .endDrag(let newOrder):
//                state.items = newOrder
//                state.dragging = false
//                // Проброс наверх через .fieldsDidReorder (AllTrendsSheetFeature)
//                return .none
//            case let .moveItem(from, to):
//                var updated = state.items
//                let item = updated.remove(at: from)
//                updated.insert(item, at: to)
//                state.items = updated
//                return .none
//            case .drop:
//                state.dragging = false
//                return .none
//            default: return .none
//            }
//        }
//    }
//}

//import ComposableArchitecture
//import Foundation
//
//@Reducer
//public struct DragAndDropFeature<Item: Identifiable & Equatable> {
//    @ObservableState
//    public struct State: Equatable {
//        public var items: [Item]
//        public var draggingID: Item.ID?
//
//        public init(items: [Item]) {
//            self.items = items
//            self.draggingID = nil
//        }
//    }
//
//    public enum Action: Equatable {
//        case dragStarted(Item.ID)
//        case dragMoved(from: Int, to: Int)
//        case dragEnded
//        case setItems([Item]) // Use this to set the initial items or update them from parent
//    }
//
//    public var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case let .dragStarted(id):
//                state.draggingID = id
//                return .none
//            case let .dragMoved(from, to):
//                guard from != to else { return .none }
//                // Ensure 'from' and 'to' indices are valid to prevent crashes
//                guard state.items.indices.contains(from),
//                      state.items.indices.contains(to) else { return .none }
//
//                let item = state.items.remove(at: from)
//                state.items.insert(item, at: to)
//                return .none
//            case .dragEnded:
//                state.draggingID = nil
//                return .none
//            case let .setItems(newItems):
//                state.items = newItems
//                return .none
//            }
//        }
//    }
//}
//
