//
//  LineupFinishedEntry.swift
//  Draftboard
//
//  Created by devguru on 8/9/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import Foundation

class LineupFinishedEntry {
    
    let id: Int
    let finalRank: Int
    let contestID: Int
    let contestName: String
    let payout: Double
    
    init(id: Int, finalRank: Int, contestID: Int, contestName: String, payout: Double) {
        self.id = id
        self.finalRank = finalRank
        self.contestID = contestID
        self.contestName = contestName
        self.payout = payout
    }
    
    convenience init(JSON: NSDictionary) throws {
        do {
            let id: Int = try JSON.get("id")
            let finalRank: Int = try JSON.get("final_rank")
            let contest: NSDictionary = try JSON.get("contest")
            let contestID: Int = try contest.get("id")
            let contestName: String = try contest.get("name")
            let payoutData: NSDictionary = try JSON.get("payout")
            let payout: Double = try payoutData.get("amount")
            self.init(id: id, finalRank: finalRank, contestID: contestID, contestName: contestName, payout: payout)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}