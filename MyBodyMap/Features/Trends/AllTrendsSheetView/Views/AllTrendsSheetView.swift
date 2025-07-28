//
//  AllTrendsSheetView.swift
//  MyBodyMap
//
//  Created by Иван on 24.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct AllTrendsSheetView: View {
    @Bindable var store: StoreOf<AllTrendsSheetFeature>
    let selectedField: String
    @Environment(\.dismiss) var dismiss
    
    public init(store: StoreOf<AllTrendsSheetFeature>,
                selectedField: String) {
        self.store = store
        self.selectedField = selectedField
    }
    
    public var body: some View {
        ZStack {
            Color("BGColor").ignoresSafeArea()
            CardView{
                ScrollView{
                    DragAndDropGridView(
                        store: store.scope(state: \.dragAndDrop, action: \.dragAndDrop),
                        columns: Array(repeating: GridItem(.flexible()), count: 3)
                    ) { item, isDragging in
                        TrendGridIconView(trend: item, goal: store.goal, isSelected: false)
                            .opacity(isDragging ? 0.5 : 1)
                            .scaleEffect(isDragging ? 1.1 : 1)
                            .onTapGesture {
                                store.send(.selectField(item.field))
                            }
                    }
                    .padding()
                    
                }
            }
            .padding(.all, 16)
        }
    }
}
