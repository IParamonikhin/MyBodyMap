//
//  CameraOverlayView.swift
//  MyBodyMap
//
//  Created by Иван on 20.07.2025.
//

import SwiftUI
import AVFoundation

public struct CameraOverlayView: View {
    @Environment(\.presentationMode) var presentationMode

    public let overlayData: Data?
    public let onPhoto: (Data) -> Void
    public let onCancel: () -> Void

    @StateObject private var cameraModel = CameraModel()

    public init(
        overlayData: Data?,
        onPhoto: @escaping (Data) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.overlayData = overlayData
        self.onPhoto = onPhoto
        self.onCancel = onCancel
    }

    public var body: some View {
        ZStack {
            CameraPreview(session: cameraModel.session)
                .ignoresSafeArea()

            if let overlayData, let overlayImage = UIImage(data: overlayData) {
                Image(uiImage: overlayImage)
                    .resizable()
                    .scaledToFit()
                    .opacity(0.8)
                    .ignoresSafeArea()
            }

            VStack {
                HStack {
                    Button("Отмена") {
                        cameraModel.stop()
                        onCancel()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    Spacer()
                }
                Spacer()
                Button(action: {
                    cameraModel.takePhoto { data in
                        if let data {
                            onPhoto(data)
                        }
                        cameraModel.stop()
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 4)
                        .frame(width: 72, height: 72)
                        .background(Circle().fill(.white.opacity(0.2)))
                        .padding(.bottom, 32)
                }
            }
            .padding()
        }
        .onAppear { cameraModel.start() }
        .onDisappear { cameraModel.stop() }
    }
}

// MARK: - CameraPreview

final class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var session = AVCaptureSession()
    private let output = AVCapturePhotoOutput()
    private var onPhotoTaken: ((Data?) -> Void)?

    override init() {
        super.init()
    }

    func start() {
        checkPermissionAndConfigure()
    }

    func stop() {
        session.stopRunning()
    }

    func takePhoto(completion: @escaping (Data?) -> Void) {
        self.onPhotoTaken = completion
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        let data = photo.fileDataRepresentation()
        onPhotoTaken?(data)
        onPhotoTaken = nil
    }

    // MARK: - Setup

    private func checkPermissionAndConfigure() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted { self.configureSession() }
            }
        default:
            // Нет доступа, можно показать алерт
            break
        }
    }

    private func configureSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.beginConfiguration()
            defer { self.session.commitConfiguration() }

            guard
                let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
                let input = try? AVCaptureDeviceInput(device: device),
                self.session.canAddInput(input),
                self.session.canAddOutput(self.output)
            else { return }

            self.session.inputs.forEach { self.session.removeInput($0) }
            self.session.outputs.forEach { self.session.removeOutput($0) }

            self.session.addInput(input)
            self.session.addOutput(self.output)
            self.session.startRunning()
        }
    }
}

struct CameraPreview: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = UIScreen.main.bounds
        view.layer.addSublayer(previewLayer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
}

//#Preview {
//    CameraOverlayView()
//}
