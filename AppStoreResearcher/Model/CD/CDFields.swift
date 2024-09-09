//
//  CDFields.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/9/24.
//

import Foundation

struct CDInAppPurchaseItem: Codable {
    var desc: String
    var price: Float
}

struct CDCompatibility: Codable {
    var device: String
    var desc: String
}

struct CDScreenshots: Codable {
    var device: String
    var index: UInt
    var url: String
}
