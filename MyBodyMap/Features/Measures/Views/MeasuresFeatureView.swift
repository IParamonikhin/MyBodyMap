//
//  MeasuresFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct MeasuresView: View {
    @Bindable var store: StoreOf<MeasuresFeature>
    public init(store: StoreOf<MeasuresFeature>) { self.store = store }

    public var body: some View {
        NavigationStack {
            ZStack{
                Color("BGColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    Text("Добавь свои измерения")
                        .padding(10)
                    
                    BodySilhouetteView(
                        selectedField: store.selectedField,
                        onSelect: { field in
                            store.send(.selectField(field))
                        },
                        gender: store.gender
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 10)
                }
                .sheet(isPresented: $store.showInputModal) {
                    if let field = store.selectedField {
                        MeasureInputModal(
                            field: field,
                            value: getValue(for: field, from: store.state)
                        ) { val in
                            if val > 0 {
                                store.send(.updateField(field, val))
                            }
                        }
                    }
                }
                .onAppear { store.send(.load) }
            }
        }
    }

    private func label(for field: MeasuresFeature.MeasuresField) -> String {
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
    private func getValue(for field: MeasuresFeature.MeasuresField, from state: MeasuresFeature.State) -> Double {
        switch field {
        case .forearm: return state.forearm ?? 0
        case .biceps: return state.biceps ?? 0
        case .neck: return state.neck ?? 0
        case .chest: return state.chest ?? 0
        case .shoulders: return state.shoulders ?? 0
        case .waist: return state.waist ?? 0
        case .hips: return state.hips ?? 0
        case .thigh: return state.thigh ?? 0
        case .buttocks: return state.buttocks ?? 0
        case .calf: return state.calf ?? 0
        case .stomach: return state.stomach ?? 0
        case .weight: return state.weight ?? 0
        case .height: return state.height ?? 0
        case .fatPercent: return state.fatPercent ?? 0
        }
    }
}


//import SwiftUI
//import ComposableArchitecture
//
//public struct MeasuresView: View {
//    @Bindable var store: StoreOf<MeasuresFeature>
//    @State private var selectedField: MeasuresFeature.MeasuresField?
//    @State private var showInputModal = false
//
//    public init(store: StoreOf<MeasuresFeature>) { self.store = store }
//
//    public var body: some View {
//        NavigationView {
//            VStack(spacing: 0) {
//                BodySilhouetteView(
//                    selectedField: selectedField,
//                    onSelect: { field in
//                        selectedField = field
//                        showInputModal = true
//                    }
//                )
//                .frame(height: 330)
//                .padding(.top, 12)
//                
//                // Показать BMI и кнопку "Сохранить" если нужно:
//                if let bmi = store.bmi {
//                    HStack {
//                        Text("ИМТ")
//                        Spacer()
//                        Text("\(bmi, specifier: "%.1f")")
//                            .foregroundColor(.secondary)
//                    }
//                    .padding()
//                }
//                Spacer()
//            }
//            .navigationTitle("Измерения")
//            .onAppear { store.send(.load) }
//            .sheet(isPresented: $showInputModal) {
//                if let field = selectedField {
//                    MeasureInputModal(
//                        field: field,
//                        value: getValue(for: field, from: store.state),
//                        onSave: { newValue in
//                            store.send(.updateField(field, newValue))
//                            showInputModal = false
//                        },
//                        onCancel: { showInputModal = false }
//                    )
//                    .presentationDetents([.medium, .fraction(0.42)])
//                }
//            }
//        }
//    }
//
//    private func getValue(for field: MeasuresFeature.MeasuresField, from state: MeasuresFeature.State) -> Double {
//        switch field {
//        case .forearm: return state.forearm ?? 0
//        case .biceps: return state.biceps ?? 0
//        case .neck: return state.neck ?? 0
//        case .chest: return state.chest ?? 0
//        case .shoulders: return state.shoulders ?? 0
//        case .waist: return state.waist ?? 0
//        case .hips: return state.hips ?? 0
//        case .thigh: return state.thigh ?? 0
//        case .buttocks: return state.buttocks ?? 0
//        case .calf: return state.calf ?? 0
//        case .stomach: return state.stomach ?? 0
//        case .weight: return state.weight ?? 0
//        case .height: return state.height ?? 0
//        case .fatPercent: return state.fatPercent ?? 0
//        }
//    }
//}


//import SwiftUI
//import ComposableArchitecture
//
//public struct MeasuresView: View {
//    @Bindable var store: StoreOf<MeasuresFeature>
//    public init(store: StoreOf<MeasuresFeature>) { self.store = store }
//
//    public var body: some View {
//        NavigationView {
//            Form {
//                Section(header: Text("Основные")) {
//                    ForEach(MeasuresFeature.MeasuresField.allCases, id: \.self) { field in
//                        HStack {
//                            Text(label(for: field))
//                            Spacer()
//                            TextField(
//                                "0",
//                                value: Binding(
//                                    get: { getValue(for: field, from: store.state) },
//                                    set: { newValue in
//                                        store.send(.updateField(field, newValue ?? 0))
//                                    }
//                                ),
//                                format: .number
//                            )
//                            .keyboardType(.decimalPad)
//                            .multilineTextAlignment(.trailing)
//                        }
//                    }
//                    if let bmi = store.bmi {
//                        HStack {
//                            Text("ИМТ")
//                            Spacer()
//                            Text("\(bmi, specifier: "%.1f")")
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                }
//                Button("Сохранить") { store.send(.save) }
//            }
//            .navigationTitle("Измерения")
//            .onAppear { store.send(.load) }
//        }
//    }
//
//    private func label(for field: MeasuresFeature.MeasuresField) -> String {
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
//
//    private func getValue(for field: MeasuresFeature.MeasuresField, from state: MeasuresFeature.State) -> Double? {
//        switch field {
//        case .forearm: return state.forearm
//        case .biceps: return state.biceps
//        case .neck: return state.neck
//        case .chest: return state.chest
//        case .shoulders: return state.shoulders
//        case .waist: return state.waist
//        case .hips: return state.hips
//        case .thigh: return state.thigh
//        case .buttocks: return state.buttocks
//        case .calf: return state.calf
//        case .stomach: return state.stomach
//        case .weight: return state.weight
//        case .height: return state.height
//        case .fatPercent: return state.fatPercent
//        }
//    }
//}
