//
//  BarcodeScannerView.swift
//  MyBodyMap
//
//  Created by Иван on 26.07.2025.
//

import SwiftUI
import AVFoundation

public struct BarcodeScannerView: UIViewControllerRepresentable {
    public var completion: (String?) -> Void

    public func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }
    public func makeUIViewController(context: Context) -> ScannerVC {
        let vc = ScannerVC()
        vc.delegate = context.coordinator
        return vc
    }
    public func updateUIViewController(_ uiViewController: ScannerVC, context: Context) {}

    public class Coordinator: NSObject, ScannerVCDelegate {
        let completion: (String?) -> Void
        init(completion: @escaping (String?) -> Void) {
            self.completion = completion
        }
        func scanner(didScanCode code: String?) {
            completion(code)
        }
    }
}

protocol ScannerVCDelegate: AnyObject {
    func scanner(didScanCode code: String?)
}

public class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    weak var delegate: ScannerVCDelegate?
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer!

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              captureSession.canAddInput(videoInput)
        else { return }
        captureSession.addInput(videoInput)

        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) { captureSession.addOutput(metadataOutput) }
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [
            .ean8, .ean13, .pdf417, .code128, .upce, .qr
        ]
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if captureSession.isRunning { captureSession.stopRunning() }
    }

    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            captureSession.stopRunning()
            delegate?.scanner(didScanCode: stringValue)
            dismiss(animated: true)
        }
    }

    public override var prefersStatusBarHidden: Bool { true }
    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .portrait }
}

struct BarcodeScannerScreen: View {
    let onScanned: (String?) -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            BarcodeScannerView { code in
                onScanned(code)
                dismiss()
            }
            ScannerOverlayView()
        }
        .ignoresSafeArea()
    }
}
