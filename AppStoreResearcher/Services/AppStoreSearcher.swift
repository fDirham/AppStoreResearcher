//
//  AppStoreSearcher.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/18/24.
//

import Foundation
import JavaScriptCore

protocol AppStoreSearcherService {
    func search(query: String) async throws -> [DummyPageRes]
}

class MainAppStoreSearcherService: AppStoreSearcherService {
    static var shared = MainAppStoreSearcherService()
    
    private let vm = JSVirtualMachine()
    private let context: JSContext
    
    func search(query: String) async throws -> [DummyPageRes] {
        return []
    }
    
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
    
    func testAppStoreSearch() async throws -> String?{
        let jsModule = self.context.objectForKeyedSubscript("AppStoreSearcher")
        if let promise = jsModule?.invokeMethod("searchAppStore", withArguments: ["productivity"]) {
            let res = try await self.context.resolveAsyncPromise(promise: promise)
            return res.toString()
        }
        return nil
    }
    
    func queryItunesSearch(searchQuery: String) async throws -> ItunesSearchRes {
        let mediaQItem = URLQueryItem(name: "media", value: "software")
        let termQItem = URLQueryItem(name: "term", value: searchQuery)
        guard let url = URLComponents(
            host: "itunes.apple.com",
            path: "/search",
            queryItems: [mediaQItem, termQItem]
        ).url else {
            throw "URL Invalid"
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let itunesRes: ItunesSearchRes = try decodeJSONData(data)
        
        return itunesRes
    }
    
    func queryAppStorePageHtml(pageUrl: String) async throws -> String {
        guard let url = URL(string: pageUrl) else {
            throw "URL Invalid"        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(decoding: data, as: UTF8.self)
    }
}

