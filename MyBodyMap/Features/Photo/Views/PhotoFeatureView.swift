//
//  PhotoFeatureView.swift
//  MyBodyMap
//
//  Created by Иван on 12.07.2025.
//

import SwiftUI
import ComposableArchitecture

public struct PhotoView: View {
    @Bindable var store: StoreOf<PhotoFeature>

    public init(store: StoreOf<PhotoFeature>) { self.store = store }

    public var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(store.photos.enumerated()), id: \.offset) { idx, data in
                            if let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 90, height: 120)
                                    .cornerRadius(12)
                            }
                        }
                    }.padding()
                }
                Button {
                    store.showCamera = true
                } label: {
                    Label("Сделать фото", systemImage: "camera.fill")
                        .font(.headline)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.12)))
                }
                .padding(.top, 12)
                Spacer()
            }
            .navigationTitle("Фото прогресса")
            .sheet(isPresented: $store.showCamera) {
                CameraOverlayView(
                    overlayData: store.lastPhotoOverlay,
                    onPhoto: { data in store.send(.cameraPhoto(data)) },
                    onCancel: { store.showCamera = false }
                )
            }
            .onAppear { store.send(.load) }
        }
    }
}
