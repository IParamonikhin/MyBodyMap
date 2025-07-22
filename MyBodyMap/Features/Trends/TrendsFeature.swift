//
//  TrendsFeature.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct TrendsFeature {
    @ObservableState
    public struct State: Equatable {
        public var mainTrends: [TrendItem] = []
        public var allTrends: [TrendItem] = []
        public var selectedField: String = "weight" // по умолчанию weight
        public var showAllTrends: Bool = false
        public var fieldTrends: [TrendItem] = [] // для выбранного поля (график)
        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case load
        case reload
        case mainTrendsReordered(IndexSet, Int)
        case showAllTrends(Bool)
        case selectField(String)
    }

    @Dependency(\.trendsService) var trendsService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .load, .reload:
                let all = trendsService.loadTrendsAllFields()
                let order = trendsService.loadMainTrendsOrder()
                // порядок главных карточек
                if order.isEmpty {
                    state.mainTrends = Array(all.prefix(6))
                } else {
                    state.mainTrends = order.compactMap { key in
                        all.first(where: { $0.field == key })
                    }
                }
                state.allTrends = all
                // По умолчанию грузим тренд по weight (или по selectedField)
                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
                return .none

            case let .mainTrendsReordered(indices, newOffset):
                state.mainTrends.move(fromOffsets: indices, toOffset: newOffset)
                let order = state.mainTrends.map { $0.field }
                trendsService.saveMainTrendsOrder(order)
                return .none

            case let .showAllTrends(flag):
                state.showAllTrends = flag
                return .none

            case let .selectField(field):
                state.selectedField = field
                state.fieldTrends = trendsService.loadTrends(for: field)
                return .none
            }
        }
    }
}
