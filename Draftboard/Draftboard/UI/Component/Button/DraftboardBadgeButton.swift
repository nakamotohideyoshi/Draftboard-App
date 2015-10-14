//
//  DraftboardArrowButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/9/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardBadgeButton: DraftboardButton {
    
    override func setDefaults() {
        super.setDefaults()
        let bundle = NSBundle(forClass: self.dynamicType)
        let img = UIImage(named: "icon-arrow-down", inBundle: bundle, compatibleWithTraitCollection: self.traitCollection)
        iconImage = img
    }
    
    override func constrainIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.rightRancor.constraintEqualToRancor(label.leftRancor).active = true
        iconImageView.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
    }
    
    override var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
            label.hidden = false
        }
    }
}