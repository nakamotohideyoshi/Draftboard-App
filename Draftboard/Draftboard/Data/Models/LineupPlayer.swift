//
//  LineupPlayer.swift
//  Draftboard
//
//  Created by Anson Schall on 5/13/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class LineupPlayer {
    let id: Int
    
    init(JSON: NSDictionary) throws {
        do {
            id = try JSON.get("id")
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}
