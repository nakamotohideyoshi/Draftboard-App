//
//  Lineup.swift
//  Draftboard
//
//  Created by Anson Schall on 11/6/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation
import UIKit

class Lineup: Model {
    var name: String = ""
    var sport: Sport = Sport() {
        didSet { didSetSport(sport) }
    }
    var draftGroup: DraftGroup = DraftGroup() {
        didSet { didSetDraftGroup(draftGroup) }
    }
    var players: [Player?] = [Player?]()
    var cardScrollPos: CGPoint = CGPointMake(0, 44.0)
    
    convenience init?(data: NSDictionary) {
        self.init()
        
        // JSON
        guard let dataID = data["id"] as? Int,
            dataName = data["name"] as? String,
            dataSport = data["sport"] as? String,
            dataDraftGroup = data["draft_group"] as? Int
        else { return nil }
        
        // Dependencies
        guard let sport = Sport(name: dataSport)
        else { return nil }
        
        // Other setup
        let draftGroup = DraftGroup()
        draftGroup.id = dataDraftGroup
        
        // Assignment
        self.id = dataID
        self.name = dataName
        self.sport = sport
        self.draftGroup = draftGroup
    }
    
    convenience init?(upcomingData data: NSDictionary) {
        self.init()
        
        // JSON
        guard let dataID = data["id"] as? Int,
            dataName = data["name"] as? String,
            dataSport = data["sport"] as? String,
            dataDraftGroup = data["draft_group"] as? Int,
            dataPlayers = data["players"] as? [NSDictionary]
        else {
            log("Failed to parse JSON")
            return nil
        }
        
        // Dependencies
        let players = dataPlayers.map { Player(lineupData: $0) }
        guard players.count == dataPlayers.count,
            let sport = Sport(name: dataSport)
        else {
            log("Failed to create dependencies")
            return nil
        }

        // Other setup
        let draftGroup = DraftGroup()
        draftGroup.id = dataDraftGroup
        
        // Assignment
        self.id = dataID
        self.name = dataName
        self.sport = sport
        self.draftGroup = draftGroup
        self.players = players
    }
}

// Property observers
extension Lineup {
    func didSetSport(sport: Sport) {
        if players.count == 0 {
            let positionsCount = sport.positions.count
            self.players = [Player?](count: positionsCount, repeatedValue: nil)
        }
    }
    
    func didSetDraftGroup(draftGroup: DraftGroup) {
        if players.count > 0 && draftGroup.players.count > 0 {
            for (i, player) in players.enumerate() {
                for draftGroupPlayer in draftGroup.players {
                    if player?.id == draftGroupPlayer.id {
                        players[i] = draftGroupPlayer
                    }
                }
            }
        }
        self.sport = draftGroup.sport
    }
}

// Computed properties
extension Lineup {
    private var flatPlayers: [Player] {
        get { return players.flatMap {$0} }
    }
    var salary: Double {
        get { return flatPlayers.reduce(0) {$0 + $1.salary} }
    }
    var points: Double {
        get { return flatPlayers.reduce(0) {$0 + $1.points} }
    }
    var mvp: Player? {
        get { return flatPlayers.sort {$0.salary > $1.salary}.first }
    }
}