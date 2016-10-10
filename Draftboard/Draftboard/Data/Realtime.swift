//
//  Realtime.swift
//  Draftboard
//
//  Created by Anson Schall on 5/12/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation
import PusherSwift

class Realtime {
    static var pusher = Pusher(key: "961cebaf8b45649cc786") // Dev
    static var statsChannel = { return Realtime.getChannel("anson_nfl_stats") }()
    static var boxscoresChannel = { return Realtime.getChannel("anson_boxscores") }()
    
    class func getChannel(channelName: String) -> PusherChannel {
        pusher.connect()
        return pusher.subscribe(channelName)
    }
    
    class func onPlayerStats(callback: (PlayerStats) -> Void) {
        statsChannel.bind("player") { data in
            guard let json = data as? NSDictionary else { return }
            if let stats = try? PlayerStats(JSON: json) {
                callback(stats)
            }
        }
    }
}

class PlayerStats {
    let playerID: Int
    let points: Double
    
    init(playerID: Int, points: Double) {
        self.playerID = playerID
        self.points = points
    }
    
    convenience init(JSON json: NSDictionary) throws {
        let fields: NSDictionary = try json.get("fields")
        let playerID: Int = try fields.get("player_id")
        let points: Double = try fields.get("fantasy_points")
        self.init(playerID: playerID, points: points)
    }
}

protocol DraftGroupPointsListener: class {
    func pointsChanged(playerID: Int)
}

class DraftGroupPoints {
    var points: [Int: Double] = [:]
    weak var delegate: DraftGroupPointsListener?
    
    func pointsForPlayer(player: Player) -> Double {
        return points[player.id] ?? 0
    }
    
    func pointsForLineup(lineup: Lineup) -> Double {
        let players = lineup.players ?? []
        return players.reduce(0) { $0 + pointsForPlayer($1) }
    }
    
    func updateRealtime() {
        
        Realtime.onPlayerStats { stats in
            self.points[stats.playerID] = stats.points
            self.delegate?.pointsChanged(stats.playerID)
        }
    }
}
