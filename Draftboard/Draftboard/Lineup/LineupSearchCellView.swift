//
//  LineupCell.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/14/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupSearchCellView: UITableViewCell {
    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var positionLabel: DraftboardLabel!
    @IBOutlet weak var avatarImageView: AvatarImageView!
    @IBOutlet weak var nameLabel: DraftboardLabel!
    @IBOutlet weak var salaryLabel: DraftboardLabel!
    @IBOutlet weak var leagueLabel: DraftboardLabel!
    @IBOutlet weak var statusLabel: DraftboardLabel!
    @IBOutlet weak var ppgLabel: UILabel!
    @IBOutlet weak var infoButton: DraftboardButton!
    @IBOutlet weak var bigInfoButton: UIButton!
//    @IBOutlet weak var infoButtonImage: UIImageView!
    @IBOutlet weak var topBorderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBorderHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        bottomBorderView.hidden = true
        topBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        bottomBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor(0x0, alpha: 0.05)
        
        contentView.userInteractionEnabled = false;
    }
    
    var player: Player? {
        didSet {
            avatarImageView.player = player
            nameLabel.text = player?.shortName
            positionLabel.text = player?.position
            leagueLabel.text = player?.team
            statusLabel.text = player?.injury
            salaryLabel.text = Format.currency.stringFromNumber(player?.salary ?? 0)
            ppgLabel.text = String(format: "%.2f FPPG", player?.fppg ?? 0)
        }
    }
    
    var overBudget: Bool = false {
        didSet {
            if overBudget {
                nameLabel.alpha = 0.35
                salaryLabel.alpha = 0.35
                leagueLabel.alpha = 0.35
                statusLabel.alpha = 0.35
            }
            else {
                nameLabel.alpha = 1.0
                salaryLabel.alpha = 1.0
                leagueLabel.alpha = 1.0
                statusLabel.alpha = 1.0
            }
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
}
