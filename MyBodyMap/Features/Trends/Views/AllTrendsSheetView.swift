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

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(store.allTrends) { trend in
                        TrendGridIconView(trend: trend)
                            .matchedGeometryEffect(id: trend.id, in: trendNamespace)
                            .onDrag {
                                NSItemProvider(object: NSString(string: trend.field))
                            }
                            .dropDestination(for: String.self) { items, _ in
                                guard let fromField = items.first,
                                      let fromIdx = store.allTrends.firstIndex(where: { $0.field == fromField }),
                                      let toIdx = store.allTrends.firstIndex(where: { $0.id == trend.id }),
                                      fromIdx != toIdx else { return false }
                                store.send(.mainTrendsReordered(IndexSet(integer: fromIdx), toIdx))
                                return true
                            }
                            .onTapGesture {
                                store.send(.selectField(trend.field))
                            }
                    }
                }
                .padding(16)
            }
            .background(Color("backgroundColor"))
            .navigationTitle("Все тренды")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") { store.send(.showAllTrends(false)) }
                }
            }
        }
    }
}


//import SwiftUI
//import ComposableArchitecture
//
//struct AllTrendsSheetView: View {
//    @Bindable var store: StoreOf<TrendsFeature>
//    @State private var dragItem: TrendItem?
//    @Namespace private var trendNamespace
//
//    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 16) {
//                    ForEach(store.allTrends) { trend in
//                        TrendGridIconView(trend: trend)
//                            .matchedGeometryEffect(id: trend.id, in: trendNamespace)
//                            .onDrag {
//                                dragItem = trend
//                                return NSItemProvider(object: NSString(string: trend.field))
//                            }
//                    }
//                }
//                // Важно: onDrop на всю сетку
//                .onDrop(of: [.text], isTargeted: nil) { providers, location in
//                    guard let provider = providers.first else { return false }
//                    _ = provider.loadObject(ofClass: NSString.self) { reading, _ in
//                        guard let field = reading as? String,
//                              let fromIdx = store.allTrends.firstIndex(where: { $0.field == field }),
//                              let dragItem = store.allTrends[safe: fromIdx]
//                        else { return }
//                        // Находим ближайший тренд к location
//                        let points: [(Int, CGFloat)] = store.allTrends.enumerated().compactMap { idx, item in
//                            // переводим frame в координаты
//                            // Здесь упрощённая версия — просто по порядку
//                            return (idx, CGFloat(idx))
//                        }
//                        let closestIdx = Int(location.x / 120) + Int(location.y / 140) * 3
//                        if fromIdx != closestIdx && closestIdx < store.allTrends.count {
//                            DispatchQueue.main.async {
//                                store.send(.mainTrendsReordered(IndexSet(integer: fromIdx), closestIdx))
//                            }
//                        }
//                    }
//                    return true
//                }
//                .padding(16)
//            }
//            .background(Color("backgroundColor"))
//            .navigationTitle("Все тренды")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Закрыть") { store.send(.showAllTrends(false)) }
//                }
//            }
//        }
//    }
//}


//struct AllTrendsSheetView: View {
//    @Bindable var store: StoreOf<TrendsFeature>
//    @Namespace private var trendNamespace
//    @Environment(\.editMode) private var editMode
//    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 3)
//    @State private var isEditing: Bool = false
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                LazyVGrid(columns: columns, spacing: 16) {
//                    ForEach(store.allTrends) { trend in
//                        TrendGridDraggableIconView(
//                            trend: trend,
//                            isEditing: isEditing,
//                            trendNamespace: trendNamespace,
//                            store: store,
//                            onTap: {
//                                if !isEditing {
//                                    store.send(.selectField(trend.field))
//                                }
//                            },
//                            onLongPress: {
//                                withAnimation {
//                                    isEditing = true
//                                }
//                                DispatchQueue.main.async {
//                                    editMode?.wrappedValue = .active
//                                }
//                                store.send(.startDragging(trend.field))
//                            }
//                        )
//                        .onDrop(of: [.text], delegate: TrendsDropDelegate(item: trend, store: store))
//                        // Важно: именно onDrop для каждой ячейки
//                    }
//                }
//                .padding(16)
//            }
//            .background(Color("BGColor"))
//            .navigationTitle("Все тренды")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    if isEditing {
//                        Button("Готово") {
//                            withAnimation { isEditing = false }
//                            editMode?.wrappedValue = .inactive
//                            store.send(.endDragging)
//                        }
//                    } else {
//                        EditButton()
//                            .onTapGesture {
//                                withAnimation { isEditing = true }
//                            }
//                    }
//                }
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Закрыть") { store.send(.showAllTrends(false)) }
//                }
//            }
//        }
//        .foregroundStyle(Color("FontColor"))
//    }
//}


//struct AllTrendsSheetView: View {
//    @Bindable var store: StoreOf<TrendsFeature>
//    @Namespace private var trendNamespace
//    @Environment(\.editMode) private var editMode
//    private let columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 16), count: 3)
//    @State private var isEditing: Bool = false
//
//    var body: some View {
//        NavigationStack {
//            ScrollView {
//                CardView {
//                    LazyVGrid(columns: columns, spacing: 16) {
//                        ForEach(store.allTrends) { trend in
//                            TrendGridDraggableIconView(
//                                trend: trend,
//                                isEditing: isEditing,
//                                trendNamespace: trendNamespace,
//                                onTap: {
//                                    if !isEditing { store.send(.selectField(trend.field)) }
//                                },
//                                onLongPress: {
//                                    withAnimation { isEditing = true }
//                                    DispatchQueue.main.async { editMode?.wrappedValue = .active }
//                                }
//                            )
//                            // Важно: фон самой ячейки убираем, т.к. фон задаёт CardView!
//                        }
//                        .onMove { indices, newOffset in
//                            store.send(.mainTrendsReordered(indices, newOffset))
//                        }
//                    }
//                    .padding(16)
//                }
//                .padding(.horizontal, 16)
//            }
//            .background(Color("BGColor"))
//            .navigationTitle("Все тренды")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    if isEditing {
//                        Button("Готово") {
//                            withAnimation { isEditing = false }
//                            editMode?.wrappedValue = .inactive
//                        }
//                    } else {
//                        EditButton()
//                            .onTapGesture {
//                                withAnimation { isEditing = true }
//                            }
//                    }
//                }
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Закрыть") { store.send(.showAllTrends(false)) }
//                }
//            }
//        }
//        .foregroundStyle(Color("FontColor"))
//    }
//}
