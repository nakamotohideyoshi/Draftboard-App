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
    static var prefix = "anson_"
    static var pusher = Pusher(key: "961cebaf8b45649cc786") // Dev
    
    class func getChannel(channelName: String) -> PusherChannel {
        pusher.connect()
        return pusher.subscribe(prefix + channelName)
    }
    
    class func onPlayerStat(for sportName: String, callback: RealtimePlayerStat -> Void) {
        let statsChannel = getChannel(sportName + "_stats")
        statsChannel.bind("player") { data in
            guard let json = data as? NSDictionary else { return }
            if let stat = try? RealtimePlayerStat(JSON: json) {
                callback(stat)
            }
        }
    }
    
    class func onGameBoxscore(for sportName: String, callback: RealtimeGameBoxscore -> Void) {
        let boxscoresChannel = getChannel("boxscores")
        boxscoresChannel.bind("game") { data in
            guard let json = data as? NSDictionary else { return }
            if let boxscore = try? RealtimeGameBoxscore(JSON: json, sportName: sportName) {
                callback(boxscore)
            }
        }
    }
}
