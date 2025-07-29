//
//  TrendModalFeature.swift
//  MyBodyMap
//
//  Created by Иван on 25.07.2025.
//

import ComposableArchitecture
import Foundation
import RealmSwift

@Reducer
public struct TrendModalFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: String { field }
        public let field: String
        public var trends: [TrendItem]
        public var chart: ChartFeature.State
        public var goal: ProfileFeature.Goal = .none
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
        case trendsReloaded([TrendItem])
        public enum Alert: Equatable {
            case confirmDelete(ObjectId)
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
                guard let objId = try? ObjectId(string: trendToDelete.id) else { return .none }
                state.alert = AlertState {
                    TextState("Удалить запись?")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDelete(objId)) {
                        TextState("Удалить")
                    }
                    ButtonState(role: .cancel) { TextState("Отмена") }
                }
                return .none

            case let .alert(.presented(.confirmDelete(id))):
                return .run { [field = state.field] send in
                    try trendsService.deleteMeasure(id: id)
                    let updatedTrends = trendsService.loadTrends(for: field)
                    await send(.trendsReloaded(updatedTrends))
                } catch: { error, send in
                    print("Failed to delete measure: \(error)")
                }
                
            case let .trendsReloaded(trends):
                state.trends = trends
                state.chart = .init(field: state.field, fieldTrends: trends, goal: state.goal)
                return .none
                
            case .delegate(.trendsUpdated):
                return .none

            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
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
