//
//  Team.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/23/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class Team {
    let id: Int
    let srid: String
    let name: String
    let alias: String
    let city: String
    
    init(id: Int, srid: String, name: String, alias: String, city: String) {
        self.id = id
        self.srid = srid
        self.name = name
        self.alias = alias
        self.city = city
    }
    
    convenience init(JSON json: NSDictionary) throws {
        do {
            let id: Int = try json.get("id")
            let srid: String = try json.get ("srid")
            let name: String = try json.get("name")
            let alias: String = try json.get("alias")
            let city: String = try json.get("city")
            self.init(id: id, srid: srid, name: name, alias: alias, city: city)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
    
}
