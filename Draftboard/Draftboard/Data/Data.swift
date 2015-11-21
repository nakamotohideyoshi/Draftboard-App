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
    static var draftGroupUpcoming = API.draftGroupUpcomingPromise()
    
    // Draft group by id
    private static var _draftGroupId = [UInt: Promise<DraftGroup>]()
    class func draftGroup(id id: UInt) -> Promise<DraftGroup> {
        if let draftGroup = _draftGroupId[id] {
            return draftGroup
        } else {
            let draftGroup = API.draftGroupPromise(id: id)
            _draftGroupId[id] = draftGroup
            return draftGroup
        }
    }
}