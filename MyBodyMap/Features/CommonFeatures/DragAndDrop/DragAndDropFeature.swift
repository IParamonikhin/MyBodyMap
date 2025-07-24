//
//  DragAndDropFeature.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import ComposableArchitecture

@Reducer
public struct DragAndDropFeature<Item: Identifiable & Equatable> {
    @ObservableState
    public struct State: Equatable {
        public var items: [Item]
        public var draggingID: Item.ID?
        public init(items: [Item]) {
            self.items = items
            self.draggingID = nil
        }
    }

    public enum Action: Equatable {
        case dragStarted(Item.ID)
        case dragMoved(from: Int, to: Int)
        case dragEnded
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .dragStarted(id):
                state.draggingID = id
                return .none
            case let .dragMoved(from, to):
                guard from != to else { return .none }
                let item = state.items.remove(at: from)
                state.items.insert(item, at: to)
                return .none
            case .dragEnded:
                state.draggingID = nil
                return .none
            }
        }
    }
}

//import ComposableArchitecture
//import Foundation
//
//public struct DragAndDropFeature<Item: Identifiable & Equatable>: Reducer {
//    public struct State: Equatable {
//        public var items: [Item]
//        public var draggingID: Item.ID? = nil
//
//        public init(items: [Item]) {
//            self.items = items
//        }
//    }
//
//    public enum Action: Equatable {
//        case dragStarted(Item.ID)
//        case dragMoved(from: Int, to: Int)
//        case dragEnded
//        case setItems([Item])
//    }
//
//    public var body: some ReducerOf<Self> {
//        Reduce { state, action in
//            switch action {
//            case let .dragStarted(id):
//                state.draggingID = id
//                return .none
//            case let .dragMoved(from, to):
//                guard from != to, from < state.items.count, to < state.items.count else { return .none }
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
