//
//  DraftboardEnums.swift
//  Draftboard
//
//  Created by Karl Weber on 9/25/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

enum Sport: String {
    
    case Basketball = "Basketball"
    case Soccer = "Soccer"
    case Baseball = "Baseball"
    case Football = "Football"
    case Lacross = "Lacross"
    case Hockey = "Hockey"
    case Golf = "Golf"
    case Parcheesy = "Parcheesy"
    case SuperSmashBrothers = "Super Smash Brothers"
    
}

enum GameType: String {
    
    case Standard = "Standard"
    case DoubleUp = "Double Up"
    case HeadsUp = "Heads Up"
    
    static var count: Int {return HeadsUp.hashValue + 1}
    
    static var asArray: Array<GameType> {
        var vals: Array<GameType> = [GameType]()
        vals.append(GameType.Standard)
        vals.append(GameType.DoubleUp)
        vals.append(GameType.HeadsUp)
        return vals
    }
    
}