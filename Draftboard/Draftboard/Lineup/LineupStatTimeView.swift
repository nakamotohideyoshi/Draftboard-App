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
    var timer: NSTimer!
    
    init(style _style: LineupStatStyle, titleText _titleText: String?, date _date: NSDate?) {
        super.init(style: _style, titleText: _titleText, valueText: nil)
        
        date = _date
        self.valueText = timeStringFromDate(_date)
        
        // Countdown timer
        timer = NSTimer(timeInterval: 0.5, target: self, selector: "update", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var date: NSDate? {
        didSet {
            if let date = date {
                self.valueText = timeStringFromDate(date)
            }
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
    
    override func attributedValueText(str: String) -> NSMutableAttributedString {
        let attrStr = super.attributedValueText(str)
        
        // TODO: add logic here for coloring the right zeros
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lineupStatTimeColor(style), range: NSMakeRange(0, 6))
        
        return attrStr
    }
    
    func update() {
        if (date != nil) {
            self.valueText = timeStringFromDate(date)
        }
    }
    
    deinit {
        timer.invalidate()
        timer = nil
    }
}
