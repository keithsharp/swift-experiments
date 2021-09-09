//
//  CoreDataTestApp.swift
//  CoreDataTest
//
//  Created by Keith Sharp on 09/09/2021.
//

import SwiftUI

@main
struct CoreDataTestApp: App {
    // Used to monitor move to background and trigger .onChanhe() -> save below
    @Environment(\.scenePhase) var scenePhase
    
    // Swap these over to get actual persistence rather than in-memory
    let persistenceController = PersistenceController.preview
//    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _ in
            persistenceController.save()
        }
    }
}
