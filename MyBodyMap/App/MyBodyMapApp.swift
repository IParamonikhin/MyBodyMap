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
            schemaVersion: 4,
            migrationBlock: { migration, oldSchemaVersion in
                // migration logic if needed
            }
        )
        Realm.Configuration.defaultConfiguration = config
        let navAppearance = UINavigationBarAppearance()
        let tabAppearance = UITabBarAppearance()
        let fontColor = UIColor(named: "FontColor") ?? .label
        let tabItemColor = UIColor(named: "ContrastColor") ?? .label
        let tabItemSelectedColor = UIColor(named: "FontColor") ?? .label
        let bgColor = UIColor(named: "BGColor") ?? .systemBackground

        // Заголовок
        navAppearance.titleTextAttributes = [.foregroundColor: fontColor]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: fontColor]
        navAppearance.backgroundColor = bgColor
        navAppearance.shadowColor = .clear
        navAppearance.shadowImage = UIImage()

        // Кнопки навбара (тулбар, барбаттоны)
        let buttonAppearance = UIBarButtonItemAppearance()
        buttonAppearance.normal.titleTextAttributes = [.foregroundColor: fontColor]
        buttonAppearance.highlighted.titleTextAttributes = [.foregroundColor: fontColor]
        buttonAppearance.disabled.titleTextAttributes = [.foregroundColor: fontColor]
        navAppearance.buttonAppearance = buttonAppearance
        navAppearance.doneButtonAppearance = buttonAppearance
        navAppearance.backButtonAppearance = buttonAppearance

        // Применяем все состояния
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().tintColor = fontColor // Цвет иконок back/close и любых SF Symbols

        // TabBar
        tabAppearance.backgroundColor = bgColor
        tabAppearance.shadowColor = .clear
        tabAppearance.shadowImage = UIImage()
        tabAppearance.stackedLayoutAppearance.normal.iconColor = tabItemColor
        tabAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: tabItemColor]
        tabAppearance.stackedLayoutAppearance.selected.iconColor = tabItemSelectedColor
        tabAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: tabItemSelectedColor]
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        UITabBar.appearance().tintColor = fontColor
        UIBarButtonItem.appearance().tintColor = fontColor
        UITextField.appearance().tintColor = fontColor
        UISearchBar.appearance().tintColor = fontColor
    }
    var body: some Scene {
        WindowGroup {
            MyBodyMapRootView()
        }
    }
}

struct MyBodyMapRootView: View {
    @State private var selectedTab = 0
    @State private var requestedHealthKit = false
    
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
        .onAppear {
            // Запускаем только один раз
            if !requestedHealthKit {
                requestedHealthKit = true
                DispatchQueue.main.async {
                    HealthKitServices.shared.requestAuthorization { success in
                        if success {
                            MeasuresRealmService().importLatestFromHealthKit()
                        }
                    }
                }
            }
        }
    }
}
