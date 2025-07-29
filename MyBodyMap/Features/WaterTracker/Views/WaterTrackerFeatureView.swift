//
//  WaterTrackerFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

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
