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
        public var selectedField: String = "weight"
        public var allTrends: [TrendItem] = []
        public var showAllTrends: Bool = false
        public var dragItem: TrendItem? = nil

        public var fieldTrends: [TrendItem] {
            allTrends.first(where: { $0.field == selectedField }).map { [$0] } ?? []
        }

        public var mainTrends: [TrendItem] {
            Array(allTrends.prefix(6))
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case load
        case mainTrendsReordered(IndexSet, Int)
        case selectField(String)
        case showAllTrends(Bool)
    }

    @Dependency(\.trendsService) var trendsService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .load:
                let trends = trendsService.loadAllTrends()
                state.allTrends = trends
                return .none
            case let .mainTrendsReordered(indices, newOffset):
                state.allTrends.move(fromOffsets: indices, toOffset: newOffset)
                trendsService.saveOrder(state.allTrends.map { $0.field })
                return .none
            case let .selectField(field):
                state.selectedField = field
                state.showAllTrends = false
                return .none
            case let .showAllTrends(show):
                state.showAllTrends = show
                return .none
            }
        }
    }
}

//import Foundation
//import ComposableArchitecture
//
//@Reducer
//public struct TrendsFeature {
//    @ObservableState
//    public struct State: Equatable {
//        public var mainTrends: [TrendItem] = []
//        public var allTrends: [TrendItem] = []
//        public var draggingField: String? = nil
//        public var selectedField: String = "weight"
//        public var showAllTrends: Bool = false
//        public var fieldTrends: [TrendItem] = []
//        public init() {}
//    }
//
//    public enum Action: BindableAction {
//        case binding(BindingAction<State>)
//        case load
//        case reload
//        case mainTrendsReordered(IndexSet, Int)
//        case showAllTrends(Bool)
//        case selectField(String)
//        case startDragging(String)
//        case moveItem(String, String)
//        case endDragging
//    }
//
//    @Dependency(\.trendsService) var trendsService
//
//    public var body: some ReducerOf<Self> {
//        BindingReducer()
//        Reduce { state, action in
//            switch action {
//            case .binding:
//                return .none
//                
//            case .load, .reload:
//                let all = trendsService.loadTrendsAllFields()
//                let order = trendsService.loadMainTrendsOrder()
//                if order.isEmpty {
//                    state.mainTrends = Array(all.prefix(6))
//                } else {
//                    state.mainTrends = order.compactMap { key in
//                        all.first(where: { $0.field == key })
//                    }
//                }
//                state.allTrends = all
//                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
//                return .none
//                
//            case let .mainTrendsReordered(indices, newOffset):
//                state.mainTrends.move(fromOffsets: indices, toOffset: newOffset)
//                let order = state.mainTrends.map { $0.field }
//                trendsService.saveMainTrendsOrder(order)
//                return .none
//                
//            case let .showAllTrends(flag):
//                state.showAllTrends = flag
//                return .none
//                
//            case let .selectField(field):
//                state.selectedField = field
//                state.fieldTrends = trendsService.loadTrends(for: field)
//                return .none
//                
//            case .startDragging(let field):
//                state.draggingField = field
//                return .none
//                
//            case .moveItem(let from, let to):
//                if let fromIndex = state.allTrends.firstIndex(where: { $0.field == from }),
//                   let toIndex = state.allTrends.firstIndex(where: { $0.field == to }), fromIndex != toIndex {
//                    let item = state.allTrends.remove(at: fromIndex)
//                    state.allTrends.insert(item, at: toIndex)
//                }
//                return .none
//                
//            case .endDragging:
//                state.draggingField = nil
//                return .none
//            }
//        }
//    }
//}
