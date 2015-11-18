//
//  PlayerDetailLiveViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 11/18/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class PlayerDetailLiveViewController: DraftboardViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var bottomInfoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the bottom of the scroll
        scrollView.bottomRancor.constraintEqualToRancor(bottomInfoView.bottomRancor).active = true
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Back) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String? {
        return "Kyle Korver".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
    
    override func titlebarBgHidden() -> Bool {
        return false
    }
}
