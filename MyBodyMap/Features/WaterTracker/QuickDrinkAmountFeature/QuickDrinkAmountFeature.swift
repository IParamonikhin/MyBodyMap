//
//  QuickDrinkAmountFeature.swift
//  MyBodyMap
//
//  Created by Иван on 27.07.2025.
//

import ComposableArchitecture

@Reducer
public struct QuickDrinkAmountFeature {
    @ObservableState
    public struct State: Equatable {
        public var drink: Drink
        public var amount: String

        public init(drink: Drink) {
            self.drink = drink
            self.amount = String(Int(drink.amount))
        }
    }

    @CasePathable
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case addTapped
        case cancelTapped
        case delegate(Delegate)

        public enum Delegate {
            case didAdd(Double, Drink)
            case didCancel
        }
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .addTapped:
                let value = Double(state.amount) ?? state.drink.amount
                return .send(.delegate(.didAdd(value, state.drink)))

            case .cancelTapped:
                return .send(.delegate(.didCancel))

            case .binding:
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
