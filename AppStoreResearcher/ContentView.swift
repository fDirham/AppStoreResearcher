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

    @State private var showDetail = true
    @State private var selectedGroupId: PageGroup.ID? = nil
    @State private var contentTitle: String = "Test"
    @State private var selectedView: String = "Choco"

    private var selectedGroup: PageGroup? {
        if let selectedGroupId = selectedGroupId {
            return groupItems.first(where: {e in e.id == selectedGroupId})
        }
        
        return nil
    }
    
    private var selectedGroupPageItems: [PageItem] {
        if let sg = selectedGroup {
            let arr = sg.page_items?.array as? [PageItem] ?? []
            return arr
        }
        
        return []
    }

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
                if let selectedGroup = selectedGroup {
                    Text(selectedGroup.group_name ?? "")
                }
                ForEach(selectedGroupPageItems) {pi in
                    Text("\(pi.app_store_page?.app_title ?? "")")
                }
                Spacer()
                Divider()
                if showDetail {
                    VStack {
                        Text(selectedGroup?.group_note?.content ?? "")
                    }
                    .transition(.move(edge: .trailing))
                    .frame(maxHeight: .infinity)
                    .frame(width: 100)
                }
            }
            .navigationTitle(contentTitle)
        } detail: {
            Spacer()
                .navigationSplitViewColumnWidth(0)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigation) {
                Picker("Flavor", selection: $selectedView) {
                    Text("Chocolate").tag("choco")
                        Text("Vanilla").tag("vanilli")
                    }
            }
            ToolbarItemGroup(placement: .secondaryAction) {
                Button("Add app") {
                    print("Credits tapped")
                }
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

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
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
