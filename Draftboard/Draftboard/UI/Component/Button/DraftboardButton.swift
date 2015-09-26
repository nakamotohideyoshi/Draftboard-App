//
//  DraftboardButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardButton: DraftboardNibControl {
    
    @IBOutlet weak var label: DraftboardLabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func willAwakeFromNib() {
        super.willAwakeFromNib()

        nibView.layer.rasterizationScale = UIScreen.mainScreen().scale
        
//        self.textHighlightColor = .whiteColor()
//        self.textColor = .whiteColor()
//        self.textSize = 10.0
//        self.textValue = "BUTTON"
//        self.textBold = false
//        self.textLetterSpacing = 0.5
//        self.borderHighlightColor = .draftboardGreen()
//        self.borderColor = .draftboardGreen()
//        self.borderWidth = 0.0
//        self.cornerRadius = 0.0
//        self.bgHighlightColor = .draftboardDarkGreen()
//        self.bgColor = .draftboardGreen()
//        self.iconColor = .whiteColor()
//        self.iconHighlightColor = .whiteColor()
//        self.selectedState = false
    }
    
    // Mark: UIControl
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                label.textColor = textHighlightColor
                nibView.layer.borderColor = borderHighlightColor.CGColor
                nibView.backgroundColor = bgHighlightColor
                nibView.tintColor = iconHighlightColor

            }
            else {
                label.textColor = textColor
                nibView.layer.borderColor = borderColor.CGColor
                nibView.backgroundColor = bgColor
                nibView.tintColor = iconColor
            }
        }
    }
    
    // Mark: Button state
    
    @IBInspectable
    var selectedState: Bool = false {
        didSet {
            if (selectedState) {
                self.highlighted = true
            } else {
                self.highlighted = false
            }
        }
    }
    
    // Mark: Text styling
    
    @IBInspectable
    var textHighlightColor: UIColor = .whiteColor()
    
    @IBInspectable
    var textColor: UIColor = .whiteColor() {
        didSet {
            label.textColor = textColor
        }
    }
    
    @IBInspectable
    var textSize: CGFloat = 10.0 {
        didSet {
            label.font = label.font.fontWithSize(textSize)
        }
    }
    
    @IBInspectable
    var textValue: String = "BUTTON" {
        didSet {
            label.text = textValue
        }
    }
    
    @IBInspectable
    var textBold: Bool = false {
        didSet {
            if (textBold) {
                label.font = UIFont(name: "OpenSans-Semibold", size: textSize)
            } else {
                label.font = UIFont(name: "OpenSans", size: textSize)
            }
        }
    }
    
    @IBInspectable
    var textLetterSpacing: CGFloat = 0.5 {
        didSet {
            label.letterSpacing = textLetterSpacing
        }
    }
    
    // MARK: Border
    
    @IBInspectable
    var borderHighlightColor: UIColor = .draftboardGreen()
    
    @IBInspectable
    var borderColor: UIColor = .draftboardGreen() {
        didSet {
            nibView.layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            nibView.layer.borderWidth = borderWidth
        }
    }
    
    // MARK: Bg
    
    @IBInspectable
    var bgHighlightColor: UIColor = .draftboardDarkGreen()
    
    @IBInspectable
    var bgColor: UIColor = .draftboardGreen() {
        didSet {
            nibView.backgroundColor = bgColor
        }
    }
    
    // MARK: Corners
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            nibView.layer.cornerRadius = cornerRadius
            nibView.layer.masksToBounds = cornerRadius > 0
            nibView.layer.shouldRasterize = cornerRadius > 0
        }
    }
    
    // MARK: Icon
    
    @IBInspectable
    var iconHighlightColor: UIColor = .whiteColor()
    
    @IBInspectable
    var iconColor: UIColor? {
        didSet {
            nibView.tintColor = iconColor
        }
    }
    
    @IBInspectable
    var iconImage: UIImage? {
        didSet {
            iconImageView.image = iconImage
            
            if (iconImage == nil) {
                label.hidden = false
            } else {
                label.hidden = true
            }
            
            if (selectedState) {
                nibView.tintColor = iconHighlightColor
            } else {
                nibView.tintColor = iconColor
            }
        }
    }
}
