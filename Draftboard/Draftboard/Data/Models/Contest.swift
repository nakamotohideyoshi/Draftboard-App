//
//  Contest.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class Contest {
    
    let id: Int
    let name: String
//    let buyin: Double
    let draftGroupID: Int
//    let maxEntries: Int
    // let prizeStructure
//    let prizePool: Double
//    let entries: Int
//    let currentEntries: Int
//    let contestSize: Int
    
    init(id: Int, name: String, draftGroupID: Int) {
        self.id = id
        self.name = name
        self.draftGroupID = draftGroupID
    }
    
    convenience init(json: NSDictionary) throws {
        do {
            let id: Int = try json.get("id")
            let name: String = try json.get("name")
            let draftGroupID: Int = try json.get("draft_group")
            self.init(id: id, name: name, draftGroupID: draftGroupID)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }

}
