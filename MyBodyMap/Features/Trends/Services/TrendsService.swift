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
            trends.append(TrendItem(date: m.date, value: val, field: field, diff: diff))
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
            return TrendItem(date: last?.date ?? Date(), value: last?.value ?? 0, field: field, diff: diff)
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


//import Foundation
//import RealmSwift
//import ComposableArchitecture
//
//protocol TrendsStoring {
//    func loadTrends(for field: String) -> [TrendItem]
//    func loadTrendsAllFields() -> [TrendItem]
//    func loadMainTrendsOrder() -> [String]
//    func saveMainTrendsOrder(_ order: [String])
//}
//
//final class TrendsRealmService: TrendsStoring {
//    private let mainTrendsOrderKey = "mainTrendsOrder"
//
//    func loadTrends(for field: String) -> [TrendItem] {
//        let realm = try! Realm()
//        let measures = realm.objects(Measures.self).sorted(byKeyPath: "date", ascending: true)
//        var items: [TrendItem] = []
//        var prevValue: Double? = nil
//        for m in measures {
//            let value: Double
//            switch field {
//            case "weight": value = m.weight
//            case "chest": value = m.chest
//            case "waist": value = m.waist
//            case "forearm": value = m.forearm
//            case "biceps": value = m.biceps
//            case "neck": value = m.neck
//            case "shoulders": value = m.shoulders
//            case "thigh": value = m.thigh
//            case "buttocks": value = m.buttocks
//            case "calf": value = m.calf
//            case "stomach": value = m.stomach
//            case "height": value = m.height
//            case "fatPercent": value = m.fatPercent
//            default: value = 0
//            }
//            let diff = prevValue != nil ? value - prevValue! : 0
//            items.append(TrendItem(date: m.date, value: value, field: field, diff: diff))
//            prevValue = value
//        }
//        return items
//    }
//
//    func loadTrendsAllFields() -> [TrendItem] {
//        let fields = ["weight", "chest", "waist", "forearm", "biceps", "neck", "shoulders", "thigh", "buttocks", "calf", "stomach", "height", "fatPercent"]
//        var result: [TrendItem] = []
//        for field in fields {
//            let trend = loadTrends(for: field)
//            if let last = trend.last {
//                result.append(last)
//            }
//        }
//        return result
//    }
//
//    func loadMainTrendsOrder() -> [String] {
//        UserDefaults.standard.stringArray(forKey: mainTrendsOrderKey) ?? []
//    }
//
//    func saveMainTrendsOrder(_ order: [String]) {
//        UserDefaults.standard.set(order, forKey: mainTrendsOrderKey)
//    }
//}
//
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
