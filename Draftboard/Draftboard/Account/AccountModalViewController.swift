//
//  AccountModalViewController.swift
//  Draftboard
//
//  Created by devguru on 9/12/17.
//  Copyright © 2017 Rally Interactive. All rights reserved.
//

import UIKit

class AccountModalViewController: DraftboardModalViewController {

    var accountModalView: AccountModalView { return view as! AccountModalView }
    var okButton: UIButton { return accountModalView.okButton }
    var logoutButton: UIButton { return accountModalView.logoutButton }
    
    override func loadView() {
        view = AccountModalView()
        okButton.addTarget(self, action: .didTapOkButton, forControlEvents: .TouchUpInside)
        logoutButton.addTarget(self, action: .didTapLogoutButton, forControlEvents: .TouchUpInside)
    }
    
    func didTapOkButton(button: UIButton) {
        RootViewController.sharedInstance.popModalViewController()
    }
    
    func didTapLogoutButton(button: UIButton) {
        API.deauth()
        let login = RootViewController.sharedInstance.showLoginController()
        login.then { () -> Void in
            RootViewController.sharedInstance.popModalViewController()
        }
    }
}

private extension Selector {
    static let didTapOkButton = #selector(AccountModalViewController.didTapOkButton(_:))
    static let didTapLogoutButton = #selector(AccountModalViewController.didTapLogoutButton(_:))
}
