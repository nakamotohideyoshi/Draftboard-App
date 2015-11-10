//
//  ContestLiveDetailViewController.swift
//  Draftboard
//
//  Created by Geof Crowl on 11/9/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestLiveDetailViewController: DraftboardViewController {
    
    @IBOutlet weak var feeLabel: DraftboardLabel!
    @IBOutlet weak var prizeLabel: DraftboardLabel!
    @IBOutlet weak var entryLabel: DraftboardLabel!
    @IBOutlet weak var avgPmrLabel: DraftboardLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didTapTitlebarButton(buttonType: TitlebarButtonType) {
        if (buttonType == .Back) {
            self.navController?.popViewController()
        }
    }
    
    override func titlebarTitle() -> String? {
        return "$100K Free Roll".uppercaseString
    }
    
    override func titlebarLeftButtonType() -> TitlebarButtonType? {
        return .Back
    }
}
