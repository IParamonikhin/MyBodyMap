//
//  TrendItem.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

public struct TrendItem: Identifiable, Equatable, Transferable, Codable {
    
    public let id: String
    public let field: String
    public let value: Double
    public let date: Date
    public let diff: Double

    public var label: String { field.trendLabel }
    
    public var formatValue: String { String(format: "%.1f", value) }
    public var formatValueDiff: String { String(format: "%.1f", abs(diff)) }
    
    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .trendItem)
    }
}

extension UTType {
    static let trendItem = UTType(exportedAs: "ru.piv.trenditem")
}

extension String {
    var trendLabel: String {
        switch self {
        case "weight": return "Вес"
        case "chest": return "Грудь"
        case "waist": return "Талия"
        case "forearm": return "Предплечье"
        case "biceps": return "Бицепс"
        case "neck": return "Шея"
        case "shoulders": return "Плечи"
        case "thigh": return "Бедро"
        case "buttocks": return "Ягодицы"
        case "calf": return "Икра"
        case "stomach": return "Живот"
        case "height": return "Рост"
        case "fatPercent": return "% Жира"
        case "bmi": return "ИМТ"
        default: return self.capitalized
        }
    }
}
