//
//  ContentView.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/9/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var showDetail = false
    @State private var selectedGroupId: PageGroup.ID? = nil
    @State private var contentTitle: String = "ASR"
    @State private var viewMode: ViewMode = .OVERVIEW

    private var selectedGroup: PageGroup? {
        if let selectedGroupId = selectedGroupId {
            return groupItems.first(where: {e in e.id == selectedGroupId})
        }
        
        return nil
    }
    
//    private var selectedGroupPageItems: [PageItem] {
//        if let sg = selectedGroup {
//            let arr = sg.page_items?.array as? [PageItem] ?? []
//            return arr
//        }
//        
//        return []
//    }

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(key: "group_name", ascending: true)],
        animation: .default) private var groupItems: FetchedResults<PageGroup>

    var body: some View {
        NavigationSplitView {
            List(groupItems, selection: $selectedGroupId){
                Text($0.group_name ?? "")
            }
        } content: {
            HStack(spacing: 0) {
                Spacer(minLength: 0)
                if let selectedGroup = selectedGroup {
                    switch viewMode {
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
                if showDetail {
                    MasterNoteView()
                }
            }
            .navigationTitle(contentTitle)
        } detail: {
            Spacer()
                .navigationSplitViewColumnWidth(0)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                Picker("Mode", selection: $viewMode) {
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
                        showDetail.toggle()
                    }
                }) {
                    Image(systemName: "sidebar.right")
                }
            }
        }
        .onChange(of: selectedGroup) {
            if let selectedGroup = selectedGroup {
                contentTitle = selectedGroup.group_name ?? ""
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
