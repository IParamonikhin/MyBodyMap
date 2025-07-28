//
//  WaterTrackerModel.swift
//  MyBodyMap
//
//  Created by Иван on 13.07.2025.
//

import Foundation
import RealmSwift

final public class WaterDay: Object, Identifiable {
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted var date: Date 
    @Persisted var totalDrunk: Double
    @Persisted var goal: Double
    @Persisted var drinks: List<ConsumedDrink>
}
final public class ConsumedDrink: Object {
    @Persisted var date: Date
    @Persisted public var name: String = ""
    @Persisted public var brand: String? = nil
    @Persisted public var barcode: String? = nil
    @Persisted public var type: String = "custom"
    @Persisted public var amount: Double = 200
    @Persisted public var hydrationFactor: Double = 1.0
    @Persisted public var imageUrl: String? = nil

    convenience init(from drink: Drink, date : Date, amount: Double) {
        self.init()
        self.date = date
        self.name = drink.name
        self.brand = drink.brand
        self.barcode = drink.barcode
        self.type = drink.type
        self.amount = amount
        self.hydrationFactor = drink.hydrationFactor
        self.imageUrl = drink.imageUrl
    }
}

