//
//  DraftboardButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardRoundedButton: DraftboardNibView {
    
    @IBOutlet weak var label: DraftboardLabel!
    @IBOutlet weak var borderImageView: UIImageView!
    
    override func awakeFromNib() {
        // nothing here
    }
    
    @IBInspectable var text: String = "tap" {
        didSet {
            label.text = text
        }
    }
    
    @IBInspectable var bold: Bool = false {
        didSet {
            let pointSize = label.font.pointSize
            
            if (bold) {
                label.font = UIFont(name: "OpenSans-Semibold", size: pointSize)
            } else {
                label.font = UIFont(name: "OpenSans", size: pointSize)
            }
        }
    }
    
    @IBInspectable var textColor: UIColor = .draftboardGreen() {
        didSet {
            label.textColor = textColor
        }
    }
}
