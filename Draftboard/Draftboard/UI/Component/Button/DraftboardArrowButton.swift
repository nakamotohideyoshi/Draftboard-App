//
//  DraftboardArrowButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/9/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardArrowButton: DraftboardButton {
    
    override func setDefaults() {
        super.setDefaults()
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let img = UIImage(named: "icon-arrow", inBundle: bundle, compatibleWithTraitCollection: self.traitCollection)
        iconImage = img
    }

    override func constrainIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.rightRancor.constraintEqualToRancor(self.rightRancor, constant: -16.0).active = true
        iconImageView.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
    }
    
    override var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
            label.hidden = false
        }
    }
}