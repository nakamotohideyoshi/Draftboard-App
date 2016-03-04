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
    @IBOutlet weak var countdownContainer: UIView!
    @IBOutlet weak var liveInLabel: UILabel!
    var countdownView = CountdownView(size: 10.0, color: .whiteColor())
    
    override func awakeFromNib() {
        topBorderViewHeight.constant = 1 / UIScreen.mainScreen().scale
        
        countdownContainer.addSubview(countdownView)
        countdownView.heightRancor.constraintEqualToConstant(20).active = true
        countdownView.centerYRancor.constraintEqualToRancor(countdownContainer.centerYRancor).active = true
        countdownView.leadingRancor.constraintEqualToRancor(liveInLabel.trailingRancor).active = true
        countdownView.trailingRancor.constraintEqualToRancor(countdownContainer.trailingRancor).active = true
    }
}
