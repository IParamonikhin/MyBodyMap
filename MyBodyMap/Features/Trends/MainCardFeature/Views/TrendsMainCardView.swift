//
//  TrendsMainCardView.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct TrendsMainCardView: View {
    @Bindable var store: StoreOf<TrendsMainCardFeature>
    var onShowAll: () -> Void

    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 3)

    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Избранные измерения")
                    .font(.headline)
                    .foregroundColor(Color("textfieldColor"))
                    .padding(.leading, 4)

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(store.mainTrends.prefix(6)) { trend in
                        TrendGridIconView(trend: trend)
                            .onTapGesture {
                                store.send(.selectField(trend.field))
                            }
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 2)

                HStack {
                    Spacer()
                    Button("Другие", action: onShowAll)
                        .font(.subheadline)
                        .foregroundColor(Color("textfieldColor"))
                        .padding(.top, 4)
                }
            }
        }
    }
}
