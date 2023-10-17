//
//  AVScanResult.swift
//  AVScanner
//
//  Created by yoshiysh on 2023/10/16.
//

import SwiftUI
import AVFoundation

public enum AVScanResult: Equatable, Sendable {
    case Success([AVScanedObject])
    case Failure(AVScanError)
}

public struct AVScanedObject: Equatable, Sendable {
    public let type: AVMetadataObject.ObjectType
    public let stringValue: String
}

public enum AVScanError: Equatable, Sendable {
    case InitializationError
    case PermissionDenied
    case BadInput
    case BadOutput
}
