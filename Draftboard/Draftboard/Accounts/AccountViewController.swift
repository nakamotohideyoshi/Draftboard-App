//
//  AccountViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/2/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class AccountViewController: DraftboardViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var segmentedControl: DraftboardSegmentedControl!
    
    var settingsView: AccountSettingsView?
    var withdrawView: WithdrawView?
    var depositView: DepositView?
    
    var currentContentView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentedControl = DraftboardSegmentedControl(
            choices: ["Settings", "Withdraw", "Add Funds"],
            textColor: .whiteLowOpacity(),
            textSelectedColor: .whiteColor()
        )
        
        self.view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.topRancor.constraintEqualToRancor(headerView.topRancor).active = true
        segmentedControl.rightRancor.constraintEqualToRancor(headerView.rightRancor).active = true
        segmentedControl.bottomRancor.constraintEqualToRancor(headerView.bottomRancor).active = true
        segmentedControl.leftRancor.constraintEqualToRancor(headerView.leftRancor).active = true
        
        segmentedControl.indexChangedHandler = { (index: Int) in
            let view = self.contentViewForIndex(index)
            self.replaceContentView(view!)
        }
        
        settingsView = AccountSettingsView()
        settingsView?.changePasswordButton.addTarget(self, action: "didTapChangePassword:", forControlEvents: .TouchUpInside)
        
        self.replaceContentView(settingsView!)
    }
    
    func didTapChangePassword(sender: DraftboardButton) {
        let pvc = ChangePasswordViewController(nibName: "ChangePasswordViewController", bundle: nil)
        self.navController?.pushViewController(pvc)
    }
    
    func contentViewForIndex(index: Int) -> UIView? {
        if (index == 0) {
            if (settingsView == nil) {
                settingsView = AccountSettingsView()
            }
            
            return settingsView
        }
        
        else if (index == 1) {
            if (withdrawView == nil) {
                withdrawView = WithdrawView()
            }
            
            return withdrawView
        }
        
        else if (index == 2) {
            if (depositView == nil) {
                depositView = DepositView()
            }
            
            return depositView
        }
        
        return nil
    }
    
    func replaceContentView(view: UIView) {
        currentContentView?.removeFromSuperview()
        contentView.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
        view.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
        view.bottomRancor.constraintEqualToRancor(contentView.bottomRancor).active = true
        view.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
    }
    
    override func titlebarTitle() -> String {
        return "Account".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return nil
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType? {
        return nil
    }
}