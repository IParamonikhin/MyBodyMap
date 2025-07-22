//
//  PhotoModel.swift
//  MyBodyMap
//
//  Created by Иван on 13.07.2025.
//

import Foundation
import RealmSwift

class ProgressPhoto: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var date: Date = Date()
    @objc dynamic var data: Data = Data()
}
