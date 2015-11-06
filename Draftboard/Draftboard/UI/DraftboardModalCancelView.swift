//
//  DraftboardModalCancelView.swift
//  Draftboard
//
//  Created by Wes Pearce on 11/5/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class DraftboardModalCancelView: DraftboardNibControl {
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var titleLabel: DraftboardLabel!
    
    override func willAwakeFromNib() {
        _selectedView = selectedView
    }
}
