//
//  UIColor+DraftboardColors.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/18/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(_ hex:Int, alpha:CGFloat) {
        self.init(red:CGFloat((hex >> 16) & 0xff), green:CGFloat((hex >> 8) & 0xff), blue:CGFloat(hex & 0xff), alpha: alpha)
    }
    
    convenience init(_ hex:Int) {
        self.init(red:CGFloat((hex >> 16) & 0xff), green:CGFloat((hex >> 8) & 0xff), blue:CGFloat(hex & 0xff), alpha: 1.0)
    }
    
    convenience init(photoshopRed red: Int, green: Int, blue: Int, alpha: Int) {
        
        let red   = CGFloat(Float(red)/255)
        let green = CGFloat(Float(green)/255)
        let blue  = CGFloat(Float(blue)/255)
        let alpha = CGFloat(Float(alpha)/255)
        
        self.init(red:red, green:green, blue: blue, alpha: alpha)
    }
    
    class func draftboardDarkText() -> UIColor {
        return UIColor(0x46495E)
    }
    
    class func draftboardLightText() -> UIColor {
        return UIColor(0xB0B2C1)
    }
    
    class func draftboardGreen() -> UIColor {
        return UIColor(0x34CC68)
    }
    
    class func draftboardDarkGray() -> UIColor {
        return UIColor(0x0A0D13)
    }
    
    class func draftboardLightGray() -> UIColor {
        return UIColor(0xEBEDF2)
    }
    
    class func funkyGreen() -> UIColor {
        return UIColor(photoshopRed: 0, green: 198, blue: 140, alpha: 255)
    }
    
}
