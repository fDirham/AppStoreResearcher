//
//  UserSelection.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/17/24.
//

import Foundation

@Observable class UserSelection {
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
