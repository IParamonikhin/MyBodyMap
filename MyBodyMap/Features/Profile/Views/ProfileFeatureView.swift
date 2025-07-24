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

