//
//  ContestsPlayerHeaderCell.swift
//  Draftboard
//
//  Created by Geof Crowl on 1/15/16.
//  Copyright © 2016 Rally Interactive. All rights reserved.
//

import UIKit

class ContestsPlayerHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var lineupPoints: DraftboardLabel!
    @IBOutlet weak var lineupPlace: DraftboardLabel!
    @IBOutlet weak var lineupPMR: DraftboardLabel!
    @IBOutlet weak var lineupWinnings: DraftboardLabel!
    @IBOutlet weak var playerName: DraftboardLabel!
    
    @IBOutlet weak var divider: UIView!
    @IBOutlet weak var dividerHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization coder
        dividerHeight.constant = App.screenPixel
        divider.backgroundColor = UIColor.dividerOnWhiteColor()
    }
    
}
