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
    static let Zipcode = LabeledFieldType(rawValue: 2 << 0)
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
    var inputToolbar: UIToolbar!
    
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
        
        inputToolbar = UIToolbar()
        inputToolbar.barStyle = .Default
        inputToolbar.translucent = true
        inputToolbar.sizeToFit()
        
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: .inputToolbarNextPressed)
        let flexibleSpaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        //var fixedSpaceButton = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        
        inputToolbar.setItems([flexibleSpaceButton, nextButton], animated: false)
        inputToolbar.userInteractionEnabled = true
        textField.inputAccessoryView = inputToolbar
    }
    
    func didTapNextButton(button: UIBarButtonItem) {
        if textField.tag > 0 && textField.tag < 7 {
            let nextTag = textField.tag + 1;
            let prevTag = textField.tag - 1;
            var tags: [Int] = [Int]()
            if (nextTag < 7) {
                for index in nextTag...6 {
                    tags += [index]
                }
            }
            if (prevTag > 0) {
                for index in 1...prevTag {
                    tags += [index]
                }
            }
            let parentView = textField.superview?.superview?.superview
            var nextEmptyField: UITextField!
            for index in tags {
                let inputField = parentView?.viewWithTag(index) as! UITextField!
                if inputField.text == "" {
                    nextEmptyField = inputField
                    break
                }
            }
            if (nextEmptyField != nil) {
                nextEmptyField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            
        } else {
            let nextTag = textField.tag + 1;
            // Try to find next responder
            let nextResponder = textField.superview?.superview?.superview?.viewWithTag(nextTag) as UIResponder!
            if (nextResponder != nil) {
                // Found next responder, so set it.
                nextResponder.becomeFirstResponder()
            } else {
                // Not found, so remove keyboard.
                textField.resignFirstResponder()
            }
        }
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
        } else if (labelType == .Zipcode) {
            let currentText = textField.text
            if (string != "") {
                if currentText?.characters.count == 5 {
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
private extension Selector {
    static let inputToolbarNextPressed = #selector(LabeledField.didTapNextButton(_:))
}
