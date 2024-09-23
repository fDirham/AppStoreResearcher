//
//  AppStoreSearcher.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/18/24.
//

import Foundation
import JavaScriptCore

protocol AppStoreSearcherService {
    func queryItunesSearch(searchQuery: String) async throws -> ItunesSearchRes
    func queryAppStorePage(pageUrl: String) async throws -> CheerioScrapeRes
}

class AppStoreSearcher: AppStoreSearcherService {
    static var shared = AppStoreSearcher()
    static var preview = DummyAppStoreSearcher()
    
    private let vm = JSVirtualMachine()
    private let context: JSContext
    
    init(){
        self.context = JSContext(virtualMachine: vm)
        self.context.exceptionHandler = { context, exception in
            if let exc = exception {
                print("JS Exception:", exc.toString() ?? "Unknown")
            }
        }
        if let jsSourcePath = Bundle.main.path(forResource: "AppStoreSearcher.bundle", ofType: "js") {
            do {
                let jsSourceContents = try String(contentsOfFile: jsSourcePath)
                self.context.evaluateScript(jsSourceContents)
            }
            catch {
                print(error.localizedDescription)
            }
        }

    }
    
    func queryAppStorePage(pageUrl: String) async throws -> CheerioScrapeRes {
        let html = try await queryAppStorePageHtml(pageUrl: pageUrl)
        return try scrapeAppStorePage(pageHTML: html)
    }
    
    func queryItunesSearch(searchQuery: String) async throws -> ItunesSearchRes {
        let isBundleSearch = searchQuery.hasPrefix("com.")
        
        var searchUrl: URL!
        if isBundleSearch {
            searchUrl = try getBundleIdItunesSearchUrl(bundleId: searchQuery)
        }
        else {
            searchUrl = try getGenericItunesSearchUrl(searchQuery: searchQuery)
        }
        
        let (data, _) = try await URLSession.shared.data(from: searchUrl)
        
        var itunesRes: ItunesSearchRes = try decodeJSONData(data)
        itunesRes.removeWeirdResults()
        
        return itunesRes
    }
    
    private func getBundleIdItunesSearchUrl(bundleId: String) throws -> URL {
        let mediaQItem = URLQueryItem(name: "media", value: "software")
        let termQItem = URLQueryItem(name: "bundleId", value: bundleId)
        guard let url = URLComponents(
            host: "itunes.apple.com",
            path: "/lookup",
            queryItems: [mediaQItem, termQItem]
        ).url else {
            throw "URL Invalid"
        }
        return url
    }

    private func getGenericItunesSearchUrl(searchQuery: String) throws -> URL {
        let mediaQItem = URLQueryItem(name: "media", value: "software")
        let termQItem = URLQueryItem(name: "term", value: searchQuery)
        guard let url = URLComponents(
            host: "itunes.apple.com",
            path: "/search",
            queryItems: [mediaQItem, termQItem]
        ).url else {
            throw "URL Invalid"
        }
        return url
    }
    
    private func scrapeAppStorePage(pageHTML: String) throws -> CheerioScrapeRes{
        let jsModule = self.context.objectForKeyedSubscript("AppStoreSearcher")
        if let res = jsModule?.invokeMethod("scrapeAppStorePage", withArguments: [pageHTML]) {
            let toReturn: CheerioScrapeRes = try decodeJSONObj(res.toString())
            return toReturn
        }
        
        throw "Something went wrong getting module"
    }
    
    private func queryAppStorePageHtml(pageUrl: String) async throws -> String {
        guard let url = URL(string: pageUrl) else {
            throw "URL Invalid"
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("text/html", forHTTPHeaderField: "Accept")
        request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:130.0) Gecko/20100101 Firefox/130.0", forHTTPHeaderField: "User-Agent")
        request.setValue("en-US,en;q=0.5", forHTTPHeaderField: "Accept-Language")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return String(decoding: data, as: UTF8.self)
    }
}

class DummyAppStoreSearcher: AppStoreSearcherService {
    func queryAppStorePage(pageUrl: String) async throws -> CheerioScrapeRes {
        print("DUMMY QUERY APP STORE PAGE \(pageUrl)")
        try await Task.sleep(for: .seconds(1))
        return CheerioScrapeRes.DUMMY
    }
    
    func queryItunesSearch(searchQuery: String) async throws -> ItunesSearchRes {
        print("DUMMY ITUNES SEARCH \(searchQuery)")
        try await Task.sleep(for: .seconds(1))
        return ItunesSearchRes.DUMMY
    }
    
}
