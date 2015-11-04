//
//  LoginViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/30/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LoginViewController: DraftboardViewController {
    
    @IBOutlet var passwordField: LabeledField!
    @IBOutlet var loginField: LabeledField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Back) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String? {
        return "".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
}