//
//  TrendsChart.swift
//  MyBodyMap
//
//  Created by Иван on 23.07.2025.
//

import SwiftUI
import Charts

struct TrendsChart: View {
    let fieldTrends: [TrendItem]
    var body: some View {
        Chart(fieldTrends) { item in
            LineMark(
                x: .value("Date", item.date),
                y: .value("Value", item.value)
            )
            .interpolationMethod(.catmullRom)
            .foregroundStyle(Gradient(colors: [.green, .blue]))
        }
        .foregroundStyle(Color("textfieldColor"))
    }
}

//#Preview {
//    TrendsChart()
//}
