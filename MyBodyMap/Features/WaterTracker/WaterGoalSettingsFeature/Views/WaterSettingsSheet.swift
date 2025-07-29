//
//  WaterSettingsSheet.swift
//  MyBodyMap
//
//  Created by Иван on 28.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct WaterSettingsSheet: View {
    @Bindable var store: StoreOf<WaterSettingsFeature>
    @Environment(\.dismiss) private var dismiss

    public init(store: StoreOf<WaterSettingsFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack{
            Color("BGColor")
            VStack(spacing: 16) {
                CardView {
                    VStack() {
                        Text("Цель по воде (мл)")
                            .font(.headline)
                            .foregroundStyle(Color("FontColor"))
                        ElementBackgroundView {
                            TextField("Цель", value: $store.waterGoal, format: .number)
                                .keyboardType(.numberPad)
                                .font(.system(size: 22, weight: .medium))
                                .foregroundStyle(Color("FontColor"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 8)
                        }
                    }
                    .padding(.vertical, 12)
                }
                .padding(.horizontal, 16)
                CardView{
                    HStack(spacing: 14) {
                        Button("Отмена") {
                            store.send(.cancelButtonTapped)
                            dismiss()
                        }
                        .buttonStyle(CustomButtonStyle())
                        
                        Button("Сохранить") {
                            store.send(.saveButtonTapped)
                            dismiss()
                        }
                        .buttonStyle(CustomButtonStyle())
                    }
                    .padding(.top, 8)
                }
                .padding(.vertical, 18)
                .background(Color("BGColor").ignoresSafeArea())
            }
            .padding(.horizontal, 16)
        }
    }
}
