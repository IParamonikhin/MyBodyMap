//
//  MeasuresFeature.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import ComposableArchitecture
import Foundation
import RealmSwift

@Reducer
public struct MeasuresFeature {
    @ObservableState
    public struct State: Equatable {
        public var selectedField: MeasuresField?
        public var inputValue: Double = 0
        public var inputDate: Date = .now
        public var showInputModal: Bool = false
        public var measuresByType: [String: [Measure]] = [:]
        public var latestMeasures: [String: Measure] = [:]
        public var gender: ProfileFeature.Gender = .other
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case loadAll
        case addMeasure(String, Double, Date)
        case updateMeasure(ObjectId, Double, Date)
        case deleteMeasure(ObjectId)
        case selectField(MeasuresField)
        case showInput(Bool)
        case loadGender
    }

    @Dependency(\.measuresService) var measuresService
    @Dependency(\.profileService) var profileService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .loadAll:
                let types = MeasuresField.allCases.map(\.rawValue)
                for type in types {
                    state.measuresByType[type] = measuresService.loadAll(for: type)
                    if let last = measuresService.loadLatest(for: type) {
                        state.latestMeasures[type] = last
                    }
                }
                return .none

            case .loadGender:
                let loadedProfile = profileService.load()
                state.gender = loadedProfile.gender
                return .none

            case let .addMeasure(type, value, date):
                let measure = Measure()
                measure.type = type
                measure.value = value
                measure.date = date
                measuresService.save(measure)
                return .send(.loadAll)

            case let .updateMeasure(id, value, date):
                measuresService.update(id, value: value, date: date, note: nil)
                return .send(.loadAll)

            case let .deleteMeasure(id):
                measuresService.delete(id)
                return .send(.loadAll)

            case let .selectField(field):
                state.selectedField = field
                state.showInputModal = true
                state.inputValue = state.latestMeasures[field.rawValue]?.value ?? 0
                state.inputDate = .now
                return .none

            case let .showInput(show):
                state.showInputModal = show
                return .none

            default:
                return .none
            }
        }
    }
    
    public enum MeasuresField: String, CaseIterable {
        case forearm, biceps, neck, chest, shoulders, waist, hips, thigh, buttocks, calf, stomach, weight, height, fatPercent

        var label: String {
            switch self {
            case .forearm: return "Предплечье"
            case .biceps: return "Бицепс"
            case .neck: return "Шея"
            case .chest: return "Грудь"
            case .shoulders: return "Плечи"
            case .waist: return "Талия"
            case .hips: return "Бёдра"
            case .thigh: return "Бедро"
            case .buttocks: return "Ягодицы"
            case .calf: return "Икра"
            case .stomach: return "Живот"
            case .weight: return "Вес"
            case .height: return "Рост"
            case .fatPercent: return "% Жира"
            }
        }
    }
}
