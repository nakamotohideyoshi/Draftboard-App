//
//  LiveContest.swift
//  Draftboard
//
//  Created by Anson Schall on 10/14/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class LiveContest {
    var id = 0
    var sportName = ""
    var contestName = ""
    var contestSize = 0
    var poolID = 0
    var draftGroupID = 0
    var draftGroup = LiveDraftGroup() { didSet { rankLineups() } }
    var lineups = [LiveLineup]()
    var prizes = [Double]()
    var listener: LiveContestListener?
    
    func setLineups(hexString hexString: String, sportName: String) {
        // First 12 chars are trash
        let s: NSString = (hexString as NSString).substringFromIndex(12)
        let idChars = 8
        let playerChars = 4
        let playerCount = Sport.slotTemplates[sportName]?().count ?? 8
        let lineupChars = idChars + playerChars * playerCount
        let lineupCount = s.length / lineupChars
        
        var lineups = [LiveLineup]()
        for i in 0..<lineupCount {
            let offset = i * lineupChars
            let lineupID = Int(s.substringWithRange(NSMakeRange(offset, idChars)), radix: 16)!
            
            var lineupPlayers = [LivePlayer]()
            for j in 0..<playerCount {
                let offset = (i * lineupChars) + idChars + (j * playerChars)
                let player = Int(s.substringWithRange(NSMakeRange(offset, playerChars)), radix: 16)!
                lineupPlayers.append(player)
            }
            
            let lineup = LiveLineup()
            lineup.id = lineupID
            lineup.players = lineupPlayers
            lineups.append(lineup)
        }
        
        self.lineups = lineups
    }
    
    func rankLineups() {
        let asPreviouslyRanked = lineups
        lineups = lineups.sort {
            draftGroup.points(for: $0) > draftGroup.points(for: $1)
        }
        if asPreviouslyRanked != lineups {
            listener?.rankChanged()
        }
    }
    
    func involves(player: LivePlayer) -> Bool {
        for lineup in lineups {
            if lineup.involves(player) { return true }
        }
        return false
    }
}

extension LiveContest: LiveDraftGroupListener {
    func pointsChanged(player: LivePlayer) {
        if self.involves(player) {
            print("contest involves player")
            rankLineups()
        }
    }
}

protocol LiveContestListener {
    func rankChanged()
}

extension LiveContestListener {
    func rankChanged() {}
}
