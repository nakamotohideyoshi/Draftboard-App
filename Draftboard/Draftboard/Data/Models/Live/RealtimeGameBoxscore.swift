//
//  RealtimeGameBoxscore.swift
//  Draftboard
//
//  Created by Anson Schall on 10/14/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class RealtimeGameBoxscore {
    let game: LiveGame
    let timeRemaining: Double
    
    init(game: LiveGame, timeRemaining: Double) {
        self.game = game
        self.timeRemaining = timeRemaining
    }
    
    convenience init(JSON json: NSDictionary) throws {
        let game: LiveGame = try json.get("srid_game")
        let quarter: Double = try json.get("quarter")
        let clock: String = try json.get("clock")
        
        // Quarter
        let currentPeriod = quarter
        
        // Minutes and seconds
        let clockMinSec = clock.componentsSeparatedByString(":").map { Double($0) ?? 0 }
        let clockMinutes = clockMinSec[0]
        let clockSeconds = clockMinSec[1]
        
        // Sport-specific constants
        let sportPeriods = 4.0
        let sportPeriodMinutes = 15.0
        
        // Determine remaining minutes based on quarters
        let remainingPeriods = (currentPeriod > sportPeriods) ? 0 : sportPeriods - currentPeriod;
        let remainingMinutes = remainingPeriods * sportPeriodMinutes;
        
        // If less than a minute left, then add one minute
        if (clockMinutes == 0 && clockSeconds != 0) {
            self.init(game: game, timeRemaining: remainingMinutes + 1)
        }
        // Round up to the nearest minute by disregarding seconds
        else {
            self.init(game: game, timeRemaining: remainingMinutes + clockMinutes)
        }
    }
}
