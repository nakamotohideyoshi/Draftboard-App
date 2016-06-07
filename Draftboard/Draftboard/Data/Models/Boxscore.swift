//
//  Boxscore.swift
//  Draftboard
//
//  Created by Anson Schall on 6/3/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class Boxscore {
    let srid: String
    let sridHome: String
    let sridAway: String
    let start: NSDate
    
    init(srid: String, sridHome: String, sridAway: String, start: NSDate) {
        self.srid = srid
        self.sridHome = sridHome
        self.sridAway = sridAway
        self.start = start
    }
    
    convenience init(json: NSDictionary) throws {
        do {
            let srid: String = try json.get("srid")
            let sridHome: String = try json.get("srid_home")
            let sridAway: String = try json.get("srid_away")
            let start: NSDate = try API.dateFromString(try json.get("start"))
            self.init(srid: srid, sridHome: sridHome, sridAway: sridAway, start: start)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
    
}
