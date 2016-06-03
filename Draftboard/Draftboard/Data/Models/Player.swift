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
    /*
    convenience init(JSON json: NSDictionary) throws {
        do {
            let id: Int = try json.get("player_id")
            let name: String = try json.get("name")
            let salary: Double = try json.get("salary")
            let position: String = try json.get("position")
            let fppg: Double = try json.get("fppg")
            let teamSRID: String = try json.get("team_srid")
            let gameSRID: String = try json.get("game_srid")
            let srid: String = try json.get("player_srid")
            self.init(id: id, name: name, salary: salary, position: position, fppg: fppg, teamSRID: teamSRID, gameSRID: gameSRID, srid: srid)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }*/

}

class LineupPlayer: Player {
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

class DraftGroupPlayer: Player {
    let position: String
    let gameSRID: String
    
    init(id: Int, name: String, salary: Double, fppg: Double, teamAlias: String, srid: String, position: String, gameSRID: String) {
        self.position = position
        self.gameSRID = gameSRID
        super.init(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid)
    }

    convenience init(JSON json: NSDictionary) throws {
        do {
            let id: Int = try json.get("player_id")
            let name: String = try json.get("name")
            let salary: Double = try json.get("salary")
            let fppg: Double = try json.get("fppg")
            let srid: String = try json.get("player_srid")
            let teamAlias: String = try json.get("team_alias")
            let position: String = try json.get("position")
            let gameSRID: String = try json.get("game_srid")
            self.init(id: id, name: name, salary: salary, fppg: fppg, teamAlias: teamAlias, srid: srid, position: position, gameSRID: gameSRID)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}

    
    /*

    private(set) var firstName: String = ""
    private(set) var lastName: String = ""
    private(set) var shortName: String = ""
    private var fullName: String = ""
    var name: String {
        get { return fullName }
        set { setName(newValue) }
    }
    var salary: Double = 0.00
    var position: String = ""
    var fppg: Double = 0.0
    var team: String = ""
    var image: UIImage = UIImage()
    var points: Double = 0.0
    var injury: String = ""
    
    convenience init?(data: NSDictionary) {
        self.init()
        
        // JSON
        guard let dataPlayerID = data["player_id"] as? Int,
            dataName = data["name"] as? String,
            dataSalary = data["salary"] as? Double,
            dataPosition = data["position"] as? String,
            dataFPPG = data["fppg"] as? Double,
            dataTeamAlias = data["team_alias"] as? String
        else { return nil }
        
        // Other setup
        let image = UIImage()
        
        // Assignment
        self.id = dataPlayerID
        self.name = dataName
        self.salary = dataSalary
        self.position = dataPosition
        self.fppg = dataFPPG
        self.team = dataTeamAlias
        self.image = image
    }
    // Upcoming lineup endpoint gives different json -_-
    convenience init?(lineupData: NSDictionary) {
        self.init()
        
        // JSON
        guard let dataPlayerID = lineupData["player_id"] as? Int,
            dataFullName = lineupData["full_name"] as? String,
//            dataRosterSpot = lineupData["roster_spot"] as? String,
            dataPlayerMeta = lineupData["player_meta"] as? NSDictionary,
            dataTeam = dataPlayerMeta["team"] as? NSDictionary,
            dataTeamName = dataTeam["alias"] as? String
        else { return nil }
        
        // Other setup
        let image = UIImage()
        
        // Assignment
        self.id = dataPlayerID
        self.name = dataFullName
        self.team = dataTeamName
        self.image = image
    }
}
 
 */
 
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
