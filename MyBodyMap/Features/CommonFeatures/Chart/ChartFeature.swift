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
        public var items: [TrendItem] = []
    }

    public enum Action {
        case setItems([TrendItem])
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setItems(items):
                state.items = items
                return .none
            }
        }
    }
}
