//
//  SizeOfArrayComparator.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/13/24.
//

import Foundation

struct OptionalOrderedSetCountComparator: SortComparator {
    var order: SortOrder = .forward
    
    func compare(_ lhs: NSOrderedSet?, _ rhs: NSOrderedSet?) -> ComparisonResult {
        return order == .forward ? result(lhs, rhs) : result(rhs, lhs)
    }
    
    private func result(_ lhs: NSOrderedSet?, _ rhs: NSOrderedSet?) -> ComparisonResult {
        if lhs == nil && rhs == nil { return .orderedAscending }
        if lhs == nil && rhs != nil { return .orderedDescending }
        if lhs != nil && rhs == nil { return .orderedAscending }
        
        if lhs!.count < rhs!.count { return .orderedAscending }
        if lhs!.count > rhs!.count { return .orderedDescending }
        return .orderedSame
    }
}
