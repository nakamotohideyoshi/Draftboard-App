//
//  Data.swift
//  Draftboard
//
//  Created by Anson Schall on 11/19/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

/*
PLEASE NOTE:
* Currently, API requests are made every time, no matter what.
* You can selectively ignore cached or fresh results, as in patterns 2 & 3.
* Specifying the maxCacheAge parameter allows forced invalidation of cache.

PATTERNS FOR USE:
* 1. Use cached (if it exists) AND update with fresh. (1 or 2 udpates)

Data.lineups().then { cached, fresh -> Promise<[Lineup]> in
    if let lineups = cached {
        self.updateWithData(lineups)
    }
    return fresh
}.then { lineups in
    self.updateWithData(lineups)
}

* 2. Use cached (if it exists) OR use fresh. (1 update)

Data.lineups().then { cached, fresh -> Promise<[Lineup]> in
    if let lineups = cached {
        return Promise(lineups)
    }
    return fresh
}.then { lineups in
    self.updateWithData(lineups)
}

* 3. Ignore cached, ONLY use fresh. (1 update)

Data.lineups().then { cached, fresh -> Promise<[Lineup]> in
    return fresh
}.then { lineups in
    self.updateWithData(lineups)
}
*/

private class Datum<T> {
    var endpoint: () -> Promise<T>
    var date: NSDate = NSDate.distantPast()
    var cached: T?
    var pending: Promise<T>?
    
    func cachedAndFresh(maxCacheAge maxAge: NSTimeInterval) -> Promise<(T?, Promise<T>)> {
        // Expired?
        if NSDate().timeIntervalSinceDate(date) > maxAge {
            cached = nil
        }
        // Limit identical API requests to one at a time
        if pending == nil {
            pending = endpoint().then { (fresh: T) -> Promise<T> in
                self.date = NSDate()
                self.cached = fresh
                return Promise(fresh)
            }.always {
                self.pending = nil
            }
        }
        // Swift compiler gets confused if these lines are combined
        let tup = (cached, pending!)
        return Promise(tup)
    }
    
    init(endpoint: () -> Promise<T>) {
        self.endpoint = endpoint
    }
}

class Data {
    typealias LineupsPromise = Promise<([Lineup]?, Promise<[Lineup]>)>
    typealias DraftGroupsPromise = Promise<([DraftGroup]?, Promise<[DraftGroup]>)>
    typealias DraftGroupPromise = Promise<(DraftGroup?, Promise<DraftGroup>)>
    typealias ContestsPromise = Promise<([Contest]?, Promise<[Contest]>)>

    // Storage
    private static var lineups: Datum<[Lineup]>?
    private static var draftGroups: Datum<[DraftGroup]>?
    private static var draftGroup = [Int: Datum<DraftGroup>]()
    private static var contests: Datum<[Contest]>?

    // Accessors
    class func lineups(maxCacheAge: NSTimeInterval = 60) -> LineupsPromise {
        if lineups == nil {
            lineups = Datum<[Lineup]> { API.lineupUpcoming() }
        }
        return lineups!.cachedAndFresh(maxCacheAge: maxCacheAge)
    }
    
    class func draftGroups(maxCacheAge: NSTimeInterval = 60) -> DraftGroupsPromise {
        if draftGroups == nil {
            draftGroups = Datum<[DraftGroup]> { API.draftGroupUpcoming() }
        }
        return draftGroups!.cachedAndFresh(maxCacheAge: maxCacheAge)
    }
    
    class func draftGroup(id id: Int, maxCacheAge: NSTimeInterval = 60) -> DraftGroupPromise {
        if draftGroup[id] == nil {
            draftGroup[id] = Datum<DraftGroup> { API.draftGroup(id: id) }
        }
        return draftGroup[id]!.cachedAndFresh(maxCacheAge: maxCacheAge)
    }
    
    class func contests(maxCacheAge: NSTimeInterval = 60) -> ContestsPromise {
        if contests == nil {
            contests = Datum<[Contest]> { API.contestLobby() }
        }
        return contests!.cachedAndFresh(maxCacheAge: maxCacheAge)
    }
}