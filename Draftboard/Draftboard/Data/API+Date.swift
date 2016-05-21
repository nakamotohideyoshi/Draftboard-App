//
//  API+Date.swift
//  Draftboard
//
//  Created by Anson Schall on 5/6/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

extension API {
    
    class func dateFromString(s: String) throws -> NSDate {
        guard let date = dateFormatter.dateFromString(s) else {
            throw APIError.InvalidDateString(s)
        }
        return date
    }
    
    // https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html#//apple_ref/doc/uid/TP40002369-SW5
    private static var dateFormatter: NSDateFormatter = {
        let f = NSDateFormatter()
        f.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        f.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
        f.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        return f
    }()
    
}