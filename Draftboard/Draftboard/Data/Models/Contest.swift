//
//  Contest.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class Contest: Model {
    var id: UInt!
    var name: String!
    var sport: Sport!
    var status: String!
    var start: NSDate!
    var buyin: Double!
    var draftGroupId: Int!
    var maxEntries: Int!
    var prizeStructureId: Int!
    var prizePool: Double!
    var entries: Int!
    var currentEntries: Int!
    var gpp: Bool!
    var doubleUp: Bool!
    var respawn: Bool!
    
    init?(data: NSDictionary) {
        guard let id = data["id"] as? UInt,
            sport = data["sport"] as? String,
            draftGroup = data["draft_group"] as? Int
        else { return }
        
        self.id = id
        self.sport = Sport.sportWithName(sport)
        self.draftGroupId = draftGroup
    }
}

//private extension NSDate {
//    class func dateFromRFC3339String(string: String) -> NSDate? {
//        let df = NSDateFormatter()
//        df.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
//        return df.dateFromString(string)
//    }
//}
