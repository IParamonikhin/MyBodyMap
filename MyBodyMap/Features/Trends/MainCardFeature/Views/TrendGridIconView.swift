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
            Text(trend.label)
                .font(.caption)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .lineLimit(2)
                .frame(maxWidth: 72)
            Text(trend.formatValue)
                .font(.headline)
            if trend.diff != 0 {
                Text(trend.diff > 0 ? "▲ \(trend.formatValueDiff)" : "▼ \(trend.formatValueDiff)")
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
                .fill(trend.diff > 0 ? Color.green.opacity(0.15) :
                      trend.diff < 0 ? Color.red.opacity(0.15) :
                      Color(.systemGray5).opacity(0.35))
        )
        .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        .padding(2)
    }
}

//#Preview {
//    TrendGridIconView()
//}
