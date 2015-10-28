//
//  DraftboardRoundButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/23/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardRoundButton: DraftboardButton {
    
    override func setDefaults() {
        super.setDefaults()
        self.cornerRadius = 4.0
        self.borderColor = .greenDraftboard()
        self.borderWidth = 1.3
        self.bgColor = .clearColor()
        self.textColor = .greenDraftboard()
        self.textHighlightColor = .whiteColor()
    }
}
