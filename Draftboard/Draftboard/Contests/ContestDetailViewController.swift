//
//  ContestDetailViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 10/27/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestDetailViewController: DraftboardViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Back) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String? {
        return "$100K Free Roll".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
}
