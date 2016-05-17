//
//  Data+Old.swift
//  Draftboard
//
//  Created by Anson Schall on 5/12/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

/*
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
//        if draftGroups == nil {
//            draftGroups = Datum<[DraftGroup]> { API.draftGroupUpcoming() }
//        }
//        return draftGroups!.cachedAndFresh(maxCacheAge: maxCacheAge)
        ////////////////////
        API.draftGroupUpcoming().then { draftGroups in
            for apiDraftGroup in draftGroups {
                let draftGroup = apiDraftGroup.getCache() ?? apiDraftGroup
                if draftGroup === apiDraftGroup {
                    draftGroup.saveCache()
                } else {
                    draftGroup.update(apiDraftGroup)
                }

                
//}
//                Data.draftGroups[id] = draftGroup
//                let d: DraftGroup!
//                let d = draftGroup.mutableCopy()
//                API.draftGroup(id: draftGroup.id).then { draftGroup in
//                    d.players
//                }
            }
        }
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

private extension Data {
    static var cache: [String: [Int: AnyObject]] = [:]
}

private extension Model {
    func getCache() -> Self? {
        return Data.cache[String(self.dynamicType)]?[self.id]
    }
    func saveCache() {
        Data.cache[String(self.dynamicType)]?[self.id] = self
    }
}
*/