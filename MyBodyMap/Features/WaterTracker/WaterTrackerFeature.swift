//
//  WaterTrackerFeature.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct WaterTrackerFeature {
    @ObservableState
    public struct State: Equatable {
        public var dailyIntake: Double = 0
        public var goal: Double = 2000
        public var glassAmount: Double = 200
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case addGlass
        case setGoal(Double)
        case load
        case loaded(Double)
    }

    @Dependency(\.waterService) var waterService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .addGlass:
                state.dailyIntake += state.glassAmount
                waterService.save(state.glassAmount)
                return .none
            case .setGoal(let goal):
                state.goal = goal
                return .none
            case .load:
                let total = waterService.fetchToday()
                state.dailyIntake = total
                return .none
            case .loaded(let value):
                state.dailyIntake = value
                return .none
            }
        }
    }
}
