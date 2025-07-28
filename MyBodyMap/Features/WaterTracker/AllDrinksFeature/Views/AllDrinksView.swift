//
//  AllDrinksView.swift
//  MyBodyMap
//
//  Created by Иван on 27.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct AllDrinksView: View {
    @Bindable var store: StoreOf<AllDrinksFeature>
    public var body: some View {
        Color("BGColor")
            .ignoresSafeArea()
            .overlay(
                VStack(spacing: 16) {
                    CardView{
                        ElementBackgroundView {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(Color("FontColor"))
                                TextField("Поиск по напиткам", text: $store.searchText)
                                    .foregroundStyle(Color("FontColor"))
                                    .font(.system(size: 18, weight: .medium))
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    CardView {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Все напитки")
                                    .font(.title2.bold())
                                    .foregroundStyle(Color("FontColor"))
                                Spacer()
                                Button(action: { store.send(.addNewTapped) }) {
                                    Image(systemName: "plus")
                                        .font(.title2.bold())
                                        .foregroundStyle(Color("FontColor"))
                                }
                                Button(action: { store.send(.scanTapped) }) {
                                    Image(systemName: "barcode.viewfinder")
                                        .font(.title2.bold())
                                        .foregroundStyle(Color("FontColor"))
                                }
                            }
                            ScrollView {
                                VStack(spacing: 12) {
                                    ForEach(store.drinks.filter { store.searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(store.searchText) }, id: \.id) { drink in
                                        ElementBackgroundView {
                                            HStack {
                                                Text(drink.name)
                                                    .font(.title3.weight(.medium))
                                                    .foregroundStyle(Color("FontColor"))
                                                    .lineLimit(1)
                                                Spacer()
                                                if let brand = drink.brand, !brand.isEmpty {
                                                    Text(brand)
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                }
                                            }
                                            .frame(height: 48)
                                            .padding(.horizontal, 12)
                                        }
                                        .onTapGesture { store.send(.selectDrink(drink)) }
                                    }
                                }
                                .padding(.top, 8)
                                .padding(.bottom, 12)
                            }
                            .scrollIndicators(.hidden)
                        }
                        .padding(.top, 8)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    Spacer()
                }
            )
            .navigationTitle("Напитки")
            .onAppear { store.send(.onAppear) }
            .sheet(
                item: $store.scope(state: \.addDrink, action: \.addDrink)
            ) { addDrinkStore in
                AddDrinkView(store: addDrinkStore)
            }
    }
}

//import SwiftUI
//import ComposableArchitecture
//
//public struct AllDrinksView: View {
//    @Bindable var store: StoreOf<AllDrinksFeature>
//    
//    public var body: some View {
//        Color("BGColor")
//            .ignoresSafeArea()
//            .overlay(
//                VStack(spacing: 16) {
//                    CardView{
//                        ElementBackgroundView {
//                            HStack {
//                                Image(systemName: "magnifyingglass")
//                                    .foregroundStyle(Color("FontColor"))
//                                TextField("Поиск по напиткам", text: $store.searchText)
//                                    .foregroundStyle(Color("FontColor"))
//                                    .font(.system(size: 18, weight: .medium))
//                                    .autocapitalization(.none)
//                                    .disableAutocorrection(true)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 16)
//                    
//                    CardView {
//                        VStack(alignment: .leading, spacing: 12) {
//                            HStack {
//                                Text("Все напитки")
//                                    .font(.title2.bold())
//                                    .foregroundStyle(Color("FontColor"))
//                                Spacer()
//                                Button(action: { store.send(.addNewTapped) }) {
//                                    Image(systemName: "plus")
//                                        .font(.title2.bold())
//                                        .foregroundStyle(Color("FontColor"))
//                                }
//                                Button(action: { store.send(.scanTapped) }) {
//                                    Image(systemName: "barcode.viewfinder")
//                                        .font(.title2.bold())
//                                        .foregroundStyle(Color("FontColor"))
//                                }
//                            }
//                            ScrollView {
//                                VStack(spacing: 12) {
//                                    ForEach(store.drinks.filter { store.searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(store.searchText) }, id: \.id) { drink in
//                                        ElementBackgroundView {
//                                            HStack {
//                                                Text(drink.name)
//                                                    .font(.title3.weight(.medium))
//                                                    .foregroundStyle(Color("FontColor"))
//                                                    .lineLimit(1)
//                                                Spacer()
//                                                if let brand = drink.brand, !brand.isEmpty {
//                                                    Text(brand)
//                                                        .font(.subheadline)
//                                                        .foregroundStyle(.secondary)
//                                                }
//                                            }
//                                            .frame(height: 48)
//                                            .padding(.horizontal, 12)
//                                        }
//                                        .onTapGesture { store.send(.selectDrink(drink)) }
//                                    }
//                                }
//                                .padding(.top, 8)
//                                .padding(.bottom, 12)
//                            }
//                            .scrollIndicators(.hidden)
//                        }
//                        .padding(.top, 8)
//                    }
//                    .padding(.horizontal, 16)
//                    .padding(.top, 12)
//                    
//                    Spacer()
//                }
//            )
//            .navigationTitle("Напитки")
//            .sheet(
//                item: $store.scope(state: \.addDrink, action: \.addDrink)
//            ) { addDrinkStore in
//                AddDrinkView(store: addDrinkStore)
//            }
//    }
//}

