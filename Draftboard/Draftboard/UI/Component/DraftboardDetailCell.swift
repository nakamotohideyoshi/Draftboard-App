//
//  DraftboardContestsCell.swift
//  Draftboard
//
//  Created by Karl Weber on 9/22/15.
//  Copyright © 2015 Rally Inte ractive. All rights reserved.
//

import UIKit

class DraftboardDetailCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: DraftboardLabel!
    @IBOutlet weak var rightLabel: DraftboardLabel!
    @IBOutlet weak var rightLabelSuffix: DraftboardLabel!
    
    @IBOutlet weak var borderTopView: UIView!
    @IBOutlet weak var borderBottomView: UIView!
    @IBOutlet weak var borderTopHeight: NSLayoutConstraint!
    @IBOutlet weak var borderBottomHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        borderBottomView.hidden = true
        
        borderTopHeight.constant = App.screenPixel
        borderBottomHeight.constant = App.screenPixel
        
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor(0x0, alpha: 0.05)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        let borderColor = borderBottomView.backgroundColor
        
        super.setSelected(selected, animated: animated)
        
        borderBottomView.backgroundColor = borderColor
        borderTopView.backgroundColor = borderColor
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        let borderColor = borderBottomView.backgroundColor
        
        super.setHighlighted(selected, animated: animated)
        
        borderBottomView.backgroundColor = borderColor
        borderTopView.backgroundColor = borderColor
    }
}
