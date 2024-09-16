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
            List(vm.pageGroupList, selection: $vm.selectedGroupId){ pg in
                Text(pg.group_name ?? "")
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
                    default:
                        Text("TODO")
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
        var path: [String] = []

        init(dataManager: DataManager = DataManager.shared) {
            self.dataManager = dataManager
        }
    }
}

#Preview {
    ContentView(vm: ContentView.ViewModel(dataManager: DataManager.preview))
}
