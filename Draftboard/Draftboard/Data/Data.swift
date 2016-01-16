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
}

/*

    // Draft groups, all upcoming (lazy by default as a static var)
    static var draftGroupUpcoming = API.draftGroupUpcoming()
    
    // Draft group by id
    private static var _draftGroupId = [Int: Promise<DraftGroup>]()
    class func draftGroup(id id: Int) -> Promise<DraftGroup> {
        if let draftGroup = _draftGroupId[id] {
            return draftGroup
        } else {
            let draftGroup = API.draftGroup(id: id)
            _draftGroupId[id] = draftGroup
            return draftGroup
        }
    }
    
    // Contests, all upcoming
    static var contestLobby = API.contestLobby()
    
    // Sports injuries by id
    private static var _sportsInjuries = [String: Promise<[Int: String]>]()
    class func sportsInjuries(sportName: String) -> Promise<[Int: String]> {
        if let injuries = _sportsInjuries[sportName] {
            return injuries
        } else {
            let injuries = API.sportsInjuries(sportName)
            _sportsInjuries[sportName] = injuries
            return injuries
        }
    }
    
    // Lineups, all upcoming
    static var lineupUpcoming = API.lineupUpcoming()
}

*/
