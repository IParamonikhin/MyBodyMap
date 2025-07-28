//
//  HealthKitServices.swift
//  MyBodyMap
//
//  Created by Иван on 26.07.2025.
//

import Foundation
import HealthKit

final class HealthKitServices {
    static let shared = HealthKitServices()
    private let healthStore = HKHealthStore()

    // Типы для синхронизации
    public let weightType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
    public let heightType = HKQuantityType.quantityType(forIdentifier: .height)!
    public let bmiType = HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!

    // Запросить разрешения (чтение и запись)
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let allTypes: Set = [weightType, heightType, bmiType]
        healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { success, _ in
            DispatchQueue.main.async { completion(success) }
        }
    }

    // Сохранить значение в HealthKit
    func save(_ type: HKQuantityType, value: Double, date: Date, unit: HKUnit, completion: ((Bool) -> Void)? = nil) {
        let quantity = HKQuantity(unit: unit, doubleValue: value)
        let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
        healthStore.save(sample) { success, _ in
            completion?(success)
        }
    }

    // Получить последние значения
    func fetchLatest(_ type: HKQuantityType, unit: HKUnit, completion: @escaping (Double?, Date?) -> Void) {
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: type, predicate: nil, limit: 1, sortDescriptors: [sort]) { _, results, _ in
            if let sample = results?.first as? HKQuantitySample {
                completion(sample.quantity.doubleValue(for: unit), sample.endDate)
            } else {
                completion(nil, nil)
            }
        }
        healthStore.execute(query)
    }
}
