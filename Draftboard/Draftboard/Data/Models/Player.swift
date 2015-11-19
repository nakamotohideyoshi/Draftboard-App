//
//  Player.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//
import UIKit

enum PlayerStatus {
    case Injured
    case None
}

class Player: Model {
    var id: UInt?
    var name: String?
    var position: String?
    var fppg: CGFloat?
    var team: String?
    var salary: CGFloat?
    var status: PlayerStatus?
    
    init(data: NSDictionary) {
        id = data["player_id"] as! UInt?
        name = data["name"] as! String?
        position = data["position"] as! String?
        fppg = data["fppg"] as! CGFloat?
        team = data["team_alias"] as! String?
        salary = data["salary"] as! CGFloat?
        status = Player.statusForCode(100)
    }
    
    func shortName() -> String {
        if let fullName = name {
            let nameArr = fullName.characters.split{$0 == " "}.map(String.init)
            let firstName = nameArr[0]
            let lastName = nameArr[1]
            let firstChar = firstName[firstName.startIndex]
            return String(firstChar).uppercaseString + ". " + lastName
        }
        
        return ""
    }
    
    class func statusForCode(status: Int) -> PlayerStatus {
        switch (status) {
            case 100:
                return .Injured
            default:
                return .None
        }
    }
    
    class func stringForStatus(status: PlayerStatus) -> String {
        switch (status) {
        case .Injured:
            return "INJ"
        case .None:
            return ""
        }
    }
}