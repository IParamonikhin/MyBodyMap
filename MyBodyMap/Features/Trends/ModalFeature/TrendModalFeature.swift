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
        public var field: String
        public var trends: [TrendItem] = []
        public var isLoading: Bool = false
        public var alert: AlertState<Action>?

        public init(field: String) {
            self.field = field
        }

        public static func == (lhs: State, rhs: State) -> Bool {
            lhs.id == rhs.id &&
            lhs.field == rhs.field &&
            lhs.trends == rhs.trends &&
            lhs.isLoading == rhs.isLoading &&
            alertEquals(lhs.alert, rhs.alert)
        }

        private static func alertEquals(
            _ lhs: AlertState<Action>?,
            _ rhs: AlertState<Action>?
        ) -> Bool {
            switch (lhs, rhs) {
            case (nil, nil): return true
            case let (l?, r?):
                // Можно сравнивать только title, если этого достаточно для логики
                return l.title == r.title
            default: return false
            }
        }
    }
    
    @CasePathable
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case trendsLoaded([TrendItem])
        case delete(IndexSet)
        case deleted(Result<Void, TrendModalError>)
        case dismissAlert
    }

    @Dependency(\.trendsService) var trendsService
    @Dependency(\.measuresService) var measuresService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                let trends = trendsService.loadTrends(for: state.field)
                state.trends = trends
                state.isLoading = false
                return .none

            case let .trendsLoaded(trends):
                state.trends = trends
                state.isLoading = false
                return .none

            case let .delete(indexSet):
                guard let idx = indexSet.first else { return .none }
                let trend = state.trends[idx]
                do {
                    try measuresService.deleteMeasure(date: trend.date)
                    state.trends.remove(at: idx)
                } catch {
                    state.alert = AlertState(
                        title: TextState("Ошибка удаления"),
                        actions: [.default(TextState("ОК"), action: .send(.dismissAlert))]
                    )
                }
                return .none

            case .deleted:
                // Здесь обработка async результата, если понадобится асинхронность
                return .none

            case .binding:
                return .none

            case .dismissAlert:
                state.alert = nil
                return .none
            }
        }
    }
}

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


