//
//  LineupNewViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupNewViewController: DraftboardViewController {
    @IBOutlet weak var remSalaryLabel: DraftboardLabel!
    @IBOutlet weak var avgSalaryLabel: DraftboardLabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var listViewController: LineupsListController?
    
    override func viewDidLoad() {
        view.backgroundColor = .clearColor()
        
        let saveTapRecognizer = UITapGestureRecognizer()
        saveTapRecognizer.addTarget(self, action: "didTapSave:")
        //saveButton.addGestureRecognizer(saveTapRecognizer)
        
        let app = UIApplication.sharedApplication()
        app.setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        
        // Do any additional setup after loading the view.
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Value) {
            listViewController?.didSaveLineup()
            RootViewController.sharedInstance.popViewController()
        }
    }
    
    override func titlebarTitle() -> String {
        return "Create Lineup".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType {
        return .Menu
    }
    
    override func titlebarRightButtonType() -> TitlebarButtonType {
        return .Value
    }
    
    override func titlebarRightButtonText() -> String? {
        return "Save".uppercaseString
    }
    
    override func titlebarBgHidden() -> Bool {
        return false
    }
}
