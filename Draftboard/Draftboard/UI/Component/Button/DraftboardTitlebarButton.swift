//
//  DraftboardTitlebarButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/29/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

struct TitlebarButtonType : OptionSetType {
    let rawValue: Int
    static let Plus = TitlebarButtonType(rawValue: 0)
    static let Menu = TitlebarButtonType(rawValue: 1 << 0)
    static let Value = TitlebarButtonType(rawValue: 1 << 1)
    static let Back = TitlebarButtonType(rawValue: 1 << 2)
    static let Close = TitlebarButtonType(rawValue: 1 << 3)
    static let Search = TitlebarButtonType(rawValue: 1 << 4)
}

class DraftboardTitlebarButton: DraftboardButton {
    var buttonType: TitlebarButtonType?
    
    class func iconForType(type: TitlebarButtonType?) -> UIImage? {
        if (type == .Plus) {
            return UIImage(named: "titlebar-icon-plus")
        } else if (type == .Menu) {
            return UIImage(named: "titlebar-icon-menu")
        } else if (type == .Back) {
            return UIImage(named: "titlebar-icon-back")
        } else if (type == .Close) {
            return UIImage(named: "titlebar-icon-close")
        } else if (type == .Search) {
            return UIImage(named: "titlebar-icon-search")
        } else if (type == .Value) {
            return nil
        }
        
        return nil
    }
    
    convenience init(type: TitlebarButtonType) {
        self.init(frame: CGRectMake(0, 0, 50, 50))
        
        buttonType = type
        iconImage = DraftboardTitlebarButton.iconForType(buttonType)
        iconHighlightColor = .draftboardAccentColor()
        textBold = true
        textSize = 11.0
        textLetterSpacing = 1.2
        
        if (type == .Value) {
//            bgColor = UIColor(0x424f68)
//            bgHighlightColor = UIColor(0x8b90af)
        }
        else {
            bgColor = .clearColor()
            bgHighlightColor = .clearColor()
        }
    }
}
