//
//  TrendsMainCard.swift
//  MyBodyMap
//
//  Created by Иван on 23.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct TrendsMainCard: View {
    @Bindable var store: StoreOf<TrendsFeature>
    @Namespace private var trendNamespace

    let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 3)
    var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Избранные измерения")
                    .font(.headline)
                    .foregroundColor(Color("FontColor"))
                    .padding(.leading, 4)
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(store.mainTrends.prefix(6)) { trend in
                        TrendGridIconView(trend: trend)
                            .matchedGeometryEffect(id: trend.id, in: trendNamespace)
                            .onTapGesture {
                                store.send(.selectField(trend.field))
                            }
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 2)
                HStack {
                    Spacer()
                    Button("Другие") {
                        store.send(.showAllTrends(true))
                    }
                    .font(.subheadline)
                    .foregroundColor(Color("FontColor"))
                    .padding(.top, 4)
                }
            }
        }
    }
}
//#Preview {
//    TrendsMainCard()
//}
