//
//  ModeTableViewWrapper.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/16/24.
//

import SwiftUI

struct ModeTableViewWrapper<Content: TableColumnContent<AppStorePage, KeyPathComparator<AppStorePage>>>: View {
    @Environment(UserSelection.self) private var userSelection
    @State private var vm: ViewModel = ViewModel()
    
    @TableColumnBuilder<AppStorePage, KeyPathComparator<AppStorePage>> var tableColumns: Content
    
    init(tableColumns: Content) {
        self.tableColumns = tableColumns
    }
    
    var body: some View {
        Table(of: AppStorePage.self, selection: $vm.selectedAppStorePageId, sortOrder: $vm.sortOrder) {
            tableColumns
        } rows: {
            ForEach(vm.aspArr, id: \.app_bundle_id) { obj in
                TableRow(obj)
            }
        }
        .onAppear {
            vm.setup(userSelection: userSelection)
        }
        .onChange(of: userSelection.pageGroup) {
            vm.onChangePageGroup(newPageGroup: userSelection.pageGroup)
        }
    }
    
    func getViewModel() -> ViewModel {
        return vm
    }
}

extension ModeTableViewWrapper {
    @Observable
    class ViewModel {
        var pg: PageGroup? = nil
        var sortKey: KeyPathComparator<AppStorePage>?
        var aspArr: [AppStorePage] {
            guard let pg = pg else {
                return []
            }
            
            guard let piList = pg.page_items else {
                return []
            }
            
            let piArr: [PageItem] = piList.array as? [PageItem] ?? []
            var toReturn: [AppStorePage] = piArr.map{$0.app_store_page!}
            
            if let sortKey = sortKey {
                toReturn.sort(using: sortKey)
            }

            return toReturn

        }
        
        private var _selectedAppStorePageId: AppStorePage.ID? = nil
        var selectedAppStorePageId: AppStorePage.ID? {
            set {
                _selectedAppStorePageId = newValue
                self.onSelectedAppStorePageIdChanged(newId: newValue)
            }
            get { return _selectedAppStorePageId }
        }
        
        private var _sortOrder: [KeyPathComparator<AppStorePage>] = []
        var sortOrder: [KeyPathComparator<AppStorePage>] {
            set {
                onSortChange(newSortOder: newValue)
                _sortOrder = newValue
            }
            get { return _sortOrder}
        }
        
        var userSelection: UserSelection? = nil

        func setup(userSelection: UserSelection) {
            self.userSelection = userSelection
            onChangePageGroup(newPageGroup: userSelection.pageGroup)
        }
        
        func onChangePageGroup(newPageGroup newPg: PageGroup?) {
            self.pg = newPg
            selectedAppStorePageId = nil
        }
        
        private func onSortChange(newSortOder: [KeyPathComparator<AppStorePage>]){
            if let newKey = newSortOder.first {
                sortKey = newKey
            }
        }
        
        private func onSelectedAppStorePageIdChanged(newId: AppStorePage.ID?){
            let pageItems = pg!.page_items?.array as! [PageItem]
            
            let pageItem = DataManager.getPageItemFromAppStorePageId(aspId: newId, pageItems: pageItems)
            userSelection!.pageItem = pageItem
        }
    }
}
