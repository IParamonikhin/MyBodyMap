//
//  TrendsFeature.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct TrendsFeature {
    @ObservableState
    public struct State: Equatable {
        public var allTrends: [TrendItem] = []
        public var mainTrends: [TrendItem] = []
        public var fieldTrends: [TrendItem] = []
        public var selectedField: String = "weight"
        public var showAllTrends: Bool = false
        // DragAndDrop state
        public var dragState: DragAndDropFeature<TrendItem>.State = .init(items: [])

        public init() {} // Add an initializer for easier State creation if needed elsewhere
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case load
        case loaded([TrendItem])
        case selectField(String)
        case showAllTrends(Bool)
        case dragAndDrop(DragAndDropFeature<TrendItem>.Action)
    }

    @Dependency(\.trendsService) var trendsService

    public var body: some ReducerOf<Self> {
        BindingReducer() // Keeps your @BindingState properties in sync

        Scope(state: \.dragState, action: \.dragAndDrop) {
            DragAndDropFeature<TrendItem>()
        }

        Reduce { state, action in
            switch action {
            case .binding:
                return .none // BindingReducer handles this

            case .load:
                let items = trendsService.loadAllTrends()
                state.allTrends = items
                state.mainTrends = Array(items.prefix(6))
                state.dragState.items = items // Initialize drag-and-drop items
                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
                return .none

            case let .loaded(items):
                state.allTrends = items
                state.mainTrends = Array(items.prefix(6))
                state.dragState.items = items
                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
                return .none

            case let .selectField(field):
                state.selectedField = field
                state.fieldTrends = trendsService.loadTrends(for: field)
                return .none

            case let .showAllTrends(show):
                state.showAllTrends = show
                return .none

            case .dragAndDrop(.dragEnded):
                // When drag ends in the child, update parent's trend lists
                state.allTrends = state.dragState.items
                state.mainTrends = Array(state.dragState.items.prefix(6))
                // Recalculate fieldTrends based on the potentially reordered allTrends or a specific service call
                state.fieldTrends = trendsService.loadTrends(for: state.selectedField) // Assuming this uses the internal allTrends or is independent
                return .none

            case .dragAndDrop:
                // Other dragAndDrop actions (dragStarted, dragMoved) are handled by the Scope,
                // and their state changes within dragState will automatically propagate due to @ObservableState.
                // No further action is needed here unless you want side effects for these specific actions.
                return .none
            }
        }
    }
}
