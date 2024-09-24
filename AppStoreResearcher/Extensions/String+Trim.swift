//
//  String+Trim.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/24/24.
//

import Foundation

extension String {
    func trim() -> String {
    return self.trimmingCharacters(in: .whitespaces)
   }
}
