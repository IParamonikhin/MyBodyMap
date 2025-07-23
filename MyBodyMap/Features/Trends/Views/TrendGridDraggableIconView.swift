//
//  TrendGridDraggableIconView.swift
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
    let onMove: (String, String) -> Void   // Новый!

    var body: some View {
        TrendGridIconView(trend: trend)
            .matchedGeometryEffect(id: trend.id, in: trendNamespace)
            .onTapGesture { onTap() }
            .onLongPressGesture { onLongPress() }
            .opacity(isEditing ? 0.9 : 1)
            .scaleEffect(isEditing ? 1.1 : 1)
            .draggable(trend.field)
            .dropDestination(for: String.self) { droppedFields, location in
                guard let droppedField = droppedFields.first else { return false }
                if droppedField != trend.field {
                    onMove(droppedField, trend.field) // Передаем оба ключа!
                }
                return true
            }
    }
}

//struct TrendGridDraggableIconView: View {
//    let trend: TrendItem
//    let isDragging: Bool
//    var trendNamespace: Namespace.ID
//    var onTap: () -> Void
//    var onLongPress: () -> Void
//
//    var body: some View {
//        VStack(spacing: 6) {
//            Text(TrendsFeatureView.labelStatic(for: trend.field))
//                .font(.caption)
//                .fontWeight(.semibold)
//                .multilineTextAlignment(.center)
//                .foregroundColor(.primary)
//                .lineLimit(2)
//                .frame(maxWidth: 72)
//            Text(TrendsFeatureView.formatValueStatic(trend.value))
//                .font(.headline)
//            if trend.diff != 0 {
//                Text(trend.diff > 0 ? "▲ \(TrendsFeatureView.formatValueStatic(abs(trend.diff)))"
//                                    : "▼ \(TrendsFeatureView.formatValueStatic(abs(trend.diff)))")
//                    .font(.caption2)
//                    .foregroundColor(trend.diff > 0 ? .green : .red)
//            } else {
//                Text("—")
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//            }
//        }
//        .frame(width: 90, height: 120)
//        .background(
//            RoundedRectangle(cornerRadius: 20)
//                .fill(backgroundColor(for: trend.diff))
//                .matchedGeometryEffect(id: trend.id, in: trendNamespace)
//        )
//        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
//        .padding(2)
//        .opacity(isDragging ? 0.35 : 1.0)
//        .onTapGesture { onTap() }
//        .onLongPressGesture { onLongPress() }
//    }
//
//    private func backgroundColor(for diff: Double) -> Color {
//        if diff > 0 {
//            return Color.green.opacity(0.15)
//        } else if diff < 0 {
//            return Color.red.opacity(0.15)
//        } else {
//            return Color(.systemGray5).opacity(0.35)
//        }
//    }
//}


//import SwiftUI
//
//struct TrendGridDraggableIconView: View {
//    let trend: TrendItem
//    var isDragging: Bool = false
//
//    var body: some View {
//        VStack(spacing: 6) {
//            Text(TrendsFeatureView.labelStatic(for: trend.field))
//                .font(.caption)
//                .fontWeight(.semibold)
//                .multilineTextAlignment(.center)
//                .foregroundColor(.primary)
//                .lineLimit(2)
//                .frame(maxWidth: 72)
//            Text(TrendsFeatureView.formatValueStatic(trend.value))
//                .font(.headline)
//            if trend.diff != 0 {
//                Text(trend.diff > 0 ? "▲ \(TrendsFeatureView.formatValueStatic(abs(trend.diff)))"
//                                    : "▼ \(TrendsFeatureView.formatValueStatic(abs(trend.diff)))")
//                    .font(.caption2)
//                    .foregroundColor(trend.diff > 0 ? .green : .red)
//            } else {
//                Text("—")
//                    .font(.caption2)
//                    .foregroundColor(.gray)
//            }
//        }
//        .frame(width: 90, height: 120)
//        .background(
//            RoundedRectangle(cornerRadius: 20)
//                .fill(isDragging ? Color.accentColor.opacity(0.3) : backgroundColor(for: trend.diff))
//        )
//        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
//        .padding(2)
//        .scaleEffect(isDragging ? 1.08 : 1.0)
//        .animation(.spring(response: 0.35, dampingFraction: 0.6), value: isDragging)
//    }
//
//    private func backgroundColor(for diff: Double) -> Color {
//        if diff > 0 {
//            return Color.green.opacity(0.15)
//        } else if diff < 0 {
//            return Color.red.opacity(0.15)
//        } else {
//            return Color(.systemGray5).opacity(0.35)
//        }
//    }
//}



//import SwiftUI
//
//struct TrendGridDraggableIconView: View {
//    let trend: TrendItem
//    let isEditing: Bool
//    let trendNamespace: Namespace.ID
//    let onTap: () -> Void
//    let onLongPress: () -> Void
//
//    @ViewBuilder
//    var body: some View {
//        let icon = TrendGridIconView(trend: trend)
//            .matchedGeometryEffect(id: trend.id, in: trendNamespace)
//            .onTapGesture { onTap() }
//            .onLongPressGesture { onLongPress() }
//
//        if isEditing {
//            icon.draggable(trend.field)
//        } else {
//            icon
//        }
//    }
//}
