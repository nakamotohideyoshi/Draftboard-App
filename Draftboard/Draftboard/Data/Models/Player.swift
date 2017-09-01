//
//  Player.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

protocol HasPosition {
    var position: String { get }
    var teamSRID: String { get }
}

protocol HasGame {
    var team: Team { get }
    var game: Game { get }
}

class Player {
    let id: Int
    let name: String
    let salary: Double
    let fppg: Double
    let teamAlias: String
    let srid: String
    var stat: NSDictionary?
    
    init(id: Int, name: String, salary: Double, fppg: Double, teamAlias: String, srid: String, stat: NSDictionary? = nil) {
        self.id = id
        self.name = name
        self.salary = salary
        self.fppg = fppg
        self.teamAlias = teamAlias
        self.srid = srid
        self.stat = stat
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
            let player_stats: [NSDictionary] = try json.get("player_stats")
            let player_stat: NSDictionary?
            
            if player_stats.count > 0 {
                player_stat = player_stats[0]
            } else {
                player_stat = nil
            }
            self.init(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid, stat: player_stat)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}

class PlayerWithPosition: Player, HasPosition {
    let position: String
    let teamSRID: String
    
    init(id: Int, name: String, salary: Double, fppg: Double, teamAlias: String, srid: String, stat: NSDictionary?, position: String, teamSRID: String) {
        self.position = position
        self.teamSRID = teamSRID
        super.init(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid, stat: stat)
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
            let teamSRID: String = try json.get("team_srid")
            let position: String = try json.get("position")
            self.init(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid, stat: nil, position: position, teamSRID: teamSRID)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}

class PlayerWithPositionAndGame: PlayerWithPosition, HasGame {
    let team: Team
    let game: Game
    
    init(id: Int, name: String, salary: Double, fppg: Double, teamAlias: String, srid: String, stat: NSDictionary?, position: String, teamSRID: String, game: Game) {
        self.team = (teamAlias == game.home.alias) ? game.home : game.away
        self.game = game
        super.init(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid, stat: stat, position: position, teamSRID: teamSRID)
    }
}

extension PlayerWithPosition {
    func withGame(game: Game) -> PlayerWithPositionAndGame {
        return PlayerWithPositionAndGame(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid, stat: stat, position: position, teamSRID: teamSRID, game: game)
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

extension Player: Equatable {}

extension Player: Hashable {
    var hashValue: Int {
        return srid.hashValue
    }
}
