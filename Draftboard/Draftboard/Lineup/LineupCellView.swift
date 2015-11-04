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
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var nameLabel: DraftboardLabel!
    @IBOutlet weak var teamLabel: DraftboardLabel!
    @IBOutlet weak var avgLabel: DraftboardLabel!
    @IBOutlet weak var selectedView: DraftboardView!
    @IBOutlet weak var pmrGraph: UIView!
    
    override func willAwakeFromNib() {
        bottomBorderView.hidden = true
        topBorderView.hidden = true
        nibView.backgroundColor = .clearColor()
        _selectedView = selectedView
    }
    
    var player: Player? {
        didSet {
            nameLabel.text = (player?.name)!
            teamLabel.text = (player?.team)!
            rightLabel.text = String(format: "$%.0f", (player?.salary)!)
        }
    }

}
