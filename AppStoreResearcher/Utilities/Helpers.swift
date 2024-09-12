//
//  Helpers.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/10/24.
//

import Foundation

var isPreview: Bool {
    ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}

func debugPrint(_ message: String){
#if DEBUG
    print(message)
#else
    return
#endif
}
