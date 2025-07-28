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
    func addDrink(for date: Date, drink: Drink, amount: Double, hydration: Double)
    func getToday() -> WaterDay?
    func updateGoal(_ newGoal: Double)
    func getHistory() -> [WaterDay]
    func getDay(for date: Date) -> WaterDay?
}

final class WaterRealmService: WaterStoring {

    private func startOfDay(for date: Date = Date()) -> Date {
        Calendar.current.startOfDay(for: date)
    }
    
    func getOrCreateDay(for date: Date = Date()) -> WaterDay {

        let realm = try! Realm()
        print (realm.configuration.fileURL)
        let dayStart = startOfDay(for: date)
        if let day = realm.objects(WaterDay.self)
            .filter("date == %@", dayStart)
            .first
        {
            return day
        }
        let lastGoal = realm.objects(WaterDay.self)
            .sorted(byKeyPath: "date", ascending: false)
            .first?.goal ?? 2000

        let day = WaterDay()
        day.date = dayStart
        day.goal = lastGoal
        day.totalDrunk = 0
        try! realm.write { realm.add(day) }
        return day
    }
    
    func addDrink(for date: Date, drink: Drink, amount: Double, hydration: Double) {
        let realm = try! Realm()
        let dayStart = startOfDay(for: date)
        let day = getOrCreateDay()
        let added = amount * hydration
        try! realm.write {
            day.totalDrunk += added
            let consumed = ConsumedDrink(from: drink, date: dayStart, amount: amount)
            day.drinks.append(consumed)
        }
    }
    
    func getToday() -> WaterDay? {
        let realm = try! Realm()
        let dayStart = startOfDay()
        return realm.objects(WaterDay.self)
            .filter("date == %@", dayStart)
            .first
    }
    
    func updateGoal(_ newGoal: Double) {
        let realm = try! Realm()
        let day = getOrCreateDay()
        try! realm.write {
            day.goal = newGoal
        }
    }
    
    func getHistory() -> [WaterDay] {
        let realm = try! Realm()
        return Array(realm.objects(WaterDay.self).sorted(byKeyPath: "date", ascending: false))
    }
    
    func getDay(for date: Date) -> WaterDay? {
        let realm = try! Realm()
        let dayStart = startOfDay(for: date)
        return realm.objects(WaterDay.self)
            .filter("date == %@", dayStart)
            .first
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
