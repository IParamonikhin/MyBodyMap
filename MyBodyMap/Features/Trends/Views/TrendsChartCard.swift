//
//  TrendsChartCard.swift
//  MyBodyMap
//
//  Created by Иван on 23.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct TrendsChartCard: View {
    @Bindable var store: StoreOf<TrendsFeature>
    var body: some View {
        CardView {
            VStack(alignment: .leading) {
                Text(store.state.selectedField)
                    .font(.title2.bold())
                    .foregroundStyle(Color("FontColor"))
                if !store.fieldTrends.isEmpty {
                    TrendsChart(fieldTrends: store.fieldTrends)
                        .frame(height: 120)
                        .padding(.vertical, 4)
                }
                HStack {
                    Text(store.fieldTrends.last?.formatValue ?? "–")
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color("FontColor"))
                    Spacer()
                    if let diff = store.fieldTrends.last?.diff {
                        Text(diff > 0 ? "▲ \(store.fieldTrends.last?.formatValueDiff ?? "")"
                             : diff < 0 ? "▼ \(store.fieldTrends.last?.formatValueDiff ?? "")" : "—")
                            .foregroundColor(diff > 0 ? .green : diff < 0 ? .red : .gray)
                            .font(.title2.bold())
                    }
                }
            }
        }
    }
}
//#Preview {
//    TrendsChartCard()
//}
