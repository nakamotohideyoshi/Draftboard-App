//
//  RealtimePlayerStat.swift
//  Draftboard
//
//  Created by Anson Schall on 10/14/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class RealtimePlayerStat {
    let player: LivePlayer
    let points: Double
    
    init(player: Int, points: Double) {
        self.player = player
        self.points = points
    }
    
    convenience init(JSON json: NSDictionary) throws {
        do {
            let fields: NSDictionary = try json.get("fields")
            let player: Int = try fields.get("player_id")
            let points: Double = try fields.get("fantasy_points")
            self.init(player: player, points: points)
        } catch {
            let player: Int = try json.get("player_id")
            let points: Double = try json.get("fantasy_points")
            self.init(player: player, points: points)
        }
    }
}
