//
//  LineupStatView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

struct LineupStatStyle : OptionSetType {
    let rawValue: Int
    static let Large = LineupStatStyle(rawValue: 0)
    static let Small = LineupStatStyle(rawValue: 1 << 0)
}

class LineupStatView: UIView {
    
    let style: LineupStatStyle
    let titleLabel = UILabel()
    let valueLabel = UILabel()
    
    init(style _style: LineupStatStyle, titleText _titleText: String?, valueText _valueText: String?) {
        style = _style
        super.init(frame: CGRectZero)
        
        var constant: CGFloat = 4.0
        if (style == .Large) {
            constant = 7.0
        }
        
        addSubview(valueLabel)
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        valueLabel.centerYRancor.constraintEqualToRancor(self.centerYRancor, constant: constant).active = true
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        titleLabel.bottomRancor.constraintEqualToRancor(valueLabel.topRancor).active = true
        
        if (_titleText != nil) {
            titleText = _titleText!
            titleLabel.attributedText = attributedTitleText(_titleText!)
        }
        if (_valueText != nil) {
            valueText = _valueText!
            valueLabel.attributedText = attributedValueText(_valueText!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var titleText: String = "TITLE" {
        didSet {
            titleLabel.attributedText = attributedTitleText(titleText)
        }
    }
    
    var valueText: String = "00" {
        didSet {
            valueLabel.attributedText = attributedValueText(valueText)
        }
    }
    
    func attributedTitleText(str: String) -> NSMutableAttributedString {
        
        // Create attributed string
        let attrStr = NSMutableAttributedString(string: str)
        
        // Kerning
        let wholeStr = NSMakeRange(0, attrStr.length)
        attrStr.addAttribute(NSKernAttributeName, value: 0.0, range: wholeStr)
        
        // Font
        if let font = UIFont.draftboardLineupStatTitleFont(style) {
            attrStr.addAttribute(NSFontAttributeName, value: font, range: wholeStr)
        }
        
        // Color
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lineupStatTitleColor(style), range: wholeStr)
        return attrStr
    }
    
    func attributedValueText(str: String) -> NSMutableAttributedString {
        
        // Create attributed string
        let attrStr = NSMutableAttributedString(string: str)
        
        // Kerning
        let wholeStr = NSMakeRange(0, attrStr.length)
        attrStr.addAttribute(NSKernAttributeName, value: 0.0, range: wholeStr)
        
        // Font
        if let font = UIFont.draftboardLineupStatValueFont(style) {
            attrStr.addAttribute(NSFontAttributeName, value: font, range: wholeStr)
        }
        
        // Color
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lineupStatValueColor(style), range: wholeStr)
        return attrStr
    }
}
