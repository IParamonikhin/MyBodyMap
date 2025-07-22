//
//  MeasuresModel.swift
//  MyBodyMap
//
//  Created by Иван on 13.07.2025.
//

import Foundation
import RealmSwift

final class Measures: Object, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var date: Date = Date()
    @objc dynamic var forearm: Double = 0
    @objc dynamic var biceps: Double = 0
    @objc dynamic var neck: Double = 0
    @objc dynamic var chest: Double = 0
    @objc dynamic var shoulders: Double = 0
    @objc dynamic var waist: Double = 0
    @objc dynamic var hips: Double = 0
    @objc dynamic var thigh: Double = 0
    @objc dynamic var buttocks: Double = 0
    @objc dynamic var calf: Double = 0
    @objc dynamic var stomach: Double = 0
    @objc dynamic var weight: Double = 0
    @objc dynamic var height: Double = 0
    @objc dynamic var fatPercent: Double = 0
}
