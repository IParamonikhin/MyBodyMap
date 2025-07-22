//
//  PhotoFeature.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct PhotoFeature {
    @ObservableState
    public struct State: Equatable {
        public var photos: [Data] = []
        public var showCamera: Bool = false
        public var lastPhotoOverlay: Data? = nil
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case load
        case add(Data)
        case photosLoaded([Data])
        case showCamera(Bool)
        case cameraPhoto(Data)
    }

    @Dependency(\.photoService) var photoService

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .load:
                let all = photoService.fetchAll()
                state.photos = all
                state.lastPhotoOverlay = all.last
                return .none
            case .add(let data):
                photoService.addPhoto(data, Date())
                let all = photoService.fetchAll()
                state.photos = all
                state.lastPhotoOverlay = all.last
                return .none
            case .photosLoaded(let arr):
                state.photos = arr
                state.lastPhotoOverlay = arr.last
                return .none
            case .showCamera(let show):
                state.showCamera = show
                return .none
            case .cameraPhoto(let data):
                photoService.addPhoto(data, Date())
                let all = photoService.fetchAll()
                state.photos = all
                state.lastPhotoOverlay = all.last
                state.showCamera = false
                return .none
            case .binding:
                return .none
            }
        }
    }
}
