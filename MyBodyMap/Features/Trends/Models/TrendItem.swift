//
//  TrendItem.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import Foundation

public struct TrendItem: Identifiable, Equatable/*, Hashable, Codable */{
    public let id: UUID
    public let field: String
    public let value: Double
    public let date: Date
    public let diff: Double

    public init(id: UUID = .init(), field: String, value: Double, date: Date, diff: Double = 0) {
        self.id = id
        self.field = field
        self.value = value
        self.date = date
        self.diff = diff
    }
}
