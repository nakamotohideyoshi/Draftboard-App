//
//  Lineup.swift
//  Draftboard
//
//  Created by Anson Schall on 11/6/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation

class Lineup: Model {
    var name: String = ""
    var sport: Sport = Sport() {
        didSet { didSetSport(sport) }
    }
    var draftGroup: DraftGroup = DraftGroup() {
        didSet { didSetDraftGroup(draftGroup) }
    }
    var players: [Player?] = [Player?]()
    
    convenience init?(data: NSDictionary) {
        self.init()
        
        // JSON
        guard let dataPK = data["pk"] as? Int,
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
        self.id = dataPK
        self.name = dataName
        self.sport = sport
        self.draftGroup = draftGroup
    }
}

// Property observers
extension Lineup {
    func didSetSport(sport: Sport) {
        let positionsCount = sport.positions.count
        self.players = [Player?](count: positionsCount, repeatedValue: nil)
    }
    
    func didSetDraftGroup(draftGroup: DraftGroup) {
        self.sport = draftGroup.sport
    }
}

// Computed properties
extension Lineup {
    var salary: Double {
        get { return players.reduce(0) {$0 + ($1?.salary ?? 0)} }
    }
    var points: Double {
        get { return players.reduce(0) {$0 + ($1?.points ?? 0)} }
    }
}