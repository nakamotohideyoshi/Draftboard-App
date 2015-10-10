//
//  DraftboardArrowButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/9/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardArrowButton: DraftboardButton {

    override func constrainIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.rightRancor.constraintEqualToRancor(self.rightRancor, constant: -10.0).active = true
        iconImageView.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
    }
}