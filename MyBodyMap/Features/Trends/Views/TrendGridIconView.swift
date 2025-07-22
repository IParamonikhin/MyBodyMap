//
//  TrendGridIconView.swift
//  MyBodyMap
//
//  Created by Иван on 23.07.2025.
//

import SwiftUI

struct TrendGridIconView: View {
    let trend: TrendItem

    var body: some View {
        VStack(spacing: 6) {
            Text(TrendsFeatureView.labelStatic(for: trend.field))
                .font(.caption)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .lineLimit(2)
                .frame(maxWidth: 72)
            Text(TrendsFeatureView.formatValueStatic(trend.value))
                .font(.headline)
            if trend.diff != 0 {
                Text(trend.diff > 0 ? "▲ \(TrendsFeatureView.formatValueStatic(abs(trend.diff)))"
                                    : "▼ \(TrendsFeatureView.formatValueStatic(abs(trend.diff)))")
                    .font(.caption2)
                    .foregroundColor(trend.diff > 0 ? .green : .red)
            } else {
                Text("—")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 90, height: 120)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor(for: trend.diff))
        )
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        .padding(2)
    }

    private func backgroundColor(for diff: Double) -> Color {
        if diff > 0 {
            return Color.green.opacity(0.15)
        } else if diff < 0 {
            return Color.red.opacity(0.15)
        } else {
            return Color(.systemGray5).opacity(0.35)
        }
    }
}

//#Preview {
//    TrendGridIconView()
//}
