//
//  Sport.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//
import Foundation

class Sport: Model {
    var name: String!
    var positions: [String]!
    var salary: Double!

    private init?(data: NSDictionary) {
        super.init()
        
        guard let name = data["name"] as? String,
            positions = data["positions"] as? [String],
            salary = data["salary"] as? Double
        else { return nil }
        
        self.name = name
        self.positions = positions
        self.salary = salary
    }
}

extension Sport {
    private static let sports: [String: Sport] = [
        "nba": Sport(data: [
            "name": "nba",
            "positions": ["PG", "SG", "SF", "PF", "C", "FX", "FX", "FX"],
            "salary": 50000
            ])!,
        "nhl": Sport(data: [
            "name": "nhl",
            "positions": ["PG", "SG", "SF", "PF", "C", "FX", "FX", "FX"],
            "salary": 50000
            ])!
    ]
    
    class func sportWithName(name: String) -> Sport {
        return Sport.sports[name]!
    }
}

