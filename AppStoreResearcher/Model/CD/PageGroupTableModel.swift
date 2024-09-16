//
//  PageGroupTableModel.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/16/24.
//

import Foundation

@Observable
class PageGroupTableModel {
    var pg: PageGroup? = nil
    var piList: [PageItem] = []
    var aspList: [AppStorePage] = []
    
    var selectedAppStorePageId: AppStorePage.ID? = nil
    var selectedPageItem: PageItem? {
        if selectedAppStorePageId == nil {
            return nil
        }
        
        let filtered = piList.filter({($0.app_store_page)?.id == selectedAppStorePageId}) as [PageItem]
        if filtered.isEmpty {
            return nil
        }
        return filtered.first
    }
    var selectedAppStorePage: AppStorePage? {
        if selectedPageItem == nil {
            return nil
        }
        
        return selectedPageItem?.app_store_page
    }
    
    private var _sortOrder: [KeyPathComparator<AppStorePage>] = []
    var sortOrder: [KeyPathComparator<AppStorePage>] {
        set {
            _onSortChange(newSortOder: newValue)
            _sortOrder = newValue
        }
        get { return _sortOrder}
    }
    
    func setPageGroup(pg: PageGroup) {
        self.pg = pg
        if let newPiList = pg.page_items {
            let piListArr: [PageItem] = newPiList.array as? [PageItem] ?? []
            piList = piListArr
        }
        else {
            piList = []
        }
        
        aspList = piList.map{$0.app_store_page!}
    }
    
    private func _onSortChange(newSortOder: [KeyPathComparator<AppStorePage>]){
        if let newKey = newSortOder.first {
            aspList.sort(using: newKey)
        }
    }
}
