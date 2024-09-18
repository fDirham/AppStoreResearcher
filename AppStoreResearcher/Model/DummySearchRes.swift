//
//  DummySearchRes.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/18/24.
//

import Foundation

struct DummySearchRes: Codable {
    var appTitle: String
    var appIcon: String
    var appUrl: String
    var subtitle: String
    var rating_avg: Float
    var rating_count: Int
}
