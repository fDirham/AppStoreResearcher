//
//  AppStoreResearcherApp.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/9/24.
//

import SwiftUI

@main
struct AppStoreResearcherApp: App {
    @State private var dataManager = DataManager.shared
    @State private var userSelection = UserSelection.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(userSelection)
                .environment(dataManager)
                .onAppear {
                    // TODO: Delete this for prod
//                    persistenceController.deleteAll()
//                    PersistenceController.sharedSetupDummy()
                }
        }
    }
}
