//
//  UIColor+Extensions.swift
//  RedMesa
//
//  Created by Karl Weber on 9/11/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit



extension UIColor {

    class func draftColorDarkBlue() -> UIColor {
        return UIColor.colorFromPhotoshop(10, green: 20, blue: 30, alpha: 255)
    }
    
    class func draftColorTextBlue() -> UIColor {
        return UIColor.colorFromPhotoshop(70, green: 72, blue: 94, alpha: 255)
    }
    
    class func draftColorTextLightBlue() -> UIColor {
        return UIColor.colorFromPhotoshop(176, green: 178, blue: 193, alpha: 255)
    }
    
    class func draftColorDividerLightBlue() -> UIColor {
        return UIColor.colorFromPhotoshop(235, green: 237, blue: 242, alpha: 255)
    }
    
    class func colorFromPhotoshop(var red: CGFloat, var green: CGFloat, var blue: CGFloat, var alpha: CGFloat ) -> UIColor {
        // normalize the colors
        red = UIColor.normalizeColor(red)
        green = UIColor.normalizeColor(green)
        blue = UIColor.normalizeColor(blue)
        alpha = UIColor.normalizeColor(alpha)
        return UIColor(red:red, green:green, blue: blue, alpha: alpha)
    }
    
    class func normalizeColor(var number: CGFloat) -> CGFloat {
        if number > 255 {
            number = 255
        }
        return CGFloat(number) / 255
    }
    
}
