//
//  Contest.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

class Contest: Model {
    let id: Int
    let name: String
    let sport_id: Int
    let sport: Sport
    
    init(data: [String: Any]) {
        id = data["id"] as! Int
        name = data["name"] as! String
        
        // It's the only sport we have!
        sport_id = 0
        sport = Sport(data: [
            "id": 0,
            "name": "Basketball",
        ])
    }
}