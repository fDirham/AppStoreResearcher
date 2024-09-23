//
//  UserSelection.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/17/24.
//

import Foundation

@Observable class UserSelection {
    static var shared: UserSelection = UserSelection()
    static var preview: UserSelection = {
        let toReturn = UserSelection(dataManager: DataManager.preview)
        toReturn.pageGroup = DataManager.preview.getRandomAppGroup()
        toReturn.pageItem = DataManager.preview.getRandomPageItem(pageGroup: toReturn.pageGroup!)
        
        return toReturn
    }()
    
    private var dataManager: DataManager
    
    init(dataManager: DataManager = DataManager.shared){
        self.dataManager = dataManager
    }
    
    private var _pageGroupIndex: Int? = nil
    var pageGroup: PageGroup? {
        set {
            pageItem = nil
            
            guard let newPg = newValue else {
                _pageGroupIndex = nil
                return
            }
            
            _pageGroupIndex = dataManager.pageGroupList.firstIndex(where: {pg in
                pg.id == newPg.id
            })
        }
        get {
            guard let idx = _pageGroupIndex else {
                return nil
            }
            return dataManager.pageGroupList[idx]
        }
    }
    
    private var _pageItemIndex: Int? = nil
    var pageItem: PageItem? {
        set {
            guard let pg = pageGroup else {
                _pageItemIndex = nil
                return
            }
            guard let newPi = newValue else {
                _pageItemIndex = nil
                return
            }
            
            let piArr: [PageItem] = pg.page_items?.array as? [PageItem] ?? []
            
            _pageItemIndex = piArr.firstIndex(where: {pi in
                pi.id == newPi.id
            })
        }
        get {
            guard let pg = pageGroup else {
                return nil
            }
            
            guard let idx = _pageItemIndex else {
                return nil
            }
            
            let piArr: [PageItem] = pg.page_items?.array as? [PageItem] ?? []
            
            return piArr[idx]
        }
    }
    
    var viewingContentMode: ContentMode = .OVERVIEW
}
