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
                HStack {
                    Text("Главные тренды")
                        .font(.headline)
                    Spacer()
                }
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                    ForEach(store.trends) { trend in
                        TrendGridIconView(trend: trend)
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 2)

                HStack {
                    Spacer()
                    Button("Другие", action: onShowAll)
                        .font(.subheadline)
                        .foregroundColor(Color("FontColor"))
                        .padding(.top, 4)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
