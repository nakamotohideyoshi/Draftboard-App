
//  ContestWithEntries.swift
//  Draftboard
//
//  Created by Anson Schall on 8/8/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

protocol HasEntries {
    var entries: [ContestPoolEntry] { get }
}

class ContestWithEntries: Contest, HasEntries {
    
    let entries: [ContestPoolEntry]
    
    init(id: Int, name: String, buyin: Double, draftGroupID: Int, sportName: String, skillLevelName: String, start: NSDate, payoutSpots: [PayoutSpot], entries: [ContestPoolEntry]) {
        self.entries = entries
        super.init(id: id, name: name, buyin: buyin, draftGroupID: draftGroupID, sportName: sportName, skillLevelName: skillLevelName, start: start, payoutSpots: payoutSpots)
    }
    
}

extension Contest {
    func withEntries(entries: [ContestPoolEntry]) -> ContestWithEntries {
        return ContestWithEntries(id: id, name: name, buyin: buyin, draftGroupID: draftGroupID, sportName: sportName, skillLevelName: skillLevelName, start: start, payoutSpots: payoutSpots, entries: entries)
    }
}