//
//  Player.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class Player {
    let id: Int
    let name: String
    let salary: Double
    let fppg: Double
    let teamAlias: String
    let srid: String
    
    init(id: Int, name: String, salary: Double, fppg: Double, teamAlias: String, srid: String) {
        self.id = id
        self.name = name
        self.salary = salary
        self.fppg = fppg
        self.teamAlias = teamAlias
        self.srid = srid
    }

    // Used by upcoming lineups API endpoint
    convenience init(JSON json: NSDictionary) throws {
        do {
            let id: Int = try json.get("player_id")
            let name: String = try json.get("full_name")
            let salary: Double = try json.get("salary")
            let fppg: Double = try json.get("fppg")
            let meta: NSDictionary = try json.get("player_meta")
            let srid: String = try meta.get("srid")
            let team: NSDictionary = try meta.get("team")
            let teamAlias: String = try team.get("alias")
            self.init(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}

class PlayerWithPosition: Player {
    let position: String
    
    init(id: Int, name: String, salary: Double, fppg: Double, teamAlias: String, srid: String, position: String) {
        self.position = position
        super.init(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid)
    }
    
    // Used by draftgroup id API endpoint
    convenience init(JSON json: NSDictionary) throws {
        do {
            let id: Int = try json.get("player_id")
            let name: String = try json.get("name")
            let salary: Double = try json.get("salary")
            let fppg: Double = try json.get("fppg")
            let srid: String = try json.get("player_srid")
            let teamAlias: String = try json.get("team_alias")
            let position: String = try json.get("position")
            self.init(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid, position: position)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}

class PlayerWithGame: Player {
    let team: Team
    let game: Game
    
    init(id: Int, name: String, salary: Double, fppg: Double, teamAlias: String, srid: String, game: Game) {
        self.team = (teamAlias == game.home.alias) ? game.home : game.away
        self.game = game
        super.init(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid)
    }
}

extension Player {
    func withGame(game: Game) -> PlayerWithGame {
        return PlayerWithGame(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid, game: game)
    }
}

// Name stuff
extension Player {
    var firstName: String {
        var nameComponents = name.componentsSeparatedByString(" ")
        return nameComponents.removeFirst()
    }
    
    var lastName: String {
        var nameComponents = name.componentsSeparatedByString(" ")
        nameComponents.removeFirst()
        return nameComponents.joinWithSeparator(" ")
    }
    
    var shortName: String {
        let firstLetter = String(firstName[firstName.startIndex])
        return "\(firstLetter). \(lastName)"
    }
}

func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.id == rhs.id
}

extension Player: Equatable { }

