//
//  MeasuresModel.swift
//  MyBodyMap
//
//  Created by Иван on 13.07.2025.
//

import Foundation
import RealmSwift


final public class Measure: Object, Identifiable {
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted public var type: String
    @Persisted public var value: Double
    @Persisted public var date: Date
    @Persisted public var note: String?
}
