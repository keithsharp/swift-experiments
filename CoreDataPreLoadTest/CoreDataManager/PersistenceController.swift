//
//  PersistenceController.swift
//  CoreDataManager
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
