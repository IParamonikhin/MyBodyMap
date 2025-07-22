//
//  WaterRealmService.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import Foundation
import RealmSwift
import ComposableArchitecture

protocol WaterStoring {
    func save(_ value: Double)
    func fetchToday() -> Double
}

final class WaterRealmService: WaterStoring {
    func save(_ value: Double) {
        let realm = try! Realm()
        let entry = WaterEntry()
        entry.value = value
        entry.date = Date()
        try! realm.write { realm.add(entry) }
    }
    func fetchToday() -> Double {
        let realm = try! Realm()
        let startOfDay = Calendar.current.startOfDay(for: Date())
        return realm.objects(WaterEntry.self)
            .filter("date >= %@", startOfDay)
            .reduce(0) { $0 + $1.value }
    }
}

private enum WaterServiceKey: DependencyKey {
    static let liveValue: WaterStoring = WaterRealmService()
}
extension DependencyValues {
    var waterService: WaterStoring {
        get { self[WaterServiceKey.self] }
        set { self[WaterServiceKey.self] = newValue }
    }
}
