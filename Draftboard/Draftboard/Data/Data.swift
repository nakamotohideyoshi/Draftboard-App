//
//  Data.swift
//  Draftboard
//
//  Created by Anson Schall on 11/19/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class Data {
    static let upcomingLineups = Cache(defaultMaxCacheAge: 60, defaultMinCacheAge: 5) { API.lineupUpcoming() }
    static let draftGroups = Cache { API.draftGroupUpcoming() }
    static let draftGroup = MultiCache { id in API.draftGroup(id: id) }
    static let contests = Cache { API.contestLobby() }
}

extension Lineup {
    func getDraftGroup() -> Promise<DraftGroup> {
        return Data.draftGroup[draftGroupID].get()
    }/*
    func getSport() -> Promise<Sport> {
        return getDraftGroup().then { draftGroup in
            return draftGroup.getSport()
        }
    }*/
}

