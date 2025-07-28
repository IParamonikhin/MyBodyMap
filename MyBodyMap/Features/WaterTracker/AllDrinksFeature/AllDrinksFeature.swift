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
        @Presents public var quickDrinkAmount: QuickDrinkAmountFeature.State?
        @Presents public var barcodeScanner: BarcodeScannerFeature.State?
    }
    
    @CasePathable
    public enum Action: BindableAction  {
        case binding(BindingAction<State>)
        case onAppear
        case selectDrink(Drink)
        case addDrink(PresentationAction<AddDrinkFeature.Action>)
        case addDrinkCommitted(Drink)
        case removeDrink(Drink)
        case addNewTapped
        case scanTapped
        case barcodeScanner(PresentationAction<BarcodeScannerFeature.Action>)
        case barcodeScanned(String)
        case drinkLoadedFromDatabase(Drink?, String)
        case drinkAPIFetched(OpenFoodFactsProduct?, String)
        case quickDrinkAmount(PresentationAction<QuickDrinkAmountFeature.Action>)
        case searchTextChanged(String)
        case delegate(Delegate)
        
        public enum Delegate {
            case didSelectDrink(Drink)
        }
    }
    
    @Dependency(\.drinkService) var drinkService
    @Dependency(\.foodFactsAPI) var foodFactsAPI

    public var body: some ReducerOf<Self> {
        BindingReducer()
        .ifLet(\.$addDrink, action: \.addDrink) { AddDrinkFeature() }
        .ifLet(\.$quickDrinkAmount, action: \.quickDrinkAmount) { QuickDrinkAmountFeature() }
        .ifLet(\.$barcodeScanner, action: \.barcodeScanner) { BarcodeScannerFeature() }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                drinkService.ensureDefaultsIfNeeded()
                state.drinks = drinkService.fetchAll()
                return .none

            case .addDrink(.presented(.delegate(.didAddDrink(let drink)))):
                drinkService.addOrUpdate(drink)
                state.drinks = drinkService.fetchAll()
                state.addDrink = nil
                return .none

            case .addDrink(.presented(.delegate(.didCancel))):
                state.addDrink = nil
                return .none

            case .addDrink:
                return .none

            case .addDrinkCommitted(let drink):
                drinkService.addOrUpdate(drink)
                state.drinks = drinkService.fetchAll()
                return .none

            case .quickDrinkAmount(.presented(.delegate(.didAdd(_, _)))):
                state.quickDrinkAmount = nil
                return .none

            case .quickDrinkAmount(.presented(.delegate(.didCancel))):
                state.quickDrinkAmount = nil
                return .none

            case .quickDrinkAmount:
                return .none

            case .selectDrink(let drink):
                return .send(.delegate(.didSelectDrink(drink)))

            case .searchTextChanged(let text):
                state.searchText = text
                return .none

            case .addNewTapped:
                state.addDrink = AddDrinkFeature.State()
                return .none

            case .removeDrink(let drink):
                drinkService.remove(drink)
                state.drinks = drinkService.fetchAll()
                return .none

            // ==== SCANNER FLOW ====
            case .scanTapped:
                state.barcodeScanner = BarcodeScannerFeature.State(isPresented: true)
                return .none

            case .barcodeScanner(.presented(.scanned(let code))):
                state.barcodeScanner = nil
                // Переходим на отдельный экшен
                return .send(.barcodeScanned(code))

            case .barcodeScanned(let code):
                let drink = drinkService.fetch(byBarcode: code)
                // Всегда прокидываем и напиток, и код, чтобы дальше использовать код при необходимости
                return .send(.drinkLoadedFromDatabase(drink, code))

            case .drinkLoadedFromDatabase(let drink, let code):
                if let drink {
                    state.quickDrinkAmount = QuickDrinkAmountFeature.State(drink: drink)
                    return .none
                } else {
                    // Не нашли в базе, идём за продуктом в API
                    return .run { send in
                        let apiProduct = await foodFactsAPI.fetchProduct(barcode: code)
                        await send(.drinkAPIFetched(apiProduct, code))
                    }
                }
            case .drinkAPIFetched(let apiProduct, let code):
                if let product = apiProduct {
                    let drink = Drink.from(product: product)
                    state.addDrink = AddDrinkFeature.State(
                        name: drink.name,
                        brand: drink.brand ?? "",
                        barcode: drink.barcode ?? "",
                        type: drink.type,
                        amount: drink.amount,
                        hydration: drink.hydrationFactor
                    )
                } else {
                    state.addDrink = AddDrinkFeature.State(barcode: code)
                }
                return .none

            case .barcodeScanner(.presented(.cancel)):
                state.barcodeScanner = nil
                return .none

            case .barcodeScanner:
                return .none

            case .delegate, .binding:
                return .none
            }
        }
    }
}

//import ComposableArchitecture
//import Foundation
//
//@Reducer
//public struct AllDrinksFeature {
//    @ObservableState
//    public struct State: Equatable {
//        public var drinks: [Drink] = []
//        public var searchText: String = ""
//        @Presents public var addDrink: AddDrinkFeature.State?
//    }
//    
//    @CasePathable
//    public enum Action: BindableAction  {
//        case binding(BindingAction<State>)
//        case onAppear
//        case selectDrink(Drink)
//        case addDrink(Drink)
//        case removeDrink(Drink)
//        case addNewTapped
//        case scanTapped
//        case searchTextChanged(String)
//        case delegate(Delegate)
//        
//        public enum Delegate {
//            case didSelectDrink(Drink)
//        }
//    }
//    
//    @Dependency(\.drinkService) var drinkService
//
//    public var body: some ReducerOf<Self> {
//        BindingReducer()
//        Reduce { state, action in
//            switch action {
//            case .onAppear:
//                drinkService.ensureDefaultsIfNeeded()
//                state.drinks = drinkService.fetchAll()
//                return .none
//            case .addDrink(let drink):
//                drinkService.addOrUpdate(drink)
//                state.drinks = drinkService.fetchAll()
//                return .none
//            case .removeDrink(let drink):
//                drinkService.remove(drink)
//                state.drinks = drinkService.fetchAll()
//                return .none
//            case .selectDrink(let drink):
//                return .send(.delegate(.didSelectDrink(drink)))
//            case .searchTextChanged(let text):
//                state.searchText = text
//                return .none
//            case .addNewTapped:
//                state.addDrink = AddDrinkFeature.State()
//                return .none
//            case .scanTapped:
//                return .none
//            case .delegate, .binding:
//                return .none
//            }
//        }
//    }
//}
