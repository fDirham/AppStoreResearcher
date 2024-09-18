//
//  DataManager.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/13/24.
//

import Foundation
import CoreData

enum DataManagerType {
    case normal, preview, testing
}

@Observable class DataManager: NSObject {
    static let shared = DataManager(type: .normal)
    static let preview = DataManager(type: .preview)
    static let testing = DataManager(type: .testing)
    
    var pageGroupList: [PageGroup] = []
    
    fileprivate var viewContext: NSManagedObjectContext
    private let pageGroupFRC: NSFetchedResultsController<PageGroup>
    
    private init(type: DataManagerType) {
        var vc: NSManagedObjectContext
        
        switch type {
        case .normal:
            let persistentStore = PersistenceController()
            vc = persistentStore.container.viewContext
            
        case .preview:
            let persistentStore = PersistenceController(inMemory: true)
            vc = persistentStore.container.viewContext
            Self.setupDummy(viewContext: vc)
            try? vc.save()
            
        case .testing:
            let persistentStore = PersistenceController(inMemory: true)
            vc = persistentStore.container.viewContext
        }
        
        let pageGroupFR: NSFetchRequest<PageGroup> = PageGroup.fetchRequest()
        pageGroupFR.sortDescriptors = [NSSortDescriptor(key: "group_name", ascending: false)]
        pageGroupFRC = NSFetchedResultsController(fetchRequest: pageGroupFR,
                                                  managedObjectContext: vc,
                                              sectionNameKeyPath: nil,
                                              cacheName: nil)
        self.viewContext = vc
        
        super.init()
        
        // Initial fetch to populate todos array
        pageGroupFRC.delegate = self
        try? pageGroupFRC.performFetch()
        if let newPgs = pageGroupFRC.fetchedObjects {
            self.pageGroupList = newPgs
        }
    }
    
    func saveData() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}

extension DataManager: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if let newPgs = controller.fetchedObjects as? [PageGroup] {
            self.pageGroupList = newPgs
        }
    }
    
    private func fetchFirst<T: NSManagedObject>(_ objectType: T.Type, predicate: NSPredicate?) -> Result<T?, Error> {
        let request = objectType.fetchRequest()
        request.predicate = predicate
        request.fetchLimit = 1
        do {
            let result = try viewContext.fetch(request) as? [T]
            return .success(result?.first)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchPageGroups(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) {
        if let predicate = predicate {
            pageGroupFRC.fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            pageGroupFRC.fetchRequest.sortDescriptors = sortDescriptors
        }
        try? pageGroupFRC.performFetch()
        if let newPgs = pageGroupFRC.fetchedObjects {
            self.pageGroupList = newPgs
        }
    }
    
    func resetFetch() {
        pageGroupFRC.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "group_name", ascending: true)]
        pageGroupFRC.fetchRequest.predicate = nil
        try? pageGroupFRC.performFetch()
        if let newPgs = pageGroupFRC.fetchedObjects {
            self.pageGroupList = newPgs
        }
    }

}

// MARK: Preview setup
extension DataManager {
    static func setupDummy(viewContext: NSManagedObjectContext) {
        do {
            // Create app store pages
            let appStorePageList: [AppStorePage] = try createDummyAppStorePages(viewContext: viewContext)
            
            // Create page items
            var pageItemList: [PageItem] = []
            let NUM_PAGE_ITEMS = 12
            for i in 0..<NUM_PAGE_ITEMS {
                let content = ["This is a cool app", "Bad app", "I like the screenshots", "Hmm need to look closer", "Pretty colors", "Bad reviews lol", "Pretty old app"].randomElement()
                let itemNote = Note(context: viewContext)
                itemNote.content = content
                
                
                let pageItem = PageItem(context: viewContext)
                pageItem.item_note = itemNote
                pageItem.app_store_page = appStorePageList[i % appStorePageList.count]
                pageItemList.append(pageItem)
            }
            
            // Create group items
            let NUM_PAGE_GROUPS = 4
            let NUM_PAGE_ITEMS_PER_GROUP = Int(NUM_PAGE_ITEMS / NUM_PAGE_GROUPS)
            var groupNames = ["Journalling", "Photos", "Boomers", "Games", "Cool"]
            for i in 0..<NUM_PAGE_GROUPS {
                let content = ["Need to do x,y,z", "Cool beans", "Should research X more", "Do more market research", "Nice collection of cool previews"].randomElement()
                let groupNote = Note(context: viewContext)
                groupNote.content = content
                
                let piStart = i * NUM_PAGE_ITEMS_PER_GROUP
                let piEnd = piStart + NUM_PAGE_ITEMS_PER_GROUP
                let chosenPageItemList = Array(pageItemList[piStart..<piEnd])
                let pageItems = NSOrderedSet(array: chosenPageItemList)
                
                let pageGroup = PageGroup(context: viewContext)
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
    }
    
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
            let dummy: DummyPageRes = try decodeJSONFile(fileName: fileName, fileType: "json")!
            let toAdd: AppStorePage = dummy.createAppStorePage(viewContext: viewContext)
            toReturn.append(toAdd)
        }
        
        return toReturn
    }
    
    func getRandomAppGroup() -> PageGroup? {
        return pageGroupList.randomElement()
    }
    
    func getRandomPageItem(pageGroup: PageGroup) -> PageItem?{
        return pageGroup.page_items?.array.randomElement() as? PageItem
    }
}

// MARK: PageGroup functions
extension DataManager {
    func createNewPageGroup(groupName: String) {
        let toAdd = PageGroup(context: self.viewContext)
        toAdd.group_name = groupName
        toAdd.group_note = Note(context: self.viewContext)
        self.saveData()
    }
    
    func deletePageGroup(pageGroup pg: PageGroup){
        self.viewContext.delete(pg)
        self.saveData()
    }
    
    func getPageGroupWithId(id: PageGroup.ID?) -> PageGroup? {
        guard let id = id else {
            return nil
        }
        
        return pageGroupList.first{e in e.id == id}
    }
}

// MARK: Note functions
extension DataManager {
    func createNoteForPageGroup(pageGroup: PageGroup) {
        if pageGroup.group_note != nil {
            return
        }
        
        let toAdd = Note(context: self.viewContext)
        pageGroup.group_note = toAdd
        self.saveData()
    }
    
    func createNoteForPageItem(pageItem: PageItem) {
        if pageItem.item_note != nil {
            return
        }
        
        let toAdd = Note(context: self.viewContext)
        pageItem.item_note = toAdd
        self.saveData()
    }
}


// MARK: Convenience functions
extension DataManager {
    static func getPageItemFromAppStorePageId(aspId: AppStorePage.ID?, pageItems: [PageItem]) -> PageItem? {
        if aspId == nil {
            return nil
        }
        
        let filtered = pageItems.filter({($0.app_store_page)?.id == aspId}) as [PageItem]
        if filtered.isEmpty {
            return nil
        }
        return filtered.first
    }
    
    
}
