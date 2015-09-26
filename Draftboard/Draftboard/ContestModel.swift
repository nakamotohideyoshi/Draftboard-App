//
//  ContestModel.swift
//  Draftboard
//
//  Created by Karl Weber on 9/18/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestModel: NSObject {

    var guaranteed: Bool = false
    var multientry: Bool = false
    var title: String = ""
    var fee: Int = 10
    var prizes: Int = 100
    var entries: Int = 0
    
    override init() {
        super.init()
        
        let a = Int(arc4random_uniform(2))
        if a > 0 {
            guaranteed = true
        }
        
        let b = Int(arc4random_uniform(2))
        print(b)
        if b > 0 {
            multientry = true
        }
        
        fee = Int(arc4random_uniform(10)) + 1
        prizes = Int(arc4random_uniform(100)) + 10
        title = "$\(prizes) Free Roll"
        entries = Int(arc4random_uniform(5)) + 1
    }
    
    func feeDescription() -> String {
        return "$\(fee) FEE / $\(prizes) PRIZES"
    }
    
}
