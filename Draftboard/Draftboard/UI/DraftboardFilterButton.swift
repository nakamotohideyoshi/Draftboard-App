//
//  DraftboardFilterButton.swift
//  Draftboard
//
//  Created by Karl Weber on 9/23/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable class DraftboardFilterButton: DraftboardNibView {

    @IBOutlet weak var label: DraftboardLabel!
    
    override func awakeFromNib() {
//        super.awakeFromNib()
        // Initialization code
    }
    
    @IBInspectable var text: String = "Button" {
        didSet {
            label.text = text
        }
    }
    
}