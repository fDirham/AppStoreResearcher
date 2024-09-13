//
//  DateComparator.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/13/24.
//

import Foundation

struct OptionalDateComparator: SortComparator {
    var order: SortOrder = .forward
    
    func compare(_ lhs: Date?, _ rhs: Date?) -> ComparisonResult {
        return order == .forward ? result(lhs, rhs) : result(rhs, lhs)
    }
    
    private func result(_ lhs: Date?, _ rhs: Date?) -> ComparisonResult {
        if lhs == nil && rhs == nil { return .orderedAscending }
        if lhs == nil && rhs != nil { return .orderedDescending }
        if lhs != nil && rhs == nil { return .orderedAscending }
        
        if lhs! < rhs! { return .orderedAscending }
        if lhs! > rhs! { return .orderedDescending }
        return .orderedSame
    }
}
