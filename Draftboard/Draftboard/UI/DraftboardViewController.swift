//
//  DraftboardViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/25/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardViewController: UIViewController, DraftboardTitlebarDelegate, DraftboardTitlebarDataSource {
    
    var navController: DraftboardNavController?
    
    func didSelectModalChoice(index: Int) {
        print("DraftboardViewController::didSelectModalChoice", index)
    }
    
    func didCancelModal() {
        print("DraftboardViewController::didCancelModal")
    }
    
    func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        print("DraftboardViewController::didTapTitlebarButton:", buttonType)
    }
    
    func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Menu
    }
    
    func titlebarRightButtonType() -> TitlebarButtonType? {
        return nil
    }
    
    func titlebarLeftButtonText() -> String? {
        return nil
    }
    
    func titlebarRightButtonText() -> String? {
        return nil
    }
    
    func titlebarBgHidden() -> Bool {
        return true
    }
    
    func titlebarTitle() -> String? {
        return "No Title".uppercaseString
    }
    
    func titlebarAttributedTitle() -> NSMutableAttributedString? {
        
        // We really need a string, not nil
        let str = self.titlebarTitle()
        if (str == nil) {
            return nil
        }
        
        // Create attributed string
        let attrStr = NSMutableAttributedString(string: str!)
        
        // Kerning
        let wholeStr = NSMakeRange(0, attrStr.length)
        attrStr.addAttribute(NSKernAttributeName, value: 0.0, range: wholeStr)
        
        // Font
        if let font = UIFont.draftboardTitlebarTitleFont() {
            attrStr.addAttribute(NSFontAttributeName, value: font, range: wholeStr)
        }
        
        // Line height
        let pStyle = NSMutableParagraphStyle()
        pStyle.lineHeightMultiple = 1.0
        pStyle.lineBreakMode = .ByTruncatingMiddle
        pStyle.alignment = .Center
        attrStr.addAttribute(NSParagraphStyleAttributeName, value: pStyle, range: wholeStr)
        
        // Color
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor(), range: wholeStr)
        
        // Done
        return attrStr
    }
}
