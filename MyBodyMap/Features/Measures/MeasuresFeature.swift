//
//  MeasuresFeature.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MeasuresFeature {
    @ObservableState
    public struct State: Equatable {
        public var gender: ProfileFeature.Gender = .other
        public var forearm: Double?
        public var biceps: Double?
        public var neck: Double?
        public var chest: Double?
        public var shoulders: Double?
        public var waist: Double?
        public var hips: Double?
        public var thigh: Double?
        public var buttocks: Double?
        public var calf: Double?
        public var stomach: Double?
        public var weight: Double?
        public var height: Double?
        public var fatPercent: Double?
        public var date: Date = .now

        public var selectedField: MeasuresField? = nil
        public var showInputModal: Bool = false

        public var bmi: Double? {
            guard let w = weight, let h = height, h > 0 else { return nil }
            return w / ((h / 100) * (h / 100))
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case save
        case load
        case loaded(State)
        case selectField(MeasuresField)
        case dismissInput
        case updateField(MeasuresField, Double)
    }

    public enum MeasuresField: String, CaseIterable, Equatable, Identifiable {
        case forearm, biceps, neck, chest, shoulders, waist, hips, thigh, buttocks, calf, stomach, weight, height, fatPercent
        public var id: String { self.rawValue }
    }

    @Dependency(\.measuresService) var measuresService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .save:
                measuresService.save(state)
                return .none
            case .load:
                let loaded = measuresService.loadLatest()
                state = loaded
                let raw = UserDefaults.standard.string(forKey: "profile.gender") ?? "other"
                state.gender = ProfileFeature.Gender(rawValue: raw) ?? .other
                return .none
            case .loaded(let loaded):
                state = loaded
                let raw = UserDefaults.standard.string(forKey: "profile.gender") ?? "other"
                state.gender = ProfileFeature.Gender(rawValue: raw) ?? .other
                return .none
            case let .updateField(field, value):
                switch field {
                case .forearm: state.forearm = value
                case .biceps: state.biceps = value
                case .neck: state.neck = value
                case .chest: state.chest = value
                case .shoulders: state.shoulders = value
                case .waist: state.waist = value
                case .hips: state.hips = value
                case .thigh: state.thigh = value
                case .buttocks: state.buttocks = value
                case .calf: state.calf = value
                case .stomach: state.stomach = value
                case .weight: state.weight = value
                case .height: state.height = value
                case .fatPercent: state.fatPercent = value
                }
                state.showInputModal = false
                measuresService.save(state)
                return .none
            case let .selectField(field):
                state.selectedField = field
                state.showInputModal = true
                return .none
            case .dismissInput:
                state.showInputModal = false
                return .none
            }
        }
    }
}

