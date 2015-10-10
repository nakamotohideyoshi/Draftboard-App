//
//  LineupCard.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupCardView: DraftboardNibView {
    
    @IBOutlet weak var editButton: DraftboardButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIView!
    
//    let itemCount = Int(arc4random_uniform(12)) + 1
    let itemCount = 12
    var contentHeight: CGFloat!
    var totalHeight: CGFloat!
    
    override func willAwakeFromNib() {
        layoutCellViews()
    }
    
    func layoutCellViews() {
        var previousCell: LineupCellView?
        
        for i in 0...itemCount {
            let cellView = LineupCellView()
            contentView.addSubview(cellView)
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
            cellView.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
            cellView.heightRancor.constraintEqualToRancor(contentView.heightRancor, multiplier: 1.0 / 8.0).active = true
            cellView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor).active = true
            
            if (previousCell == nil) {
                cellView.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
            }
            else {
                cellView.topRancor.constraintEqualToRancor(previousCell!.bottomRancor).active = true
            }
            
            if (i == itemCount) {
                cellView.bottomRancor.constraintEqualToRancor(contentView!.bottomRancor).active = true
            }
            
            previousCell = cellView
        }
    }
}
