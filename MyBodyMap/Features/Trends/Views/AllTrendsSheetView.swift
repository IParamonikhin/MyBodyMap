//
//  AllTrendsSheetView.swift
//  MyBodyMap
//
//  Created by Иван on 23.07.2025.
//

import SwiftUI
import ComposableArchitecture

struct AllTrendsSheetView: View {
    @Bindable var store: StoreOf<TrendsFeature>
    @Namespace private var trendNamespace
    @Environment(\.editMode) private var editMode
    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 3)
    @State private var isEditing: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(store.allTrends) { trend in
                        TrendGridDraggableIconView(
                            trend: trend,
                            isEditing: isEditing,
                            trendNamespace: trendNamespace,
                            onTap: {
                                if !isEditing { store.send(.selectField(trend.field)) }
                            },
                            onLongPress: {
                                withAnimation { isEditing = true }
                                DispatchQueue.main.async { editMode?.wrappedValue = .active }
                            }
                        )
                    }
                    .onMove { indices, newOffset in
                        store.send(.mainTrendsReordered(indices, newOffset))
                    }
                }
                .padding(16)
            }
            .background(Color("backgroundColor"))
            .navigationTitle("Все тренды")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isEditing {
                        Button("Готово") {
                            withAnimation { isEditing = false }
                            editMode?.wrappedValue = .inactive
                        }
                    } else {
                        EditButton()
                            .onTapGesture {
                                withAnimation { isEditing = true }
                            }
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { store.send(.showAllTrends(false)) }
                }
            }
        }
    }
}
