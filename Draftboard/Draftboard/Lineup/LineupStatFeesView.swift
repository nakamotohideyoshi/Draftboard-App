//
//  LineupStatView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupStatFeesView: LineupStatView {
    
    override func attributedValueText(str: String) -> NSMutableAttributedString {
        let attrStr = super.attributedValueText(str)

        // TODO: add logic here to color the right range
        attrStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lineupStatFeesColor(style), range: NSMakeRange(attrStr.length-2, 2))

        return attrStr
    }
}
