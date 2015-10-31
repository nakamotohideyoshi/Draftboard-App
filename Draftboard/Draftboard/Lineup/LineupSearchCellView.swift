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
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: DraftboardLabel!
    @IBOutlet weak var salaryLabel: DraftboardLabel!
    @IBOutlet weak var leagueLabel: DraftboardLabel!
    @IBOutlet weak var statusLabel: DraftboardLabel!
    @IBOutlet weak var ppgLabel: UILabel!
    @IBOutlet weak var infoButton: DraftboardButton!
    @IBOutlet weak var topBorderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBorderHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        bottomBorderView.hidden = true
        topBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        bottomBorderHeightConstraint.constant = 1.0 / UIScreen.mainScreen().scale
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor(0x0, alpha: 0.05)
    }
    
    var player: Player? {
        didSet {
            nameLabel.text = (player?.name)!
            positionLabel.text = (player?.position)!
            ppgLabel.text = String(format: "%.2f FPPG", (player?.fppg)!)
            leagueLabel.text = " - " + (player?.team)!
            salaryLabel.text = String(format: "$%.0f", (player?.salary)!)
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
