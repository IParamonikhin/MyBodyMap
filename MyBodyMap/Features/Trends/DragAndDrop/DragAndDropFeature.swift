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
                return .none
            }
        }
    }
}
