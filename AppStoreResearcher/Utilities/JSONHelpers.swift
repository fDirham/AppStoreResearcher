//
//  JSONHelpers.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/10/24.
//

import Foundation

func encodeJSONObj<T: Encodable>(_ obj: T) throws -> String {
    let plainJSONEncoder = JSONEncoder()
    let data = try plainJSONEncoder.encode(obj)
    guard let toReturn = String(data: data, encoding: .utf8) else {
     throw "Encoding failed"
    }
    
    return toReturn
}

func decodeJSONObj<T: Decodable>(_ inJSONStr: String) throws -> T {
    let plainJSONDecoder = JSONDecoder()
    let dataJson = inJSONStr.data(using: .utf8)!
    let product = try plainJSONDecoder.decode(T.self, from: dataJson)
    return product
}

func decodeJSONFile<T: Decodable>(_ filePath: String) throws -> T {
    let plainJSONDecoder = JSONDecoder()
    let dataJson = try Data(contentsOf: URL(fileURLWithPath: filePath), options: .mappedIfSafe)
    let product = try plainJSONDecoder.decode(T.self, from: dataJson)
    return product
}
