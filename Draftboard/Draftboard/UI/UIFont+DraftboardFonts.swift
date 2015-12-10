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
}