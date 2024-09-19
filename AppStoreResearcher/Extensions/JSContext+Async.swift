//
//  JSContext+Async.swift
//  AppStoreResearcher
//
//  Created by Fajar Dirham on 9/18/24.
//

import JavaScriptCore

extension JSContext {
    func callAsyncFunction(key: String, withArguments: [Any] = []) async throws -> JSValue {
        try await withCheckedThrowingContinuation { continuation in
            let onFulfilled: @convention(block) (JSValue) -> Void = {
                continuation.resume(returning: $0)
            }
            let onRejected: @convention(block) (JSValue) -> Void = {
                let error = NSError(domain: key, code: 0, userInfo: [NSLocalizedDescriptionKey : "\($0)"])
                continuation.resume(throwing: error)
            }
            let promiseArgs = [unsafeBitCast(onFulfilled, to: JSValue.self), unsafeBitCast(onRejected, to: JSValue.self)]
            
            let promise = self.objectForKeyedSubscript(key).call(withArguments: withArguments)
            promise?.invokeMethod("then", withArguments: promiseArgs)
        }
    }
    
    func resolveAsyncPromise(promise: JSValue) async throws -> JSValue {
        try await withCheckedThrowingContinuation { continuation in
            let onFulfilled: @convention(block) (JSValue) -> Void = {
                continuation.resume(returning: $0)
            }
            let onRejected: @convention(block) (JSValue) -> Void = {
                let error = NSError(domain: "com.fbdco.appstoreresearcher-JS", code: 0, userInfo: [NSLocalizedDescriptionKey : "\($0)"])
                continuation.resume(throwing: error)
            }
            let promiseArgs = [unsafeBitCast(onFulfilled, to: JSValue.self), unsafeBitCast(onRejected, to: JSValue.self)]
            
            promise.invokeMethod("then", withArguments: promiseArgs)
        }
    }
}

