//
//  DummyPageRes.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/11/24.
//

import Foundation
import CoreData

struct DummyPageRes: Codable {
    struct DummyInAppPurchaseSpec: Codable {
        var desc: String
        var price: String
    }
    
    var app_title: String
    var app_store_url: String
    var app_bundle_id: String
    var app_id: Int64
    var app_description: String
    var app_icon_60: String
    var app_icon_512: String
    var creator_name: String
    var creator_url: String
    var rating_avg: Float
    var rating_count: Int64
    var current_version: String
    var release_date: String
    var current_version_release_date: String
    var primary_genre: String
    var genre_list: [String]
    var purchase_price: Float
    var purchase_currency: String
    var content_rating: String
    var minimum_os_version: String
    var screenshot_ios: [String]
    var screenshot_ipad: [String]
    var app_subtitle: String
    var in_app_purchases: [DummyInAppPurchaseSpec]
    
    func createAppStorePage(viewContext: NSManagedObjectContext) -> AppStorePage{
        
        // Create stringholders
        var cdGenreListArr: [StringHolder] = []
        for strVal in self.genre_list {
            let toAdd = StringHolder(context: viewContext)
            toAdd.string = strVal
            cdGenreListArr.append(toAdd)
        }
        let cdGenreList: NSSet = NSSet(array: cdGenreListArr)

        var cdScreenshotIosArr: [StringHolder] = []
        for strVal in self.screenshot_ios {
            let toAdd = StringHolder(context: viewContext)
            toAdd.string = strVal
            cdScreenshotIosArr.append(toAdd)
        }
        let cdScreenshotIos = NSOrderedSet(array: cdScreenshotIosArr)

        var cdScreenshotIpadArr: [StringHolder] = []
        for strVal in self.screenshot_ios {
            let toAdd = StringHolder(context: viewContext)
            toAdd.string = strVal
            cdScreenshotIpadArr.append(toAdd)
        }
        let cdScreenshotIpad = NSOrderedSet(array: cdScreenshotIpadArr)

        // Create in app purchases
        var cdInAppPurchasesList: [InAppPurchaseSpec] = []
        for inAppSpec in in_app_purchases {
            let toAdd = InAppPurchaseSpec(context: viewContext)
            toAdd.desc = inAppSpec.desc
            toAdd.price_str = inAppSpec.price
            cdInAppPurchasesList.append(toAdd)
        }
        let cdInAppPurchases = NSOrderedSet(array: cdInAppPurchasesList)
        
        // Parse dates
        let dateFormatter = ISO8601DateFormatter()
        let releaseDate = dateFormatter.date(from: self.release_date)
        let currVerReleaseDate = dateFormatter.date(from: self.current_version_release_date)

        // Assign app store object
        let asp: AppStorePage = AppStorePage(context: viewContext)
        asp.app_title = self.app_title
        asp.app_store_url = self.app_store_url
        asp.app_bundle_id = self.app_bundle_id
        asp.app_id = String(self.app_id)
        asp.app_description = self.app_description
        asp.app_icon_60 = self.app_icon_60
        asp.app_icon_512 = self.app_icon_512
        asp.creator_name = self.creator_name
        asp.creator_url = self.creator_url
        asp.rating_avg = self.rating_avg
        asp.rating_count = self.rating_count
        asp.current_version = self.current_version
        asp.release_date = releaseDate
        asp.current_version_release_date = currVerReleaseDate
        asp.primary_genre = self.primary_genre
        asp.genre_list = cdGenreList
        asp.purchase_price = self.purchase_price
        asp.purchase_currency = self.purchase_currency
        asp.content_rating = self.content_rating
        asp.minimum_os_version = self.minimum_os_version
        asp.screenshot_ios = cdScreenshotIos
        asp.screenshot_ipad = cdScreenshotIpad
        asp.app_subtitle = self.app_subtitle
        asp.in_app_purchases = cdInAppPurchases
        
        return asp
    }
}

