//
//  DraftboardViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/25/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardViewController: UIViewController, DraftboardTitlebarDelegate, DraftboardTitlebarDataSource {
    
    var navController: DraftboardNavController?
    
    func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        print("didTapTitlebarButton:", buttonType)
    }
    
    func titlebarTitle() -> String? {
        return "No Title".uppercaseString
    }
    
    func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Menu
    }
    
    func titlebarRightButtonType() -> TitlebarButtonType? {
        return nil
    }
    
    func titlebarLeftButtonText() -> String? {
        return nil
    }
    
    func titlebarRightButtonText() -> String? {
        return nil
    }
    
    func titlebarBgHidden() -> Bool {
        return true
    }
}
