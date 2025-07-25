//
//  ChartFeature.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct ChartFeature {
    @ObservableState
    public struct State: Equatable {
        public var field: String
        public var trends: [TrendItem] = []
        public init(field: String, trends: [TrendItem] = []) {
            self.field = field
            self.trends = trends
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case load
        case setTrends([TrendItem])
    }

    @Dependency(\.trendsService) var trendsService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .load:
                state.trends = trendsService.loadTrends(for: state.field)
                return .none
            case let .setTrends(items):
                state.trends = items
                return .none
            }
        }
    }
}

//import ComposableArchitecture
//import Foundation
//
//@Reducer
//public struct ChartFeature {
//    @ObservableState
//    public struct State: Equatable {
//        public var points: [TrendItem] = []
//        public var field: String = "weight"
//        public var fieldLabel: String { TrendItem.label(for: field) }
//    }
//
//    public enum Action: BindableAction {
//        case binding(BindingAction<State>)
//        case setField(String)
//        case setPoints([TrendItem])
//    }
//
//    public var body: some ReducerOf<Self> {
//        BindingReducer()
//        Reduce { state, action in
//            switch action {
//            case .binding:
//                return .none
//            case let .setField(field):
//                state.field = field
//                return .none
//            case let .setPoints(points):
//                state.points = points
//                return .none
//            }
//        }
//    }
//}
