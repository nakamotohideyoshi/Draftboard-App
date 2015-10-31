//
//  DraftboardContestsCell.swift
//  Draftboard
//
//  Created by Karl Weber on 9/22/15.
//  Copyright © 2015 Rally Inte ractive. All rights reserved.
//

import UIKit

class DraftboardContestsCell: UITableViewCell {
    
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var amountLabel: DraftboardLabel!
    @IBOutlet weak var titleLabel: DraftboardLabel!
    @IBOutlet weak var moneyBar: MoneyBar!
    
    @IBOutlet weak var topBorderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomBorderHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        let heightConstant = 1.0 / UIScreen.mainScreen().scale
        topBorderHeightConstraint.constant = heightConstant
        bottomBorderHeightConstraint.constant = heightConstant
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
        let moneybarColor = self.moneyBar.backgroundColor
        
        super.setSelected(selected, animated: animated)
        
        self.bottomBorderView.backgroundColor = borderColor
        self.topBorderView.backgroundColor = borderColor
        self.moneyBar.backgroundColor = moneybarColor
        
        self.moneyBar.layoutSubviews()
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let borderColor = self.bottomBorderView.backgroundColor
        let moneybarColor = self.moneyBar.backgroundColor
        
        super.setHighlighted(selected, animated: animated)
        
        self.bottomBorderView.backgroundColor = borderColor
        self.topBorderView.backgroundColor = borderColor
        self.moneyBar.backgroundColor = moneybarColor
        
        self.moneyBar.layoutSubviews()
    }
}
