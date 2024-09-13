//
//  ContentView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/9/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State private var vm = ViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "group_name", ascending: true)],
        animation: .default) private var groupItems: FetchedResults<PageGroup>

    var body: some View {
        NavigationSplitView {
            List(groupItems, selection: $vm.selectedGroupId){
                Text($0.group_name ?? "")
            }
        } content: {
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                if let selectedGroup = vm.selectedGroup {
                    switch vm.viewMode {
                    case .OVERVIEW:
                        OverviewModeView(pg: selectedGroup)
                    case .SCREENSHOTS:
                        ScreenshotModeView()
                    case .ICONS:
                        IconModeView()
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
        } detail: {
            Spacer()
                .navigationSplitViewColumnWidth(0)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                Picker("Mode", selection: $vm.viewMode) {
                    Text(ViewMode.OVERVIEW.rawValue).tag(ViewMode.OVERVIEW)
                    Text(ViewMode.SCREENSHOTS.rawValue).tag(ViewMode.SCREENSHOTS)
                    Text(ViewMode.ICONS.rawValue).tag(ViewMode.ICONS)
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
        var pageGroupList: [PageGroup] = []
        var showDetail = false
        var selectedGroupId: PageGroup.ID? = nil
        var selectedGroup: PageGroup? {
            if let selectedGroupId = selectedGroupId {
                return pageGroupList.first(where: {e in e.id == selectedGroupId})
            }
            
            return nil
        }
        var contentTitle: String = "ASR"
        var viewMode: ViewMode = .OVERVIEW
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