//import SwiftUI
//import ComposableArchitecture
//
//public struct AllDrinksView: View {
//    @Bindable var store: StoreOf<AllDrinksFeature>
//    
//    public var body: some View {
//        Color("BGColor")
//            .ignoresSafeArea()
//            .overlay(
//                VStack(spacing: 16) {
//                    CardView{
//                        ElementBackgroundView {
//                            HStack {
//                                Image(systemName: "magnifyingglass")
//                                    .foregroundStyle(Color("FontColor"))
//                                TextField("Поиск по напиткам", text: $store.searchText)
//                                    .foregroundStyle(Color("FontColor"))
//                                    .font(.system(size: 18, weight: .medium))
//                                    .autocapitalization(.none)
//                                    .disableAutocorrection(true)
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 16)
//                    
//                    CardView {
//                        VStack(alignment: .leading, spacing: 12) {
//                            HStack {
//                                Text("Все напитки")
//                                    .font(.title2.bold())
//                                    .foregroundStyle(Color("FontColor"))
//                                Spacer()
//                                Button(action: { store.send(.addNewTapped) }) {
//                                    Image(systemName: "plus")
//                                        .font(.title2.bold())
//                                        .foregroundStyle(Color("FontColor"))
//                                }
//                                Button(action: { store.send(.scanTapped) }) {
//                                    Image(systemName: "barcode.viewfinder")
//                                        .font(.title2.bold())
//                                        .foregroundStyle(Color("FontColor"))
//                                }
//                            }
//                            ScrollView {
//                                VStack(spacing: 12) {
//                                    ForEach(store.drinks.filter { store.searchText.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(store.searchText) }, id: \.id) { drink in
//                                        ElementBackgroundView {
//                                            HStack {
//                                                Text(drink.name)
//                                                    .font(.title3.weight(.medium))
//                                                    .foregroundStyle(Color("FontColor"))
//                                                    .lineLimit(1)
//                                                Spacer()
//                                                if let brand = drink.brand, !brand.isEmpty {
//                                                    Text(brand)
//                                                        .font(.subheadline)
//                                                        .foregroundStyle(.secondary)
//                                                }
//                                            }
//                                            .frame(height: 48)
//                                            .padding(.horizontal, 12)
//                                        }
//                                        .onTapGesture { store.send(.selectDrink(drink)) }
//                                    }
//                                }
//                                .padding(.top, 8)
//                                .padding(.bottom, 12)
//                            }
//                            .scrollIndicators(.hidden)
//                        }
//                        .padding(.top, 8)
//                    }
//                    .padding(.horizontal, 16)
//                    .padding(.top, 12)
//                    
//                    Spacer()
//                }
//            )
//            .navigationTitle("Напитки")
//    }
//}
