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
        public var goal: ProfileFeature.Goal = .none
        
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
    
    @Dependency(\.profileService) var profileService
    @Dependency(\.trendsService) var trendsService

    public var body: some ReducerOf<Self> {
        Scope(state: \.mainCard, action: \.mainCard) { TrendsMainCardFeature() }
        Scope(state: \.chart, action: \.chart) { ChartFeature() }

        Reduce { state, action in
            switch action {
            case .onAppear:
                let goal = profileService.load().goal
                state.goal = goal

                // goal прокидываем во все сабфичи
                var mainCard = state.mainCard
                mainCard.goal = goal
                state.mainCard = mainCard

                var chart = state.chart
                chart.goal = goal
                state.chart = chart

                if var allTrendsSheet = state.allTrendsSheet {
                    allTrendsSheet.goal = goal
                    state.allTrendsSheet = allTrendsSheet
                }
                
                return .run { send in
                    let trends = trendsService.loadAllTrends()
                    await send(.trendsLoaded(trends))
                }
  
            case let .trendsLoaded(trends):
                state.allTrends = trends
                var mainCard = state.mainCard
                mainCard.trends = Array(trends.prefix(6))
                mainCard.goal = state.goal
                state.mainCard = mainCard

                var chart = state.chart
                chart.field = trends.first?.field ?? "weight"
                chart.fieldTrends = trendsService.loadTrends(for: chart.field)
                chart.goal = state.goal
                state.chart = chart

                if var allTrendsSheet = state.allTrendsSheet {
                    allTrendsSheet.goal = state.goal
                    state.allTrendsSheet = allTrendsSheet
                }

                return .none
            
            case let .selectField(field):
                state.chart.field = field
                state.chart.fieldTrends = trendsService.loadTrends(for: field)
                return .none
                
            case .presentAllTrendsSheetButtonTapped:
                var allTrendsSheet = AllTrendsSheetFeature.State(trends: state.allTrends)
                allTrendsSheet.goal = state.goal
                state.allTrendsSheet = allTrendsSheet
                return .none

            case .allTrendsSheet(.presented(.delegate(.openModalFor(let field)))):
                let trendsForField = trendsService.loadTrends(for: field)
                state.modal = .init(field: field, trends: trendsForField)
                return .none
            
            case .allTrendsSheet(.dismiss):
                if let newOrder = state.allTrendsSheet?.trends.map({ $0.field }) {
                    trendsService.saveOrder(newOrder)
                    // После reorder или удаления тренда — обновляем всё!
                    return .send(.onAppear)
                }
                return .none
                
            case .modal(.presented(.delegate(.trendsUpdated))):
                return .send(.onAppear)

            default:
                return .none
            }
        }
        .ifLet(\.$allTrendsSheet, action: \.allTrendsSheet) { AllTrendsSheetFeature() }
        .ifLet(\.$modal, action: \.modal) { TrendModalFeature() }
    }
}
