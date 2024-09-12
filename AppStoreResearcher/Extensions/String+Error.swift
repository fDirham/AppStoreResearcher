//
//  String+Error.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/10/24.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}

