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
        public var goal: ProfileFeature.Goal = .none
    }
    
    public enum Action {
    }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

