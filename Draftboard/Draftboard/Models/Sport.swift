//
//  Sport.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

class Sport: Model {
    let id: Int
    let name: String
    
    init(data: NSDictionary) {
        id = data["id"] as! Int
        name = data["name"] as! String
    }
}
