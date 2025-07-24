//
//  TrendItem.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import Foundation

public struct TrendItem: Identifiable, Equatable, Hashable, Codable {
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

//import Foundation
//
//public struct TrendItem: Equatable, Identifiable, Codable {
//    public var id = UUID()
//    public var date: Date
//    public var value: Double
//    public var field: String
//    public var diff: Double
//
//    public var label: String {
//        switch field {
//        case "weight": return "Вес"
//        case "chest": return "Грудь"
//        case "waist": return "Талия"
//        case "forearm": return "Предплечье"
//        case "biceps": return "Бицепс"
//        case "neck": return "Шея"
//        case "shoulders": return "Плечи"
//        case "thigh": return "Бедро"
//        case "buttocks": return "Ягодицы"
//        case "calf": return "Икра"
//        case "stomach": return "Живот"
//        case "height": return "Рост"
//        case "fatPercent": return "% Жира"
//        default: return field
//        }
//    }
//
//    public var formatValue: String {
//        String(format: "%.1f", value)
//    }
//    public var formatValueDiff: String {
//        String(format: "%.1f", abs(diff))
//    }
//}
////public struct TrendItem: Equatable, Identifiable {
////    public var id = UUID()
////    public var date: Date
////    public var value: Double
////    public var field: String 
////    public var diff: Double
////}
