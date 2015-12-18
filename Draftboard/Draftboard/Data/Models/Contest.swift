//
//  Contest.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class Contest: Model {
    var name: String = ""
    var sport: Sport = Sport()
    var status: String = ""
    var start: NSDate = NSDate()
    var buyin: Double = 0.00
    var draftGroup: DraftGroup = DraftGroup()
    var maxEntries: Int = 0
    var prizeStructure: Int = 0
    var prizePool: Double = 0.00
    var entries: Int = 0
    var currentEntries: Int = 0
    var gpp: Bool = false
    var doubleup: Bool = false
    var respawn: Bool = false
    
    convenience init?(data: NSDictionary) {
        self.init()
        
        // JSON
        guard let dataID = data["id"] as? Int,
            dataName = data["name"] as? String,
            dataSport = data["sport"] as? String,
            dataStatus = data["status"] as? String,
            dataStart = data["start"] as? String,
            dataBuyin = data["buyin"] as? Double,
            dataDraftGroup = data["draft_group"] as? Int,
            dataMaxEntries = data["max_entries"] as? Int,
            dataPrizeStructure = data["prize_structure"] as? Int,
            dataPrizePool = data["prize_pool"] as? Double,
            dataEntries = data["entries"] as? Int,
            dataCurrentEntries = data["current_entries"] as? Int,
            dataGPP = data["gpp"] as? Bool,
            dataDoubleup = data["doubleup"] as? Bool,
            dataRespawn = data["respawn"] as? Bool
        else { return nil }
        
        // Dependencies
        guard let sport = Sport(name: dataSport),
            start = Format.date.dateFromString(dataStart)
        else { return nil }

        // Other setup
        let draftGroup = DraftGroup()
        draftGroup.id = dataDraftGroup

        // Assignment
        self.id = dataID
        self.name = dataName
        self.sport = sport
        self.status = dataStatus
        self.start = start
        self.buyin = dataBuyin
        self.draftGroup = draftGroup
        self.maxEntries = dataMaxEntries
        self.prizeStructure = dataPrizeStructure
        self.prizePool = dataPrizePool
        self.entries = dataEntries
        self.currentEntries = dataCurrentEntries
        self.gpp = dataGPP
        self.doubleup = dataDoubleup
        self.respawn = dataRespawn
    }
}
