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
        VStack(spacing: 16) {
            CardView {
                VStack(spacing: 12) {
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
            HStack(spacing: 14) {
                Button("Отмена") {
                    // Отправляем новый action и закрываем View
                    store.send(.cancelButtonTapped)
                    dismiss()
                }
                .buttonStyle(CustomButtonStyle()) // Предполагается, что у вас есть этот стиль
                
                Button("Сохранить") {
                    // Отправляем новый action и закрываем View
                    store.send(.saveButtonTapped)
                    dismiss()
                }
                .buttonStyle(CustomButtonStyle()) // Предполагается, что у вас есть этот стиль
            }
            .padding(.top, 8)
        }
        .padding(.vertical, 18)
        .background(Color("BGColor").ignoresSafeArea())
    }
}

//import SwiftUI
//import ComposableArchitecture
//
//public struct WaterSettingsSheet: View {
//    @Bindable var store: StoreOf<WaterSettingsFeature>
//    @Environment(\.dismiss) private var dismiss
//
//    public init(store: StoreOf<WaterSettingsFeature>) {
//        self.store = store
//    }
//
//    public var body: some View {
//        VStack(spacing: 16) {
//            CardView {
//                VStack(spacing: 12) {
//                    Text("Цель по воде (мл)")
//                        .font(.headline)
//                        .foregroundStyle(Color("FontColor"))
//                    ElementBackgroundView {
//                        TextField("Цель", value: $store.waterGoal, format: .number)
//                            .keyboardType(.numberPad)
//                            .font(.system(size: 22, weight: .medium))
//                            .foregroundStyle(Color("FontColor"))
//                            .multilineTextAlignment(.center)
//                            .padding(.horizontal, 8)
//                    }
//                }
//                .padding(.vertical, 12)
//            }
//            .padding(.horizontal, 16)
//            HStack(spacing: 14) {
//                Button("Отмена") {
//                    store.send(.cancel)
//                    dismiss()
//                }
//                .buttonStyle(CustomButtonStyle())
//                Button("Сохранить") {
//                    store.send(.save(store.waterGoal))
//                    dismiss()
//                }
//                .buttonStyle(CustomButtonStyle())
//            }
//            .padding(.top, 8)
//        }
//        .padding(.vertical, 18)
//        .background(Color("BGColor").ignoresSafeArea())
//    }
//}
