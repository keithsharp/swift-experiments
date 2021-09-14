//
//  CoreDataPreLoadTestApp.swift
//  CoreDataPreLoadTest
//
//  Created by Keith Sharp on 14/09/2021.
//

import SwiftUI

@main
struct CoreDataPreLoadTestApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    
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
