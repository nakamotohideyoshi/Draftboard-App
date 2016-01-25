//
//  DraftGroup.swift
//  Draftboard
//
//  Created by Anson Schall on 11/19/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation

class DraftGroup: Model {
    var sport: Sport = Sport()
    var start: NSDate = NSDate.distantPast()
    var numGames: Int = 0
    var players: [Player] = [Player]()
    var complete: Bool = false
    
    convenience init?(upcomingData data: NSDictionary) {
        self.init()
        
        // JSON
        guard let dataPK = data["pk"] as? Int,
            dataStart = data["start"] as? String,
            dataSport = data["sport"] as? String,
            dataNumGames = data["num_games"] as? Int
        else {
            log("Failed to parse JSON")
            return nil
        }
        
        // Dependencies
        guard let sport = Sport(name: dataSport),
            start = Format.date.dateFromString(dataStart)
        else {
            log("Failed to create dependencies")
            return nil
        }
        
        // Assignment
        self.id = dataPK
        self.start = start
        self.sport = sport
        self.numGames = dataNumGames
    }
    
    convenience init?(idData data: NSDictionary) {
        self.init()
        
        // JSON
        guard let dataPK = data["pk"] as? Int,
            dataStart = data["start"] as? String,
            dataSport = data["sport"] as? String,
            dataPlayers = data["players"] as? [NSDictionary]
        else {
            log("Failed to parse JSON")
            return nil
        }
        
        // Dependencies
        let players = dataPlayers.flatMap { Player(data: $0) }
        guard players.count == dataPlayers.count,
            let sport = Sport(name: dataSport),
            start = Format.date.dateFromString(dataStart)
        else {
            log("Failed to create dependencies")
            return nil
        }
        
        // Assignment
        self.id = dataPK
        self.start = start
        self.sport = sport
        self.players = players
        
        complete = true
    }
}
