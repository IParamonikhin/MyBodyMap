//
//  BarcodeScannerFeature.swift
//  MyBodyMap
//
//  Created by Иван on 26.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct BarcodeScannerFeature {
    @ObservableState
    public struct State: Equatable, Identifiable {
        public var id: UUID = UUID()
        public var isPresented: Bool = false
        public var currentScannedCode: String? = nil
    }
    @CasePathable
    public enum Action {
        case scanned(String)
        case cancel
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .scanned(let code):
                state.isPresented = false
                state.currentScannedCode = code
                return .none
            case .cancel:
                state.isPresented = false
                return .none
            }
        }
    }
}
