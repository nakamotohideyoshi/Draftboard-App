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
    let maxEntries: Int
    let prizePool: Double
    let currentEntries: Int
    let skillLevelName: String
    let start: NSDate
    let payoutSpots: [PayoutSpot]
    var payoutIsFlat: Bool { return payoutSpots.uniqBy { $0.value }.count == 1 }
    var payoutDescription: String {
        if payoutIsFlat && payoutSpots.count > 1 {
            return "1st - \(payoutSpots.last!)"
        } else {
            return payoutSpots.map {"\($0)"}.joinWithSeparator(" | ")
        }
    }
    
    init(id: Int, name: String, buyin: Double, draftGroupID: Int, sportName: String, maxEntries: Int, prizePool: Double, currentEntries: Int, skillLevelName: String, start: NSDate, payoutSpots: [PayoutSpot]) {
        self.id = id
        self.name = name
        self.buyin = buyin
        self.draftGroupID = draftGroupID
        self.sportName = sportName
        self.maxEntries = maxEntries
        self.prizePool = prizePool
        self.currentEntries = currentEntries
        self.skillLevelName = skillLevelName
        self.start = start
        self.payoutSpots = payoutSpots
    }
    
    convenience init(json: NSDictionary) throws {
        do {
            let id: Int = try json.get("id")
            let name: String = try json.get("name")
            let buyin: Double = try json.get("buyin")
            let draftGroupID: Int = try json.get("draft_group")
            let sportName: String = try json.get("sport")
            let maxEntries: Int = try json.get("max_entries")
            let prizePool: Double = try json.get("prize_pool")
            let currentEntries: Int = try json.get("current_entries")
            // Skill level
            let skillLevel: NSDictionary = try json.get("skill_level")
            let skillLevelName: String = try skillLevel.get("name")
            // Start
            let start: NSDate = try API.dateFromString(try json.get("start"))
            // Prize structure
            let prizeStructure: NSDictionary = try json.get("prize_structure")
            let prizeRanks: [NSDictionary] = try prizeStructure.get("ranks")
            let payoutSpots: [PayoutSpot] = try prizeRanks.map { try PayoutSpot(json: $0) }
            self.init(id: id, name: name, buyin: buyin, draftGroupID: draftGroupID, sportName: sportName, maxEntries: maxEntries, prizePool: prizePool, currentEntries: currentEntries, skillLevelName: skillLevelName, start: start, payoutSpots: payoutSpots)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }

}
