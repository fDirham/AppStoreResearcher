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
        print(pageTestRes.prefix(100))
      
        XCTAssert(true)
    }

}
