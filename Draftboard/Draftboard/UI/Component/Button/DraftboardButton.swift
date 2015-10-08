//
//  DraftboardButton.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardButton: UIControl {
    var label: DraftboardLabel!
    var iconImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
        
        label = DraftboardLabel()
        self.addSubview(label)
        constrainLabel()
        
        iconImageView = UIImageView()
        iconImageView.contentMode = .Center
        self.addSubview(iconImageView)
        constrainIconImageView()
        
        setDefaults()
    }
    
    func setDefaults() {
        textHighlightColor = .whiteColor()
        textColor = .whiteColor()
        textSize = 10.0
        textValue = "button".uppercaseString
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
    }
    
    func constrainLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXRancor.constraintEqualToRancor(self.centerXRancor).active = true
        label.centerYRancor.constraintEqualToRancor(self.centerYRancor).active = true
    }
    
    func constrainIconImageView() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        iconImageView.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        iconImageView.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        iconImageView.topRancor.constraintEqualToRancor(self.topRancor).active = true
    }
    
    // MARK: UIControl
    
    override var highlighted: Bool {
        didSet {
            if (highlighted) {
                label.textColor = textHighlightColor
                self.tintColor = iconHighlightColor
                self.layer.borderColor = borderHighlightColor.CGColor
                self.backgroundColor = bgHighlightColor

            }
            else {
                label.textColor = textColor
                self.tintColor = iconColor
                self.layer.borderColor = borderColor.CGColor
                self.backgroundColor = bgColor
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
    var textValue: String = "button".uppercaseString {
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
            self.layer.borderColor = borderColor.CGColor
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    // MARK: Background
    
    @IBInspectable
    var bgHighlightColor: UIColor = .draftboardAccentDarkColor()
    
    @IBInspectable
    var bgColor: UIColor = .draftboardAccentColor() {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    
    // MARK: Corners
    
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
            self.layer.shouldRasterize = cornerRadius > 0
        }
    }
    
    // MARK: Icon
    
    @IBInspectable
    var iconHighlightColor: UIColor = .whiteColor()
    
    @IBInspectable
    var iconColor: UIColor = .draftboardAccentColor() {
        didSet {
            self.tintColor = iconColor
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
        }
    }
    
    // MARK: Interface builder sucks
    
    override func prepareForInterfaceBuilder() {
        let _textHighlightColor = textHighlightColor
        textHighlightColor = _textHighlightColor
        
        let _textColor = textColor
        textColor = _textColor
        
        let _textSize = textSize
        textSize = _textSize
        
        let _textValue = textValue
        textValue = _textValue
        
        let _textBold = textBold
        textBold = _textBold
        
        let _textLetterSpacing = textLetterSpacing
        textLetterSpacing = _textLetterSpacing
        
        let _borderHighlightColor = borderHighlightColor
        borderHighlightColor = _borderHighlightColor
        
        let _borderColor = borderColor
        borderColor = _borderColor
        
        let _borderWidth = borderWidth
        borderWidth = _borderWidth
        
        let _bgHighlightColor = bgHighlightColor
        bgHighlightColor = _bgHighlightColor
        
        let _bgColor = bgColor
        bgColor = _bgColor
        
        let _iconColor = iconColor
        iconColor = _iconColor
        
        let _iconHighlightColor = iconHighlightColor
        iconHighlightColor = _iconHighlightColor
        
        let _selectedState = selectedState
        selectedState = _selectedState
        
        let _cornerRadius = cornerRadius
        cornerRadius = _cornerRadius
    }
}
