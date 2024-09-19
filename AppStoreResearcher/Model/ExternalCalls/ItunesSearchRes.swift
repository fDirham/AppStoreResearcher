//
//  ItunesSearchRes.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/19/24.
//

import Foundation


struct ItunesSearchRes: Codable {
    struct Result: Codable {
        var artistViewUrl: String
        var artworkUrl60: String
        var supportedDevices: [String]
        var features: [String]
        var isGameCenterEnabled: Bool
        var advisories: [String]
        var screenshotUrls: [String]
        var ipadScreenshotUrls: [String]
        var appletvScreenshotUrls: [String]
        var artworkUrl512: String
        var kind: String
        var trackViewUrl: String
        var contentAdvisoryRating: String
        var averageUserRating: Float
        var currentVersionReleaseDate: String
        var releaseNotes: String
        var minimumOsVersion: String
        var artistId: Int
        var artistName: String
        var genres: [String]
        var price: Float
        var genreIds: [String]
        var primaryGenreName: String
        var description: String
        var bundleId: String
        var trackId: Int
        var trackName: String
        var sellerName: String
        var currency: String
        var fileSizeBytes: String
        var formattedPrice: String
        var userRatingCountForCurrentVersion: Int
        var trackContentRating: String
        var averageUserRatingForCurrentVersion: Float
        var releaseDate: String
        var version: String
        var userRatingCount: Int
    }
    
    var results: [Result]
    var resultCount: Int
}
