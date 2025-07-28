//
//  Drink.swift
//  MyBodyMap
//
//  Created by Иван on 27.07.2025.
//

import Foundation
import RealmSwift

final public class Drink: Object, Identifiable {
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted public var name: String = ""
    @Persisted public var brand: String? = nil
    @Persisted public var barcode: String? = nil
    @Persisted public var type: String = "custom"
    @Persisted public var amount: Double = 200 // мл
    @Persisted public var hydrationFactor: Double = 1.0 
    @Persisted public var imageUrl: String? = nil


    // Конструктор из API
    static func from(product: OpenFoodFactsProduct) -> Drink {
        let drink = Drink()
        drink.name = product.product_name ?? "Без названия"
        drink.brand = product.brands
        drink.barcode = product.code
        drink.type = "custom"
        drink.amount = Double(product.quantity?.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression) ?? "200") ?? 200
        drink.hydrationFactor = 1.0
        drink.imageUrl = product.image_url
        return drink
    }
    
    convenience init(name: String, type: String, amount: Double, hydrationFactor: Double, brand: String? = nil) {
        self.init()
        self.name = name
        self.type = type
        self.amount = amount
        self.hydrationFactor = hydrationFactor
        self.brand = brand
    }
}
