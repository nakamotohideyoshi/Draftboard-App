//
//  LineupCell.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/14/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupCellView: DraftboardNibControl {
    @IBOutlet weak var positionLabel: DraftboardLabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var nameLabel: DraftboardLabel!
    @IBOutlet weak var teamLabel: DraftboardLabel!
    @IBOutlet weak var selectedView: DraftboardView!
    @IBOutlet weak var unitLabel: DraftboardLabel!
    @IBOutlet weak var avatarView: AvatarPMRView!
    
    override func willAwakeFromNib() {
        nibView.backgroundColor = .clearColor()
        _selectedView = selectedView
    }
    
    var player: Player? {
        didSet {
            nameLabel.text = player?.shortName()
            teamLabel.text = (player?.team)!
            rightLabel.text = String(format: "$%.0f", (player?.salary)!)
        }
    }
}