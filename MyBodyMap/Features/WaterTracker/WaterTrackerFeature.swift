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
        public var drinks: [Drink] = []
        public var quickDrinks: [Drink] = [
            Drink(name: "Вода", type: "water", amount: 200, hydrationFactor: 1.0),
            Drink(name: "Чай", type: "tea", amount: 200, hydrationFactor: 0.7),
            Drink(name: "Кофе", type: "coffee", amount: 200, hydrationFactor: 0.7),
            Drink(name: "Молоко", type: "milk", amount: 200, hydrationFactor: 1.0)
        ]
        @Presents public var allDrinks: AllDrinksFeature.State?
        @Presents public var quickDrinkAmount: QuickDrinkAmountFeature.State?
    }
    
    @CasePathable
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case selectQuickDrink(Drink)
        case showAllDrinksTapped
        case allDrinks(PresentationAction<AllDrinksFeature.Action>)
        case quickDrinkAmount(PresentationAction<QuickDrinkAmountFeature.Action>)
    }
    
    @Dependency(\.waterService) var waterService
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        .ifLet(\.$allDrinks, action: \.allDrinks) { AllDrinksFeature() }
        .ifLet(\.$quickDrinkAmount, action: \.quickDrinkAmount) { QuickDrinkAmountFeature() }

        Reduce { state, action in
            switch action {
            case .selectQuickDrink(let drink):
                state.quickDrinkAmount = QuickDrinkAmountFeature.State(drink: drink)
                return .none

            case .quickDrinkAmount(.presented(.delegate(.didAdd(let value, let drink)))):
                let water = value * drink.hydrationFactor
                state.dailyIntake += water
                waterService.save(water)
                state.quickDrinkAmount = nil
                return .none

            case .quickDrinkAmount(.presented(.delegate(.didCancel))):
                state.quickDrinkAmount = nil
                return .none

            case .showAllDrinksTapped:
                state.allDrinks = AllDrinksFeature.State()
                return .none

            case .allDrinks(.presented(.delegate(.didSelectDrink(let drink)))):
                state.quickDrinkAmount = QuickDrinkAmountFeature.State(drink: drink)
                return .none

            case .allDrinks:
                return .none
            case .quickDrinkAmount:
                return .none
            case .binding:
                return .none
            }
        }
    }
}
