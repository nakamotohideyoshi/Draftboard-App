//
//  DraftboardButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardIconButton: DraftboardNibView {
    
    @IBOutlet weak var borderImageView: UIImageView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        // nothing here
    }
    
    @IBInspectable var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
        }
    }
}