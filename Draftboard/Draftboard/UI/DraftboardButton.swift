//
//  DraftboardButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardButton: DraftboardNibView {
    
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.redColor().CGColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 2.0
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.greenColor() {
        didSet {
            self.layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable var borderWidth : CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}
