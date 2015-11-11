//
//  ContestsHeaderCell.swift
//  Draftboard
//
//  Created by Karl Weber on 9/23/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

@IBDesignable class ContestsHeaderCell: UITableViewHeaderFooterView {
    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var topBorderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: DraftboardLabel!
    
    override func awakeFromNib() {
        topBorderViewHeight.constant = 1 / UIScreen.mainScreen().scale
    }
}
