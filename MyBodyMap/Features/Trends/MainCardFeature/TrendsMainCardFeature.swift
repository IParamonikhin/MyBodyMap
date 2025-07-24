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
        public var mainTrends: [TrendItem] = []
        public var selectedField: String = ""
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case selectField(String)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .selectField(let field):
                state.selectedField = field
                return .none
            }
        }
    }
}
