//
//  TrendGridDraggableIconView.swift.swift
//  MyBodyMap
//
//  Created by Иван on 23.07.2025.
//

import SwiftUI

struct TrendGridDraggableIconView: View {
    let trend: TrendItem
    let isEditing: Bool
    let trendNamespace: Namespace.ID
    let onTap: () -> Void
    let onLongPress: () -> Void

    @ViewBuilder
    var body: some View {
        let icon = TrendGridIconView(trend: trend)
            .matchedGeometryEffect(id: trend.id, in: trendNamespace)
            .onTapGesture { onTap() }
            .onLongPressGesture { onLongPress() }

        if isEditing {
            icon.draggable(trend.field)
        } else {
            icon
        }
    }
}
