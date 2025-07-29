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
        public var drinks: [ConsumedDrink] = []
        public var quickDrinks: [Drink] = [
            Drink(name: "Вода", type: "water", amount: 200, hydrationFactor: 1.0),
            Drink(name: "Чай", type: "tea", amount: 200, hydrationFactor: 0.7),
            Drink(name: "Кофе", type: "coffee", amount: 200, hydrationFactor: 0.7),
            Drink(name: "Молоко", type: "milk", amount: 200, hydrationFactor: 1.0)
        ]
        @Presents public var allDrinks: AllDrinksFeature.State?
        @Presents public var quickDrinkAmount: QuickDrinkAmountFeature.State?
        @Presents public var settingsSheet: WaterSettingsFeature.State?
    }
    
    @CasePathable
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case selectQuickDrink(Drink)
        case showAllDrinksTapped
        case allDrinks(PresentationAction<AllDrinksFeature.Action>)
        case quickDrinkAmount(PresentationAction<QuickDrinkAmountFeature.Action>)
        case openSettings
        case settingsSheet(PresentationAction<WaterSettingsFeature.Action>)
    }
    
    @Dependency(\.waterService) var waterService
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
            .ifLet(\.$allDrinks, action: \.allDrinks) { AllDrinksFeature() }
            .ifLet(\.$quickDrinkAmount, action: \.quickDrinkAmount) { QuickDrinkAmountFeature() }
            .ifLet(\.$settingsSheet, action: \.settingsSheet) { WaterSettingsFeature() }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                if let today = waterService.getToday() {
                    state.goal = today.goal
                    state.dailyIntake = today.totalDrunk
                    state.drinks = Array(today.drinks)
                }
                return .none
                
  
            case .selectQuickDrink(let drink):
                state.quickDrinkAmount = QuickDrinkAmountFeature.State(drink: drink)
                return .none

            case .quickDrinkAmount(.presented(.delegate(.didAdd(let value, let drink)))):
                waterService.addDrink(for: Date(), drink: drink, amount: value, hydration: drink.hydrationFactor)
                if let today = waterService.getToday() {
                    state.dailyIntake = today.totalDrunk
                    state.goal = today.goal
                    state.drinks = Array(today.drinks) 
                }
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
                
            case .openSettings:
                state.settingsSheet = WaterSettingsFeature.State(waterGoal: Int(state.goal))
                return .none

            case .settingsSheet(.presented(.delegate(.saveGoal(let newGoal)))):
                waterService.updateGoal(Double(newGoal))
                state.goal = Double(newGoal)
                state.settingsSheet = nil
                return .none

            case .settingsSheet(.dismiss):
                 state.settingsSheet = nil
                 return .none

            case .binding, .allDrinks, .quickDrinkAmount, .settingsSheet:
                return .none
            }
        }
    }
}
