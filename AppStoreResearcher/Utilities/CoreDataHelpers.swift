//
//  CoreDataHelpers.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/11/24.
//

import Foundation
import CoreData

func convertStringArrayToStringHolderSet(someArr: [String], viewContext: NSManagedObjectContext) -> Set<StringHolder> {
    
    var toReturn: Set<StringHolder> = Set()
    for strVal in someArr {
        let toAdd = StringHolder(context: viewContext)
        toAdd.string = strVal
        toReturn.insert(toAdd)
    }
    
    return toReturn
}

func convertStringArrayToStringHolderOrderedSet(someArr: [String], viewContext: NSManagedObjectContext) -> NSOrderedSet {
    var arr: [StringHolder] = []
    for strVal in someArr {
        let toAdd = StringHolder(context: viewContext)
        toAdd.string = strVal
        arr.append(toAdd)
    }
    
    return NSOrderedSet(array: arr)
}
