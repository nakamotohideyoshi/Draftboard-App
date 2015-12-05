//
//  ChangePasswordViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 12/4/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ChangePasswordViewController: DraftboardViewController {

    @IBOutlet weak var currentPasswordField: LabeledField!
    @IBOutlet weak var newPasswordFirstField: LabeledField!
    @IBOutlet weak var newPasswordSecondField: LabeledField!
    @IBOutlet weak var saveBtn: DraftboardButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Back) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String {
        return "Change Password".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType? {
        return nil
    }
}
