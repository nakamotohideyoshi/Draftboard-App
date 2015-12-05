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
    // Draft groups, all upcoming (lazy by default as a static var)
    static var draftGroupUpcoming = API.draftGroupUpcoming()
    
    // Draft group by id
    private static var _draftGroupId = [UInt: Promise<DraftGroup>]()
    class func draftGroup(id id: UInt) -> Promise<DraftGroup> {
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
}

