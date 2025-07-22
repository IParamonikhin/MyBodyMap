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
    func loadTrendsAllFields() -> [TrendItem]
    func loadMainTrendsOrder() -> [String]
    func saveMainTrendsOrder(_ order: [String])
}

final class TrendsRealmService: TrendsStoring {
    private let mainTrendsOrderKey = "mainTrendsOrder"

    func loadTrends(for field: String) -> [TrendItem] {
        let realm = try! Realm()
        let measures = realm.objects(Measures.self).sorted(byKeyPath: "date", ascending: true)
        var items: [TrendItem] = []
        var prevValue: Double? = nil
        for m in measures {
            let value: Double
            switch field {
            case "weight": value = m.weight
            case "chest": value = m.chest
            case "waist": value = m.waist
            case "forearm": value = m.forearm
            case "biceps": value = m.biceps
            case "neck": value = m.neck
            case "shoulders": value = m.shoulders
            case "thigh": value = m.thigh
            case "buttocks": value = m.buttocks
            case "calf": value = m.calf
            case "stomach": value = m.stomach
            case "height": value = m.height
            case "fatPercent": value = m.fatPercent
            default: value = 0
            }
            let diff = prevValue != nil ? value - prevValue! : 0
            items.append(TrendItem(date: m.date, value: value, field: field, diff: diff))
            prevValue = value
        }
        return items
    }

    func loadTrendsAllFields() -> [TrendItem] {
        let fields = ["weight", "chest", "waist", "forearm", "biceps", "neck", "shoulders", "thigh", "buttocks", "calf", "stomach", "height", "fatPercent"]
        var result: [TrendItem] = []
        for field in fields {
            let trend = loadTrends(for: field)
            if let last = trend.last {
                result.append(last)
            }
        }
        return result
    }

    func loadMainTrendsOrder() -> [String] {
        UserDefaults.standard.stringArray(forKey: mainTrendsOrderKey) ?? []
    }

    func saveMainTrendsOrder(_ order: [String]) {
        UserDefaults.standard.set(order, forKey: mainTrendsOrderKey)
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
