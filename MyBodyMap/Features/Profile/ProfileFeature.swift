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
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case save
        case load
        case loaded(State)
    }

    public enum Gender: String, CaseIterable, Equatable, Identifiable {
        case male, female, other
        public var id: String { self.rawValue }
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
