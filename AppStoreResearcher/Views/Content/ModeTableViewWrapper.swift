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
    
    var pg: PageGroup
    @TableColumnBuilder<AppStorePage, KeyPathComparator<AppStorePage>> var tableColumns: Content
    
    init(pg: PageGroup, tableColumns: Content) {
        self.pg = pg
        self.tableColumns = tableColumns
    }
    
    var body: some View {
        Table(of: AppStorePage.self, selection: $vm.selectedAppStorePageId, sortOrder: $vm.sortOrder) {
            tableColumns
        } rows: {
            ForEach(vm.aspList, id: \.app_bundle_id) { obj in
                TableRow(obj)
            }
        }
        .onAppear {
            vm.setup(pageGroup: pg, userSelection: userSelection)
        }
        .onChange(of: pg) {
            vm.setPageGroup(pg: pg)
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
        var piList: [PageItem] = []
        var aspList: [AppStorePage] = []
        
        private var _selectedAppStorePageId: AppStorePage.ID? = nil
        var selectedAppStorePageId: AppStorePage.ID? {
            set {
                _selectedAppStorePageId = newValue
                self._onSelectedAppStorePageIdChanged(newId: newValue)
            }
            get { return _selectedAppStorePageId }
        }
        
        private var _sortOrder: [KeyPathComparator<AppStorePage>] = []
        var sortOrder: [KeyPathComparator<AppStorePage>] {
            set {
                _onSortChange(newSortOder: newValue)
                _sortOrder = newValue
            }
            get { return _sortOrder}
        }
        
        var userSelection: UserSelection? = nil

        func setup(pageGroup: PageGroup, userSelection: UserSelection) {
            setPageGroup(pg: pageGroup)
            self.userSelection = userSelection
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
        
        private func _onSelectedAppStorePageIdChanged(newId: AppStorePage.ID?){
            let pageItem = DataManager.getPageItemFromAppStorePageId(aspId: newId, pageItems: self.piList)
            userSelection!.pageItem = pageItem
        }
    }
}
