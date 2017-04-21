//
//  LabeledField.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/2/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

struct LabeledFieldType : OptionSetType {
    let rawValue: Int
    static let Normal = LabeledFieldType(rawValue: 0)
    static let Birthday = LabeledFieldType(rawValue: 1 << 0)
}

@IBDesignable
class LabeledField: DraftboardNibView, UITextFieldDelegate {
    @IBOutlet weak var borderTopView: UIView!
    @IBOutlet weak var borderBottomView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: DraftboardLabel!
    
    @IBOutlet weak var topBorderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBorderHeightConstraint: NSLayoutConstraint!
    
    var delegate: UITextFieldDelegate?
    var labelType: LabeledFieldType = .Normal
    
    override func willAwakeFromNib() {
        borderBottomView.hidden = true
        
        topBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        bottomBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        
        let bc = UIColor(0xFFFFFF, alpha: 0.1)
        borderTopView.backgroundColor = bc
        borderBottomView.backgroundColor = bc
        
        textField.textColor = .whiteColor()
        textField.autocorrectionType = .No
        textField.delegate = self
        
        label.textColor = .whiteLowOpacity()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let delegate = delegate {
            return (delegate.textFieldShouldReturn?(textField))!
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (labelType == .Birthday) {
            let currentText = textField.text
            if (string != "") {
                if currentText!.characters.count == 2 {
                    textField.text = currentText! + "/"
                } else if currentText!.characters.count == 5 {
                    textField.text = currentText! + "/"
                } else if currentText!.characters.count == 10 {
                    return false
                }
            }
        }
        return true
    }
    
    override func prepareForInterfaceBuilder() {
        textField.text = textField.placeholder
    }
    
    @IBInspectable var secureEntry: Bool = false {
        didSet {
            textField.secureTextEntry = secureEntry
        }
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
            let str = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: UIColor(0xFFFFFF, alpha: 0.25)])
            textField.attributedPlaceholder = str
        }
    }
}
