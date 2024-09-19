//
//  URLComponents+queryItems.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/19/24.
//

import Foundation

extension URLComponents {
    init(scheme: String = "https",
         host: String,
         path: String,
         queryItems: [URLQueryItem]) {
        self.init()
        self.scheme = scheme
        self.host = host
        self.path = path
        self.queryItems = queryItems
    }
}
