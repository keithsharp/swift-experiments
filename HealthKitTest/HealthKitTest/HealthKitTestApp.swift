//
//  HealthKitTestApp.swift
//  HealthKitTest
//
//  Created by Keith Sharp on 17/06/2021.
//

import SwiftUI

@main
struct HealthKitTestApp: App {
    
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
