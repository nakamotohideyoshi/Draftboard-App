//
//  Lineup.swift
//  Draftboard
//
//  Created by Anson Schall on 11/6/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class Sport {
    
    static let salaryCaps = [
        "nba": 50_000.00,
        "nfl": 50_000.00,
        "nhl": 50_000.00,
        "mlb": 50_000.00,
    ]
    
    static let slotTemplates: [String: () -> [LineupSlot]] = [
        "nfl": {[
            LineupSlot(name: "QB", description: "Quarterback", positions: ["QB"]),
            LineupSlot(name: "RB", description: "Running Back", positions: ["RB", "FB"]),
            LineupSlot(name: "RB", description: "Running Back", positions: ["RB", "FB"]),
            LineupSlot(name: "WR", description: "Wide Receiver", positions: ["WR"]),
            LineupSlot(name: "WR", description: "Wide Receiver", positions: ["WR"]),
            LineupSlot(name: "TE", description: "Tight End", positions: ["TE"]),
            LineupSlot(name: "FX", description: "Flex Player", positions: ["RB", "FB", "WR", "TE"]),
            LineupSlot(name: "FX", description: "Flex Player", positions: ["RB", "FB", "WR", "TE"]),
        ]},
        "nba": {[
            LineupSlot(name: "G", description: "Guard", positions: ["PG", "SG"]),
            LineupSlot(name: "G", description: "Guard", positions: ["PG", "SG"]),
            LineupSlot(name: "F", description: "Forward", positions: ["SF", "PF"]),
            LineupSlot(name: "F", description: "Forward", positions: ["SF", "PF"]),
            LineupSlot(name: "C", description: "Center", positions: ["C"]),
            LineupSlot(name: "FX", description: "Flex Player", positions: ["PG", "SG", "SF", "PF", "C"]),
            LineupSlot(name: "FX", description: "Flex Player", positions: ["PG", "SG", "SF", "PF", "C"]),
            LineupSlot(name: "FX", description: "Flex Player", positions: ["PG", "SG", "SF", "PF", "C"]),
        ]},
        "nhl": {[
            LineupSlot(name: "F", description: "Forward", positions: ["C", "LW", "RW"]),
            LineupSlot(name: "F", description: "Forward", positions: ["C", "LW", "RW"]),
            LineupSlot(name: "F", description: "Forward", positions: ["C", "LW", "RW"]),
            LineupSlot(name: "D", description: "Defenseman", positions: ["D"]),
            LineupSlot(name: "D", description: "Defenseman", positions: ["D"]),
            LineupSlot(name: "FX", description: "Flex Player", positions: ["C", "D", "LW", "RW"]),
            LineupSlot(name: "FX", description: "Flex Player", positions: ["C", "D", "LW", "RW"]),
            LineupSlot(name: "G", description: "Goaltender", positions: ["G"]),
        ]},
        "mlb": {[
            LineupSlot(name: "SP", description: "Starting Pitcher", positions: ["SP"]),
            LineupSlot(name: "C", description: "Catcher", positions: ["C"]),
            LineupSlot(name: "1B", description: "First Baseman", positions: ["1B", "DH"]),
            LineupSlot(name: "2B", description: "Second Baseman", positions: ["2B"]),
            LineupSlot(name: "3B", description: "Third Baseman", positions: ["3B"]),
            LineupSlot(name: "SS", description: "Shortstop", positions: ["SS"]),
            LineupSlot(name: "OF", description: "Outfielder", positions: ["LF", "CF", "RF"]),
            LineupSlot(name: "OF", description: "Outfielder", positions: ["LF", "CF", "RF"]),
            LineupSlot(name: "OF", description: "Outfielder", positions: ["LF", "CF", "RF"]),
        ]},
    ]
}

class LineupSlot {
    let name: String
    let description: String
    let positions: [String]
    var player: LineupPlayer?
    
    init(name: String, description: String, positions: [String], player: LineupPlayer? = nil) {
        self.name = name
        self.description = description
        self.positions = positions
        self.player = player
    }
}

class Lineup {
    let id: Int
    var name: String
    let sportName: String
    let draftGroupID: Int
    var slots: [LineupSlot]
    let salaryCap: Double
    var players: [LineupPlayer]? {
        get { return _players() }
        set { _setPlayers(newValue) }
    }
    
    init(id: Int? = nil, name: String? = nil, sportName: String, draftGroupID: Int, players: [LineupPlayer]? = nil) {
        self.id = id ?? -1
        self.name = name ?? "New Lineup"
        self.sportName = sportName
        self.draftGroupID = draftGroupID
        self.slots = Sport.slotTemplates[sportName]!()
        self.salaryCap = Sport.salaryCaps[sportName]!
        self.players = players
    }
    
    func _players() -> [LineupPlayer]? {
        let players = slots.flatMap { $0.player }
        return (players.count == slots.count) ? players : nil
    }
    
    func _setPlayers(newValue: [LineupPlayer]?) {
        if let players = newValue where players.count == slots.count {
            players.enumerate().forEach { slots[$0].player = $1 }
        }
    }

    // Initializer for api/lineup/upcoming
    convenience init(JSON: NSDictionary) throws {
        do {
            let id: Int = try JSON.get("id")
            let name: String = try JSON.get("name")
            let sportName: String = try JSON.get("sport")
            let draftGroupID: Int = try JSON.get("draft_group")
            let playersJSON: [NSDictionary] = try JSON.get("players")
            let players = try playersJSON.sortBy {
                $0["idx"] as? Int ?? 0 // stdlib sort can't throw
            }.map {
                try LineupPlayer(JSON: $0)
            }
            self.init(id: id, name: name, sportName: sportName, draftGroupID: draftGroupID, players: players)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
    
}

class LineupWithStart: Lineup {
    let start: NSDate
    
    init(id: Int? = nil, name: String? = nil, sportName: String, draftGroupID: Int, players: [LineupPlayer]? = nil, start: NSDate) {
        self.start = start
        super.init(id: id, name: name, sportName: sportName, draftGroupID: draftGroupID, players: players)
    }
    
    // Intitializer for empty/blank lineup
    convenience init(draftGroup: DraftGroup) {
        self.init(sportName: draftGroup.sportName, draftGroupID: draftGroup.id, start: draftGroup.start)
    }

}

extension Lineup {
    func withStart(start: NSDate) -> LineupWithStart {
        let players = slots.flatMap { $0.player }
        return LineupWithStart(id: id, name: name, sportName: sportName, draftGroupID: draftGroupID, players: players, start: start)
    }
}

/*
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