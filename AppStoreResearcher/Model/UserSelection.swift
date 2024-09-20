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
        let toReturn = UserSelection()
        toReturn.pageGroup = DataManager.preview.getRandomAppGroup()
        toReturn.pageItem = DataManager.preview.getRandomPageItem(pageGroup: toReturn.pageGroup!)
        
        return toReturn
    }()
    
    private var _pageGroup: PageGroup? = nil
    var pageGroup: PageGroup? {
        set {
            pageItem = nil
            _pageGroup = newValue
        }
        get {
            return _pageGroup
        }
    }
    var pageItem: PageItem? = nil
}
