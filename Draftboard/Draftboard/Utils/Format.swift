//
//  Format.swift
//  Draftboard
//
//  Created by Anson Schall on 12/11/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation

final class Format {
    static let currency = CurrencyNumberFormatter()
    static let date = Format.dateFormatter()
    static let ordinal = OrdinalNumberFormatter()

    private init() {}
    
    private class func dateFormatter() -> NSDateFormatter {
        let f = NSDateFormatter()
        f.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        f.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        return f
    }
}

class CurrencyNumberFormatter: NSNumberFormatter {
    override init() {
        super.init()
        numberStyle = .CurrencyStyle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func stringFromNumber(number: NSNumber) -> String? {
        maximumFractionDigits = (number == Int(number)) ? 0 : 2
        minimumFractionDigits = maximumFractionDigits
        return super.stringFromNumber(number)
    }
}

// This can be replaced with native functionality in iOS 9
class OrdinalNumberFormatter: NSNumberFormatter {
    override func stringFromNumber(number: NSNumber) -> String? {
        let n = "\(number)"
        if n.hasSuffix("11") || n.hasSuffix("12") || n.hasSuffix("13") {
            return n + "th"
        }
        if n.hasSuffix("1") { return n + "st" }
        if n.hasSuffix("2") { return n + "nd" }
        if n.hasSuffix("3") { return n + "rd" }
        return n + "th"
    }
}
