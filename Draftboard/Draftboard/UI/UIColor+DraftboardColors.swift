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
    
    convenience init(photoshopRed red: Int, green: Int, blue: Int, alpha: CGFloat) {
        
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
        return UIColor(photoshopRed: 0, green: 198, blue: 140, alpha: 1)
    }
    
    /*
        Colors for the pie charts
    */
    class func moneyRangeBackground() -> UIColor {
        return UIColor(photoshopRed: 94, green: 106, blue: 127, alpha: 0.2)
    }
    
    class func moneyBrightBackground() -> UIColor {
        return UIColor(photoshopRed: 36, green: 48, blue: 67, alpha: 1)
    }
    
    class func moneyDarkBackground() -> UIColor {
        return UIColor(photoshopRed: 19, green: 29, blue: 43, alpha: 1)
    }
    
    class func moneyGray() -> UIColor {
        return UIColor(photoshopRed: 94, green: 106, blue: 127, alpha: 1)
    }
    
    class func moneyBlue() -> UIColor {
        return UIColor(photoshopRed: 0, green: 162, blue: 255, alpha: 1)
    }
    
    class func moneyDarkBlue() -> UIColor {
        return UIColor(photoshopRed: 0, green: 162, blue: 255, alpha: 0.2)
    }

    class func moneyGreen() -> UIColor {
        return UIColor(photoshopRed: 0, green: 198, blue: 140, alpha: 1)
    }
    
    class func moneyDarkGreen() -> UIColor {
        return UIColor(photoshopRed: 0, green: 198, blue: 140, alpha: 0.2)
    }
    
    class func moneyYellow() -> UIColor {
        return UIColor(photoshopRed: 230, green: 202, blue: 26, alpha: 1)
    }
    
    class func moneyDarkYellow() -> UIColor {
        return UIColor(photoshopRed: 230, green: 202, blue: 26, alpha: 0.1)
    }

    class func moneyRed() -> UIColor {
        return UIColor(photoshopRed: 255, green: 30, blue: 109, alpha: 1)
    }
    
    class func moneyDarkRed() -> UIColor {
        return UIColor(photoshopRed: 255, green: 30, blue: 109, alpha: 0.2)
    }
    
}
