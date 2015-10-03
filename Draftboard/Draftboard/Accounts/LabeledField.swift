//
//  LabeledField.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/2/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class LabeledField: DraftboardNibView, UITextFieldDelegate {
    @IBOutlet weak var borderTopView: UIView!
    @IBOutlet weak var borderBottomView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: DraftboardLabel!
    
    @IBOutlet weak var topBorderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBorderHeightConstraint: NSLayoutConstraint!
    
    override func willAwakeFromNib() {
        borderBottomView.hidden = true
        
        topBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        bottomBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        
        let bc = UIColor(0xFFFFFF, alpha: 0.05)
        borderTopView.backgroundColor = bc
        borderBottomView.backgroundColor = bc
        
        textField.textColor = .whiteColor()
        textField.delegate = self
        
        label.textColor = .draftboardTextLightColor()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepareForInterfaceBuilder() {
        textField.text = textField.placeholder
    }
    
    @IBInspectable var borderColor: UIColor = UIColor(0xFFFFFF, alpha: 0.2) {
        didSet {
            borderTopView.backgroundColor = borderColor
            borderBottomView.backgroundColor = borderColor
        }
    }
    
    @IBInspectable var topBorder: Bool = true {
        didSet {
            borderTopView.hidden = !topBorder
        }
    }
    
    @IBInspectable var bottomBorder: Bool = false {
        didSet {
            borderBottomView.hidden = !bottomBorder
        }
    }
    
    @IBInspectable var titleText: String = "Label" {
        didSet {
            label.text = titleText.uppercaseString
        }
    }
    
    @IBInspectable var placeholderText: String = "Placeholder Text" {
        didSet {
            let str = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            textField.attributedPlaceholder = str
        }
    }
}
