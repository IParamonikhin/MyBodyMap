//
//  MeasuresRealmServices.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import Foundation
import RealmSwift
import ComposableArchitecture

protocol MeasuresStoring {
    func save(_ state: MeasuresFeature.State)
    func loadLatest() -> MeasuresFeature.State
}

final class MeasuresRealmService: MeasuresStoring {
    func save(_ state: MeasuresFeature.State) {
        let realm = try! Realm()
        let entry = Measures()
        entry.date = state.date
        entry.forearm = state.forearm ?? 0
        entry.biceps = state.biceps ?? 0
        entry.neck = state.neck ?? 0
        entry.chest = state.chest ?? 0
        entry.shoulders = state.shoulders ?? 0
        entry.waist = state.waist ?? 0
        entry.hips = state.hips ?? 0
        entry.thigh = state.thigh ?? 0
        entry.buttocks = state.buttocks ?? 0
        entry.calf = state.calf ?? 0
        entry.stomach = state.stomach ?? 0
        entry.weight = state.weight ?? 0
        entry.height = state.height ?? 0
        entry.fatPercent = state.fatPercent ?? 0
        try! realm.write { realm.add(entry) }
    }
    func loadLatest() -> MeasuresFeature.State {
        let realm = try! Realm()
        print (realm.configuration.fileURL)
        guard let last = realm.objects(Measures.self).sorted(byKeyPath: "date", ascending: false).last else {
            return .init()
        }
        var state = MeasuresFeature.State()
        state.forearm = last.forearm
        state.biceps = last.biceps
        state.neck = last.neck
        state.chest = last.chest
        state.shoulders = last.shoulders
        state.waist = last.waist
        state.hips = last.hips
        state.thigh = last.thigh
        state.buttocks = last.buttocks
        state.calf = last.calf
        state.stomach = last.stomach
        state.weight = last.weight
        state.height = last.height
        state.fatPercent = last.fatPercent
        state.date = last.date
        return state
    }
}

// DependencyKey для MeasuresStoring

private enum MeasuresServiceKey: DependencyKey {
    static let liveValue: MeasuresStoring = MeasuresRealmService()
}

extension DependencyValues {
    var measuresService: MeasuresStoring {
        get { self[MeasuresServiceKey.self] }
        set { self[MeasuresServiceKey.self] = newValue }
    }
}
