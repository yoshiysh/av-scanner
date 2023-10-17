//
//  AVScannerView.swift
//  AVScanner
//
//  Created by yoshiysh on 2023/10/16.
//

import AVFoundation
import SwiftUI

public struct AVScannerView: View {
    let types: [AVMetadataObject.ObjectType]
    let interval: Double
    let onCompletion: (AVScanResult) -> Void

    public var body: some View {
        AVScannerViewInternal(
            types: types,
            interval: interval, 
            onCompletion: onCompletion
        )
    }

    public init(
        types: [AVMetadataObject.ObjectType],
        interval: Double = 1.0,
        onCompletion: @escaping (AVScanResult) -> Void
    ) {
        self.types = types
        self.interval = interval
        self.onCompletion = onCompletion
    }
}
