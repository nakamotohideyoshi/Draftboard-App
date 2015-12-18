//
//  DraftGroup.swift
//  Draftboard
//
//  Created by Anson Schall on 11/19/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation

class DraftGroup: Model {
    var sport: Sport = Sport()
    var start: NSDate = NSDate()
    var numGames: Int = 0
    var players: [Player] = [Player]()
    
    convenience init?(data: NSDictionary) {
        self.init()
        
        // JSON
        guard let dataPK = data["pk"] as? Int,
            dataSport = data["sport"] as? String,
            dataStart = data["start"] as? String,
            dataNumGames = data["num_games"] as? Int
        else { return }
        
        // Dependencies
        guard let sport = Sport(name: dataSport),
            start = Format.date.dateFromString(dataStart)
        else { return nil }
        
        // Assignment
        self.id = dataPK
        self.sport = sport
        self.start = start
        self.numGames = dataNumGames
    }
}
