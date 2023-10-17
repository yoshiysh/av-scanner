//
//  BasicExample.swift
//  AVScannerExample
//
//  Created by yoshiysh on 2023/10/16.
//

import SwiftUI
import AVScanner

struct BasicExample: View {
    var body: some View {
        AVScannerView(types: [.qr]) { result in
            if case .Success(let array) = result {
                array.forEach { value in
                    print("result: \(value.stringValue)")
                }
            }
        }
        .navigationTitle("Basic Example")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        BasicExample()
    }
}
