//
//  DraftboardTitlebarButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/29/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

struct TabBarButtonType : OptionSetType {
    let rawValue: Int
    static let Lineups = TabBarButtonType(rawValue: 0)
    static let Contests = TabBarButtonType(rawValue: 1 << 0)
    static let Profile = TabBarButtonType(rawValue: 1 << 1)
}

class DraftboardTabBarButton: DraftboardButton {
    
    var buttonType: TabBarButtonType?
    
    convenience init(type: TabBarButtonType) {
        self.init(frame: CGRectMake(0, 0, 50, 50))
        
        buttonType = type
        iconImage = iconForType(buttonType)
    }
    
    override func setDefaults() {
        super.setDefaults()
        
        bgColor = .clearColor()
        bgHighlightColor = .clearColor()
        
        iconColor = .whiteColor()
        iconHighlightColor = .whiteColor()
    }
    
    func iconForType(type: TabBarButtonType?) -> UIImage? {
        var imgPath = ""
        if (type == .Lineups) {
            imgPath = "tab-icon-jersey"
        } else if (type == .Profile) {
            imgPath = "tab-icon-profile"
        } else if (type == .Contests) {
            imgPath = "tab-icon-trophy"
        }
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let img = UIImage(named: imgPath, inBundle: bundle, compatibleWithTraitCollection: self.traitCollection)
        return img
    }
}
