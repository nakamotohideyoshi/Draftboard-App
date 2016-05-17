//
//  DraftGroup.swift
//  Draftboard
//
//  Created by Anson Schall on 11/19/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation

class ShortDraftGroup {
    
    let id: Int
    let sportName: String
    let start: NSDate
    
    init(id: Int, sportName: String, start: NSDate) {
        self.id = id
        self.sportName = sportName
        self.start = start
    }
    
    convenience init(JSON: NSDictionary) throws {
        do {
            let id: Int = try JSON.get("pk")
            let sportName: String = try JSON.get("sport")
            let start: NSDate = try API.dateFromString(try JSON.get("start"))
            self.init(id: id, sportName: sportName, start: start)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }

}

class DraftGroup {
    let id: Int
    let sportName: String
    let start: NSDate
    let players: [Player]
    
    init(id: Int, sportName: String, start: NSDate, players: [Player]) {
        self.id = id
        self.sportName = sportName
        self.start = start
        self.players = players
    }
    
    convenience init(JSON json: NSDictionary) throws {
        do {
            let id: Int = try json.get("pk")
            let sportName: String = try json.get("sport")
            let start: NSDate = try API.dateFromString(try json.get("start"))
            let playersJSON: [NSDictionary] = try json.get("players")
            let players: [Player] = try playersJSON.map { try Player(JSON: $0) }
            self.init(id: id, sportName: sportName, start: start, players: players)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
    
}
/*
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
    }
}
 */
