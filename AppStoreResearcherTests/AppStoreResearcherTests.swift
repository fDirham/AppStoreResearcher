//
//  AppStoreResearcherTests.swift
//  AppStoreResearcherTests
//
//  Created by Fajar Dirham on 9/9/24.
//

import XCTest
@testable import AppStoreResearcher

final class AppStoreResearcherTests: XCTestCase {
    func testJS() async throws {
        let ass = MainAppStoreSearcherService()
        
        let testRes = try await ass.queryItunesSearch(searchQuery: "focus")
        guard let testObj = testRes.results.first else {
            XCTAssert(false)
            return
        }
        
        print(testObj.trackViewUrl)
        
        let pageTestRes = try await ass.queryAppStorePageHtml(pageUrl: testObj.trackViewUrl)
      
        XCTAssert(true)
    }
    
    func testHTMLScrape() async throws {
        let ass = MainAppStoreSearcherService()
        
        // Get test HTML string
        let filePath = Bundle.main.path(forResource: "page_fetch_res", ofType: "html")
        XCTAssert(filePath != nil)
        
        let fileData = try Data(contentsOf: URL(fileURLWithPath: filePath!), options: .mappedIfSafe)
        let htmlString =  String(decoding: fileData, as: UTF8.self)
        
        let scrapedRes = try await ass.scrapeAppStorePage(pageHTML: htmlString)
        XCTAssert(scrapeRes != nil)
        
    }

}
