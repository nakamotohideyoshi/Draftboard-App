//
//  ContestPoolEntry.swift
//  Draftboard
//
//  Created by Anson Schall on 7/15/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class ContestPoolEntry {
    
    let id: Int
    let contestPoolID: Int
    let lineupID: Int
    let lineupName: String

    init(id: Int, contestPoolID: Int, lineupID: Int, lineupName: String) {
        self.id = id
        self.contestPoolID = contestPoolID
        self.lineupID = lineupID
        self.lineupName = lineupName
    }
    
    convenience init(JSON: NSDictionary) throws {
        do {
            let id: Int = try JSON.get("id")
            let contestPoolID: Int = try JSON.get("contest_pool")
            let lineupID: Int = try JSON.get("lineup")
            let lineupName: String = try JSON.get("lineup_name")
            self.init(id: id, contestPoolID: contestPoolID, lineupID: lineupID, lineupName: lineupName)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}
