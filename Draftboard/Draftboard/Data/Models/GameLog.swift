//
//  GameLog.swift
//  Draftboard
//
//  Created by devguru on 5/12/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import Foundation

class MLBPitcherGameLog {
    
    let date: String
    let opp: String
    let result: String
    let ip: Int
    let h: Int
    let er: Int
    let bb: Int
    let so: Int
    let fp: Double
    
    init(date: String, opp: String, result: String, ip: Int, h: Int, er: Int, bb: Int, so: Int, fp: Double) {
        self.date = date
        self.opp = opp
        self.result = result
        self.ip = ip
        self.h = h
        self.er = er
        self.bb = bb
        self.so = so
        self.fp = fp
    }
}

class MLBHitterGameLog {
    
    let date: String
    let opp: String
    let ab: Int
    let r: Int
    let h: Int
    let doubles: Int
    let triples: Int
    let hr: Int
    let rbi: Int
    let bb: Int
    let sb: Int
    let fp: Double
    
    init(date: String, opp: String, ab: Int, r: Int, h: Int, doubles: Int, triples: Int, hr: Int, rbi: Int, bb: Int, sb: Int, fp: Double) {
        self.date = date
        self.opp = opp
        self.ab = ab
        self.r = r
        self.h = h
        self.doubles = doubles
        self.triples = triples
        self.hr = hr
        self.rbi = rbi
        self.bb = bb
        self.sb = sb
        self.fp = fp
    }
}

