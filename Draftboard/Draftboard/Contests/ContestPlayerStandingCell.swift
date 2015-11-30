//
//  ContestPlayerStandingCell.swift
//  Draftboard
//
//  Created by Geof Crowl on 11/9/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class ContestPlayerStandingCell: UITableViewCell {
    @IBOutlet weak var playerName: DraftboardLabel!
    @IBOutlet weak var lineupPoints: DraftboardLabel!
    @IBOutlet weak var lineupPMR: DraftboardLabel!
    @IBOutlet weak var lineupWinnings: DraftboardLabel!
    @IBOutlet weak var lineupPlace: DraftboardLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor(0x0, alpha: 0.1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = UIColor(0x1a2537)
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(selected, animated: animated)
    }
}
