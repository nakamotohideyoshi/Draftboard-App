//
//  LineupNewViewController.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/16/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupNewViewController: UIViewController {
    
    // Header
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // Content area (items)
    @IBOutlet weak var contentView: UIView!
    
    // Footer
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var remSalaryLabel: DraftboardLabel!
    @IBOutlet weak var avgSalaryLabel: DraftboardLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
