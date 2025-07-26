//
//  TrendsFeature.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct TrendsFeature {
    @ObservableState
    public struct State: Equatable {
        public var allTrends: [TrendItem] = []
        public var mainCard: TrendsMainCardFeature.State = .init()
        public var chart: ChartFeature.State = .init(field: "weight")
        
        @Presents public var allTrendsSheet: AllTrendsSheetFeature.State?
        @Presents public var modal: TrendModalFeature.State?
        
        public init() {}
    }

    @CasePathable
    public enum Action {
        case onAppear
        case trendsLoaded([TrendItem])
        
        case selectField(String)
        case presentAllTrendsSheetButtonTapped
        
        case mainCard(TrendsMainCardFeature.Action)
        case chart(ChartFeature.Action)
        case allTrendsSheet(PresentationAction<AllTrendsSheetFeature.Action>)
        case modal(PresentationAction<TrendModalFeature.Action>)
    }

    @Dependency(\.trendsService) var trendsService

    public var body: some ReducerOf<Self> {
        Scope(state: \.mainCard, action: \.mainCard) { TrendsMainCardFeature() }
        Scope(state: \.chart, action: \.chart) { ChartFeature() }

        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let trends = trendsService.loadAllTrends()
                    await send(.trendsLoaded(trends))
                }
                
            case let .trendsLoaded(trends):
                state.allTrends = trends
                state.mainCard.trends = Array(trends.prefix(6))
                
                let currentField = state.chart.field
                if !trends.contains(where: { $0.field == currentField }) {
                    state.chart.field = trends.first?.field ?? "weight"
                }
                state.chart.fieldTrends = trendsService.loadTrends(for: state.chart.field)
                return .none

            case let .selectField(field):
                state.chart.field = field
                state.chart.fieldTrends = trendsService.loadTrends(for: field)
                return .none
                
            case .presentAllTrendsSheetButtonTapped:
                state.allTrendsSheet = .init(trends: state.allTrends)
                return .none

            case .allTrendsSheet(.presented(.delegate(.openModalFor(let field)))):
                let trendsForField = trendsService.loadTrends(for: field)
                state.modal = .init(field: field, trends: trendsForField)
                return .none
            
            case .allTrendsSheet(.dismiss):
                if let newOrder = state.allTrendsSheet?.trends.map({ $0.field }) {
                    trendsService.saveOrder(newOrder)
                    return .send(.onAppear) // Перезагружаем данные для отражения нового порядка
                }
                return .none
                
            case .modal(.presented(.delegate(.trendsUpdated))):
                // После удаления данных в модальном окне, просто перезагружаем все данные
                return .send(.onAppear)

            default:
                return .none
            }
        }
        .ifLet(\.$allTrendsSheet, action: \.allTrendsSheet) { AllTrendsSheetFeature() }
        .ifLet(\.$modal, action: \.modal) { TrendModalFeature() }
    }
}

//import ComposableArchitecture
//import Foundation
//
//@Reducer
//public struct TrendsFeature {
//    @ObservableState
//    public struct State: Equatable {
//        public var mainCard: TrendsMainCardFeature.State
//        public var chart: ChartFeature.State
//        @Presents var modal: TrendModalFeature.State?
//
//        public init() {
//            self.mainCard = .init()
//            self.chart = .init(field: "weight", fieldTrends: [])
//            self.modal = nil
//        }
//    }
//
//    @CasePathable
//    public enum Action: BindableAction {
//        case binding(BindingAction<State>)
//        case mainCard(TrendsMainCardFeature.Action)
//        case chart(ChartFeature.Action)
//        case modal(PresentationAction<TrendModalFeature.Action>)
//        case presentModal(field: String)
//        case dismissModal
//    }
//
//    @Dependency(\.trendsService) var trendsService
//
//    public var body: some ReducerOf<Self> {
//        Scope(state: \.mainCard, action: \.mainCard) { TrendsMainCardFeature() }
//        Scope(state: \.chart, action: \.chart) { ChartFeature() }
//        self.ifLet(\.$modal, action: \.modal) { TrendModalFeature() }
//        BindingReducer()
//        Reduce { state, action in
//            switch action {
//            case .presentModal(let field):
//                let trends = trendsService.loadTrends(for: field)
//                state.modal = .init(field: field, trends: trends)
//                return .none
//
//            case .dismissModal:
//                state.modal = nil
//                return .none
//
//            default:
//                return .none
//            }
//        }
//    }
//}

//import ComposableArchitecture
//import Foundation
//
//@Reducer
//public struct TrendsFeature {
//    @ObservableState
//    public struct State: Equatable {
//        public var allTrends: [TrendItem] = []
//        public var mainTrends: [TrendItem] = []
//        public var fieldTrends: [TrendItem] = []
//        public var selectedField: String = "weight"
//        public var showAllTrends: Bool = false
//        public var dragState: DragAndDropFeature<TrendItem>.State = .init(items: [])
//        public var mainCardState: TrendsMainCardFeature.State = .init()
//        public var chartState = ChartFeature.State()
//        public init() {}
//    }
//    
//    @CasePathable
//    public enum Action: BindableAction {
//        case binding(BindingAction<State>)
//        case load
//        case loaded([TrendItem])
//        case selectField(String)
//        case showAllTrends(Bool)
//        case dragAndDrop(DragAndDropFeature<TrendItem>.Action)
//        case mainCard(TrendsMainCardFeature.Action)
//        case updateTrendsOrder([UUID])
//        case chart(ChartFeature.Action)
//    }
//
//    @Dependency(\.trendsService) var trendsService
//
//    public var body: some ReducerOf<Self> {
//        BindingReducer()
//        Scope(state: \.dragState, action: \.dragAndDrop) { DragAndDropFeature<TrendItem>() }
//        Scope(state: \.mainCardState, action: \.mainCard) { TrendsMainCardFeature() }
//        Scope(state: \.chartState, action: \.chart) { ChartFeature() }
//        Reduce { state, action in
//            switch action {
//            case .binding:
//                return .none
//
//            case .load:
//                let items = trendsService.loadAllTrends()
//                state.allTrends = items
//                let first6 = Array(items.prefix(6))
//                state.mainTrends = first6
//                state.dragState.items = items
//                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
//                return .send(.mainCard(.setTrends(first6)))
//
//            case let .loaded(items):
//                state.allTrends = items
//                let first6 = Array(items.prefix(6))
//                state.mainTrends = first6
//                state.dragState.items = items
//                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
//                return .send(.mainCard(.setTrends(first6)))
//
//            case let .selectField(field):
//                state.selectedField = field
//                state.fieldTrends = trendsService.loadTrends(for: field)
//                return .none
//
//            case let .showAllTrends(show):
//                state.showAllTrends = show
//                return .none
//
//            case .dragAndDrop(.dragEnded):
//                state.allTrends = state.dragState.items
//                let first6 = Array(state.dragState.items.prefix(6))
//                state.mainTrends = first6
//                state.fieldTrends = trendsService.loadTrends(for: state.selectedField)
//                return .send(.mainCard(.setTrends(first6)))
//
//            case .dragAndDrop:
//                return .none
//
//            case .mainCard:
//                return .none
//                
//            case let .updateTrendsOrder(newOrderIDs):
//                state.allTrends = newOrderIDs.compactMap { id in
//                    state.allTrends.first(where: { $0.id == id })
//                }
//                state.mainTrends = Array(state.allTrends.prefix(6))
//                state.dragState.items = state.allTrends
//                trendsService.saveOrder(newOrderIDs.map { $0.uuidString })
//                return .none
//                
//            case .chart(_):
//                return .none
//            }
//        }
//    }
//}
