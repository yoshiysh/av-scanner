//
//  ContentView.swift
//  AVScannerExample
//
//  Created by yoshiysh on 2023/10/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NavigationLink("Basic Example") {
                        BasicExample()
                    }
                } header: {
                    Text("Basic")
                }
            }
            .navigationTitle("Examples")
        }
    }
}

#Preview {
    ContentView()
}
