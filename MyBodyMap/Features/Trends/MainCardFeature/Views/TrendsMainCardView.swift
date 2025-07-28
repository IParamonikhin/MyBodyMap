//
//  TrendsMainCardView.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct TrendsMainCardView: View {
    let store: StoreOf<TrendsMainCardFeature>
    let selectedField: String
    let onSelectField: (String) -> Void
    let onShowAll: () -> Void
    
    public init(
        store: StoreOf<TrendsMainCardFeature>,
        selectedField: String,
        onSelectField: @escaping (String) -> Void,
        onShowAll: @escaping () -> Void
    ) {
        self.store = store
        self.selectedField = selectedField
        self.onSelectField = onSelectField
        self.onShowAll = onShowAll
    }
    
    public var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Главные тренды")
                        .font(.title2.bold())
                        .foregroundStyle(Color("FontColor"))
                    Spacer()
                    Button(action: onShowAll) {
                        Image(systemName: "ellipsis.circle")
                            .font(.title2)
                    }
                }
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 12) {
                    ForEach(store.trends.prefix(6)) { trend in
                        TrendGridIconView(trend: trend, goal: store.goal, isSelected: trend.field == selectedField)
                            .onTapGesture { onSelectField(trend.field) }
                    }
                }
                .padding(.top, 4)
                .padding(.bottom, 2)
                
            }
        }
        .padding(.horizontal, 16)
    }
}
