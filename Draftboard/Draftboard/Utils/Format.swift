//
//  Format.swift
//  Draftboard
//
//  Created by Anson Schall on 12/11/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import Foundation

final class Format {
    static let currency = Format.currencyFormatter()
    static let date = Format.dateFormatter()

    private init() {}
    
    private class func currencyFormatter() -> NSNumberFormatter {
        let f = NSNumberFormatter()
        f.numberStyle = .CurrencyStyle
        f.maximumFractionDigits = 0
        return f
    }
    
    private class func dateFormatter() -> NSDateFormatter {
        let f = NSDateFormatter()
        f.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        f.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        return f
    }
}
