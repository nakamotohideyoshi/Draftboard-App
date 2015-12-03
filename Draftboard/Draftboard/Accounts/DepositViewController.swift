//
//  DepositViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 12/3/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DepositViewController: DraftboardViewController {

    @IBOutlet weak var currentBalanceLabel: DraftboardLabel!
    @IBOutlet weak var pendingBonusLabel: DraftboardLabel!
    
    @IBOutlet weak var depositedAmountField: LabeledField!
    @IBOutlet weak var creditCardField: LabeledField!
    
    @IBOutlet weak var visaImageView: UIImageView!
    @IBOutlet weak var amexImageView: UIImageView!
    @IBOutlet weak var mastercardImageView: UIImageView!
    @IBOutlet weak var discoverImageView: UIImageView!
    @IBOutlet weak var paypalImageView: UIImageView!
    
    @IBOutlet weak var addressOneField: LabeledField!
    @IBOutlet weak var addressTwoField: LabeledField!
    @IBOutlet weak var cityField: LabeledField!
    @IBOutlet weak var stateField: LabeledField!
    @IBOutlet weak var postalField: LabeledField!
    
    @IBOutlet weak var depositBtn: DraftboardButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
