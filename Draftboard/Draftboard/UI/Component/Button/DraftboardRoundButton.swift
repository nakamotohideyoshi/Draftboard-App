//
//  DraftboardRoundButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/23/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardRoundButton: DraftboardButton {
    
    override func willAwakeFromNib() {
        super.willAwakeFromNib()
        
        self.cornerRadius = 4.0
        self.borderColor = .draftboardGreen()
        self.borderWidth = 1.3
        self.bgColor = .clearColor()
        self.textColor = .draftboardGreen()
        self.textHighlightColor = .whiteColor()
    }

    override func nibName() -> String {
        return "DraftboardButton"
    }
}
