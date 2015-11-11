//
//  LineupStatView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupStatTimeView: LineupStatView {
    
    override func setup() {
        titleLabel.font = .draftboardLineupStatTitleFont()
        titleLabel.textColor = .lineupStatTitleColor()
        titleLabel.text = titleText.uppercaseString
        
        valueLabel.attributedText = attributedText(valueText.uppercaseString)
        
        self.addSubview(titleLabel)
        self.addSubview(valueLabel)
        
        constrainLabels()
    }
    
    func attributedText(str: String) -> NSMutableAttributedString? {
        
        // Create attributed string
        let attrStr = NSMutableAttributedString(string: valueText.uppercaseString)
        
        // Kerning
        let wholeStr = NSMakeRange(0, attrStr.length)
        attrStr.addAttribute(NSKernAttributeName, value: 0.0, range: wholeStr)
        
        // Font
        if let font = UIFont.draftboardLineupStatValueFont() {
            attrStr.addAttribute(NSFontAttributeName, value: font, range: wholeStr)
        }
        
        // Line height
        let pStyle = NSMutableParagraphStyle()
        pStyle.lineHeightMultiple = 1.0
        pStyle.lineBreakMode = .ByClipping
        pStyle.alignment = .Center
        attrStr.addAttribute(NSParagraphStyleAttributeName, value: pStyle, range: wholeStr)
        
        // Colors
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lineupStatValueColor(), range: wholeStr)
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lineupStatTimeColor(), range: NSMakeRange(0, 3))
        
        // Done
        return attrStr
    }
}
