//
//  LineupStatView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupStatCurrencyView: LineupStatView {
    
    var invalid = false
    var defaultString = "--"
    let formatter = NSNumberFormatter()
    
    init(style _style: LineupStatStyle, titleText _titleText: String?, currencyValue _currencyValue: Double?) {
        super.init(style: _style, titleText: _titleText, valueText: nil)
        
        formatter.numberStyle = .CurrencyStyle
        formatter.maximumFractionDigits = 0
        
        if (_currencyValue != nil) {
            invalid = (_currencyValue < 0)
        }
        
        let text = currencyTextFromValue(_currencyValue)
        valueLabel.attributedText = attributedValueText(text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func currencyTextFromValue(value: Double?) -> String {
        if let val = value {
            if let str = formatter.stringFromNumber(val) {
                return str
            }
        }
        
        return defaultString
    }
    
    var currencyValue: Double? {
        didSet {
            invalid = (currencyValue < 0)
            let text = currencyTextFromValue(currencyValue)
            valueLabel.attributedText = attributedValueText(text)
        }
    }
    
    override func attributedValueText(str: String) -> NSMutableAttributedString {
        let attrStr = super.attributedValueText(str)
        
        // Make it red if necessary
        if (invalid) {
            attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSMakeRange(0, str.characters.count))
        }

        return attrStr
    }
}
