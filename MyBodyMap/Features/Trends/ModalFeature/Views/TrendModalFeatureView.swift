//
//  TrendModalFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 25.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct TrendModalFeatureView: View {
    @Bindable var store: StoreOf<TrendModalFeature>
    @Environment(\.dismiss) var dismiss
    
    public init(store: StoreOf<TrendModalFeature>) { self.store = store }
    
    public var body: some View {
        let reversedTrends = Array(store.trends.reversed())
        NavigationStack {
            Color("BGColor")
                .ignoresSafeArea()
                .overlay(
                    VStack(spacing: 16) {
                        ChartFeatureView(store: store.scope(state: \.chart, action: \.chart))
                            .frame(height: 240)
                            .padding(.top)
                        Spacer()
                        CardView {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("История измерений")
                                        .font(.title2.bold())
                                        .foregroundStyle(Color("FontColor"))
                                    Spacer()
                                }
                                List {
                                    ForEach(reversedTrends) { trend in
                                        ElementBackgroundView {
                                            HStack {
                                                Text(trend.date, style: .date)
                                                Spacer()
                                                Text(trend.formatValue).bold()
                                            }
                                            .padding(.vertical, 8)
                                            .frame(maxWidth: .infinity)
                                        }
                                        .padding(.vertical, 8)
                                        .listRowInsets(EdgeInsets())
                                        .listRowBackground(Color.clear)
                                        .foregroundStyle(Color("FontColor"))
                                    }
                                    .onDelete { idx in
                                        let original = idx.map { store.trends.count - 1 - $0 }
                                        store.send(.delete(IndexSet(original)))
                                    }
                                }
                                .listStyle(.plain)
                                .scrollContentBackground(.hidden)
                                .frame(maxWidth: .infinity)
                            }
                        }
                        
                        .padding(.horizontal, 16)
                        Spacer()
                    }
                        .padding(.top, 16)
                )
                .alert($store.scope(state: \.alert, action: \.alert))
        }
    }
}
