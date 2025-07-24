//
//  TrendsService.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import Foundation
import RealmSwift
import ComposableArchitecture

protocol TrendsStoring {
    func loadTrends(for field: String) -> [TrendItem]
    func loadAllTrends() -> [TrendItem]
    func saveOrder(_ order: [String])
    func loadOrder() -> [String]
}

final class TrendsRealmService: TrendsStoring {
    func loadTrends(for field: String) -> [TrendItem] {
        let realm = try! Realm()
        let measures = realm.objects(Measures.self).sorted(byKeyPath: "date", ascending: true)
        var trends: [TrendItem] = []
        var prev: Double?
        for m in measures {
            let val = valueForField(field, in: m)
            let diff = prev != nil ? val - prev! : 0
            trends.append(TrendItem(id: UUID(), field: field, value: val, date: m.date, diff: diff))
            prev = val
        }
        return trends
    }

    func loadAllTrends() -> [TrendItem] {
        let fields = ["weight", "chest", "waist", "forearm", "biceps", "neck", "shoulders", "thigh", "buttocks", "calf", "stomach", "height", "fatPercent"]
        let order = loadOrder()
        let sortedFields = order.isEmpty ? fields : order
        return sortedFields.map { field in
            let trends = loadTrends(for: field)
            let last = trends.last
            let diff = (trends.count > 1) ? (trends.last!.value - trends[trends.count-2].value) : 0
            return TrendItem(id: UUID(), field: field, value: last?.value ?? 0, date: last?.date ?? Date(),  diff: diff)
        }
    }

    func saveOrder(_ order: [String]) {
        UserDefaults.standard.set(order, forKey: "trend_order")
    }

    func loadOrder() -> [String] {
        UserDefaults.standard.stringArray(forKey: "trend_order") ?? []
    }

    private func valueForField(_ field: String, in m: Measures) -> Double {
        switch field {
        case "weight": return m.weight
        case "chest": return m.chest
        case "waist": return m.waist
        case "forearm": return m.forearm
        case "biceps": return m.biceps
        case "neck": return m.neck
        case "shoulders": return m.shoulders
        case "thigh": return m.thigh
        case "buttocks": return m.buttocks
        case "calf": return m.calf
        case "stomach": return m.stomach
        case "height": return m.height
        case "fatPercent": return m.fatPercent
        default: return 0
        }
    }
}


// DependencyKey для DI через TCA
private enum TrendsServiceKey: DependencyKey {
    static let liveValue: TrendsStoring = TrendsRealmService()
}
extension DependencyValues {
    var trendsService: TrendsStoring {
        get { self[TrendsServiceKey.self] }
        set { self[TrendsServiceKey.self] = newValue }
    }
}
