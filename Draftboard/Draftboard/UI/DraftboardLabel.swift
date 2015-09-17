//
//  Label.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable class DraftboardLabel: UILabel {
    
    func updateAttributedString() {
        var str = self.text
        if (str == nil) {
            str = ""
        }
        
        let attrStr = NSMutableAttributedString(string: str!)
        let attrRange = NSMakeRange(0, attrStr.length)
        
        attrStr.removeAttribute(NSKernAttributeName, range: NSMakeRange(0, attrStr.length))
        attrStr.addAttribute(NSKernAttributeName, value: letterSpacing, range: attrRange)
        
        self.attributedText = attrStr
    }
    
    override var text: String? {
        didSet {
            updateAttributedString()
        }
    }
    
    @IBInspectable var letterSpacing: CGFloat = 0.0 {
        didSet {
            updateAttributedString()
        }
    }
}