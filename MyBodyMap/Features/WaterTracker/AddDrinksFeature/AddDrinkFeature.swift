//
//  AddDrinkFeature.swift
//  MyBodyMap
//
//  Created by Иван on 28.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct AddDrinkFeature {
    @ObservableState
    public struct State: Equatable {
        public var name: String = ""
        public var brand: String = ""
        public var barcode: String = ""
        public var type: String = "custom"
        public var amount: Double = 200
        public var hydration: Double = 1.0
        public var isScanning: Bool = false
        public var hydrationLoading: Bool = false
        public var hydrationError: String?
    }
    
    @CasePathable
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case scanTapped
        case barcodeScanned(String)
        case loadHydrationForType
        case hydrationLoaded(Double?)
        case saveTapped
        case cancelTapped
        case delegate(Delegate)
        
        public enum Delegate {
            case didAddDrink(Drink)
            case didCancel
        }
    }
    
    @Dependency(\.foodFactsAPI) var foodFactsAPI
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .scanTapped:
                state.isScanning = true
                return .none
            case .barcodeScanned(let code):
                state.barcode = code
                state.isScanning = false
                // Тут автозаполнение, если хочешь
                return .none
            case .loadHydrationForType:
                state.hydrationLoading = true
                // Можно запросить из API, если реализовано
                return .run { [type = state.type] send in
                    let hydration = Drink.hydrationFactor(forType: type)
                    await send(.hydrationLoaded(hydration))
                }
            case .hydrationLoaded(let hydration):
                state.hydrationLoading = false
                if let hydration = hydration {
                    state.hydration = hydration
                    state.hydrationError = nil
                } else {
                    state.hydrationError = "Не удалось определить коэффициент."
                }
                return .none
            case .saveTapped:
                let drink = Drink()
                drink.name = state.name
                drink.brand = state.brand
                drink.barcode = state.barcode
                drink.type = state.type
                drink.amount = state.amount
                drink.hydrationFactor = state.hydration
                return .send(.delegate(.didAddDrink(drink)))
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

extension Drink {
    static func hydrationFactor(forType type: String) -> Double {
        switch type {
        case "water": return 1.0
        case "mineral_water": return 1.0
        case "milk": return 1.0
        case "soy_milk": return 0.95
        case "kefir": return 0.9
        case "coffee": return 0.7
        case "coffee_milk": return 0.8
        case "decaf_coffee": return 0.9
        case "tea": return 0.7
        case "herbal_tea": return 0.9
        case "milk_tea": return 0.8
        case "juice": return 0.8
        case "fresh_juice": return 0.85
        case "smoothie": return 0.75
        case "lemonade": return 0.9
        case "cola": return 0.9
        case "tonic": return 0.85
        case "kvass": return 0.85
        case "energy": return 0.8
        case "isotonic": return 0.95
        case "broth": return 0.95
        case "beer": return 0.7
        case "wine": return 0.6
        case "champagne": return 0.7
        case "cider": return 0.7
        case "strong_alcohol": return 0.4
        case "cocktail": return 0.6
        case "liqueur": return 0.6
        case "cacao": return 0.85
        case "hot_chocolate": return 0.8
        case "protein": return 0.85
        case "bubble_tea": return 0.8
        case "matcha_latte": return 0.85
        case "kombucha": return 0.85
        case "aloe": return 0.9
        default: return 1.0
        }
    }
}
