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
    struct Ocean: Identifiable, Hashable {
        let name: String
        let id = UUID()
    }

    private var oceans = [
        Ocean(name: "Pacific"),
        Ocean(name: "Atlantic"),
        Ocean(name: "Indian"),
        Ocean(name: "Southern"),
        Ocean(name: "Arctic")
    ]


    @State private var multiSelection = Set<UUID>()
    @State private var showDetail = true


//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
//    private var items: FetchedResults<Item>

    var body: some View {
        NavigationSplitView {
            List(oceans, selection: $multiSelection) {
                Text($0.name)
            }
        } content: {
            HStack(spacing: 0) {
                if let firstItem = multiSelection.first {
                    Text(firstItem.uuidString)
                }
                Spacer()
                Divider()
                if showDetail {
                    VStack {
                        Text("Some detail")
                    }
                    .transition(.move(edge: .trailing))
                    .frame(maxHeight: .infinity)
                    .frame(width: 100)
                }
            }
        } detail: {
            Spacer()
                .navigationSplitViewColumnWidth(0)
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    withAnimation {
                        showDetail.toggle()
                    }
                }) {
                    Image(systemName: "sidebar.right")
                }
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
