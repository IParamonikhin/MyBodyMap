//
//  TrendColor.swift
//  MyBodyMap
//
//  Created by Иван on 26.07.2025.
//

import SwiftUI

enum TrendColor {
    static func color(for diff: Double, goal: ProfileFeature.Goal) -> Color {
        switch goal {
        case .looseWeight:
            if diff < 0 { return .green }
            if diff > 0 { return .red }
            return Color("BodyColor")
        case .gainWeight, .gainMuscle:
            if diff > 0 { return .green }
            if diff < 0 { return .red }
            return Color("BodyColor")
        case .none:
            return Color("BodyColor")
        }
    }
    static func textColor(for diff: Double, goal: ProfileFeature.Goal) -> Color {
        switch goal {
        case .looseWeight:
            if diff < 0 { return .green }
            if diff > 0 { return .red }
            return Color("FontOneColor")
        case .gainWeight, .gainMuscle:
            if diff > 0 { return .green }
            if diff < 0 { return .red }
            return Color("FontOneColor")
        case .none:
            return Color("FontOneColor")
        }
    }
}
