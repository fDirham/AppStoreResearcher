//
//  ModeTableViewWrapper.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/16/24.
//

import SwiftUI

struct ModeTableViewWrapper<Content: TableColumnContent<AppStorePage, KeyPathComparator<AppStorePage>>>: View {
    @Environment(UserSelection.self) private var userSelection
    @Environment(DataManager.self) private var dataManager
    
    @State private var vm: ViewModel = ViewModel()
    
    @TableColumnBuilder<AppStorePage, KeyPathComparator<AppStorePage>> var tableColumns: Content
    
    init(tableColumns: Content) {
        self.tableColumns = tableColumns
    }
    
    var body: some View {
        Table(of: AppStorePage.self, selection: $vm.selectedAppStorePageId, sortOrder: $vm.sortOrder) {
            tableColumns
        } rows: {
            ForEach(vm.aspArr, id: \.id) { obj in
                TableRow(obj)
                    .contextMenu {
                        Button {
                            vm.onDeleteRow(asp: obj)
                        } label: {
                            Text("Delete")
                        }
                    }
            }
        }
        .onAppear {
            vm.setup(userSelection: userSelection, dataManager: dataManager)
        }
        .onChange(of: userSelection.pageGroup) {
            vm.onChangePageGroup()
        }
    }
    
    func getViewModel() -> ViewModel {
        return vm
    }
}

extension ModeTableViewWrapper {
    @Observable
    class ViewModel {
        var userSelection: UserSelection!
        var dataManager: DataManager!
        
        var pg: PageGroup? {
            guard let userSelection = userSelection else {
                return nil
            }
           
            return userSelection.pageGroup
        }
        
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
        
        var selectedAppStorePageId: AppStorePage.ID? {
            set {
                if self.userSelection == nil {
                    return
                }
                
                guard let pg = self.pg else {
                    return
                }
                
                guard let pageItems = pg.page_items?.array as? [PageItem] else {
                    return
                }
                
                let pageItem = DataManager.getPageItemFromAppStorePageId(aspId: newValue, pageItems: pageItems)
                self.userSelection!.pageItem = pageItem
            }
            get {
                guard let userSelection = userSelection else {
                    return nil
                }
                
                guard let pi = userSelection.pageItem else {
                    return nil
                }
                
                return pi.app_store_page?.id
            }
        }
        
        var sortKey: KeyPathComparator<AppStorePage>? {
            if userSelection == nil {
                return nil
            }
            
            return userSelection.tableSortArray.first
        }
        
        var sortOrder: [KeyPathComparator<AppStorePage>] {
            set {
                if userSelection != nil {
                    userSelection.tableSortArray = newValue
                }
            }
            get {
                if userSelection == nil {
                    return []
                }
                
                return userSelection.tableSortArray
            }
        }
        

        func setup(userSelection: UserSelection, dataManager: DataManager) {
            self.userSelection = userSelection
            self.dataManager = dataManager
        }
        
        func onChangePageGroup() {
            selectedAppStorePageId = nil
        }
        
        func onDeleteRow(asp: AppStorePage) {
            if let pi = dataManager.getPageItemWithAppStorePage(asp: asp, pageGroup: pg!) {
                dataManager.deletePageItem(pageItem: pi)
            }
        }
    }
}
