//
//  UIColor+DraftboardColors.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/18/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func oswaldRegular() -> UIFont? {
        return UIFont(name: "Oswald-Regular", size: 15)
    }
    
    class func openSansRegular() -> UIFont? {
        return UIFont(name: "OpenSans", size: 15)
    }
    
    class func draftboardTitlebarTitleFont() -> UIFont? {
        return UIFont(name: "Oswald-Regular", size: 15.0)
    }
    
    class func draftboardGlobalFilterFont() -> UIFont? {
        return UIFont(name: "OpenSans-Light", size: 65.0)
    }
    
    class func draftboardLineupStatTitleFont(style: LineupStatStyle) -> UIFont? {
        let size: CGFloat = (style == .Small) ? 8.0 : 10.0
        return UIFont(name: "OpenSans-Semibold", size: size)
    }
    
    class func draftboardLineupStatValueFont(style: LineupStatStyle) -> UIFont? {
        let size: CGFloat = (style == .Small) ? 12.0 : 20.0
        return UIFont(name: "Oswald-Regular", size: size)
    }
    
    // The new way
    
    class OpenSans {
        enum Weight: String {
            case Light = "Light"
            case Regular = ""
            case Semibold = "Semibold"
            case Bold = "Bold"
            case ExtraBold = "ExtraBold"
        }
        enum Style: String {
            case Regular = ""
            case Italic = "Italic"
        }
    }
    
    class Oswald {
        enum Weight: String {
            case Light = "Light"
            case Regular = "Regular"
            case Bold = "Bold"
        }
    }
    
    class func openSans(size size: CGFloat) -> UIFont {
        return openSans(weight: .Regular, style: .Regular, size: size)
    }
    
    class func openSans(weight weight: OpenSans.Weight, size: CGFloat) -> UIFont {
        return openSans(weight: weight, style: .Regular, size: size)
    }
    
    class func openSans(weight weight: OpenSans.Weight, style: OpenSans.Style, size: CGFloat) -> UIFont {
        return font("OpenSans", variant: "\(weight.rawValue)\(style.rawValue)", size: size)
    }
    
    class func oswald(size size: CGFloat) -> UIFont {
        return oswald(weight: .Regular, size: size)
    }
    
    class func oswald(weight weight: Oswald.Weight, size: CGFloat) -> UIFont {
        return font("Oswald", variant: "\(weight.rawValue)", size: size)
    }
    
    private class func font(family: String, variant: String, size: CGFloat) -> UIFont {
        var name = family
        if variant != "" {
            name += "-" + variant
        }
        let font = UIFont(name: name, size: size)
        if font == nil { print("Font not found: \(name)") }
        return font ?? UIFont.systemFontOfSize(size)
    }
    
}