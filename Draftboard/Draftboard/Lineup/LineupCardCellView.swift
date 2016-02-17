//
//  LineupCell.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/14/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupCardCellView: DraftboardNibControl {
    @IBOutlet weak var positionLabel: DraftboardLabel!
    @IBOutlet weak var rightLabel: DraftboardLabel!
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
            avatarView.avatarImageView.image = UIImage(named: "sample-avatar-big")
            positionLabel.text = player?.position
            nameLabel.text = player?.shortName
            teamLabel.text = player?.team
        }
    }
    
    func showPoints() {
        if let _ = player { // TODO: for real
            rightLabel.text = String(format: "%.1f", 0.0)
            unitLabel.text = "PTS"
        }
    }
    
    func showFantasyPoints() {
        if let player = player {
            rightLabel.text = String(format: "%.1f", player.fppg)
            unitLabel.text = "FPPG"
        }
    }
    
    func showSalary() {
        if let player = player {
            rightLabel.text = Format.currency.stringFromNumber(player.salary ?? 0)
            unitLabel.text = ""
        }
    }
}