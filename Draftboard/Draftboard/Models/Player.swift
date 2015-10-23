//
//  Player.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

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
    
//    _ = [
//        "name": "Kevin Korver",
//        "fppg": 25.10,
//        "status": 100,
//        "salary": 25.10,
//        "fppg": 25.10
//    ]
    
    init(data: NSDictionary) {
        id = data["player_id"] as! UInt
        first_name = data["first_name"] as! String
        last_name = data["last_name"] as! String
        fppg = data["fppg"] as! CGFloat
        //team = data["team_id"] as! String
        team = nil
        salary = data["salary"] as! CGFloat
        status = Player.statusForString(data["status"] as! Int)
    }
    
    class func statusForString(status: Int) -> PlayerStatus {
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