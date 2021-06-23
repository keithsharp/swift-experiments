//
//  RealityKitTestApp.swift
//  RealityKitTest
//
//  Created by Keith Sharp on 23/06/2021.
//

import SwiftUI

@main
struct RealityKitTestApp: App {
    var body: some Scene {
        WindowGroup {
            RealityKitView()
                .frame(width: 800, height: 600)
        }
    }
}
