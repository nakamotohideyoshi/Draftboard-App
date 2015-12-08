//
//  AccountViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/2/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class AccountSettingsView: DraftboardNibView {
    
    @IBOutlet weak var usernameField: LabeledField!
    @IBOutlet weak var changePasswordButton: DraftboardButton!
    @IBOutlet weak var emailField: LabeledField!
    @IBOutlet weak var fullNameField: LabeledField!
    @IBOutlet weak var streetAddressField: LabeledField!
    @IBOutlet weak var streetAddress2Field: LabeledField!
    @IBOutlet weak var cityField: LabeledField!
    @IBOutlet weak var zipField: LabeledField!
    @IBOutlet weak var dobField: LabeledField!
    @IBOutlet weak var ssnField: LabeledField!
    @IBOutlet weak var saveButton: DraftboardButton!
    @IBOutlet weak var stateField: LabeledField!
    @IBOutlet var scrollView: UIScrollView!
    
    override func willAwakeFromNib() {
        super.willAwakeFromNib()
        self.backgroundColor = .clearColor()
        
        // Set the scrollView bottom so that it can scroll
        scrollView.bottomRancor.constraintEqualToRancor(saveButton.bottomRancor, constant: 30).active = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapRecognizer.cancelsTouchesInView = false
        self.addGestureRecognizer(tapRecognizer)
    }
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
}