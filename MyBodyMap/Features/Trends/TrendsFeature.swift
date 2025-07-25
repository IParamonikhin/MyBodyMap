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
        public var dragState: DragAndDropFeature<TrendItem>.State = .init(items: [])
        public var mainCardState: TrendsMainCardFeature.State = .init()
        public var chartState = ChartFeature.State()
        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case load
        case loaded([TrendItem])
        case selectField(String)
        case showAllTrends(Bool)
        case dragAndDrop(DragAndDropFeature<TrendItem>.Action)
        case mainCard(TrendsMainCardFeature.Action)
        case updateTrendsOrder([UUID])
        case chart(ChartFeature.Action)
    }

    @Dependency(\.trendsService) var trendsService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Scope(state: \.dragState, action: \.dragAndDrop) { DragAndDropFeature<TrendItem>() }
        Scope(state: \.mainCardState, action: \.mainCard) { TrendsMainCardFeature() }
        Scope(state: \.chartState, action: \.chart) { ChartFeature() }
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .load:
                let items = trendsService.loadAllTrends()
                state.allTrends = items
                let first6 = Array(items.prefix(6))
                state.mainTrends = first6
                state.dragState.items = items
                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
                return .send(.mainCard(.setTrends(first6)))

            case let .loaded(items):
                state.allTrends = items
                let first6 = Array(items.prefix(6))
                state.mainTrends = first6
                state.dragState.items = items
                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
                return .send(.mainCard(.setTrends(first6)))

            case let .selectField(field):
                state.selectedField = field
                state.fieldTrends = trendsService.loadTrends(for: field)
                return .none

            case let .showAllTrends(show):
                state.showAllTrends = show
                return .none

            case .dragAndDrop(.dragEnded):
                state.allTrends = state.dragState.items
                let first6 = Array(state.dragState.items.prefix(6))
                state.mainTrends = first6
                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
                return .send(.mainCard(.setTrends(first6)))

            case .dragAndDrop:
                return .none

            case .mainCard:
                return .none
                
            case let .updateTrendsOrder(newOrderIDs):
                state.allTrends = newOrderIDs.compactMap { id in
                    state.allTrends.first(where: { $0.id == id })
                }
                state.mainTrends = Array(state.allTrends.prefix(6))
                state.dragState.items = state.allTrends
                trendsService.saveOrder(newOrderIDs.map { $0.uuidString })
                return .none
                
            case .chart(_):
                return .none
            }
        }
    }
}
