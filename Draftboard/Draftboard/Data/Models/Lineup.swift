//
//  Lineup.swift
//  Draftboard
//
//  Created by Anson Schall on 11/6/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class Lineup: Model {
    var id: UInt!
    var name: String!
    var sport: Sport!
    var draftGroupId: UInt!
    var players: [Player]!
    var salary: Double {
        get {
            return players.reduce(0) {$0 + $1.salary}
        }
    }
    var points: Double {
        get {
            return players.reduce(0) {$0 + $1.points}
        }
    }
    
    init?(data: NSDictionary) {
        super.init()
        
        guard let id = data["id"] as? UInt,
            name = data["name"] as? String,
            sport = data["sport"] as? String,
            draft_group = data["draft_group"] as? UInt
        else { return nil }
        
        self.id = id
        self.name = name
        self.sport = Sport.sportWithName(sport)
        self.draftGroupId = draft_group
    }
}
