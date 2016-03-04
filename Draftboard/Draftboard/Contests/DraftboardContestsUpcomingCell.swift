//
//  DraftboardContestsCell.swift
//  Draftboard
//
//  Created by Karl Weber on 9/22/15.
//  Copyright © 2015 Rally Inte ractive. All rights reserved.
//

import UIKit

class DraftboardContestsUpcomingCell: UITableViewCell {
    
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var guaranteedImageView: UIImageView!
    @IBOutlet weak var titleLabel: DraftboardLabel!
    @IBOutlet weak var contestFee: DraftboardLabel!
    @IBOutlet weak var contestPrizes: DraftboardLabel!
    
    override func awakeFromNib() {
        self.backgroundColor = .cellColorDark()
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor(0x0, alpha: 0.1)
        
        let tintColor = iconImageView.tintColor
        iconImageView.tintColor = nil
        iconImageView.tintColor = tintColor
        
        self.bottomBorderView.hidden = true
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        let borderColor = self.bottomBorderView.backgroundColor
        
        super.setSelected(selected, animated: animated)
        
        self.bottomBorderView.backgroundColor = borderColor
        self.topBorderView.backgroundColor = borderColor
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let borderColor = self.bottomBorderView.backgroundColor
        
        super.setHighlighted(selected, animated: animated)
        
        self.bottomBorderView.backgroundColor = borderColor
        self.topBorderView.backgroundColor = borderColor
    }
}
