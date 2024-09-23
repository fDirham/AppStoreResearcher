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
    @State private var serviceCentral = ServiceCentral.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(serviceCentral)
                .environment(userSelection)
                .environment(dataManager)
                .onAppear {
                    // TODO: Delete this for prod
//                    dataManager.deleteAll(entityName: "AppStorePage")
//                    dataManager.deleteAll(entityName: "PageItem")
                }
        }
    }
}
