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
    @IBOutlet weak var downArrow: UIImageView!
    
    override func willAwakeFromNib() {
        super.willAwakeFromNib()
        // Initialization code
        downArrow.tintColor = .greenDraftboard()
    }
    
    @IBInspectable var text: String = "Button" {
        didSet {
            label.text = text
        }
    }
}