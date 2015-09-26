//
//  LineupCell.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/14/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupCellView: DraftboardNibControl {
    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var positionLabel: DraftboardLabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var salaryLabel: DraftboardLabel!
    @IBOutlet weak var nameLabel: DraftboardLabel!
    @IBOutlet weak var avgLabel: DraftboardLabel!
    @IBOutlet weak var avgValueLabel: DraftboardLabel!
    @IBOutlet weak var selectedView: DraftboardView!
    
    override func willAwakeFromNib() {
        bottomBorderView.hidden = true
        _selectedView = selectedView
    }
}
