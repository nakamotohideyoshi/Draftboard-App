//
//  LineupStatView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupStatTimeView: LineupStatView {
    
    var defaultString = "00:00:00"
    
    init(style _style: LineupStatStyle, titleText _titleText: String?, date _date: NSDate?) {
        super.init(style: _style, titleText: _titleText, valueText: nil)
        
        // TODO: add logic to get time from date
        date = _date
        self.valueText = timeStringFromDate(_date)
    }
    
    var date: NSDate? {
        didSet {
            self.valueText = timeStringFromDate(date!)
        }
    }
    
    func timeStringFromDate(date: NSDate?) -> String {
        if (date == nil) {
            return defaultString
        }
        
        let cal = NSCalendar.currentCalendar()
        let now = NSDate()
        
        let components = cal.components(
            [.Hour, .Minute, .Second],
            fromDate: now,
            toDate: date!,
            options: []
        )
        
        return String(format: "%02d:%02d:%02d", components.hour, components.minute, components.second)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func attributedValueText(str: String) -> NSMutableAttributedString {
        let attrStr = super.attributedValueText(str)
        
        // TODO: add logic here for coloring the right zeros
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lineupStatTimeColor(style), range: NSMakeRange(0, 6))
        
        return attrStr
    }
}
