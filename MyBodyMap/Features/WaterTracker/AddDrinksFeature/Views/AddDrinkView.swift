//
//  AddDrinkView.swift
//  MyBodyMap
//
//  Created by Иван on 28.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct DrinkType: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let tag: String
    let hydration: Double
}

let drinkTypes: [DrinkType] = [
    .init(name: "Вода", tag: "water", hydration: 1.0),
    .init(name: "Минеральная вода", tag: "mineral_water", hydration: 1.0),
    .init(name: "Молоко", tag: "milk", hydration: 1.2),
    .init(name: "Соевое молоко", tag: "soy_milk", hydration: 0.95),
    .init(name: "Кефир", tag: "kefir", hydration: 0.9),
    .init(name: "Чёрный кофе", tag: "coffee", hydration: 0.8),
    .init(name: "Кофе с молоком", tag: "coffee_milk", hydration: 0.85),
    .init(name: "Безкофеиновый кофе", tag: "decaf_coffee", hydration: 0.9),
    .init(name: "Чай", tag: "tea", hydration: 0.8),
    .init(name: "Травяной чай", tag: "herbal_tea", hydration: 0.9),
    .init(name: "Чай с молоком", tag: "milk_tea", hydration: 0.85),
    .init(name: "Сок", tag: "juice", hydration: 0.9),
    .init(name: "Фреш", tag: "fresh_juice", hydration: 0.85),
    .init(name: "Смузи", tag: "smoothie", hydration: 0.75),
    .init(name: "Лимонад", tag: "lemonade", hydration: 0.9),
    .init(name: "Кола", tag: "cola", hydration: 0.9),
    .init(name: "Тоник", tag: "tonic", hydration: 0.85),
    .init(name: "Квас", tag: "kvass", hydration: 0.85),
    .init(name: "Энергетик", tag: "energy", hydration: 0.8),
    .init(name: "Изотоник", tag: "isotonic", hydration: 1.1),
    .init(name: "Бульон", tag: "broth", hydration: 1.1),
    .init(name: "Пиво", tag: "beer", hydration: 0.7),
    .init(name: "Вино", tag: "wine", hydration: 0.6),
    .init(name: "Шампанское", tag: "champagne", hydration: 0.7),
    .init(name: "Сидр", tag: "cider", hydration: 0.7),
    .init(name: "Крепкий алкоголь", tag: "strong_alcohol", hydration: 0.4),
    .init(name: "Коктейль", tag: "cocktail", hydration: 0.6),
    .init(name: "Ликер", tag: "liqueur", hydration: 0.6),
    .init(name: "Какао", tag: "cacao", hydration: 0.85),
    .init(name: "Горячий шоколад", tag: "hot_chocolate", hydration: 0.8),
    .init(name: "Протеиновый напиток", tag: "protein", hydration: 0.85),
    .init(name: "Бабл-ти", tag: "bubble_tea", hydration: 0.8),
    .init(name: "Матча-латте", tag: "matcha_latte", hydration: 0.85),
    .init(name: "Комбуча", tag: "kombucha", hydration: 0.85),
    .init(name: "Алоэ-вера напиток", tag: "aloe", hydration: 0.9),
    .init(name: "Другое", tag: "custom", hydration: 1.0)
]

public struct AddDrinkView: View {
    @Bindable var store: StoreOf<AddDrinkFeature>
    @Environment(\.dismiss) var dismiss

    func drinkType(for tag: String) -> DrinkType {
        drinkTypes.first { $0.tag == tag } ?? drinkTypes.last!
    }

    public var body: some View {
        Color("BGColor")
            .ignoresSafeArea()
            .overlay(
                ScrollView {
                    CardView {
                        VStack(spacing: 18) {
                            HStack {
                                Text("Добавить напиток")
                                    .font(.title2.bold())
                                    .foregroundStyle(Color("FontColor"))
                                Spacer()
                            }
                            ElementBackgroundView {
                                TextField("Название", text: $store.name)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(Color("FontColor"))
                                    .padding(.horizontal, 4)
                            }
                            ElementBackgroundView {
                                TextField("Бренд", text: $store.brand)
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(Color("FontColor"))
                                    .padding(.horizontal, 4)
                            }
                            ElementBackgroundView {
                                HStack {
                                    TextField("Штрихкод", text: $store.barcode)
                                        .keyboardType(.numberPad)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(Color("FontColor"))
                                    Button {
                                        store.send(.scanTapped)
                                    } label: {
                                        Image(systemName: "barcode.viewfinder")
                                            .font(.title2)
                                            .foregroundStyle(Color("FontColor"))
                                    }
                                }
                            }
                            ElementBackgroundView {
                                Menu {
                                    ForEach(drinkTypes, id: \.tag) { type in
                                        Button(type.name) {
                                            store.type = type.tag
                                            store.hydration = type.hydration
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(drinkType(for: store.type).name)
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundStyle(Color("FontColor"))
                                        Spacer()
                                        Image(systemName: "chevron.down")
                                            .font(.subheadline)
                                            .foregroundStyle(Color("FontColor"))
                                    }
                                    .padding(.horizontal, 6)
                                }
                            }
                            HStack(spacing: 12) {
                                Button("Отмена") { store.send(.cancelTapped) }
                                    .buttonStyle(CustomButtonStyle())
                                Button("Сохранить") {
                                    store.send(.saveTapped)
                                }
                                .buttonStyle(CustomButtonStyle())
                                .disabled(store.name.isEmpty)
                            }
                            .padding(.top, 12)
                        }
                        .padding(.vertical, 16)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                }
            )
            .navigationTitle("Добавить напиток")
            .sheet(isPresented: $store.isScanning) {
                BarcodeScannerScreen { code in
                    if let code = code {
                        store.send(.barcodeScanned(code))
                    }
                }
            }
    }
}
