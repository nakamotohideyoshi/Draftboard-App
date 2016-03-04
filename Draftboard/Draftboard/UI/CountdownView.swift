//
//  CountdownView.swift
//  Draftboard
//
//  Created by Anson Schall on 2/29/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class CountdownView: UILabel {
    var date: NSDate { didSet { setup() } }
    var size: CGFloat { didSet { setup() } }
    var color: UIColor { didSet { setup() } }
    private var textAttributes: [String: AnyObject]
    private var lastTimestamp: CFTimeInterval
    private var widthConstraint: NSLayoutConstraint!
    
    init(date: NSDate = NSDate(), size: CGFloat = 10.0, color: UIColor = .whiteColor()) {
        self.date = date
        self.size = size
        self.color = color
        self.textAttributes = [:]
        self.lastTimestamp = 0
        super.init(frame: CGRectZero)
        
        // Constraints
        translatesAutoresizingMaskIntoConstraints = false
        widthConstraint = widthRancor.constraintEqualToConstant(0)
        widthConstraint.active = true

        // Tick
        let displayLink = CADisplayLink(target: self, selector:"tick:")
        displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
        
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        // Text attributes
        textAttributes[NSForegroundColorAttributeName] = color
        textAttributes[NSFontAttributeName] = UIFont(name: "Oswald-Regular", size: size)
        
        // Constraints
        widthConstraint.constant = 0
        
        update()
    }
    
    func tick(displayLink: CADisplayLink) {
        // Update every second, on the second
        if displayLink.timestamp - lastTimestamp >= 1.0 {
            lastTimestamp = floor(displayLink.timestamp)
            update()
        }
    }
    
    func update() {
        let components = dateComponents()
        let (h, m, s) = (components.hour, components.minute, components.second)
        
        // Size to fit :00 seconds to avoid wiggling
        if widthConstraint.constant == 0 || s == 59 {
            let timeString = String(format: "%02d:%02d:00", h, m)
            attributedText = attributedTimeString(timeString)
            widthConstraint.constant = sizeThatFits(CGSizeZero).width
        }
        
        // Real text, including seconds
        let timeString = String(format: "%02d:%02d:%02d", h, m, s)
        attributedText = attributedTimeString(timeString)
    }
    
    func attributedTimeString(timeString: String) -> NSAttributedString {
        // Make seconds semi-transparent
        let secondsColor = color.colorWithAlphaComponent(0.4)
        let secondsRange = (timeString as NSString).rangeOfString(":[0-9]+$", options: .RegularExpressionSearch)
        let attrString = NSMutableAttributedString(string: timeString, attributes: textAttributes)
        attrString.addAttribute(NSForegroundColorAttributeName, value: secondsColor, range: secondsRange)
        return attrString
    }

    func dateComponents() -> NSDateComponents {
        let units: NSCalendarUnit = [.Hour, .Minute, .Second]
        let cal = NSCalendar.currentCalendar()
        let now = date.earlierDate(NSDate()) // Stop at zero
        return cal.components(units, fromDate: now, toDate: date, options: [])
    }
}