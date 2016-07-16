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

    init(id: Int, contestPoolID: Int, lineupID: Int) {
        self.id = id
        self.contestPoolID = contestPoolID
        self.lineupID = lineupID
    }
    
    convenience init(JSON: NSDictionary) throws {
        do {
            let id: Int = try JSON.get("id")
            let contestPoolID: Int = try JSON.get("contest_pool")
            let lineupID: Int = try JSON.get("lineup")
            self.init(id: id, contestPoolID: contestPoolID, lineupID: lineupID)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}