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
        BindingReducer()
        Scope(state: \.dragState, action: /Action.dragAndDrop) {
            DragAndDropFeature<TrendItem>()
        }
        Reduce { state, action in
            switch action {
            case .binding: return .none
            case .load:
                // Загрузка всех трендов и обновление состояния
                let items = trendsService.loadAllTrends()
                state.allTrends = items
                state.mainTrends = Array(items.prefix(6))
                state.dragState.items = items
                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
                return .none

            case let .loaded(items):
                state.allTrends = items
                state.mainTrends = Array(items.prefix(6))
                state.dragState.items = items
                // Не забываем обновить fieldTrends, если items изменились
                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
                return .none

            case let .selectField(field):
                state.selectedField = field
                state.fieldTrends = trendsService.loadTrends(for: field)
                return .none

            case let .showAllTrends(show):
                state.showAllTrends = show
                return .none

            case .dragAndDrop(.itemsChanged(let items)):
                state.allTrends = items
                state.mainTrends = Array(items.prefix(6))
                // Не забываем обновить fieldTrends, если selectedField изменился!
                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
                return .none

            case .dragAndDrop:
                return .none
            }
        }
    }
}
