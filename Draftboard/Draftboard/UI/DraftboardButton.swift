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

    @IBOutlet weak var label: DraftboardLabel!
    
    override func awakeFromNib() {
        // nothing here
    }
    
    @IBInspectable var text: String = "Button" {
        didSet {
            label.text = text
        }
    }
}