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
        public var fieldTrends: [TrendItem] = []
        public var goal: ProfileFeature.Goal = .none
    }
    public enum Action {}
    public var body: some ReducerOf<Self> { Reduce { _, _ in .none } }
}
