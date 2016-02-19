//
//  LineupEditCellView.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/15/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable
class LineupEditCellView: DraftboardNibControl {
    @IBOutlet weak var bottomBorderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topBorderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var avatarImageView: AvatarImageView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var topBorderView: UIView!
    
    @IBOutlet weak var teamLabel: DraftboardLabel!
    @IBOutlet weak var nameLabel: DraftboardLabel!
    @IBOutlet weak var abbrLabel: DraftboardLabel!
    @IBOutlet weak var salaryLabel: DraftboardLabel!
    
    var index: Int = 0
    
    override func willAwakeFromNib() {
        nibView.backgroundColor = .clearColor()
        bottomBorderView.hidden = true
        topBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        bottomBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
    }
    
    var player: Player? {
        didSet {
            avatarImageView.player = player
            nameLabel.textColor = .whiteColor()
            nameLabel.text = player?.shortName
            teamLabel.text = player?.team
            salaryLabel.text = Format.currency.stringFromNumber(player?.salary ?? 0)
        }
    }
    
    @IBInspectable var topBorder: Bool = true {
        didSet {
            topBorderView.hidden = !topBorder
        }
    }
    
    @IBInspectable var bottomBorder: Bool = false {
        didSet {
            bottomBorderView.hidden = !bottomBorder
        }
    }
    
    @IBInspectable var nameText: String = "" {
        didSet {
            nameLabel.text = nameText
        }
    }
    
    @IBInspectable var abbrText: String = "" {
        didSet {
            abbrLabel.text = abbrText
        }
    }
    
    @IBInspectable var teamText: String = "" {
        didSet {
            teamLabel.text = teamText
        }
    }
    
    @IBInspectable var salaryText: String = "" {
        didSet {
            salaryLabel.text = salaryText
        }
    }
}