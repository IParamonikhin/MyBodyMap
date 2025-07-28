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
                    // Верхний CardView с прогрессом
                    CardView {
                        VStack {
                            HStack{
                                Text("Сегодня выпито")
                                    .font(.title2.bold())
                                    .foregroundStyle(Color("FontColor"))
                                Spacer()
                            }
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color("TextfieldColor"))
                                    .frame(height: 48)
                                GeometryReader { geo in
                                    let width = max(12, CGFloat(store.dailyIntake / max(1, store.goal)) * (geo.size.width))
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                                            .fill(Color.cyan)
                                            .blur(radius: isPulsing ? 5 : 3)
                                            .opacity(isPulsing ? 0.7 : 1.0)
                                            .frame(width: min(width, geo.size.width), height: 48)
                                            .animation(.easeInOut(duration: 1.2), value: isPulsing)
                                            .animation(.easeInOut, value: store.dailyIntake)
                                        if store.dailyIntake > store.goal {
                                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                                .fill(Color.green)
                                                .blur(radius: isPulsing ? 5 : 3)
                                                .opacity(isPulsing ? 0.7 : 1.0)
                                                .frame(
                                                    width: min(width - (geo.size.width - 16), geo.size.width),
                                                    height: 48
                                                )
                                                .animation(.easeInOut(duration: 1.2), value: isPulsing)
                                                .animation(.easeInOut, value: store.dailyIntake)
                                        }
                                    }
                                }.frame(height: 48)
                                
                                Text("\(Int(store.dailyIntake)) из \(Int(store.goal)) мл")
                                    .font(.title2)
                                    .bold()
                                    .foregroundStyle(Color("BodyColor"))
                            }
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
                    .presentationDetents([.height(230)]) // <-- Точная высота CardView + paddings
            }
            .navigationTitle("Трекер воды")
        }
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                isPulsing = true
            }
        }
    }
}
