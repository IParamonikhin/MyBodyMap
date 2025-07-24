//
//  ChartModel.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import Foundation

public struct ChartDataPoint: Equatable, Identifiable {
    public var id: UUID = UUID()
    public let x: Double
    public let y: Double
    public let label: String?

    public init(x: Double, y: Double, label: String? = nil) {
        self.x = x
        self.y = y
        self.label = label
    }
}
