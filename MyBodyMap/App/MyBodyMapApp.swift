//
//  MyBodyMapApp.swift
//  MyBodyMap
//
//  Created by Иван on 10.07.2025.
//

import SwiftUI
import ComposableArchitecture
import RealmSwift

@main
struct MyBodyMapApp: SwiftUI.App {
    init() {
        let config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                // migration logic if needed
            }
        )
        Realm.Configuration.defaultConfiguration = config
    }
    var body: some Scene {
        WindowGroup {
            MyBodyMapRootView()
        }
    }
}

struct MyBodyMapRootView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView {
            Tab("Измерения", systemImage: "ruler") {
                MeasuresView(store: Store(initialState: MeasuresFeature.State()) { MeasuresFeature() })
            }
            Tab("Фото", systemImage: "photo.on.rectangle") {
                PhotoView(store: Store(initialState: PhotoFeature.State()) { PhotoFeature() })
            }
            Tab("Тренды", systemImage: "chart.line.uptrend.xyaxis") {
                TrendsFeatureView(store: Store(initialState: TrendsFeature.State()) { TrendsFeature() })
            }
            Tab("Вода", systemImage: "drop.fill") {
                WaterTrackerView(store: Store(initialState: WaterTrackerFeature.State()) { WaterTrackerFeature() })
            }
            Tab("Профиль", systemImage: "person.fill") {
                ProfileView(store: Store(initialState: ProfileFeature.State()) { ProfileFeature() })
            }
        }
    }
}
