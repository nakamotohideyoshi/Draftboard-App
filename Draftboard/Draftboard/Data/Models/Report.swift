//
//  Report.swift
//  Draftboard
//
//  Created by devguru on 5/4/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import Foundation

class Report {

    let headline: String
    let value: String
    let notes: String
    let analysis: String
    let updatedAt: NSDate
    let dayAgo: String
    
    init(headline: String, value: String, notes: String, analysis: String, updatedAt: NSDate, dayAgo: String) {
        self.headline = headline
        self.value = value
        self.notes = notes
        self.analysis = analysis
        self.updatedAt = updatedAt
        self.dayAgo = dayAgo
    }
    
    convenience init(json: NSDictionary) throws {
        do {
            let headline: String = try json.get("headline")
            let value: String = try json.get("value")
            let notes: String = try json.get("notes")
            let analysis: String = try json.get("analysis")
            let updatedAt: NSDate = try API.dateFromString(try json.get("updated_at"))
            let calendar = NSCalendar.currentCalendar()
            
            // Replace the hour (time) of both dates with 00:00
            let date1 = calendar.startOfDayForDate(updatedAt)
            let date2 = calendar.startOfDayForDate(NSDate())
            
            let flags = NSCalendarUnit.Day
            let components = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
            var dayAgo = ""
            if (components.day == 1) {
                dayAgo = "a day ago"
            } else {
                dayAgo = NSString(format:"%d", components.day) as String + " days ago"
            }
            self.init(headline: headline, value: value, notes: notes, analysis:analysis, updatedAt: updatedAt, dayAgo: dayAgo)
        } catch let error {
            throw APIError.ModelError(self.dynamicType, error)
        }
    }
}
