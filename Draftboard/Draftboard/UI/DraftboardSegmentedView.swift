//
//  DraftboardSegmentedView.swift
//  Draftboard
//
//  Created by Wes Pearce on 10/2/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class DraftboardSegmentedView: DraftboardNibView {

    @IBOutlet weak var settingsLabel: DraftboardLabel!
    @IBOutlet weak var withdrawLabel: DraftboardLabel!
    @IBOutlet weak var addFundsLabel: DraftboardLabel!
    @IBOutlet weak var indicatorView: UIView!
    
    override func willAwakeFromNib() {
        super.willAwakeFromNib()
        nibView.backgroundColor = .clearColor()
    }
}
