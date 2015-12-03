//
//  WithdrawViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 12/2/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class WithdrawViewController: DraftboardViewController {

    @IBOutlet weak var currentBalanceLabel: DraftboardLabel!
    @IBOutlet weak var pendingBonusLabel: DraftboardLabel!
    
    @IBOutlet weak var withdrawAmountField: LabeledField!
    @IBOutlet weak var paypalAddressField: LabeledField!
    
    @IBOutlet weak var ssnField: LabeledField!
    
    @IBOutlet weak var withdrawBtn: DraftboardButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
