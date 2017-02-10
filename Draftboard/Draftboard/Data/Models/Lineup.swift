//
//  Lineup.swift
//  Draftboard
//
//  Created by Anson Schall on 11/6/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class Sport {
    
    static let names = ["mlb", "nfl", "nba", "nhl"]
    
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
    
    static let icons = [
        "nba": UIImage(named: "sport-icon-nba")!.imageWithRenderingMode(.AlwaysTemplate),
        "nfl": UIImage(named: "sport-icon-nfl")!.imageWithRenderingMode(.AlwaysTemplate),
        "nhl": UIImage(named: "sport-icon-nhl")!.imageWithRenderingMode(.AlwaysTemplate),
        "mlb": UIImage(named: "sport-icon-mlb")!.imageWithRenderingMode(.AlwaysTemplate),
    ]
    
    static let scoring = [
        "nba": [
            "Point: 1 pt",
            "Assist: 1.5 pts",
            "Rebound: 1.25 pts",
            "Steal: 2 pts",
            "Block: 2 pts",
            "Turnover: -0.5 pts",
        ],
        "nfl": [
            "Passing Yard: 0.04 pts",
            "Passing TD: 4 pts",
            "Interception: -1 pts",
            "Reception: 0.5 pts",
            "Receiving Yard: 0.1 pts",
            "Receiving TD: 6 pts",
            "Rushing Yard: 0.1 pts",
            "Rushing TD: 6 pts",
            "2 Point Conversion: 2 pts",
            "Fumble: -0.1 pts",
        ]
    ]
    
    static let periods = [
        "nba": 4.0,
        "nfl": 4.0,
        "nhl": 3.0
    ]
    
    static let periodMinutes = [
        "nba": 12.0,
        "nfl": 15.0,
        "nhl": 20.0
    ]
    
    static let gameDuration = [
        "nba": periods["nba"]! * periodMinutes["nba"]!,
        "nfl": periods["nfl"]! * periodMinutes["nfl"]!,
        "nhl": periods["nhl"]! * periodMinutes["nhl"]!,
        "mlb": 18.0 // Half-innings
    ]
}

class LineupSlot {
    let name: String
    let description: String
    let positions: [String]
    var player: Player?
    
    init(name: String, description: String, positions: [String], player: Player? = nil) {
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
    var players: [Player]? {
        get { return _players() }
        set { _setPlayers(newValue) }
    }
    var contests:[Int]
    
    init(id: Int? = nil, name: String? = nil, sportName: String, draftGroupID: Int, players: [Player]? = nil, contests: [Int] = []) {
        self.id = id ?? -1
        self.name = name ?? "New Lineup"
        self.sportName = sportName
        self.draftGroupID = draftGroupID
        self.slots = Sport.slotTemplates[sportName]!()
        self.salaryCap = Sport.salaryCaps[sportName]!
        self.contests = contests
        self.players = players
    }
    
    func _players() -> [Player]? {
        let players = slots.flatMap { $0.player }
        return (players.count == slots.count) ? players : nil
    }
    
    func _setPlayers(newValue: [Player]?) {
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
                try Player(JSON: $0)
            }
            var contests:[Int] = []
            if (JSON["contests_by_pool"] != nil) {
                let contestsByPool = JSON["contests_by_pool"] as! NSDictionary
                for (_, value) in contestsByPool {
                    contests += value as! [Int]
                }
            } else {
                
            }
            self.init(id: id, name: name, sportName: sportName, draftGroupID: draftGroupID, players: players, contests:contests)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
    
}

class LineupWithStart: Lineup {
    let start: NSDate
    var isLive: Bool { return NSDate() > start }
    
    init(id: Int? = nil, name: String? = nil, sportName: String, draftGroupID: Int, players: [Player]? = nil, start: NSDate, contests: [Int] = []) {
        self.start = start
        super.init(id: id, name: name, sportName: sportName, draftGroupID: draftGroupID, players: players, contests: contests)
    }
    
    // Intitializer for empty/blank lineup
    convenience init(draftGroup: DraftGroup) {
        self.init(sportName: draftGroup.sportName, draftGroupID: draftGroup.id, start: draftGroup.start)
    }
    
    // Copy
    convenience init(lineup: LineupWithStart) {
        self.init(id: lineup.id, name: lineup.name, sportName: lineup.sportName, draftGroupID: lineup.draftGroupID, players: lineup.players, start: lineup.start)
    }

}

extension Lineup {
    func withStart(start: NSDate) -> LineupWithStart {
        let players = slots.flatMap { $0.player }
        return LineupWithStart(id: id, name: name, sportName: sportName, draftGroupID: draftGroupID, players: players, start: start, contests: contests)
    }
}

// Computed properties
extension Lineup {
    var filledSlots: [LineupSlot] {
        return slots.filter { $0.player != nil }
    }
    var emptySlots: [LineupSlot] {
        return slots.filter { $0.player == nil }
    }
    var salary: Double {
        return slots.reduce(0) {$0 + ($1.player?.salary ?? 0)}
    }
    var totalSalaryRemaining: Double {
        return salaryCap - salary
    }
    var avgSalaryRemaining: Double {
        if emptySlots.count == 0 {
            return 0
        }
        return totalSalaryRemaining / Double(emptySlots.count)
    }
}
