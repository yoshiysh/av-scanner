//
//  AVScannerCameraView.swift
//  AVScanner
//
//  Created by yoshiysh on 2023/10/16.
//

import SwiftUI
import AVFoundation

class AVScannerCameraView: UIView {
    private var preview: AVCaptureVideoPreviewLayer?
#if targetEnvironment(simulator)
    private var label: UILabel?
    private var delegate: AVScannerOutputDelegate?
#endif

    init() {
        super.init(frame: .zero)
        backgroundColor = .black
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
#if targetEnvironment(simulator)
        label?.frame = bounds
#else
        preview?.frame = bounds
#endif
    }
}

extension AVScannerCameraView {
    func setupPreview(session: AVCaptureSession) {
        let previewLayer: AVCaptureVideoPreviewLayer = .init(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
        preview = previewLayer
    }
}

#if targetEnvironment(simulator)
extension AVScannerCameraView {
    func simulatorView(delegate: AVScannerOutputDelegate?) {
        self.delegate = delegate

        label = UILabel(frame: bounds)
        guard let label else { fatalError() }
        label.text = "Tap here to simulate scan"
        label.textColor = .white
        label.textAlignment = .center
        addSubview(label)

        let gesture: UITapGestureRecognizer = .init(target: self, action: #selector(onClick))
        self.addGestureRecognizer(gesture)
    }

    @objc func onClick() {
        delegate?.onSimulateScanning()
    }
}
#endif
