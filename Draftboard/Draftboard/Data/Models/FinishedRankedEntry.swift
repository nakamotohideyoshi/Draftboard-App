//
//  FinishedRankedEntry.swift
//  Draftboard
//
//  Created by devguru on 8/29/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import Foundation

class FinishedRankedEntry {
    
    let id: Int
    let username: String
    let finalRank: Int
    let payout: Double
    let points: Double
    
    init(id: Int, username: String, finalRank: Int, payout: Double, points: Double) {
        self.id = id
        self.username = username
        self.finalRank = finalRank
        self.payout = payout
        self.points = points
    }
    
    convenience init(JSON: NSDictionary) throws {
        do {
            let id: Int = try JSON.get("id")
            let username: String = try JSON.get("username")
            let finalRank: Int = try JSON.get("final_rank")
            let points: Double = try JSON.get("fantasy_points")
            do {
                let payoutData: NSDictionary = try JSON.get("payout")
                let payout: Double = try payoutData.get("amount")
                self.init(id: id, username: username, finalRank: finalRank, payout: payout, points: points)
            } catch _ {
                self.init(id: id, username: username, finalRank: finalRank, payout: 0.0, points: points)
            }
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}
