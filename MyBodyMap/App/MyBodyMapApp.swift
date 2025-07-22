//
//  MyBodyMapApp.swift
//  MyBodyMap
//
//  Created by Иван on 10.07.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct MyBodyMapApp: App {
    var body: some Scene {
        WindowGroup {
            MyBodyMapRootView()
        }
    }
}

struct MyBodyMapRootView: View {
    var body: some View {
        TabView {
            MeasuresView(store: Store(initialState: MeasuresFeature.State()) { MeasuresFeature() })
                .tabItem { Label("Измерения", systemImage: "ruler") }
            PhotoView(store: Store(initialState: PhotoFeature.State()) { PhotoFeature() })
                .tabItem { Label("Фото", systemImage: "photo.on.rectangle") }
            TrendsFeatureView(store: Store(initialState: TrendsFeature.State()) { TrendsFeature() })
                .tabItem { Label("Тренды", systemImage: "chart.line.uptrend.xyaxis") }
            WaterTrackerView(store: Store(initialState: WaterTrackerFeature.State()) { WaterTrackerFeature() })
                .tabItem { Label("Вода", systemImage: "drop.fill") }
            ProfileView(store: Store(initialState: ProfileFeature.State()) { ProfileFeature() })
                .tabItem { Label("Профиль", systemImage: "person.fill") }
        }
    }
}
