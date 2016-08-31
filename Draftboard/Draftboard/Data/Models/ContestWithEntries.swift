
//  ContestWithEntries.swift
//  Draftboard
//
//  Created by Anson Schall on 8/8/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation
import PromiseKit

protocol HasEntries: class {
    var entries: [ContestPoolEntry] { get }
    var maxEntries: Int { get }
}

extension HasEntries {
    var maxEntriesReached: Bool {
        return entries.count == maxEntries
    }
}

class ContestWithEntries: Contest, HasEntries {
    
    let entries: [ContestPoolEntry]
    
    init(id: Int, name: String, buyin: Double, draftGroupID: Int, sportName: String, maxEntries: Int, prizePool: Double, currentEntries: Int, skillLevelName: String, start: NSDate, payoutSpots: [PayoutSpot], entries: [ContestPoolEntry]) {
        self.entries = entries
        super.init(id: id, name: name, buyin: buyin, draftGroupID: draftGroupID, sportName: sportName, maxEntries: maxEntries, prizePool: prizePool, currentEntries: currentEntries, skillLevelName: skillLevelName, start: start, payoutSpots: payoutSpots)
    }
    
}

extension Contest {
    func withEntries(entries: [ContestPoolEntry]) -> ContestWithEntries {
        return ContestWithEntries(id: id, name: name, buyin: buyin, draftGroupID: draftGroupID, sportName: sportName, maxEntries: maxEntries, prizePool: prizePool, currentEntries: currentEntries, skillLevelName: skillLevelName, start: start, payoutSpots: payoutSpots, entries: entries)
    }
}
