//
//  CheerioScrapeRes.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/19/24.
//

import Foundation

struct CheerioScrapeRes: Codable {
    struct InAppPurchase: Codable {
        var desc: String
        var price_str: String
    }
    
    var app_subtitle: String
    var in_app_purchases: [InAppPurchase]
}

extension CheerioScrapeRes {
    static let DUMMY_IN_APP_PURCHASES: [InAppPurchase] = [
        InAppPurchase(desc: "ur mom", price_str: "$0.01"),
        InAppPurchase(desc: "dad", price_str: "$0.02"),
        InAppPurchase(desc: "cuzin WoaAH", price_str: "$2.99")
    ]
    
    static let DUMMY = CheerioScrapeRes(app_subtitle: "This is a subtitle", in_app_purchases: DUMMY_IN_APP_PURCHASES)
}
