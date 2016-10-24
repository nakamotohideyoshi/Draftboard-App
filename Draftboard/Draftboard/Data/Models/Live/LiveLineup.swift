//
//  LiveLineup.swift
//  Draftboard
//
//  Created by Anson Schall on 10/14/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class LiveLineup {
    var id = 0
    var players = [LivePlayer]() { didSet { playerSet = Set(players) } }
    var playerSet = Set<LivePlayer>()
    
    func involves(player: LivePlayer) -> Bool {
        return playerSet.contains(player)
    }
}

func ==(lhs: LiveLineup, rhs: LiveLineup) -> Bool {
    return lhs === rhs || lhs.id == rhs.id
}

extension LiveLineup: Equatable {}