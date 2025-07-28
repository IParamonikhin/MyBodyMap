//
//  DrinkServices.swift
//  MyBodyMap
//
//  Created by Иван on 27.07.2025.
//

import Foundation
import RealmSwift
import ComposableArchitecture

protocol DrinkStoring {
    func fetchAll() -> [Drink]
    func fetch(byBarcode barcode: String) -> Drink?
    func addOrUpdate(_ drink: Drink)
    func remove(_ drink: Drink)
    func ensureDefaultsIfNeeded()
}

final class DrinkRealmService: DrinkStoring {
    func fetchAll() -> [Drink] {
        let realm = try! Realm()
        return Array(realm.objects(Drink.self))
    }
    func fetch(byBarcode barcode: String) -> Drink? {
        let realm = try! Realm()
        return realm.objects(Drink.self).filter("barcode == %@", barcode).first
    }
    func addOrUpdate(_ drink: Drink) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(drink, update: .all)
        }
    }
    func remove(_ drink: Drink) {
        let realm = try! Realm()
        if let object = realm.object(ofType: Drink.self, forPrimaryKey: drink.id) {
            try! realm.write {
                realm.delete(object)
            }
        }
    }
    func ensureDefaultsIfNeeded() {
        let realm = try! Realm()
        if realm.objects(Drink.self).isEmpty {
            let defaults = [
                Drink(name: "Вода", type: "water", amount: 200, hydrationFactor: 1.0),
                Drink(name: "Чай", type: "tea", amount: 200, hydrationFactor: 0.8),
                Drink(name: "Кофе", type: "coffee", amount: 200, hydrationFactor: 0.8),
                Drink(name: "Молоко", type: "milk", amount: 200, hydrationFactor: 1.0)
            ]
            try! realm.write {
                realm.add(defaults)
            }
        }
    }
}

private enum DrinkServiceKey: DependencyKey {
    static let liveValue: DrinkStoring = DrinkRealmService()
}
extension DependencyValues {
    var drinkService: DrinkStoring {
        get { self[DrinkServiceKey.self] }
        set { self[DrinkServiceKey.self] = newValue }
    }
}
