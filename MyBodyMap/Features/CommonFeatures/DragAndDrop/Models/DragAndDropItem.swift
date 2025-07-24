//
//  DragAndDropItem.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import Foundation

protocol DragAndDropIdentifiable: Identifiable, Equatable {}

struct DragAndDropItem: DragAndDropIdentifiable {
    let id: UUID
    let title: String
}
