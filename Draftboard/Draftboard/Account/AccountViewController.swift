//
//  AccountViewController.swift
//  Draftboard
//
//  Created by Anson Schall on 9/23/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit
import PromiseKit

class AccountViewController: DraftboardViewController {
    
    var accountView: AccountView { return view as! AccountView }
    var usernameField: DraftboardLabeledField { return accountView.usernameField }
    var logoutButton: DraftboardTextButton { return accountView.logoutButton }
    
    override func loadView() {
        self.view = AccountView()
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), forControlEvents: .TouchUpInside)
    }
    
    override func viewWillAppear(animated: Bool) {
        if let username = API.username {
            usernameField.textField.text = username
            usernameField.alpha = 1
            logoutButton.label.text = "Log Out".uppercaseString
            logoutButton.label.alpha = 1
            logoutButton.backgroundColor = .greenDraftboard()
            self.logoutButton.layer.borderColor = UIColor.greenDraftboard().CGColor
            logoutButton.userInteractionEnabled = true
        } else {
            usernameField.textField.text = nil
            usernameField.alpha = 0
            logoutButton.label.text = "Logged Out".uppercaseString
            logoutButton.label.alpha = 0.5
            logoutButton.backgroundColor = .greyCool()
            self.logoutButton.layer.borderColor = UIColor.greyCool().CGColor
            logoutButton.userInteractionEnabled = false
        }
    }
    
    func logoutButtonTapped() {
        API.deauth()
        logoutButton.userInteractionEnabled = false
        logoutButton.label.text = "Logged Out".uppercaseString
        UIView.animateWithDuration(0.25) {
            self.usernameField.alpha = 0
            self.logoutButton.label.alpha = 0.5
            self.logoutButton.backgroundColor = .greyCool()
            self.logoutButton.layer.borderColor = UIColor.greyCool().CGColor
        }
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return nil
    }
    
    override func titlebarTitle() -> String? {
        return "Account".uppercaseString
    }
    
}
