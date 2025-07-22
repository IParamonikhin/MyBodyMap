//
//  ProfileFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct ProfileView: View {
    @Bindable var store: StoreOf<ProfileFeature>

    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }

    public var body: some View {
        Form {
            Section(header: Text("Личные данные")) {
                TextField("Имя", text: $store.name)
                Picker("Пол", selection: $store.gender) {
                    ForEach(ProfileFeature.Gender.allCases, id: \.self) { g in
                        Text(label(for: g)).tag(g)
                    }
                }
                DatePicker("Дата рождения", selection: $store.birthdate, displayedComponents: .date)
                HStack {
                    Text("Возраст")
                    Spacer()
                    Text("\(store.age)")
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.gray)
            }
            Button("Сохранить") { store.send(.save) }
        }
        .navigationTitle("Профиль")
        .onAppear { store.send(.load) }
    }

    private func label(for gender: ProfileFeature.Gender) -> String {
        switch gender {
        case .male: return "Мужской"
        case .female: return "Женский"
        case .other: return "Другое"
        }
    }
}
