//
//  DraftboardLabel.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardLabel: UILabel {
    func updateAttributedString() {
        
        // Protect from nil string
        var str = self.text
        if (str == nil) {
            str = ""
        }
        
        // Create new attributed string
        let attrStr = NSMutableAttributedString(string: str!)
        let attrRange = NSMakeRange(0, attrStr.length)
        
        // Remove old attributes
        attrStr.removeAttribute(NSKernAttributeName, range: attrRange)
        attrStr.addAttribute(NSKernAttributeName, value: letterSpacing, range: attrRange)
        
        // Adjust line height?
        if (lineHeightMultiple != 1.0) {
            
            // Create paragraph style
            let pStyle = NSMutableParagraphStyle()
            pStyle.lineHeightMultiple = lineHeightMultiple
            pStyle.lineBreakMode = self.lineBreakMode
            pStyle.alignment = self.textAlignment
            
            // Set paragraph style
            attrStr.removeAttribute(NSParagraphStyleAttributeName, range: attrRange)
            attrStr.addAttribute(NSParagraphStyleAttributeName, value: pStyle, range: attrRange)
        }
        
        // Set string
        self.attributedText = attrStr
    }
    
    override func prepareForInterfaceBuilder() {
        updateAttributedString()
    }
    
    override var text: String? {
        didSet {
            updateAttributedString()
        }
    }
    
    @IBInspectable
    var letterSpacing: CGFloat = 0.0
    
    @IBInspectable
    var lineHeightMultiple: CGFloat = 1.0
}