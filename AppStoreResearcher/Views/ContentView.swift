//
//  ContentView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/9/24.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var vm = ViewModel()
    
    var body: some View {
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
                if let selectedGroup = vm.selectedGroup {
                    switch vm.contentMode {
                    case .OVERVIEW:
                        OverviewModeView(pg: selectedGroup)
                    case .SCREENSHOTS:
                        ScreenshotModeView(pg: selectedGroup)
                    case .ICONS:
                        IconModeView(pg: selectedGroup)
                    case .IN_APP_PURCHASES:
                        InAppPurchasesModeView(pg: selectedGroup)
                    }
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
                Picker("Mode", selection: $vm.contentMode) {
                    Text(ContentMode.OVERVIEW.rawValue).tag(ContentMode.OVERVIEW)
                    Text(ContentMode.SCREENSHOTS.rawValue).tag(ContentMode.SCREENSHOTS)
                    Text(ContentMode.ICONS.rawValue).tag(ContentMode.ICONS)
                    Text(ContentMode.IN_APP_PURCHASES.rawValue).tag(ContentMode.IN_APP_PURCHASES)
                }
            }
            ToolbarItemGroup(placement: .secondaryAction) {
                Button("Add app") {
                    print("Add tapped")
                }
                .roundedBG(fill: Color.indigo)
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
        .onChange(of: vm.selectedGroup) {
            if let selectedGroup = vm.selectedGroup {
                vm.contentTitle = selectedGroup.group_name ?? ""
            }
        }
    }
}

extension ContentView {
    @Observable class ViewModel {
        var showDetail = false
        var selectedGroupId: PageGroup.ID? = nil
        var selectedGroup: PageGroup? {
            if let selectedGroupId = selectedGroupId {
                return pageGroupList.first(where: {e in e.id == selectedGroupId})
            }
            
            return nil
        }
        var contentTitle: String = "ASR"
        var contentMode: ContentMode = .OVERVIEW
        private var dataManager: DataManager
        var anyCancellable: AnyCancellable? = nil
        var pageGroupList: [PageGroup] {
            dataManager.pageGroupList
        }
        
        var alertNewGroup = false
        var newGroupName: String = ""
        var alertDeleteGroup = false
        var groupToDelete: PageGroup? = nil
        
        
        init(dataManager: DataManager = DataManager.shared) {
            self.dataManager = dataManager
        }
        
        func startNewGroup(){
            alertNewGroup = true
        }
        
        func confirmNewGroup(){
            dataManager.createNewPageGroup(groupName: self.newGroupName)
            newGroupName = ""
            alertNewGroup = false
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

#Preview {
    ContentView(vm: ContentView.ViewModel(dataManager: DataManager.preview))
}
