//
//  ProfileCardView.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct ProfileCardView: View {
    @Bindable var store: StoreOf<ProfileFeature>
    
    var body: some View {
        CardView {
            VStack(spacing: 18) {
                HStack(spacing: 12) {
                    Image(systemName: store.gender == .female ? "person.fill" : "person.fill")
                        .font(.system(size: 44))
                        .foregroundColor(Color("ContrastColor"))
                    ElementBackgroundView{
                        TextField("Имя", text: $store.name)
                            .padding(.horizontal, 12)
                            .foregroundColor(Color("FontColor"))
                            .font(.system(size: 18, weight: .medium))
                        
                    }
                }
                ElementBackgroundView{
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
                
                ElementBackgroundView{
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
                
                ElementBackgroundView{
                    HStack{
                        Text("Выбери цель")
                            .foregroundColor(Color("FontColor"))
                        Picker("Цель", selection: $store.goal) {
                            ForEach(ProfileFeature.Goal.allCases, id: \.self) { g in
                                Text(goalLabel(for: g)).tag(g)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding(.horizontal, 12)
                        .foregroundColor(Color("FontColor"))
                    }
                }
                
                
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
