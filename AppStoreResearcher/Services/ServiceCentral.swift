//
//  ServiceCentral.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/23/24.
//

import Foundation

@Observable
class ServiceCentral {
    static var shared: ServiceCentral = ServiceCentral(
        appStoreSearcher: AppStoreSearcher.shared
    )
    static var preview: ServiceCentral = ServiceCentral(
        appStoreSearcher: AppStoreSearcher.preview
    )

    var appStoreSearcher: AppStoreSearcherService
    
    init(appStoreSearcher: AppStoreSearcherService){
        self.appStoreSearcher = appStoreSearcher
    }
}
