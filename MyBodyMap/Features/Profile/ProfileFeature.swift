//
//  ProfileFeature.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct ProfileFeature {
    @ObservableState
    public struct State {
        public var name: String = ""
        public var gender: Gender = .other
        public var birthdate: Date = Date()
        public var age: Int {
            Calendar.current.dateComponents([.year], from: birthdate, to: .now).year ?? 0
        }
        public var goal: Goal = .none
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case save
        case load
        case loaded(State)
    }

    public enum Gender: String, CaseIterable, Equatable, Hashable, Identifiable, CustomStringConvertible {
        
        case male, female, other
        public var id: String { self.rawValue }
        
        static var selectable: [Gender] { [.male, .female] }
        
        public var description: String {
            switch self {
            case .male: return "Мужской"
            case .female: return "Женский"
            case .other: return "Другое"
            }
        }
    }

    
    public enum Goal: String, CaseIterable, Equatable, Identifiable, CustomStringConvertible {
        case none, looseWeight, gainWeight, gainMuscle
        public var id: String { rawValue }
        public var description: String {
            switch self {
            case .none: return "Без цели"
            case .looseWeight: return "Снижение веса"
            case .gainWeight: return "Набор веса"
            case .gainMuscle: return "Набор мышц"
            }
        }
    }
    
    @Dependency(\.profileService) var profileService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            case .save:
                profileService.save(state)
                return .none
            case .load:
                let loaded = profileService.load()
                state = loaded
                return .none
            case .loaded(let s):
                state = s
                return .none
            }
        }
    }
}
