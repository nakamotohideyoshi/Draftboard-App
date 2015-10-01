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
    
    class func iconForType(type: TabBarButtonType?) -> UIImage? {
        if (type == .Lineups) {
            return UIImage(named: "tab-icon-jersey")
        } else if (type == .Profile) {
            return UIImage(named: "tab-icon-profile")
        } else if (type == .Contests) {
            return UIImage(named: "tab-icon-trophy")
        }
        
        return nil
    }
    
    convenience init(type: TabBarButtonType) {
        self.init(frame: CGRectMake(0, 0, 50, 50))
        buttonType = type
        iconImage = DraftboardTabBarButton.iconForType(type)
    }
    
    override func willAwakeFromNib() {
        super.willAwakeFromNib()
        
        bgColor = .clearColor()
        bgHighlightColor = .clearColor()
        
        iconColor = .whiteColor()
        iconHighlightColor = .whiteColor()
    }
    
    override func nibName() -> String {
        return "DraftboardButton"
    }
}
