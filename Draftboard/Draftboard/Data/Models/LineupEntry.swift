//
//  LineupEntry.swift
//  Draftboard
//
//  Created by Anson Schall on 7/15/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class LineupEntry {
    
    let id: Int
    let contest: Contest

    init(id: Int, contest: Contest) {
        self.id = id
        self.contest = contest
    }
    
}