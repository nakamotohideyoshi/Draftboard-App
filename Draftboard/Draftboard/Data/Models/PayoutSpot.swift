//
//  PayoutSpot.swift
//  Draftboard
//
//  Created by Anson Schall on 8/8/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

class PayoutSpot {
    let rank: Int
    let value: Double
    
    init(rank: Int, value: Double) {
        self.rank = rank
        self.value = value
    }
    
    convenience init(json: NSDictionary) throws {
        do {
            let rank: Int = try json.get("rank")
            let value: Double = try json.get("value")
            self.init(rank: rank, value: value)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}

extension PayoutSpot: CustomStringConvertible {
    var description: String {
        let ordinalRank = Format.ordinal.stringFromNumber(rank)!
        let currencyValue = Format.currency.stringFromNumber(value)!
        return "\(ordinalRank): \(currencyValue)"
    }
}
