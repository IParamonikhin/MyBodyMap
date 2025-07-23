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
        ZStack {
            Color("BGColor").ignoresSafeArea()
            VStack {
                ProfileCardView(store: store)
                    .padding(.top, 32)
            }
        }
        .navigationTitle("Профиль")
        .onAppear { store.send(.load) }
    }
}

struct ProfileCardView: View {
    @Bindable var store: StoreOf<ProfileFeature>

    var body: some View {
        CardView {
            VStack(spacing: 18) {
                HStack(spacing: 12) {
                    Image(systemName: store.gender == .female ? "person.fill" : "person.fill")
                        .font(.system(size: 44))
                        .foregroundColor(Color("ContrastColor"))
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color("TextfieldColor"))
                            .frame(height: 48)
                        TextField("Имя", text: $store.name)
                            .padding(.horizontal, 12)
                            .foregroundColor(Color("FontColor"))
                            .font(.system(size: 18, weight: .medium))
                    }
                    .padding(.horizontal, 4)
                .padding(.horizontal, 4)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color("TextfieldColor"))
                        .frame(height: 48)
                    Picker("Пол", selection: $store.gender) {
                        ForEach(ProfileFeature.Gender.selectable, id: \.self) { g in
                            Text(genderLabel(for: g))
                                .tag(g)
                        }
                    }
                    .tint(Color("FontContrastColor"))
                    .pickerStyle(.segmented)
                    .padding(.horizontal, 12)
                    .foregroundStyle(Color("FontColor"))
                }
                .padding(.horizontal, 4)

                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color("TextfieldColor"))
                        .frame(height: 48)
                    
                    HStack{
                        Text("Дата рождения")
                            .foregroundColor(Color("FontColor"))
                        DatePicker(
                            "Дата рождения",
                            selection: $store.birthdate,
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden() // убирает системный лейбл, если не нужен
                        .padding(.horizontal, 12)
                        .foregroundColor(Color("FontColor")) // цвет текста
                    }
                }
                .padding(.horizontal, 4)

                ZStack {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color("TextfieldColor"))
                        .frame(height: 48)
                    HStack{
                        Text("Выбери цель")
                            .foregroundColor(Color("FontColor"))
                        Picker("Цель", selection: $store.goal) {
                            ForEach(ProfileFeature.Goal.allCases, id: \.self) { g in
                                Text(goalLabel(for: g)).tag(g)
                            }
                        }
                        .pickerStyle(.menu) // компактный выпадающий стиль
                        .padding(.horizontal, 12)
                        .foregroundColor(Color("FontColor")) // цвет текста пикера
                    }
                }
                .padding(.horizontal, 4)
                
                
                Button("Сохранить") { store.send(.save) }
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("ContrastColor"))
                    .foregroundColor(Color("FontColor"))
                    .cornerRadius(14)
                    .padding(.top, 8)
            }
            .padding(.horizontal, 8)
        }
        .padding(.horizontal, 16)
    }

    private func genderLabel(for gender: ProfileFeature.Gender) -> String {
        switch gender {
        case .male: return "Мужской"
        case .female: return "Женский"
        case .other: return "Другое"
        }
    }
    private func goalLabel(for goal: ProfileFeature.Goal) -> String {
        switch goal {
        case .none: return "Без цели"
        case .looseWeight: return "Снижение веса"
        case .gainWeight: return "Набор веса"
        case .gainMuscle: return "Набор мышц"
        }
    }
}

//// Карточка (если ещё не добавил)
//struct CardView<Content: View>: View {
//    let content: () -> Content
//    var body: some View {
//        VStack { content() }
//            .padding()
//            .background(Color("bodyColor"))
//            .cornerRadius(20)
//            .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 2)
//    }
//}
