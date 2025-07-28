//
//  WaterSettingsFeature.swift
//  MyBodyMap
//
//  Created by Иван on 28.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct WaterSettingsFeature {
    @ObservableState
    public struct State: Equatable {
        public var waterGoal: Int
        public init(waterGoal: Int) {
            self.waterGoal = waterGoal
        }
    }

    @CasePathable
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case saveButtonTapped
        case cancelButtonTapped
        case delegate(Delegate)

        public enum Delegate {
            case saveGoal(Int)
        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .saveButtonTapped:
                return .send(.delegate(.saveGoal(state.waterGoal)))

            case .cancelButtonTapped:
                return .none
                
            case .binding, .delegate:
                return .none
            }
        }
    }
}

//import ComposableArchitecture
//import Foundation
//
//@Reducer
//public struct WaterSettingsFeature {
//    @ObservableState
//    public struct State: Equatable {
//        @BindingState public var waterGoal: Int
//        public init(waterGoal: Int) { self.waterGoal = waterGoal }
//    }
//
//    @CasePathable
//    public enum Action: BindableAction {
//        case binding(BindingAction<State>)
//        case save(Int)
//        case cancel
//    }
//
//    public var body: some ReducerOf<Self> {
//        BindingReducer()
//        Reduce { state, action in
//            switch action {
//            case .save(let value):
//                return .send(.save(value))
//            case .cancel:
//                return .send(.cancel)
//            case .binding:
//                return .none
//            }
//        }
//    }
//}
