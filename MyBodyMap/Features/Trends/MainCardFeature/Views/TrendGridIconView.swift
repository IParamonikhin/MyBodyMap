//
//  TrendGridIconView.swift
//  MyBodyMap
//
//  Created by Иван on 23.07.2025.
//

import SwiftUI

struct TrendGridIconView: View {
    let trend: TrendItem
    let goal: ProfileFeature.Goal
    let isSelected: Bool

    var body: some View {
        ZStack {
            if isSelected {
                RoundedRectangle(cornerRadius: 28)
                     .fill(Color.cyan.opacity(0.55))
                     .frame(width: 98, height: 128) // чуть больше самой ячейки
                     .blur(radius: 14)
                     .offset(y: 6)
                     .zIndex(-1)
            }
            VStack(spacing: 6) {
                Text(trend.label)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color("FontOneColor"))
                    .lineLimit(2)
                    .frame(maxWidth: 72)
                Text(trend.formatValue)
                    .font(.headline)
                    .foregroundStyle(Color("FontOneColor"))
                if trend.diff != 0 {
                    Text(trend.diff > 0 ? "▲ \(trend.formatValueDiff)" : "▼ \(trend.formatValueDiff)")
                        .font(.caption2)
                        .foregroundStyle(TrendColor.textColor(for: trend.diff, goal: goal))
                } else {
                    Text("—")
                        .font(.caption2)
                        .foregroundStyle(Color("FontOneColor"))
                }
            }
            .frame(width: 90, height: 120)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(TrendColor.color(for: trend.diff, goal: goal).opacity(trend.diff == 0 ? 0.6 : 0.5))

            )
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
            .padding(2)
        }
        .animation(.easeInOut, value: isSelected)
    }
}
