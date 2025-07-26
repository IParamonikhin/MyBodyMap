//
//  TrendModalFeature.swift
//  MyBodyMap
//
//  Created by Иван on 25.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct TrendModalFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: String { field }
        public let field: String
        public var trends: [TrendItem]
        public var chart: ChartFeature.State
        @Presents public var alert: AlertState<Action.Alert>?

        public init(field: String, trends: [TrendItem]) {
            self.field = field
            self.trends = trends
            self.chart = .init(field: field, fieldTrends: trends)
        }
    }

    @CasePathable
    public enum Action {
        case chart(ChartFeature.Action)
        case delete(IndexSet)
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)

        public enum Alert: Equatable {
            case confirmDelete(Date)
        }
        
        public enum Delegate {
            case trendsUpdated
        }
    }

    @Dependency(\.trendsService) var trendsService

    public var body: some ReducerOf<Self> {
        Scope(state: \.chart, action: \.chart) { ChartFeature() }
        
        Reduce { state, action in
            switch action {
            case let .delete(indexSet):
                guard let index = indexSet.first else { return .none }
                let trendToDelete = state.trends[index]
                state.alert = AlertState {
                    TextState("Удалить запись?")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDelete(trendToDelete.date)) {
                        TextState("Удалить")
                    }
                    ButtonState(role: .cancel) { TextState("Отмена") }
                }
                return .none

            case let .alert(.presented(.confirmDelete(date))):
                return .run { send in
                    try await trendsService.deleteMeasure(date: date)
                    await send(.delegate(.trendsUpdated))
                } catch: { error, send in
                    // Можно обработать ошибку, если нужно
                    print("Failed to delete measure: \(error)")
                }
                
            case .delegate(.trendsUpdated):
                // После обновления родитель сам перезагрузит данные,
                // поэтому здесь можно просто закрыть модалку или ничего не делать.
                // Обновление trends и chart произойдет в родительском компоненте.
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}


//import ComposableArchitecture
//import Foundation
//
//@Reducer
//public struct TrendModalFeature {
//    @ObservableState
//    public struct State: Equatable, Identifiable {
//        public var id: String { field }
//        public var field: String
//        public var trends: [TrendItem]
//        public var chart: ChartFeature.State
//        public var isLoading: Bool = false
//        public var alert: AlertState<Action>?
//
//        public init(field: String, trends: [TrendItem]) {
//            self.field = field
//            self.trends = trends
//            self.chart = .init(field: field, fieldTrends: trends)
//        }
//
//        public static func == (lhs: State, rhs: State) -> Bool {
//            lhs.id == rhs.id &&
//            lhs.field == rhs.field &&
//            lhs.trends == rhs.trends &&
//            lhs.isLoading == rhs.isLoading &&
//            alertEquals(lhs.alert, rhs.alert)
//        }
//
//        private static func alertEquals(
//            _ lhs: AlertState<Action>?,
//            _ rhs: AlertState<Action>?
//        ) -> Bool {
//            switch (lhs, rhs) {
//            case (nil, nil): return true
//            case let (l?, r?):
//                return l.title == r.title
//            default: return false
//            }
//        }
//    }
//
//    @CasePathable
//    public enum Action: BindableAction {
//        case binding(BindingAction<State>)
//        case delete(IndexSet)
//        case onAppear  
//        case chart(ChartFeature.Action)
//        case dismissAlert
//    }
//
//    @Dependency(\.measuresService) var measuresService
//
//    public var body: some ReducerOf<Self> {
//        Scope(state: \.chart, action: \.chart) { ChartFeature() }
//        BindingReducer()
//        Reduce { state, action in
//            switch action {
//            case let .delete(indexSet):
//                guard let idx = indexSet.first else { return .none }
//                let trend = state.trends[idx]
//                do {
//                    try measuresService.deleteMeasure(date: trend.date)
//                    state.trends.remove(at: idx)
//                    state.chart = .init(field: state.field, fieldTrends: state.trends)
//                } catch {
//                    state.alert = AlertState(
//                        title: TextState("Ошибка удаления"),
//                        actions: [.default(TextState("ОК"), action: .send(.dismissAlert))]
//                    )
//                }
//                return .none
//            case .dismissAlert:
//                state.alert = nil
//                return .none
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
//public struct TrendModalFeature {
//    @ObservableState
//    public struct State: Equatable, Identifiable {
//        public var id: String { field }
//        public var field: String
//        public var trends: [TrendItem] = []
//        public var isLoading: Bool = false
//        public var alert: AlertState<Action>?
//        public var chart: ChartFeature.State
//        public init(field: String) {
//            self.field = field
//            self.chart = .init(field: field, trends: [])
//        }
//
//        public static func == (lhs: State, rhs: State) -> Bool {
//            lhs.id == rhs.id &&
//            lhs.field == rhs.field &&
//            lhs.trends == rhs.trends &&
//            lhs.isLoading == rhs.isLoading &&
//            alertEquals(lhs.alert, rhs.alert)
//        }
//
//        private static func alertEquals(
//            _ lhs: AlertState<Action>?,
//            _ rhs: AlertState<Action>?
//        ) -> Bool {
//            switch (lhs, rhs) {
//            case (nil, nil): return true
//            case let (l?, r?):
//                // Можно сравнивать только title, если этого достаточно для логики
//                return l.title == r.title
//            default: return false
//            }
//        }
//    }
//    
//    @CasePathable
//    public enum Action: BindableAction {
//        case binding(BindingAction<State>)
//        case onAppear
//        case trendsLoaded([TrendItem])
//        case delete(IndexSet)
//        case deleted(Result<Void, TrendModalError>)
//        case dismissAlert
//        case chart(ChartFeature.Action)
//    }
//
//    @Dependency(\.trendsService) var trendsService
//    @Dependency(\.measuresService) var measuresService
//
//    public var body: some ReducerOf<Self> {
//        BindingReducer()
//        Scope(state: \.chart, action: \.chart) { ChartFeature() }
//        Reduce { state, action in
//            switch action {
//            case .onAppear:
//                state.isLoading = true
//                let trends = trendsService.loadTrends(for: state.field)
//                state.trends = trends
//                state.isLoading = false
//                return .none
//
//            case let .trendsLoaded(trends):
//                state.trends = trends
//                state.isLoading = false
//                return .none
//
//            case let .delete(indexSet):
//                guard let idx = indexSet.first else { return .none }
//                let trend = state.trends[idx]
//                do {
//                    try measuresService.deleteMeasure(date: trend.date)
//                    state.trends.remove(at: idx)
//                } catch {
//                    state.alert = AlertState(
//                        title: TextState("Ошибка удаления"),
//                        actions: [.default(TextState("ОК"), action: .send(.dismissAlert))]
//                    )
//                }
//                return .none
//
//            case .deleted:
//                // Здесь обработка async результата, если понадобится асинхронность
//                return .none
//
//            case .binding:
//                return .none
//
//            case .dismissAlert:
//                state.alert = nil
//                return .none
//                
//            case .chart:
//                return .none
//            }
//        }
//    }
//}

    public enum TrendModalError: Error, Equatable, LocalizedError {
        case deletionFailed(String)
        case unknown

        public var errorDescription: String? {
            switch self {
            case .deletionFailed(let reason):
                return "Ошибка удаления: \(reason)"
            case .unknown:
                return "Неизвестная ошибка"
            }
        }
    }


