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

class NFLQBGameLog {
    
    let date: String
    let opp: String
    let pass_yds: Int
    let pass_td: Int
    let pass_int: Int
    let rush_yds: Int
    let rush_td: Int
    let fp: Double
    
    init(date: String, opp: String, pass_yds: Int, pass_td: Int, pass_int: Int, rush_yds: Int, rush_td: Int, fp: Double) {
        self.date = date
        self.opp = opp
        self.pass_yds = pass_yds
        self.pass_td = pass_td
        self.pass_int = pass_int
        self.rush_yds = rush_yds
        self.rush_td = rush_td
        self.fp = fp
    }
}

class NFLRBGameLog {
    
    let date: String
    let opp: String
    let rush_yds: Int
    let rush_td: Int
    let rec_rec: Int
    let rec_yds: Int
    let rec_td: Int
    let fp: Double
    
    init(date: String, opp: String, rush_yds: Int, rush_td: Int, rec_rec: Int, rec_yds: Int, rec_td: Int, fp: Double) {
        self.date = date
        self.opp = opp
        self.rush_yds = rush_yds
        self.rush_td = rush_td
        self.rec_rec = rec_rec
        self.rec_yds = rec_yds
        self.rec_td = rec_td
        self.fp = fp
    }
}

class NFLGameLog {
    
    let date: String
    let opp: String
    let rec_rec: Int
    let rec_yds: Int
    let rec_td: Int
    let fp: Double
    
    init(date: String, opp: String, rec_rec: Int, rec_yds: Int, rec_td: Int, fp: Double) {
        self.date = date
        self.opp = opp
        self.rec_rec = rec_rec
        self.rec_yds = rec_yds
        self.rec_td = rec_td
        self.fp = fp
    }
}
