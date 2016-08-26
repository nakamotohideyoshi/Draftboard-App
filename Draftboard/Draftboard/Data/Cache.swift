//
//  Cache.swift
//  Draftboard
//
//  Created by Anson Schall on 5/11/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation
import PromiseKit

class CachedValue<T> {
    var date = NSDate.distantPast()
    var value: T? { didSet { date = NSDate() } }
}

class Cache<T> {
    private let defaultMaxCacheAge: NSTimeInterval
    private let defaultMinCacheAge: NSTimeInterval
    private let endpoint: () -> Promise<T>
    private let cached = CachedValue<T>()
    private var pending: Promise<T>?
    
    // Always makes API request, without regard to cache
    func fresh() -> Promise<T> {
        // Limit identical API requests to one at a time
        if pending == nil {
            pending = endpoint().then { freshValue in
                self.cached.value = freshValue
                return Promise(freshValue)
            }.always {
                self.pending = nil
            }
        }
        return pending!
    }
    
    // If cache too old (invalid), returns nil
    func cachedOrNil(maxCacheAge maxCacheAge: NSTimeInterval) -> T? {
        // maxCacheAge is maximum cache age before cache is deleted
        if NSDate().timeIntervalSinceDate(cached.date) > maxCacheAge {
            cached.value = nil
        }
        return cached.value
    }
    
    // If cache nil too old (stale), makes API request
    func cachedOrFresh(maxCacheAge maxCacheAge: NSTimeInterval, minCacheAge: NSTimeInterval) -> Promise<T> {
        // minCacheAge is minimum cache age before API request is made
        if let cachedValue = cachedOrNil(maxCacheAge: maxCacheAge) {
            if NSDate().timeIntervalSinceDate(cached.date) < minCacheAge {
                return Promise(cachedValue)
            }
        }
        return fresh()
    }
    
    // Wraps cachedOrFresh, allows default parameter values
    func get(maxCacheAge maxCacheAge: NSTimeInterval? = nil, minCacheAge: NSTimeInterval? = nil) -> Promise<T> {
        let maxCacheAge = maxCacheAge ?? defaultMaxCacheAge
        let minCacheAge = minCacheAge ?? defaultMinCacheAge
        return cachedOrFresh(maxCacheAge: maxCacheAge, minCacheAge: minCacheAge)
    }
    
    // Remove cached value
    func clearCache() {
        cached.value = nil
    }
    
    init(defaultMaxCacheAge: NSTimeInterval = .OneHour, defaultMinCacheAge: NSTimeInterval = .OneMinute, endpoint: () -> Promise<T>) {
        self.endpoint = endpoint
        self.defaultMaxCacheAge = defaultMaxCacheAge
        self.defaultMinCacheAge = defaultMinCacheAge
    }
}

class MultiCache<T:Hashable, U> {
    private let defaultMaxCacheAge: NSTimeInterval
    private let defaultMinCacheAge: NSTimeInterval
    private let endpoint: (T) -> Promise<U>
    private var caches = [T: Cache<U>]()
    
    subscript(key: T) -> Cache<U> {
        if caches[key] == nil {
            caches[key] = Cache(defaultMaxCacheAge: defaultMaxCacheAge, defaultMinCacheAge: defaultMinCacheAge) {
                self.endpoint(key)
            }
        }
        return caches[key]!
    }
    
    init(defaultMaxCacheAge: NSTimeInterval = .OneHour, defaultMinCacheAge: NSTimeInterval = .OneMinute, endpoint: (T) -> Promise<U>) {
        self.endpoint = endpoint
        self.defaultMaxCacheAge = defaultMaxCacheAge
        self.defaultMinCacheAge = defaultMinCacheAge
    }
}
