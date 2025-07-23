//
//  ProfileModel.swift
//  MyBodyMap
//
//  Created by Иван on 13.07.2025.
//

import Foundation
import RealmSwift

class Profile: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var gender: String = "other"
    @objc dynamic var birthdate: Date = Date()
    @objc dynamic var goal: String = "none"
}

