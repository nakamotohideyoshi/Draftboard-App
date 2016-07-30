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
    let buyin: Double
    let draftGroupID: Int
    let sportName: String
    let skillLevelName: String
//    let maxEntries: Int
    // let prizeStructure
//    let prizePool: Double
//    let entries: Int
//    let currentEntries: Int
//    let contestSize: Int
    
    init(id: Int, name: String, buyin: Double, draftGroupID: Int, sportName: String, skillLevelName: String) {
        self.id = id
        self.name = name
        self.buyin = buyin
        self.draftGroupID = draftGroupID
        self.sportName = sportName
        self.skillLevelName = skillLevelName
    }
    
    convenience init(json: NSDictionary) throws {
        do {
            let id: Int = try json.get("id")
            let name: String = try json.get("name")
            let buyin: Double = try json.get("buyin")
            let draftGroupID: Int = try json.get("draft_group")
            let sportName: String = try json.get("sport")
            let skillLevel: NSDictionary = try json.get("skill_level")
            let skillLevelName: String = try skillLevel.get("name")
            self.init(id: id, name: name, buyin: buyin, draftGroupID: draftGroupID, sportName: sportName, skillLevelName: skillLevelName)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }

}
