//
//  LiveDraftGroup.swift
//  Draftboard
//
//  Created by Anson Schall on 10/14/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class LiveDraftGroup {
    var id = 0
    var sportName = ""
    var points = [LivePlayer: Double]()
    var timeRemaining = [LiveGame: Double]()
    var listeners = [LiveDraftGroupListener]()
    
    func points(for player: LivePlayer) -> Double {
        return points[player] ?? 0
    }
    
    func points(for lineup: LiveLineup) -> Double {
        return lineup.players.reduce(0) { $0 + points(for: $1) }
    }
    
    func timeRemaining(for game: LiveGame) -> Double {
        return timeRemaining[game] ?? 0
    }
    
    func startRealtime() {
        Realtime.onPlayerStat(for: sportName) { stat in
            self.points[stat.player] = stat.points
            self.listeners.forEach { $0.pointsChanged(stat.player) }
        }
        Realtime.onGameBoxscore(for: sportName) { boxscore in
            self.timeRemaining[boxscore.game] = boxscore.timeRemaining
            self.listeners.forEach { $0.timeRemainingChanged(boxscore.game) }
        }
    }
}

protocol LiveDraftGroupListener {
    func pointsChanged(player: LivePlayer)
    func timeRemainingChanged(game: LiveGame)
}

extension LiveDraftGroupListener {
    func pointsChanged(player: LivePlayer) {}
    func timeRemainingChanged(game: LiveGame) {}
}

