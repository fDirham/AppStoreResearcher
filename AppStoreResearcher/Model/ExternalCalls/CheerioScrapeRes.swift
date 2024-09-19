//
//  CheerioScrapeRes.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/19/24.
//

import Foundation

struct CheerioScrapeRes: Codable {
    struct InAppPurchases: Codable {
        var desc: String
        var price_str: String
    }
    
    var app_subtitle: String
    var in_app_purchases: [InAppPurchases]
}
