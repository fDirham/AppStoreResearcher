//
//  AppSearchRes.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/18/24.
//

import Foundation

struct AppSearchRes: Codable {
    var appTitle: String
    var appIcon: String
    var appUrl: String
    var ratingAvg: Float
    var ratingCount: Int
    var bundleId: String
    
    init(appTitle: String, appIcon: String, appUrl: String, ratingAvg: Float, ratingCount: Int, bundleId: String) {
        self.appTitle = appTitle
        self.appIcon = appIcon
        self.appUrl = appUrl
        self.ratingAvg = ratingAvg
        self.ratingCount = ratingCount
        self.bundleId = bundleId
    }
    
    init(itunesResult: ItunesSearchRes.Result){
        self.appTitle = itunesResult.trackName ?? ""
        self.appIcon = itunesResult.artworkUrl60 ?? ""
        self.appUrl = itunesResult.trackViewUrl ?? ""
        self.ratingAvg = itunesResult.averageUserRating ?? 0
        self.ratingCount = itunesResult.userRatingCount ?? 0
        self.bundleId = itunesResult.bundleId ?? ""
    }
}

extension AppSearchRes {
    static let DUMMY = [
        AppSearchRes(
            appTitle: "PomoFocus", appIcon: "", appUrl: "", ratingAvg: 3.2, ratingCount: 23, bundleId: "dummy0"
        ),
        AppSearchRes(
            appTitle: "Daylio", appIcon: "", appUrl: "", ratingAvg: 4.9, ratingCount: 1245, bundleId: "dummy1"
        ),
        AppSearchRes(
            appTitle: "Boom App", appIcon: "", appUrl: "", ratingAvg: 1.3, ratingCount: 230, bundleId: "dummy2"
        )

    ]
}
