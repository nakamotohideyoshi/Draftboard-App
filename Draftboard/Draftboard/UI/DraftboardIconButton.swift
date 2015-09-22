//
//  DraftboardButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardIconButton: DraftboardNibControl {
    
    @IBOutlet weak var borderImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var selectedView: DraftboardView!
    
    var iconColor: UIColor?
    
    override func awakeFromNib() {
        iconColor = iconImageView.tintColor
        _selectedView = selectedView
    }
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                self.iconImageView.tintColor = .whiteColor()
                self.selectedView.hidden = false
            }
            else {
                self.iconImageView.tintColor = iconColor
                self.selectedView.hidden = true
            }
        }
    }
    
    @IBInspectable var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
        }
    }
}