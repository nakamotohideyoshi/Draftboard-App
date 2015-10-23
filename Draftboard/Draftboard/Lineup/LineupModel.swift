//
//  LineupModel.swift
//  Draftboard
//
//  Created by Karl Weber on 9/24/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupModel: NSObject {

    var name: String = "Warriors Stack"
    var sport: SportType = .Basketball
    
    override init() {
        super.init()
        
        
        let team = Int(arc4random_uniform(6)) + 1
        var team_name: String
        switch team {
        case 1:
            team_name = "Warriors"
        case 2:
            team_name = "Raiders"
        case 3:
            team_name = "Soldiers"
        case 4:
            team_name = "Militia"
        case 5:
            team_name = "Braves"
        case 6:
            team_name = "Renegades"
        case 7:
            team_name = "Mercenaries"
        default:
            team_name = "Bunnies"
        }
        
        let adjective = Int(arc4random_uniform(10)) + 1
        var adjective_name: String
        switch adjective {
        case 1:
            adjective_name = "Group"
        case 2:
            adjective_name = "Stack"
        case 3:
            adjective_name = "2"
        case 4:
            adjective_name = "3"
        case 5:
            adjective_name = "4"
        case 6:
            adjective_name = "No Charlie"
        case 7:
            adjective_name = "Test"
        default:
            adjective_name = ""
        }
        
        name = "\(team_name) \(adjective_name)"
        
    }
    
//    func feeDescription() -> String {
//        return "$\(fee) FEE / $\(prizes) PRIZES"
//    }
    
}
