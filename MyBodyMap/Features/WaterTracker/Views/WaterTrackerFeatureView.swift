//
//  WaterTrackerFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

//сохранение заполнения в реалм, каждый день заполнение шкалы начинается сначала
//В реалм надо хранить так дата (только день без времени), обновляемая ячейка выпитого (здесь при пополнении шкалы изменяем значение,  не создаем новую строку), цель по питью в день, массив выпитых напитков за день (Drink)( каждое пополнение шкалы запись в массив)

//на кардвью со шкалой сверху справа добавить кнопку календарь
// - календарь открывает через навигацию вью где кастомный календарь на котором на днях вокруг числа кольцо в стиле apple fitnes заполняется в зависимости от выпитого за день, также как шкала на вотерфичавью, круг до цели заполняется циан, сверх цели заполняется зеленым
// - - по нажатию на число открывается модалка на ней шкала выпитого за тот день, а под ней лист с напитками за день

import SwiftUI
import ComposableArchitecture

public struct WaterTrackerView: View {
    @Bindable var store: StoreOf<WaterTrackerFeature>
    @State private var amountInput: String = ""
    @State private var isPulsing = true
    @State private var showQuickDrinkSheet = false
    @State private var selectedQuickDrink: Drink? = nil
    
    public init(store: StoreOf<WaterTrackerFeature>) { self.store = store }
    
    public var body: some View {
        NavigationStack {
            ZStack {
                Color("BGColor").ignoresSafeArea()
                VStack(spacing: 16) {
                    // Верхний CardView с прогрессом
                    CardView {
                        VStack {
                            HStack{
                                Text("Сегодня выпито")
                                    .font(.title2.bold())
                                    .foregroundStyle(Color("FontColor"))
                                Spacer()
                                Button {
                                    store.send(.openSettings)
                                } label: {
                                    Image(systemName: "slider.horizontal.3")
                                        .font(.title2)
                                        .foregroundStyle(Color("FontColor"))
                                }
                            }
                            WaterProgressBar(intake: store.dailyIntake,
                                             goal: store.goal,
                                             isPulsing: isPulsing)
                        }
                        .padding(.vertical, 12)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    
                    // Быстрые напитки
                    CardView {
                        VStack(spacing: 8) {
                            HStack{
                                Text("Быстрые напитки")
                                    .font(.title2.bold())
                                    .foregroundStyle(Color("FontColor"))
                                Spacer()
                            }
                            HStack {
                                ForEach(store.quickDrinks, id: \.id) { drink in
                                    Button(drink.name) {
                                        amountInput = String(Int(drink.amount))
                                        store.send(.selectQuickDrink(drink))
                                    }
                                    .buttonStyle(CustomButtonStyle())
                                }
                            }
                            
                            Button("Другие") {
                                store.send(.showAllDrinksTapped)
                            }
                            .buttonStyle(CustomButtonStyle())
                        }
                        .padding(.vertical, 12)
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                }
                .padding(.top)
            }
            .navigationDestination(
                item: $store.scope(state: \.allDrinks, action: \.allDrinks)
            ) { allDrinksStore in
                AllDrinksView(store: allDrinksStore)
            }
            .sheet(
                item: $store.scope(state: \.quickDrinkAmount, action: \.quickDrinkAmount)
            ) { quickDrinkStore in
                QuickDrinkAmountSheet(store: quickDrinkStore)
            }
            .sheet(item: $store.scope(state: \.settingsSheet, action: \.settingsSheet)) { sheetStore in
                WaterSettingsSheet(store: sheetStore)
            }
            .navigationTitle("Трекер воды")
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    isPulsing = true
                }
            }
            .onAppear { store.send(.onAppear) }
        }
    }
}
