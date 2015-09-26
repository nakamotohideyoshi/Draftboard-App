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
    
    class func draftboardDarkText() -> UIColor {
        return UIColor(0x46495E)
    }
    
    class func draftboardLightText() -> UIColor {
        return UIColor(0xB0B2C1)
    }
    
    class func draftboardGreen() -> UIColor {
        return UIColor(0x00C68C)
    }
    
    class func draftboardDarkGreen() -> UIColor {
        return UIColor(0x00b47f)
    }
    
    class func draftboardDarkGray() -> UIColor {
        return UIColor(0x0A0D13)
    }
    
    class func draftboardLightGray() -> UIColor {
        return UIColor(0xEBEDF2)
    }
    
    class func draftboardSelected() -> UIColor {
        return .yellowColor()
    }
}
