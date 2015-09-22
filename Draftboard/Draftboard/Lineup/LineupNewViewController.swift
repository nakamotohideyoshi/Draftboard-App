//
//  LineupNewViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupNewViewController: UIViewController {
    @IBOutlet weak var editButton: DraftboardIconButton!
    @IBOutlet weak var saveButton: DraftboardRoundedButton!
    @IBOutlet weak var remSalaryLabel: DraftboardLabel!
    @IBOutlet weak var avgSalaryLabel: DraftboardLabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    weak var listViewController: LineupsListController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sv = self.view as! UIScrollView
        sv.alwaysBounceVertical = true
        
        let saveTapRecognizer = UITapGestureRecognizer()
        saveTapRecognizer.addTarget(self, action: "didTapSave:")
        saveButton.addGestureRecognizer(saveTapRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    func didTapSave(gestureRecognizer: UITapGestureRecognizer) {
        listViewController?.didSaveLineup()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            // nothing here
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
