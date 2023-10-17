//
//  AVScannerOutputDelegate.swift
//  AVScanner
//
//  Created by yoshiysh on 2023/10/16.
//

import AVFoundation

class AVScannerOutputDelegate: NSObject {
    private let objectTypes: [AVMetadataObject.ObjectType]
    private let interval: Double
    private let onCompletion: (AVScanResult) -> Void
    private var lastUpdated = Date.now

    init(
        objectTypes: [AVMetadataObject.ObjectType],
        interval: Double,
        onCompletion: @escaping (AVScanResult) -> Void
    ) {
        self.objectTypes = objectTypes
        self.interval = interval
        self.onCompletion = onCompletion
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate
extension AVScannerOutputDelegate: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        let now = Date.now
        if now.timeIntervalSince(lastUpdated) < interval { return }
        lastUpdated = now

        let readableObjects = metadataObjects.map {
            $0 as? AVMetadataMachineReadableCodeObject
        }.compactMap {
            $0
        }.filter {
            objectTypes.contains($0.type) && $0.stringValue != nil
        }

        onCompletion(.Success(
            readableObjects.map { .init(type: $0.type, stringValue: $0.stringValue ?? "") }
        ))
    }
}

#if targetEnvironment(simulator)
extension AVScannerOutputDelegate {
    @objc func onSimulateScanning() {
        onCompletion(.Success([.init(type: .qr, stringValue: "on tapped simulate scan")]))
    }
}
#endif
