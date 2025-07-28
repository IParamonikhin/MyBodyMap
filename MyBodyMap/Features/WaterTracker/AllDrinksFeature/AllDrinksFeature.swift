//
//  AllDrinksFeature.swift
//  MyBodyMap
//
//  Created by Иван on 27.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct AllDrinksFeature {
    @ObservableState
    public struct State: Equatable {
        public var drinks: [Drink] = []
        public var searchText: String = ""
        @Presents public var addDrink: AddDrinkFeature.State?
    }
    
    @CasePathable
    public enum Action: BindableAction  {
        case binding(BindingAction<State>)
        case onAppear
        case selectDrink(Drink)
        case addDrink(Drink)
        case removeDrink(Drink)
        case addNewTapped
        case scanTapped
        case searchTextChanged(String)
        case delegate(Delegate)
        
        public enum Delegate {
            case didSelectDrink(Drink)
        }
    }
    
    @Dependency(\.drinkService) var drinkService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                drinkService.ensureDefaultsIfNeeded()
                state.drinks = drinkService.fetchAll()
                return .none
            case .addDrink(let drink):
                drinkService.addOrUpdate(drink)
                state.drinks = drinkService.fetchAll()
                return .none
            case .removeDrink(let drink):
                drinkService.remove(drink)
                state.drinks = drinkService.fetchAll()
                return .none
            case .selectDrink(let drink):
                return .send(.delegate(.didSelectDrink(drink)))
            case .searchTextChanged(let text):
                state.searchText = text
                return .none
            case .addNewTapped:
                state.addDrink = AddDrinkFeature.State()
                return .none
            case .scanTapped:
                return .none
            case .delegate, .binding:
                return .none
            }
        }
    }
}
