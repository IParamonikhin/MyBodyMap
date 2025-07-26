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
    @Environment(\.dismiss) var dismiss
    
    public init(store: StoreOf<AllTrendsSheetFeature>) { self.store = store }
    
    public var body: some View {
        ZStack {
            Color("BGColor").ignoresSafeArea()
            CardView{
                ScrollView{
                    DragAndDropGridView(
                        store: store.scope(state: \.dragAndDrop, action: \.dragAndDrop),
                        columns: Array(repeating: GridItem(.flexible()), count: 3)
                    ) { item, isDragging in
                        TrendGridIconView(trend: item)
                            .opacity(isDragging ? 0.5 : 1)
                            .scaleEffect(isDragging ? 1.1 : 1)
                            .onTapGesture {
                                store.send(.selectField(item.field))
                            }
                    }
                    .padding()
                    
                }
                Button("Готово") { dismiss() }
                    .padding(.top, 8)
                    .buttonStyle(.borderedProminent)
            }
            .padding(.all, 16)
        }
    }
}

//import SwiftUI
//import ComposableArchitecture
//
//struct AllTrendsSheetView: View {
//    @Bindable var store: StoreOf<TrendsFeature>
//    @State private var selectedField: String?
//    private let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
//   
//    var body: some View {
//        DragAndDropGridView(
//            store: store.scope(
//                state: \.dragState,
//                action: \.dragAndDrop
//            ),
//            columns: columns,
//            itemView: { item, isDragging in
//                TrendGridIconView(trend: item)
//                    .opacity(isDragging ? 0.6 : 1)
//                    .scaleEffect(isDragging ? 1.07 : 1)
//                    .onTapGesture {
//                        selectedField = item.field 
//                    }
//            }
//        )
//        .navigationTitle("Все тренды")
//        .background(Color("BGColor"))
//        .sheet(item: $selectedField) { field in
//            TrendModalFeatureView(
//                store: Store(
//                    initialState: TrendModalFeature.State(field: field),
//                    reducer: { TrendModalFeature() }
//                )
//            )
//        }
//    }
//}
