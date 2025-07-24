//
//  ChartFeature.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct ChartFeature {
    @ObservableState
    public struct State: Equatable {
        public var items: [TrendItem] = []
    }

    public enum Action {
        case setItems([TrendItem])
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .setItems(items):
                state.items = items
                return .none
            }
        }
    }
}

//import ComposableArchitecture
//
//@Reducer
//public struct ChartFeature {
//    @ObservableState
//    public struct State: Equatable {
//        public var data: [ChartDataPoint] = []
//        public var title: String = ""
//        public var color: String = "AccentColor"
//        public var showLegend: Bool = false
//
//        public init(
//            data: [ChartDataPoint] = [],
//            title: String = "",
//            color: String = "AccentColor",
//            showLegend: Bool = false
//        ) {
//            self.data = data
//            self.title = title
//            self.color = color
//            self.showLegend = showLegend
//        }
//    }
//
//    public enum Action: Equatable {
//        // Зарезервировано под будущий интерактив
//    }
//
//    public var body: some ReducerOf<Self> {
//        Reduce { state, action in .none }
//    }
//}
