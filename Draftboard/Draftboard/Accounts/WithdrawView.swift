//
//  WithdrawViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 12/2/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class WithdrawView: DraftboardNibView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var currentBalanceLabel: DraftboardLabel!
    @IBOutlet weak var pendingBonusLabel: DraftboardLabel!
    
    @IBOutlet weak var withdrawAmountField: LabeledField!
    @IBOutlet weak var paypalAddressField: LabeledField!
    @IBOutlet weak var ssnField: LabeledField!
    
    @IBOutlet weak var withdrawBtn: DraftboardButton!
    
    override func willAwakeFromNib() {
        super.willAwakeFromNib()
        scrollView.bottomRancor.constraintEqualToRancor(withdrawBtn.bottomRancor, constant: 30).active = true
    }
}
