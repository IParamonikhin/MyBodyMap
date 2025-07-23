//
//  ProfileServices.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import ComposableArchitecture
import Foundation

protocol ProfileStoring {
    func save(_ state: ProfileFeature.State)
    func load() -> ProfileFeature.State
}

final class ProfileUserDefaultsService: ProfileStoring {
    private let nameKey = "profile.name"
    private let genderKey = "profile.gender"
    private let birthdateKey = "profile.birthdate"
    private let goalKey = "profile.goal"

    func save(_ state: ProfileFeature.State) {
        UserDefaults.standard.set(state.name, forKey: nameKey)
        UserDefaults.standard.set(state.gender.rawValue, forKey: genderKey)
        UserDefaults.standard.set(state.birthdate, forKey: birthdateKey)
        UserDefaults.standard.set(state.goal.rawValue, forKey: goalKey)
    }

    func load() -> ProfileFeature.State {
        var state = ProfileFeature.State()
        let defaults = UserDefaults.standard
        if let name = defaults.string(forKey: nameKey) {
            state.name = name
        }
        if let genderStr = defaults.string(forKey: genderKey),
           let gender = ProfileFeature.Gender(rawValue: genderStr) {
            state.gender = gender
        }
        if let birthdate = defaults.object(forKey: birthdateKey) as? Date {
            state.birthdate = birthdate
        }
        if let goalStr = defaults.object(forKey: goalKey),
           let goal = ProfileFeature.Goal(rawValue: goalStr as! String ) {
             state.goal = goal
        }
        return state
    }
}
private enum ProfileServiceKey: DependencyKey {
    static let liveValue: ProfileStoring = ProfileUserDefaultsService()
}
extension DependencyValues {
    var profileService: ProfileStoring {
        get { self[ProfileServiceKey.self] }
        set { self[ProfileServiceKey.self] = newValue }
    }
}
