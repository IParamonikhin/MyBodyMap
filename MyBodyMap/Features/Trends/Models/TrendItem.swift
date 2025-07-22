//
//  TrendItem.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import Foundation

public struct TrendItem: Equatable, Identifiable {
    public var id = UUID()
    public var date: Date
    public var value: Double
    public var field: String // новое поле: название поля (например, "waist", "biceps" и т.д.)
    public var diff: Double // разница с предыдущим значением
}
