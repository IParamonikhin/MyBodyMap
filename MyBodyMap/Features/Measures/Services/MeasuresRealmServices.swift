//
//  MeasuresRealmServices.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import Foundation
import RealmSwift
import ComposableArchitecture
import HealthKit

protocol MeasuresStoring {
    func save(_ measure: Measure)
    func loadAll(for type: String) -> [Measure]
    func loadLatest(for type: String) -> Measure?
    func loadLatestAllTypes() -> [String: Measure]
    func update(_ id: ObjectId, value: Double, date: Date, note: String?)
    func delete(_ id: ObjectId)
}

final class MeasuresRealmService: MeasuresStoring {
    
    
    func save(_ measure: Measure) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(measure)
        }
        if measure.type == "weight" || measure.type == "height" {
            updateBMIIfNeeded()
        }
        if measure.type == "weight" {
            HealthKitServices.shared.save(
                HealthKitServices.shared.weightType,
                value: measure.value,
                date: measure.date,
                unit: .gramUnit(with: .kilo)
            )
        }
        if measure.type == "height" {
            HealthKitServices.shared.save(
                HealthKitServices.shared.heightType,
                value: measure.value,
                date: measure.date,
                unit: .meterUnit(with: .centi)
            )
        }
        if measure.type == "bmi" {
            HealthKitServices.shared.save(
                HealthKitServices.shared.bmiType,
                value: measure.value,
                date: measure.date,
                unit: HKUnit.count()
            )
        }
    }
    
    func loadAll(for type: String) -> [Measure] {
        let realm = try! Realm()
        return Array(
            realm.objects(Measure.self)
                .filter("type == %@", type)
                .sorted(byKeyPath: "date", ascending: true)
        )
    }

    func loadLatest(for type: String) -> Measure? {
        let realm = try! Realm()
        return realm.objects(Measure.self)
            .filter("type == %@", type)
            .sorted(byKeyPath: "date", ascending: false)
            .first
    }
    
    func loadLatestAllTypes() -> [String: Measure] {
        let realm = try! Realm()
        let all = realm.objects(Measure.self).sorted(byKeyPath: "date", ascending: false)
        var result = [String: Measure]()
        for item in all {
            if result[item.type] == nil {
                result[item.type] = item
            }
        }
        return result
    }
    
    func update(_ id: ObjectId, value: Double, date: Date, note: String?) {
        let realm = try! Realm()
        if let obj = realm.object(ofType: Measure.self, forPrimaryKey: id) {
            try! realm.write {
                obj.value = value
                obj.date = date
                obj.note = note
            }
        }
    }
    
    func delete(_ id: ObjectId) {
        let realm = try! Realm()
        if let obj = realm.object(ofType: Measure.self, forPrimaryKey: id) {
            try! realm.write {
                realm.delete(obj)
            }
        }
    }
    
    private func updateBMIIfNeeded() {
        guard let weight = loadLatest(for: "weight")?.value,
              let height = loadLatest(for: "height")?.value,
              height > 0 else { return }

        let bmiValue = weight / pow(height / 100, 2)
        let bmiMeasure = Measure()
        bmiMeasure.type = "bmi"
        bmiMeasure.value = bmiValue
        bmiMeasure.date = Date() 
        let realm = try! Realm()
        let today = Calendar.current.startOfDay(for: Date())
        if let old = realm.objects(Measure.self).filter("type == 'bmi' AND date >= %@", today).first {
            try! realm.write { realm.delete(old) }
        }
        try! realm.write { realm.add(bmiMeasure) }
    }
    
    func importLatestFromHealthKit() {
        HealthKitServices.shared.fetchLatest(HealthKitServices.shared.weightType, unit: .gramUnit(with: .kilo)) { value, date in
            if let value, let date {
                DispatchQueue.main.async {
                    let m = Measure()
                    m.type = "weight"
                    m.value = value
                    m.date = date
                    self.save(m)
                }
            }
        }
        HealthKitServices.shared.fetchLatest(HealthKitServices.shared.heightType, unit: .meterUnit(with: .centi)) { value, date in
            if let value, let date {
                DispatchQueue.main.async {
                    let m = Measure()
                    m.type = "height"
                    m.value = value
                    m.date = date
                    self.save(m)
                }
            }
        }
        HealthKitServices.shared.fetchLatest(HealthKitServices.shared.bmiType, unit: HKUnit.count()) { value, date in
            if let value, let date {
                DispatchQueue.main.async {
                    let m = Measure()
                    m.type = "bmi"
                    m.value = value
                    m.date = date
                    self.save(m)
                }
            }
        }
    }
    
}

private enum MeasuresServiceKey: DependencyKey {
    static let liveValue: MeasuresStoring = MeasuresRealmService()
}

extension DependencyValues {
    var measuresService: MeasuresStoring {
        get { self[MeasuresServiceKey.self] }
        set { self[MeasuresServiceKey.self] = newValue }
    }
}
