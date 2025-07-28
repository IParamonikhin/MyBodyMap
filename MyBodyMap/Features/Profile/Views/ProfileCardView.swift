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
                        .foregroundStyle(Color("ContrastColor"))
                    ElementBackgroundView{
                        TextField("Имя", text: $store.name)
                            .padding(.horizontal, 12)
                            .foregroundStyle(Color("FontColor"))
                            .font(.system(size: 18, weight: .medium))
                        
                    }
                }
                ElementBackgroundView{
                    CustomSegmentedPickerView(selection: $store.gender, items: ProfileFeature.Gender.selectable)
                    .padding(.horizontal, 4)
                }
                
                ElementBackgroundView {
                    GeometryReader { geo in
                        HStack(spacing: 0) {
                            Text("Дата рождения")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color("FontColor"))
                                .frame(width: geo.size.width * 0.5)
                                .multilineTextAlignment(.center)
                            CustomDatePicker(selectedDate: $store.birthdate)
                                .frame(width: geo.size.width * 0.5, alignment: .trailing)
                                .padding(.trailing, 8)
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .frame(height: 48)
                }
                
                ElementBackgroundView {
                    GeometryReader { geo in
                        HStack(spacing: 0) {
                            Text("Выбери цель")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color("FontColor"))
                                .frame(width: geo.size.width * 0.5)
                                .multilineTextAlignment(.center)
                            CustomMenuPicker(
                                title: "Цель",
                                selection: $store.goal,
                                options: ProfileFeature.Goal.allCases
                            )
                            .frame(width: geo.size.width * 0.5, alignment: .trailing)
                            .padding(.trailing, 8)
                        }
                        .frame(width: geo.size.width, height: geo.size.height)
                    }
                    .frame(height: 48)
                }
                
                
                Button("Сохранить") { store.send(.save) }
                .buttonStyle(CustomButtonStyle())
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
