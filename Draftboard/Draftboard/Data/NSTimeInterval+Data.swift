//
//  NSTimeInterval+Data.swift
//  Draftboard
//
//  Created by Anson Schall on 5/11/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import Foundation

extension NSTimeInterval {
    static let OneMinute: NSTimeInterval = 60
    static let OneHour: NSTimeInterval = OneMinute * 60
    static let OneDay: NSTimeInterval = OneHour * 24
    static let OneWeek: NSTimeInterval = OneDay * 7
    static let OneMonth: NSTimeInterval = OneDay * 30
    static let OneYear: NSTimeInterval = OneDay * 365
}
