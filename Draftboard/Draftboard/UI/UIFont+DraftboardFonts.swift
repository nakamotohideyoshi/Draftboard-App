//
//  UIColor+DraftboardColors.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/18/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

extension UIFont {
    
    class func draftboardTitlebarTitleFont() -> UIFont? {
        return UIFont(name: "Oswald-Regular", size: 15.0)
    }
    
    class func draftboardGlobalFilterFont() -> UIFont? {
        return UIFont(name: "OpenSans-Light", size: 65.0)
    }
    
    class func draftboardLineupStatTitleFont() -> UIFont? {
        return UIFont(name: "OpenSans-Semibold", size: 8.0)
    }
    
    class func draftboardLineupStatValueFont() -> UIFont? {
        return UIFont(name: "Oswald-Regular", size: 12.0)
    }
}