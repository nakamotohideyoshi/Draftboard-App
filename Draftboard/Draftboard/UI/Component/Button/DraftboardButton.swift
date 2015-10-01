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
        
        // Defaults
        textHighlightColor = .whiteColor()
        textColor = .whiteColor()
        textSize = 10.0
        textValue = "BUTTON"
        textBold = false
        textLetterSpacing = 0.5
        borderHighlightColor = .draftboardAccentColor()
        borderColor = .draftboardAccentColor()
        borderWidth = 0.0
        cornerRadius = 0.0
        bgHighlightColor = .draftboardAccentDarkColor()
        bgColor = .draftboardAccentColor()
        iconColor = .whiteColor()
        iconHighlightColor = .whiteColor()
        selectedState = false
        
        // Needed for rounded corners
        nibView.layer.rasterizationScale = UIScreen.mainScreen().scale
    }
    
    // MARK: UIControl
    
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
    
    // MARK: Button state
    
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
    
    // MARK: Text styling
    
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
    var borderHighlightColor: UIColor = .draftboardAccentColor()
    
    @IBInspectable
    var borderColor: UIColor = .draftboardAccentColor() {
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
    var bgHighlightColor: UIColor = .draftboardAccentDarkColor()
    
    @IBInspectable
    var bgColor: UIColor = .draftboardAccentColor() {
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
    var iconColor: UIColor = .draftboardAccentColor() {
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
