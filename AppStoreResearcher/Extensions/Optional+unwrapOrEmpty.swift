//
//  Optional+unwrapOrEmpty.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/13/24.
//

import Foundation

extension Optional where Wrapped == String {
    var unwrapOrEmpty: Wrapped {
        self ?? ""
    }
}
