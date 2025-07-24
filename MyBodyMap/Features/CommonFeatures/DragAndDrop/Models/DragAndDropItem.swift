//
//  DragAndDropItem.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import Foundation

protocol DragAndDropIdentifiable: Identifiable, Equatable {}

public struct DragAndDropItem: DragAndDropIdentifiable {
    public let id: UUID
    public let title: String
}
