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
    
    class func onPlayerStat(callback: (RealtimePlayerStat) -> Void) {
        statsChannel.bind("player") { data in
            guard let json = data as? NSDictionary else { return }
            if let stat = try? RealtimePlayerStat(JSON: json) {
                callback(stat)
            }
        }
    }
    
    class func onGameBoxscore(callback: (RealtimeGameBoxscore) -> Void) {
        boxscoresChannel.bind("game") { data in
            guard let json = data as? NSDictionary else { return }
            if let boxscore = try? RealtimeGameBoxscore(JSON: json) {
                callback(boxscore)
            }
        }
    }
}
