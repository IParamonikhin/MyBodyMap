//
//  MeasureInputModal.swift
//  MyBodyMap
//
//  Created by Иван on 20.07.2025.
//

import SwiftUI

struct MeasureInputModal: View {
    let field: MeasuresFeature.MeasuresField
    @State var value: Double = 0
    var onSave: (Double) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 18) {
                    Text(fieldLabel)
                        .font(.largeTitle.bold())
                        .padding(.bottom, 12)

                    Text("Введите значение")
                        .font(.subheadline)
                        .foregroundColor(Color("AccentColor"))

                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color("textfieldColor"))
                            .frame(height: 48)
                        TextField("0", value: $value, format: .number)
                            .keyboardType(.decimalPad)
                            .padding(.horizontal, 12)
                            .foregroundColor(Color("AccentColor"))
                    }
                    .padding(.horizontal, 4)

                    Spacer()
                }
                .padding(.top, 24)
                .padding(.horizontal, 20)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("OK") {
                            onSave(value)
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Отмена") {
                            dismiss()
                        }
                    }
                }
            }
        }
        .foregroundColor(Color("AccentColor"))
    }

    private var fieldLabel: String {
        switch field {
        case .forearm: return "Предплечье"
        case .biceps: return "Бицепс"
        case .neck: return "Шея"
        case .chest: return "Грудь"
        case .shoulders: return "Плечи"
        case .waist: return "Талия"
        case .hips: return "Бёдра"
        case .thigh: return "Бедро"
        case .buttocks: return "Ягодицы"
        case .calf: return "Икра"
        case .stomach: return "Живот"
        case .weight: return "Вес"
        case .height: return "Рост"
        case .fatPercent: return "% Жира"
        }
    }
}

//import SwiftUI
//
//struct MeasureInputModal: View {
//    let field: MeasuresFeature.MeasuresField
//    @State var value: Double = 0
//    var onSave: (Double) -> Void
//
//    @Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//        
//        NavigationStack {
//            ZStack {
//                Color("backgroundColor")
//                    .ignoresSafeArea()
//                Form {
//                    Section(header: Text("Введите значение")) {
//                        TextField("0", value: $value, format: .number)
//                            .keyboardType(.decimalPad)
//                            .textFieldStyle(.plain)
//                            .background(Color("textfieldColor"))
//                            .frame(maxWidth: .infinity)
//                    }
//                }
//                .navigationTitle(fieldLabel)
//                .toolbar {
//                    ToolbarItem(placement: .confirmationAction) {
//                        Button("OK") {
//                            onSave(value)
//                            dismiss()
//                        }
//                    }
//                    ToolbarItem(placement: .cancellationAction) {
//                        Button("Отмена") {
//                            dismiss()
//                        }
//                    }
//                }
//                .scrollContentBackground(.hidden) // скрыть фон формы, чтобы был твой цвет
//            }
//            .background(Color.clear)
//        }
//    }
//
//    private var fieldLabel: String {
//        switch field {
//        case .forearm: return "Предплечье"
//        case .biceps: return "Бицепс"
//        case .neck: return "Шея"
//        case .chest: return "Грудь"
//        case .shoulders: return "Плечи"
//        case .waist: return "Талия"
//        case .hips: return "Бёдра"
//        case .thigh: return "Бедро"
//        case .buttocks: return "Ягодицы"
//        case .calf: return "Икра"
//        case .stomach: return "Живот"
//        case .weight: return "Вес"
//        case .height: return "Рост"
//        case .fatPercent: return "% Жира"
//        }
//    }
//}
