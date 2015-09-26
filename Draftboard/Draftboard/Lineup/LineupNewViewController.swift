//
//  LineupNewViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupNewViewController: DraftboardModalViewController {
    @IBOutlet weak var editButton: DraftboardRoundButton!
    @IBOutlet weak var saveButton: DraftboardRoundButton!
    @IBOutlet weak var remSalaryLabel: DraftboardLabel!
    @IBOutlet weak var avgSalaryLabel: DraftboardLabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var listViewController: LineupsListController?
    
    override func viewDidLoad() {
        let sv = self.view as! UIScrollView
        sv.alwaysBounceVertical = true
        
        let saveTapRecognizer = UITapGestureRecognizer()
        saveTapRecognizer.addTarget(self, action: "didTapSave:")
        saveButton.addGestureRecognizer(saveTapRecognizer)
        
        let app = UIApplication.sharedApplication()
        app.setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Fade)
        
        // Do any additional setup after loading the view.
    }
    
    func didTapSave(gestureRecognizer: UITapGestureRecognizer) {
        listViewController?.didSaveLineup()
        RootViewController.sharedInstance.popViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
