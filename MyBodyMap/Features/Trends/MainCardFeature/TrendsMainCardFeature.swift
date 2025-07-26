//
//  TrendsMainCardFeature.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct TrendsMainCardFeature {
    @ObservableState
    public struct State: Equatable {
        public var trends: [TrendItem] = []
    }
    
    public enum Action {
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

//import ComposableArchitecture
//import Foundation
//
//@Reducer
//public struct TrendsMainCardFeature {
//    @ObservableState
//    public struct State: Equatable {
//        public var fields: [String] = ["weight", "chest", "waist"]
//    }
//    public enum Action: BindableAction {
//        case binding(BindingAction<State>)
//        case selectField(String)
//    }
//    public var body: some ReducerOf<Self> {
//        BindingReducer()
//        Reduce { state, action in
//            .none
//        }
//    }
//}

//import ComposableArchitecture
//import Foundation
//
//@Reducer
//public struct TrendsMainCardFeature {
//    @ObservableState
//    public struct State: Equatable {
//        public var mainTrends: [TrendItem] = []
//        public var selectedField: String = ""
//        public var trends: [TrendItem] = []
//        public init(trends: [TrendItem] = []) { self.trends = trends }
//    }
//
//    public enum Action: BindableAction, Equatable {
//        case binding(BindingAction<State>)
//        case setTrends([TrendItem])
//        case selectField(String)
//    }
//
//    public var body: some ReducerOf<Self> {
//        BindingReducer()
//        Reduce { state, action in
//            switch action {
//            case .binding:
//                return .none
//            case .selectField(let field):
//                state.selectedField = field
//                return .none
//            case let .setTrends(trends):
//                state.trends = trends
//                return .none
//            }
//        }
//    }
//}
