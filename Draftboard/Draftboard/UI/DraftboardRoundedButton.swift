//
//  DraftboardButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardRoundedButton: DraftboardNibControl {
    
    @IBOutlet weak var label: DraftboardLabel!
    @IBOutlet weak var borderImageView: UIImageView!
    @IBOutlet weak var selectedView: DraftboardView!
    
    var labelColor: UIColor?
    
    override func awakeFromNib() {
        labelColor = label.textColor
    }
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                label.textColor = .whiteColor()
                self.selectedView.hidden = false
            }
            else {
                label.textColor = labelColor
                self.selectedView.hidden = true
            }
        }
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
