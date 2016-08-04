//
//  Contest.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class PayoutSpot {
    let rank: Int
    let value: Double
    
    init(rank: Int, value: Double) {
        self.rank = rank
        self.value = value
    }
    
    convenience init(json: NSDictionary) throws {
        do {
            let rank: Int = try json.get("rank")
            let value: Double = try json.get("value")
            self.init(rank: rank, value: value)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}

extension PayoutSpot: CustomStringConvertible {
    var description: String {
        let ordinalRank = Format.ordinal.stringFromNumber(rank)!
        let currencyValue = Format.currency.stringFromNumber(value)!
        return "\(ordinalRank): \(currencyValue)"
    }
}

class Contest {
    
    let id: Int
    let name: String
    let buyin: Double
    let draftGroupID: Int
    let sportName: String
    let skillLevelName: String
    let payoutSpots: [PayoutSpot]
    var payoutIsFlat: Bool { return payoutSpots.uniqBy { $0.value }.count == 1 }
    var payoutDescription: String {
        if payoutIsFlat && payoutSpots.count > 1 {
            return "1st - \(payoutSpots.last!)"
        } else {
            return payoutSpots.map {"\($0)"}.joinWithSeparator(" | ")
        }
    }
    
//    let maxEntries: Int
    // let prizeStructure
//    let prizePool: Double
//    let entries: Int
//    let currentEntries: Int
//    let contestSize: Int
    
    init(id: Int, name: String, buyin: Double, draftGroupID: Int, sportName: String, skillLevelName: String, payoutSpots: [PayoutSpot]) {
        self.id = id
        self.name = name
        self.buyin = buyin
        self.draftGroupID = draftGroupID
        self.sportName = sportName
        self.skillLevelName = skillLevelName
        self.payoutSpots = payoutSpots
    }
    
    convenience init(json: NSDictionary) throws {
        do {
            let id: Int = try json.get("id")
            let name: String = try json.get("name")
            let buyin: Double = try json.get("buyin")
            let draftGroupID: Int = try json.get("draft_group")
            let sportName: String = try json.get("sport")
            // Skill level
            let skillLevel: NSDictionary = try json.get("skill_level")
            let skillLevelName: String = try skillLevel.get("name")
            // Prize structure
            let prizeStructure: NSDictionary = try json.get("prize_structure")
            let prizeRanks: [NSDictionary] = try prizeStructure.get("ranks")
            let payoutSpots: [PayoutSpot] = try prizeRanks.map { try PayoutSpot(json: $0) }
            self.init(id: id, name: name, buyin: buyin, draftGroupID: draftGroupID, sportName: sportName, skillLevelName: skillLevelName, payoutSpots: payoutSpots)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }

}
