//
//  Game.swift
//  Draftboard
//
//  Created by Anson Schall on 6/3/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class Game {
    let srid: String
    let home: Team
    let away: Team
    let start: NSDate
    
    init(srid: String, home: Team, away: Team, start: NSDate) {
        self.srid = srid
        self.home = home
        self.away = away
        self.start = start
    }
}