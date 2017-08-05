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
        "nhl": 3.0,
        "mlb": 9.0
    ]
    
    static let periodMinutes = [
        "nba": 12.0,
        "nfl": 15.0,
        "nhl": 20.0,
        "mlb": 6.0
    ]
    
    static let gameDuration = [
        "nba": periods["nba"]! * periodMinutes["nba"]!,
        "nfl": periods["nfl"]! * periodMinutes["nfl"]!,
        "nhl": periods["nhl"]! * periodMinutes["nhl"]!,
        "mlb": 18.0 // Half-innings
    ]
    
    static let colors = [
        "mlb": [

//            "29dd9a87-5bcc-4774-80c3-7f50d985068b": [0x333366, 0x231F20, 0xC4CED4],
//            "a7723160-10b7-4277-a309-d8dd95a8ae65": [0xFD5A1E, 0x000000, 0x8B6F4E],
//            "12079497-e414-450a-8bf2-29f91de646bf": [0xCE1141, 0x13274F],
//            "4f735188-37c8-473d-ae32-1f7e34ccf892": [0xBA0021, 0x003263],
//            "d52d5339-cbdd-43f3-9dfa-a42fd588b9a3": [0x002D62, 0xFEC325, 0x7F411C, 0xA0AAB2],
//            "55714da8-fcaf-4574-8443-59bfb511a524": [0xCC3433, 0x0E3386],
//            "f246a5e5-afdb-479c-9aaa-c68beeda7af6": [0xFF5910, 0x002D72],
//            "d89bed32-3aee-4407-99e3-4103641b999a": [0xAB0003, 0x11225B],
//            "03556285-bdbb-4576-a06d-42f71f46ddc5": [0xFF6600, 0x0077C8, 0xFFD100, 0x000000],
//            "2142e1ba-3b40-445c-b8bb-f1f8b1054220": [0x284898, 0xE81828],
//            "1d678440-b4b1-4954-9b39-70afb3ebbcfa": [0x134A8E, 0x1D2D5C, 0xE8291C],
//            "25507be1-6a68-4267-bd82-e097d94b359b": [0xA71930, 0x000000, 0xE3D4AD],
//            "bdc11650-6f74-49c4-875e-778aeb7632d9": [0x092C5C, 0x8FBCE6, 0xF5D130],
//            "75729d34-bca7-4a0f-b3df-6f26c6ad3719": [0xDF4601, 0x000000],
//            "833a51a9-0d84-410f-bd77-da08c3e5e26e": [0x004687, 0xC09A5B],
//            "80715d0d-0d2a-450f-a970-1b9a3b18c7e7": [0xE31937, 0x002B5C],
//            "575c19b7-4052-41c2-9f0a-1c5813d02f99": [0x0C2C56, 0x0C2C56],
//            "27a59d3b-ff7c-48ea-b016-4798f560f5e1": [0x003831, 0xEFB21E],
//            "d99f919b-1534-4516-8e8a-9cd106c6d8cd": [0xC0111F, 0x003278]
            
            //            "ef64da7f-cfaf-4300-87b0-9313386b977c": [UIColor(0xEF3E42), UIColor(0x005A9C)],
            //            "c874a065-c115-4e7d-b0f0-235584fb0e6f": [UIColor(0xC6011F), UIColor(0x000000)],
            //            "44671792-dc02-4fdd-a5ad-f5f17edaa9d7": [UIColor(0xC41E3A), UIColor(0x000066), UIColor(0xFEDB00)],
            //            "47f490cd-2f58-4ef7-9dfd-2ad6ba6c1ae8": [UIColor(0x000000), UIColor(0xC4CED4)],
            //            "aa34e0ed-f342-4ec6-b774-c79b47b60e2d": [UIColor(0x002B5C), UIColor(0xD31145)],
            //            "93941372-eb4c-4c40-aced-fe3267174393": [UIColor(0xBD3039), UIColor(0x0D2B56)],
            //            "43a39081-52b4-4f93-ad29-da7f329ea960": [UIColor(0x0C2C56), UIColor(0x005C5C), UIColor(0xC4CED4)],
            //            "481dfe7e-5dab-46ab-a49f-9dcc2b6e2cfd": [UIColor(0xFDB827), UIColor(0x000000)],
            //            "a09ec676-f887-43dc-bbb3-cf4bbaee9a18": [UIColor(0xE4002B), UIColor(0x003087)],
            //            "eb21dadd-8f10-4095-8bf3-dfb3b779f107": [UIColor(0x002D62), UIColor(0xEB6E1F)],
            //            "dcfd5266-00ce-442c-bc09-264cd20cf455": [UIColor(0x0A2351), UIColor(0xB6922E)],
            //            "29dd9a87-5bcc-4774-80c3-7f50d985068b": [UIColor(0x333366), UIColor(0x231F20), UIColor(0xC4CED4)],
            //            "a7723160-10b7-4277-a309-d8dd95a8ae65": [UIColor(0xFD5A1E), UIColor(0x000000), UIColor(0x8B6F4E)],
            //            "12079497-e414-450a-8bf2-29f91de646bf": [UIColor(0xCE1141), UIColor(0x13274F)],
            //            "4f735188-37c8-473d-ae32-1f7e34ccf892": [UIColor(0xBA0021), UIColor(0x003263)],
            //            "d52d5339-cbdd-43f3-9dfa-a42fd588b9a3": [UIColor(0x002D62), UIColor(0xFEC325), UIColor(0x7F411C), UIColor(0xA0AAB2)],
            //            "55714da8-fcaf-4574-8443-59bfb511a524": [UIColor(0xCC3433), UIColor(0x0E3386)],
            //            "f246a5e5-afdb-479c-9aaa-c68beeda7af6": [UIColor(0xFF5910), UIColor(0x002D72)],
            //            "d89bed32-3aee-4407-99e3-4103641b999a": [UIColor(0xAB0003), UIColor(0x11225B)],
            //            "03556285-bdbb-4576-a06d-42f71f46ddc5": [UIColor(0xFF6600), UIColor(0x0077C8), UIColor(0xFFD100), UIColor(0x000000)],
            //            "2142e1ba-3b40-445c-b8bb-f1f8b1054220": [UIColor(0x284898), UIColor(0xE81828)],
            //            "1d678440-b4b1-4954-9b39-70afb3ebbcfa": [UIColor(0x134A8E), UIColor(0x1D2D5C), UIColor(0xE8291C)],
            //            "25507be1-6a68-4267-bd82-e097d94b359b": [UIColor(0xA71930), UIColor(0x000000), UIColor(0xE3D4AD)],
            //            "bdc11650-6f74-49c4-875e-778aeb7632d9": [UIColor(0x092C5C), UIColor(0x8FBCE6), UIColor(0xF5D130)],
            //            "75729d34-bca7-4a0f-b3df-6f26c6ad3719": [UIColor(0xDF4601), UIColor(0x000000)],
            //            "833a51a9-0d84-410f-bd77-da08c3e5e26e": [UIColor(0x004687), UIColor(0xC09A5B)],
            //            "80715d0d-0d2a-450f-a970-1b9a3b18c7e7": [UIColor(0xE31937), UIColor(0x002B5C)],
            //            "575c19b7-4052-41c2-9f0a-1c5813d02f99": [UIColor(0x0C2C56), UIColor(0x0C2C56)],
            //            "27a59d3b-ff7c-48ea-b016-4798f560f5e1": [UIColor(0x003831), UIColor(0xEFB21E)],
            //            "d99f919b-1534-4516-8e8a-9cd106c6d8cd": [UIColor(0xC0111F), UIColor(0x003278)]
        ]
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
        self.init(id: lineup.id, name: lineup.name, sportName: lineup.sportName, draftGroupID: lineup.draftGroupID, players: lineup.players, start: lineup.start, contests: lineup.contests)
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
