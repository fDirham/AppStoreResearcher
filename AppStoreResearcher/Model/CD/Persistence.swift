//
//  Persistence.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/9/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create groups
        var groupIdList: [UUID] = []
        for _ in 0..<5 {
            let newItem = PageGroup(context: viewContext)
            newItem.id = UUID()
            groupIdList.append(newItem.id!)
            newItem.title = ["Journaling", "Fitness","Action games", "Anti smoking", "Focus"].randomElement()
        }
        
        // Create items
        for _ in 0..<15 {
            let newItem = PageItem(context: viewContext)
            newItem.id = UUID()
            newItem.group_id = groupIdList.randomElement()
            newItem.app_title = ["Focus Duck", "Pomo Focus","Puff Quit", "Smoke free", "Ad Blocker", "Temple Run", "Flappy Bird", "Golf Mini", "Screen Zen"].randomElement()
        }

        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "AppStoreResearcher")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
