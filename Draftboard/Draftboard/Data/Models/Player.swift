//
//  Player.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//
import UIKit

class Player: Model {
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

// Name stuff
extension Player {
    private func setName(name: String) {
        fullName = name
        // First, last names
        var nameComponents = name.componentsSeparatedByString(" ")
        firstName = nameComponents.removeFirst()
        lastName = nameComponents.joinWithSeparator(" ")
        // Short name
        let firstChar = firstName[firstName.startIndex]
        shortName = String(firstChar).uppercaseString + ". " + lastName
    }
}
