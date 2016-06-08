//
//  DraftGroup.swift
//  Draftboard
//
//  Created by Anson Schall on 11/19/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation

class DraftGroup {
    
    let id: Int
    let sportName: String
    let start: NSDate
    let numGames: Int
    
    init(id: Int, sportName: String, start: NSDate, numGames: Int) {
        self.id = id
        self.sportName = sportName
        self.start = start
        self.numGames = numGames
    }
    
    convenience init(JSON: NSDictionary) throws {
        do {
            let id: Int = try JSON.get("pk")
            let sportName: String = try JSON.get("sport")
            let start: NSDate = try API.dateFromString(try JSON.get("start"))
            let numGames: Int = try JSON.get("num_games")
            self.init(id: id, sportName: sportName, start: start, numGames: numGames)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }

}

class DraftGroupWithPlayers {
    let id: Int
    let sportName: String
    let start: NSDate
    let players: [PlayerWithPosition]
    
    init(id: Int, sportName: String, start: NSDate, players: [PlayerWithPosition]) {
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
            let players: [PlayerWithPosition] = try playersJSON.map { try PlayerWithPosition(JSON: $0) }
            self.init(id: id, sportName: sportName, start: start, players: players)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
    
}

class DraftGroupWithContestCount: DraftGroup {
    let contestCount: Int
    
    init(id: Int, sportName: String, start: NSDate, numGames: Int, contestCount: Int) {
        self.contestCount = contestCount
        super.init(id: id, sportName: sportName, start: start, numGames: numGames)
    }
}

extension DraftGroup {
    func withContestCount(contestCount: Int) -> DraftGroupWithContestCount {
        return DraftGroupWithContestCount(id: id, sportName: sportName, start: start, numGames: numGames, contestCount: contestCount)
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
