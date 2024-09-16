//
//  AppStoreResearcherApp.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/9/24.
//

import SwiftUI

@main
struct AppStoreResearcherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // TODO: Delete this for prod
//                    persistenceController.deleteAll()
//                    PersistenceController.sharedSetupDummy()
                }
        }
    }
}
