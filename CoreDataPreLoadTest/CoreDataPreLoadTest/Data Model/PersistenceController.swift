//
//  PersistenceController.swift
//  CoreDataPreLoadTest
//
//  Created by Keith Sharp on 14/09/2021.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "TrigPoints")
        
        let storeUrl = self.getDocumentsDirectory().appendingPathComponent("TrigPoints.sqlite")
        
        if isFirstLaunch() {
            print("Performing first launch activity")
            let seededDataUrl = Bundle.main.url(forResource: "TrigPoints", withExtension: "sqlite")!
            do {
                try FileManager.default.createDirectory(at: self.getDocumentsDirectory(), withIntermediateDirectories: true, attributes: nil)
            } catch {
                fatalError("Failed to create: \(self.getDocumentsDirectory()) - \(error.localizedDescription)")
            }
            try! container.persistentStoreCoordinator.replacePersistentStore(at: storeUrl, destinationOptions: nil, withPersistentStoreFrom: seededDataUrl, sourceOptions: nil, ofType: NSSQLiteStoreType)
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error loading persistent store: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving changes: \(error.localizedDescription)")
            }
        }
    }
}

// Support functions for installing pre-loaded SQLITE
extension PersistenceController {
    private func isFirstLaunch() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
}
