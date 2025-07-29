//
//  TrendsService.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import Foundation
import RealmSwift
import ComposableArchitecture

public protocol TrendsStoring {
    func loadTrends(for field: String) -> [TrendItem]
    func loadAllTrends() -> [TrendItem]
    func saveOrder(_ order: [String])
    func loadOrder() -> [String]
    func allFields() -> [String]
    func deleteMeasure(id: ObjectId)
}

public final class TrendsRealmService: TrendsStoring {
    private let fields = [
        "weight", "chest", "waist", "forearm", "biceps", "neck",
        "shoulders", "thigh", "buttocks", "calf", "stomach", "height", "fatPercent", "hips"
    ]
    
    public init() {}

    public func loadTrends(for field: String) -> [TrendItem] {
        let realm = try! Realm()
        let measures = realm.objects(Measure.self)
            .filter("type == %@", field)
            .sorted(byKeyPath: "date", ascending: true)
        var trends: [TrendItem] = []
        var prev: Double?
        for m in measures {
            let diff = prev != nil ? m.value - prev! : 0
            trends.append(TrendItem(
                id: m.id.stringValue,
                field: field,
                value: m.value,
                date: m.date,
                diff: diff
            ))
            prev = m.value
        }
        return trends
    }
    
    public func loadAllTrends() -> [TrendItem] {
        let realm = try! Realm()
        let fieldsFromDB = Array(Set(realm.objects(Measure.self).map(\.type))) 
        let order = loadOrder().filter { fieldsFromDB.contains($0) }
        let orderedFields = order + fieldsFromDB.filter { !order.contains($0) }
        return orderedFields.compactMap { field in
            let trends = loadTrends(for: field)
            guard let last = trends.last else { return nil }
            let diff = trends.count > 1 ? last.value - trends[trends.count - 2].value : 0
            return TrendItem(
                id: last.id,
                field: field,
                value: last.value,
                date: last.date,
                diff: diff
            )
        }
    }

    public func saveOrder(_ order: [String]) {
        UserDefaults.standard.set(order, forKey: "trend_order")
    }

    public func loadOrder() -> [String] {
        UserDefaults.standard.stringArray(forKey: "trend_order") ?? []
    }

    public func allFields() -> [String] {
        return fields
    }

    public func deleteMeasure(id: ObjectId) {
        let realm = try! Realm()
        if let object = realm.object(ofType: Measure.self, forPrimaryKey: id) {
            try! realm.write {
                realm.delete(object)
            }
        }
    }
}

private enum TrendsServiceKey: DependencyKey {
    static let liveValue: TrendsStoring = TrendsRealmService()
}

extension DependencyValues {
    public var trendsService: TrendsStoring {
        get { self[TrendsServiceKey.self] }
        set { self[TrendsServiceKey.self] = newValue }
    }
}
