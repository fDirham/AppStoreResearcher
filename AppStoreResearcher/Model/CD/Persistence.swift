//
//  Persistence.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/9/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

//#if targetEnvironment(simulator)
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        

        do {
            // Create app store pages
            var appStorePageList: [AppStorePage] = try createDummyAppStorePages(viewContext: viewContext)
            
            // Create page items
            var pageItemList: [PageItem] = []
            let NUM_PAGE_ITEMS = 12
            for _ in 0..<NUM_PAGE_ITEMS {
                var content = ["This is a cool app", "Bad app", "I like the screenshots", "Hmm need to look closer", "Pretty colors", "Bad reviews lol", "Pretty old app"].randomElement()
                var itemNote = Note(context: viewContext)
                itemNote.content = content
                
                
                var pageItem = PageItem(context: viewContext)
                pageItem.item_note = itemNote
                var storePage = appStorePageList.randomElement()!
                pageItem.app_store_page = storePage
                pageItemList.append(pageItem)
            }
            
            // Create group items
            let NUM_PAGE_GROUPS = 4
            let NUM_PAGE_ITEMS_PER_GROUP = Int(NUM_PAGE_ITEMS / NUM_PAGE_GROUPS)
            var groupNames = ["Journalling", "Photos", "Boomers", "Games", "Cool"]
            for i in 0..<NUM_PAGE_GROUPS {
                var content = ["Need to do x,y,z", "Cool beans", "Should research X more", "Do more market research", "Nice collection of cool previews"].randomElement()
                var groupNote = Note(context: viewContext)
                groupNote.content = content
                
                let piStart = i * NUM_PAGE_ITEMS_PER_GROUP
                let piEnd = piStart + NUM_PAGE_ITEMS_PER_GROUP
                var chosenPageItemList = Array(pageItemList[piStart..<piEnd])
                var pageItems = NSOrderedSet(array: chosenPageItemList)
                
                var pageGroup = PageGroup(context: viewContext)
                pageGroup.group_note = groupNote
                pageGroup.group_name = groupNames.randomElement()
                groupNames.removeAll(where: {e in e == pageGroup.group_name})
                pageGroup.page_items = pageItems
            }
            
            try viewContext.save()
        } catch {
            // TODO: Handle error
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    static private func createDummyAppStorePages(viewContext: NSManagedObjectContext) throws -> [AppStorePage] {
        let DUMMY_FILE_NAME_LIST: [String] = [
            "dummy_page_res-1638027598",
            "dummy_page_res-1528322796",
            "dummy_page_res-1044867788",
            "dummy_page_res-6608983404",
            "dummy_page_res-1194023242",
            "dummy_page_res-1252208166"
        ]
        
        var toReturn: [AppStorePage] = []
        for fileName in DUMMY_FILE_NAME_LIST {
            if let filePath = Bundle.main.path(forResource: fileName, ofType: "json"){
                let dummy: DummyPageRes = try decodeJSONFile(filePath)
                let toAdd: AppStorePage = dummy.createAppStorePage(viewContext: viewContext)
                toReturn.append(toAdd)
            }
        }
        
        return toReturn
    }
    
    func getRandomAppGroup() -> PageGroup?{
        let fetchRequest: NSFetchRequest<PageGroup>
        fetchRequest = PageGroup.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        do {
            let objects = try container.viewContext.fetch(fetchRequest)
            if objects.isEmpty {
                return nil
            }
            return objects[0]
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
//#endif

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "AppStoreResearcher")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                // TODO: Handle error
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
