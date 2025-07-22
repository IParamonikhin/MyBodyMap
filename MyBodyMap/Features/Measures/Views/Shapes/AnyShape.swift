//
//  AnyShape.swift
//  MyBodyMap
//
//  Created by Иван on 22.07.2025.
//

import SwiftUI

struct AnyShape: Shape {
    private let _path: (CGRect) -> Path
    init<S: Shape>(_ wrapped: S) {
        _path = { rect in wrapped.path(in: rect) }
    }
    func path(in rect: CGRect) -> Path { _path(rect) }
}
