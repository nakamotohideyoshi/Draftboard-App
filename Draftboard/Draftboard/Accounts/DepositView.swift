//
//  DepositViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 12/3/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DepositView: DraftboardNibView {

    @IBOutlet weak var scrollView: UIScrollView!
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
    
    override func willAwakeFromNib() {
        super.willAwakeFromNib()
        scrollView.bottomRancor.constraintEqualToRancor(depositBtn.bottomRancor, constant: 30).active = true
    }
}
