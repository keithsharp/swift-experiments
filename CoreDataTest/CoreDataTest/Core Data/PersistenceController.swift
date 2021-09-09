//
//  PersistenceController.swift
//  CoreDataTest
//
//  Created by Keith Sharp on 09/09/2021.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    // For SwiftUI Previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        
        // Create sample data
        let glasgow = Place(context: controller.container.viewContext)
        glasgow.name = "Glasgow"
        glasgow.latitude = 55.860916
        glasgow.longitude = -4.251433
        glasgow.tapped = false
        
        let edinburgh = Place(context: controller.container.viewContext)
        edinburgh.name = "Edinburgh"
        edinburgh.latitude = 55.953
        edinburgh.longitude = -3.189
        edinburgh.tapped = false
        
        let aberdeen = Place(context: controller.container.viewContext)
        aberdeen.name = "Aberdeen"
        aberdeen.latitude = 57.15
        aberdeen.longitude = -2.11
        aberdeen.tapped = false
        
        return controller
    }()
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Places")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
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
