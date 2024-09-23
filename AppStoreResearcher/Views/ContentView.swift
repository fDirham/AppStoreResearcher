//
//  ContentView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/9/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @Environment(UserSelection.self) var userSelection
    @Environment(DataManager.self) var dataManager
    @State var vm = ViewModel()
    
    var body: some View {
        @Bindable var userSelectionBinding = userSelection
        
        ZStack {
            NavigationSplitView {
                VStack {
                    Button(action: {
                        vm.startNewGroup()
                    }) {
                        Text("+ New Group")
                    }
                    .alert("New group", isPresented: $vm.alertNewGroup) {
                        TextField("e.g Social Apps", text: $vm.newGroupName)
                        Button("Create", action: {
                            vm.confirmNewGroup()
                        })
                        Button("Cancel", role:.cancel , action: {
                            vm.cancelNewGroup()
                        })
                    } message: {
                        Text("What should we call the group?")
                    }
                    List(vm.pageGroupList, selection: $vm.selectedGroupId){ pg in
                        Text(pg.group_name ?? "")
                            .contextMenu(ContextMenu(menuItems: {
                                Button("Delete") {
                                    vm.startDeleteGroup(pg)
                                }
                            }))
                    }
                    .alert("Delete group", isPresented: $vm.alertDeleteGroup) {
                        Button("Cancel", role:.cancel , action: {
                            vm.cancelDeleteGroup()
                        })
                        Button("Delete", role:.destructive , action: {
                            vm.confirmDeleteGroup()
                        })
                    } message: {
                        Text("Are you sure?")
                    }
                }
            } detail: {
                HStack(spacing: 0) {
                    Spacer(minLength: 0)
                    if vm.selectedGroupId != nil {
                        switch userSelection.viewingContentMode {
                        case .OVERVIEW:
                            OverviewModeView()
                        case .SCREENSHOTS:
                            ScreenshotModeView()
                        case .ICONS:
                            IconModeView()
                        case .IN_APP_PURCHASES:
                            InAppPurchasesModeView()
                        }
                        EmptyView()
                    }
                    else {
                        NoGroupSelectedView()
                    }
                    Spacer(minLength: 0)
                    Divider()
                    if vm.showDetail {
                        MasterNoteView()
                    }
                }
                .navigationTitle(vm.contentTitle)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigation) {
                    Picker("Mode", selection: $userSelectionBinding.viewingContentMode) {
                        Text(ContentMode.OVERVIEW.rawValue).tag(ContentMode.OVERVIEW)
                        Text(ContentMode.SCREENSHOTS.rawValue).tag(ContentMode.SCREENSHOTS)
                        Text(ContentMode.ICONS.rawValue).tag(ContentMode.ICONS)
                        Text(ContentMode.IN_APP_PURCHASES.rawValue).tag(ContentMode.IN_APP_PURCHASES)
                    }
                }
                ToolbarItemGroup(placement: .secondaryAction) {
                    if vm.showAddInterface {
                        Button("Cancel") {
                            vm.showAddInterface = false
                        }
                        .roundedBG(fill: Color.red)
                    }
                    else {
                        Button("Add app") {
                            vm.showAddInterface = true
                        }
                        .roundedBG(fill: Color.indigo)
                    }
                }
                ToolbarItemGroup(placement: .primaryAction) {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            vm.showDetail.toggle()
                        }
                    }) {
                        Image(systemName: "sidebar.right")
                    }
                }
            }
            .onAppear {
                vm.setup(userSelection: userSelection, dataManager: dataManager)
            }
            if vm.showAddInterface {
                AppSearchView(isPresented: $vm.showAddInterface)
            }
        }
    }
}

extension ContentView {
    @Observable class ViewModel {
        var userSelection: UserSelection!
        private var dataManager: DataManager!
        
        var showDetail = false
        private var _selectedGroupId: PageGroup.ID? = nil
        var selectedGroupId: PageGroup.ID? {
            set {
                let newPg = dataManager.getPageGroupWithId(id: newValue)
                userSelection?.pageGroup = newPg
            }
            get {
                guard let us = userSelection else {
                    return nil
                }
                
                return us.pageGroup?.id
            }
        }
        
        var contentTitle: String {
            guard let us = userSelection else {
                return "ASR"
            }
            
            return us.pageGroup?.group_name ?? "ASR"
        }
        
        var anyCancellable: AnyCancellable? = nil
        var pageGroupList: [PageGroup] {
            guard let dataManager = dataManager else {
                return []
            }
            return dataManager.pageGroupList
        }
        var alertNewGroup = false
        var newGroupName: String = ""
        var alertDeleteGroup = false
        var groupToDelete: PageGroup? = nil
        
        var showAddInterface = false
        
        func setup(userSelection: UserSelection, dataManager: DataManager) {
            self.userSelection = userSelection
            self.dataManager = dataManager
        }
        
        func startNewGroup(){
            alertNewGroup = true
        }
        
        func confirmNewGroup(){
            let newlyAdded = dataManager.createNewPageGroup(groupName: self.newGroupName)
            newGroupName = ""
            alertNewGroup = false
            
            self.selectedGroupId = newlyAdded.id
        }
        
        func cancelNewGroup(){
            newGroupName = ""
            alertNewGroup = false
        }
        
        func startDeleteGroup(_ pg: PageGroup){
            alertDeleteGroup = true
            groupToDelete = pg
        }
        
        func confirmDeleteGroup(){
            if let pg = groupToDelete {
                self.selectedGroupId = nil
                dataManager.deletePageGroup(pageGroup: pg)
            }
            groupToDelete = nil
            alertDeleteGroup = false
            
        }
        
        func cancelDeleteGroup(){
            groupToDelete = nil
            alertDeleteGroup = false
        }
        
    }
}

struct ContentView_Preview: PreviewProvider {
    struct Container: View {
        @State private var userSelection = UserSelection.preview
        @State private var dataManager = DataManager.preview

        var body: some View {
            ContentView()
                .environment(userSelection)
                .environment(dataManager)
        }
    }
    
    static var previews: some View {
        Container()
    }
}
