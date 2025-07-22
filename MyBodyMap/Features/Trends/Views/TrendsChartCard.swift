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
                Text(TrendsFeatureView.labelStatic(for: store.selectedField)).font(.title2.bold())
                    .foregroundStyle(Color("textfieldColor"))
                if !store.fieldTrends.isEmpty {
                    TrendsChart(fieldTrends: store.fieldTrends)
                        .frame(height: 120)
                        .padding(.vertical, 4)
                }
                HStack {
                    Text(TrendsFeatureView.formatValueStatic(store.fieldTrends.last?.value))
                        .font(.largeTitle.bold())
                        .foregroundStyle(Color("textfieldColor"))
                    Spacer()
                    if let diff = store.fieldTrends.last?.diff {
                        Text(diff > 0 ? "▲ \(TrendsFeatureView.formatValueStatic(diff))" :
                             diff < 0 ? "▼ \(TrendsFeatureView.formatValueStatic(abs(diff)))" : "—")
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
