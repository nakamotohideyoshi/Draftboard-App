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
    let id: UInt
    let first_name: String
    let last_name: String
    let fppg: CGFloat
    let team: Team?
    let salary: CGFloat
    let status: PlayerStatus
    
    init(data: NSDictionary) {
        id = data["id"] as! UInt
        first_name = data["first_name"] as! String
        last_name = data["last_name"] as! String
        fppg = 10.0
        
        team = Team(data: [
            "id": 17,
            "abbr": "GSW",
            "short_name": "Warriors",
            "name": "Golden State Warriors"
        ])
        
        salary = 6000.0
        status = Player.statusForCode(100)
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