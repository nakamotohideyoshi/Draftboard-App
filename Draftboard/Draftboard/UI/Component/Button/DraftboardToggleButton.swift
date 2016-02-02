//
//  DraftboardButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardToggleButton: DraftboardButton {
    
    var option: LineupCardToggleOption
    
    init(option _option: LineupCardToggleOption) {
        option = _option
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        option = .Points
        super.init(coder: aDecoder)
    }

    override func setDefaults() {
        super.setDefaults()
        
        bgColor = .clearColor()
        textColor = UIColor(0x6d718a, alpha: 0.8)
        cornerRadius = 10.0
        bgDisabledColor = UIColor(0x495b78, alpha: 0.5)
        textDisabledColor = .whiteColor()
    }
}
