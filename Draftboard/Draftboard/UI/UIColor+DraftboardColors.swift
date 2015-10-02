//
//  UIColor+DraftboardColors.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/18/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(_ hex:UInt32, alpha:CGFloat = 1.0) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 256.0
        let g = CGFloat((hex & 0xFF00) >> 8) / 256.0
        let b = CGFloat(hex & 0xFF) / 256.0
        self.init(red:r, green:g, blue:b, alpha:alpha)
    }
    
    convenience init(photoshopRed red: Int, green: Int, blue: Int, alpha: CGFloat) {
        
        let red   = CGFloat(Float(red)/255.0)
        let green = CGFloat(Float(green)/255.0)
        let blue  = CGFloat(Float(blue)/255.0)
        
        self.init(red:red, green:green, blue: blue, alpha: alpha)
    }
    
    // MARK: Draftboard palette
    
    class func draftboardTextDarkColor() -> UIColor {
        return UIColor(0x46495E)
    }
    
    class func draftboardTextLightColor() -> UIColor {
        return UIColor(0xB0B2C1)
    }
    
    class func draftboardAccentColor() -> UIColor {
        return UIColor(0x00C68C)
    }
    
    class func draftboardAccentDarkColor() -> UIColor {
        return UIColor(0x00b47f)
    }
    
    class func draftboardBgDarkColor() -> UIColor {
        return UIColor(0x0A0D13)
    }
    
    class func draftboardBgLightColor() -> UIColor {
        return UIColor(0xEBEDF2)
    }
    
    class func draftboardSelected() -> UIColor {
        return .yellowColor()
    }

    class func funkyGreen() -> UIColor {
        return UIColor(photoshopRed: 0, green: 198, blue: 140, alpha: 1)
    }
    
    // MARK: Pie chart colors
    
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
