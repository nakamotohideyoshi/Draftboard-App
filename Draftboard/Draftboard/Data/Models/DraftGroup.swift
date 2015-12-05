//
//  DraftGroup.swift
//  Draftboard
//
//  Created by Anson Schall on 11/19/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation

class DraftGroup {
    var id: UInt!
    var sport: Sport!
    var start: NSDate!
    var numGames: Int!
    var players: [Player]?
    
    init(data: NSDictionary) {
        guard let pk = data["pk"] as? UInt,
            sport = data["sport"] as? String,
            start = data["start"] as? String,
            numGames = data["num_games"] as? Int
        else { return }
        
        self.id = pk
        self.sport = Sport.sportWithName(sport)
        self.start = NSDate.dateFromRFC3339String(start)
        self.numGames = numGames
    }
}

private extension NSDate {
    class func dateFromRFC3339String(string: String) -> NSDate? {
        let df = NSDateFormatter()
        df.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        return df.dateFromString(string)
    }
}
