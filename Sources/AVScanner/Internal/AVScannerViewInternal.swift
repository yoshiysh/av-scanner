//
//  AVScannerViewInternal.swift
//  AVScanner
//
//  Created by yoshiysh on 2023/10/16.
//

import AVFoundation
import SwiftUI

struct AVScannerViewInternal {
    let types: [AVMetadataObject.ObjectType]
    let interval: Double
    let onCompletion: (AVScanResult) -> Void

    let session: AVCaptureSession = {
        let session: AVCaptureSession = .init()
        session.sessionPreset = .photo
        return session
    }()
    
    let metadataOutput: AVCaptureMetadataOutput = .init()
    var delegate: AVScannerOutputDelegate?

    var available: Bool {
        types.map {
            metadataOutput.availableMetadataObjectTypes.contains($0)
        }.filter {
            $0
        }.count != 0
    }

    init(
        types: [AVMetadataObject.ObjectType],
        interval: Double,
        onCompletion: @escaping (AVScanResult) -> Void
    ) {
        self.types = types
        self.interval = interval
        self.onCompletion = onCompletion

        delegate = .init(
            objectTypes: types,
            interval: interval,
            onCompletion: onCompletion
        )
    }
}

// MARK: - UIViewRepresentable
extension AVScannerViewInternal: UIViewRepresentable {
    public func makeUIView(context: Context) -> some UIView {
        let uiView = AVScannerCameraView()
#if targetEnvironment(simulator)
        uiView.simulatorView(delegate: delegate)
#else
        checkCameraAuthorizationStatus(uiView)
#endif
        return uiView
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
}

// MARK: - Private Extension
extension AVScannerViewInternal {
    func checkCameraAuthorizationStatus(_ uiView: AVScannerCameraView) {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if authorizationStatus == .authorized {
            DispatchQueue.main.async {
                setupCamera(uiView)
            }
        } else {
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        setupCamera(uiView)
                    } else {
                        onCompletion(.Failure(.PermissionDenied))
                    }
                }
            }
        }
    }

    func setupCamera(_ uiView: AVScannerCameraView) {
        guard let camera: AVCaptureDevice = .default(for: .video) else {
            onCompletion(.Failure(.PermissionDenied))
            return
        }
        
        var input: AVCaptureDeviceInput?
        do {
            input = try AVCaptureDeviceInput(device: camera)
        } catch {
            onCompletion(.Failure(.InitializationError))
            return
        }
        guard let input else { return }

        uiView.setupPreview(session: session)

        if session.canAddInput(input) {
            session.addInput(input)
        }

        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            guard available else  {
                onCompletion(.Failure(.BadInput))
                return
            }

            metadataOutput.metadataObjectTypes = types
            metadataOutput.setMetadataObjectsDelegate(delegate, queue: DispatchQueue.main)
        }

        session.commitConfiguration()
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }
}
