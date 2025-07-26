//
//  AllTrendsSheetFeature.swift
//  MyBodyMap
//
//  Created by Иван on 25.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct AllTrendsSheetFeature {
    @ObservableState
    public struct State: Equatable {
        public var trends: [TrendItem]
        public var dragAndDrop: DragAndDropFeature.State {
            get { .init(items: self.trends) }
            set { self.trends = newValue.items }
        }
        @Presents public var allTrendsSheet: AllTrendsSheetFeature.State?

        public init(trends: [TrendItem]) {
            self.trends = trends
        }
    }

    @CasePathable
    public enum Action {
        case dragAndDrop(DragAndDropFeature.Action)
        case selectField(String)
        case delegate(Delegate)
        
        public enum Delegate {
            case openModalFor(String)
        }
    }

    public var body: some ReducerOf<Self> {
        Scope(state: \.dragAndDrop, action: \.dragAndDrop) { DragAndDropFeature() }
        
        Reduce { state, action in
            switch action {
            case let .selectField(field):
                return .send(.delegate(.openModalFor(field)))
            default:
                return .none
            }
        }
    }
}
