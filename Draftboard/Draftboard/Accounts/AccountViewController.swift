//
//  AccountViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/2/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class AccountViewController: DraftboardViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clearColor()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapRecognizer.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func titlebarTitle() -> String {
        return "Account".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Menu
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType? {
        return nil
    }
}
