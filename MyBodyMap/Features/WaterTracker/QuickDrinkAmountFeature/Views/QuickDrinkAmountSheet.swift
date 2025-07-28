//
//  QuickDrinkAmountSheet.swift
//  MyBodyMap
//
//  Created by Иван on 27.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct QuickDrinkAmountSheet: View {
    @Bindable var store: StoreOf<QuickDrinkAmountFeature>
    @Environment(\.dismiss) private var dismiss

    public var body: some View {
        ZStack {
            Color("BGColor").ignoresSafeArea()
            VStack(spacing: 24) {
                Spacer().frame(height: 16)
                CardView {
                    VStack(alignment: .leading, spacing: 18) {
                        HStack {
                            Text(store.drink.name)
                                .font(.title2.bold())
                                .foregroundStyle(Color("FontColor"))
                            Spacer()
                        }
                        ElementBackgroundView(height: 48) {
                            TextField("Объём (мл)", text: $store.amount)
                                .keyboardType(.numberPad)
                                .foregroundStyle(Color("FontColor"))
                                .font(.system(size: 22, weight: .medium))
                                .multilineTextAlignment(.center)
                        }
                        HStack(spacing: 12) {
                            Button("Отмена") {
                                store.send(.cancelTapped)
                                dismiss()
                            }
                            .buttonStyle(CustomButtonStyle())
                            Button("Добавить") {
                                store.send(.addTapped)
                                dismiss()
                            }
                            .buttonStyle(CustomButtonStyle())
                        }
                        .frame(height: 48)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
                Spacer()
            }
        }
        .presentationDetents([.medium, .large])
    }
}
