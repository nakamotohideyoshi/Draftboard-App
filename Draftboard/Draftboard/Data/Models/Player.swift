//
//  Player.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//
import UIKit

class Player: Model {
    var id: UInt!
    var name: String!
    var salary: Double!
    var position: String!
    var fppg: Double!
    var team: String!
    var image: UIImage!
    var points: Double = 0
    
    init?(data: NSDictionary) {
        super.init()
        
        guard let player_id = data["player_id"] as? UInt,
            name = data["name"] as? String,
            salary = data["salary"] as? Double,
            position = data["position"] as? String,
            fppg = data["fppg"] as? Double,
            team_alias = data["team_alias"] as? String
        else { return nil }
        
        self.id = player_id
        self.name = name
        self.salary = salary
        self.position = position
        self.fppg = fppg
        self.team = team_alias
        self.image = UIImage()
    }
    
    func shortName() -> String {
        let nameArr = name.characters.split{$0 == " "}.map(String.init)
        let firstName = nameArr[0]
        let lastName = nameArr[1]
        let firstChar = firstName[firstName.startIndex]
        return String(firstChar).uppercaseString + ". " + lastName
    }
}