//
//  Lineup.swift
//  Draftboard
//
//  Created by Anson Schall on 11/6/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation

class Lineup: CustomStringConvertible {
    
    let id: Int
    let name: String
    let draftGroupID: Int
    let playerIDs: [Int]
    
    init(id: Int, name: String, draftGroupID: Int, playerIDs: [Int]) {
        self.id = id
        self.name = name
        self.draftGroupID = draftGroupID
        self.playerIDs = playerIDs
    }
    
    convenience init(JSON: NSDictionary) throws {
        do {
            let id: Int = try JSON.get("id")
            let name: String = try JSON.get("name")
            let draftGroupID: Int = try JSON.get("draft_group")
            let playersJSON: [NSDictionary] = try JSON.get("players")
//            playersJSON.sortInPlace { let idx: Int = J
            let playerIDs: [(Int, Int)] = try playersJSON.map {
                (try $0.get("idx"), try $0.get("player_id"))
            }
            let foo = playerIDs.sort { (a, b) in a.0 < a.1 }.map { $0.1 }
//            let foo = playerIDs.sort { ((idxA, _), (idxB, _)) in idxA < idxB }.map { (_, id) in id }
            self.init(id: id, name: name, draftGroupID: draftGroupID, playerIDs: foo)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
    
//    var description: String { return "Lineup: \(id) \(name) \(playerIDs)" }
    
}

class MutableLineup {
    var id: Int?
    var name: String?
    var draftGroupID: Int?
    var playerIDs: [Int?] = []
    
    func copy() -> Lineup? {
        if let id = id, name = name, draftGroupID = draftGroupID {
            if !playerIDs.contains({$0 == nil}) {
                return Lineup(id: id, name: name, draftGroupID: draftGroupID, playerIDs: playerIDs.map {$0!})
            }
        }
        return nil
    }
}

//class LineupWithInfo {
//    let id: Int
//    let name: String
//    let draftGroup: DraftGroupWithInfo
//    let players: [PlayerWithInfo]
//}

    /*
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
        let players = dataPlayers.reverse().map { Player(lineupData: $0) }
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
 */