//
//  Sport.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/22/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//
import Foundation

/*
class Sport: Model {
    var name: String = ""
    var positions: [String] = [String]()
    var positionMatches: [[String]] = [[String]]()
    var salary: Double = 0.00

    convenience init?(name: String) {
        self.init()
        
        // Pre-defined sport data
        guard let positions = Sport.positions[name],
            positionMatches = Sport.positionMatches[name],
            salary = Sport.salaries[name]
        else { return nil }

        // Assignment
        self.name = name
        self.positions = positions
        self.positionMatches = positionMatches
        self.salary = salary
    }
}

extension Sport {
    private static let positions: [String: [String]] = [
        "nba": ["G", "G", "F", "F", "C", "FX", "FX", "FX"],
        "nhl": ["PG", "SG", "SF", "PF", "C", "FX", "FX", "FX"],
    ]
    private static let positionMatches: [String: [[String]]] = [
        "nba": [["PG", "SG"], ["PG", "SG"], ["SF", "PF"], ["SF", "PF"], ["C"], [], [], []],
        "nhl": [["PG", "SG"], ["PG", "SG"], ["SF", "PF"], ["SF", "PF"], ["C"], [], [], []],
    ]
    private static let salaries: [String: Double] = [
        "nba": 50_000.00,
        "nhl": 50_000.00,
    ]
}

*/