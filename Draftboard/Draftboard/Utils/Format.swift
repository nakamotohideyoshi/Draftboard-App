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

    private init() {}
    
    private class func currencyFormatter() -> NSNumberFormatter {
        let f = NSNumberFormatter()
        f.numberStyle = .CurrencyStyle
        f.maximumFractionDigits = 0
        return f
    }
}