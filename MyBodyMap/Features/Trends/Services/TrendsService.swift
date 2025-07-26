//
//  TrendsService.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import Foundation
import RealmSwift
import ComposableArchitecture

// Протокол теперь включает удаление
public protocol TrendsStoring {
    func loadTrends(for field: String) -> [TrendItem]
    func loadAllTrends() -> [TrendItem]
    func saveOrder(_ order: [String])
    func loadOrder() -> [String]
    func allFields() -> [String]
    func deleteMeasure(date: Date) throws
}

public final class TrendsRealmService: TrendsStoring {
    // Список всех полей для измерений
    private let fields = [
        "weight", "chest", "waist", "forearm", "biceps", "neck",
        "shoulders", "thigh", "buttocks", "calf", "stomach", "height", "fatPercent", "hips"
    ]
    
    public init() {}

    public func loadTrends(for field: String) -> [TrendItem] {
        let realm = try! Realm()
        // Предполагается, что ваша модель Measures имеет строковый ID
        let measures = realm.objects(Measures.self).sorted(byKeyPath: "date", ascending: true)
        var trends: [TrendItem] = []
        var prev: Double?
        for m in measures {
            if let val = valueForField(field, in: m) {
                let diff = prev != nil ? val - prev! : 0
                // Теперь m.id (String) корректно передается в TrendItem
                trends.append(TrendItem(id: "\(field)-\(m.id)", field: field, value: val, date: m.date, diff: diff))
                prev = val
            }
        }
        return trends
    }

    public func loadAllTrends() -> [TrendItem] {
        let order = loadOrder()
        let sortedFields = order.isEmpty ? fields : order
        
        return sortedFields.compactMap { field in
            let trends = loadTrends(for: field)
            guard let last = trends.last else {
                // Если для поля нет данных, не включаем его в список
                return nil
            }
            
            let diff: Double
            if trends.count > 1 {
                let secondLastValue = trends[trends.count - 2].value
                diff = last.value - secondLastValue
            } else {
                diff = 0
            }
            
            return TrendItem(
                id: last.id, // Используем ID последней записи
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
        UserDefaults.standard.stringArray(forKey: "trend_order") ?? fields
    }

    public func allFields() -> [String] {
        return fields
    }

    // Новый метод, перенесенный сюда
    public func deleteMeasure(date: Date) throws {
        let realm = try Realm()
        // Фильтруем по дате с небольшой погрешностью для надежности
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: date)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
        
        if let object = realm.objects(Measures.self).filter("date >= %@ AND date < %@", startDate, endDate).first {
            try realm.write {
                realm.delete(object)
            }
        }
    }

    private func valueForField(_ field: String, in m: Measures) -> Double? {
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
        case "hips": return m.hips
        default: return nil
        }
    }
}

// DependencyKey для DI через TCA
private enum TrendsServiceKey: DependencyKey {
    static let liveValue: TrendsStoring = TrendsRealmService()
}

extension DependencyValues {
    public var trendsService: TrendsStoring {
        get { self[TrendsServiceKey.self] }
        set { self[TrendsServiceKey.self] = newValue }
    }
}
