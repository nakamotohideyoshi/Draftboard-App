//
//  LineupCard.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import Restraint

class LineupCardView: DraftboardNibView {
    
    let cellReuseId = "lineup-card-cell"
    
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    let itemCount = Int(arc4random_uniform(12)) + 1
    var contentHeight: CGFloat!
    var totalHeight: CGFloat!
    
    override func awakeFromNib() {
        contentHeight = (CGFloat(itemCount + 1) * 60.0)
        totalHeight = 66.0 + contentHeight + 48.0
        
        contentHeightConstraint.active = false
        contentView.heightRancor.constraintEqualToConstant(contentHeight).active = true
        
        layoutCellViews()
    }
    
    func layoutCellViews() {
        var lastCellView: LineupCellView?
        for _ in 0...itemCount {
            let cellView = LineupCellView()
            contentView.addSubview(cellView)
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.widthRancor.constraintEqualToRancor(contentView.widthRancor).active = true
            cellView.heightRancor.constraintEqualToConstant(60).active = true
            cellView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor).active = true
            
            cellView.onTap = {(target: AnyObject) -> () in
                print("cell tap")
            }
            
            if (lastCellView == nil) {
                cellView.topRancor.constraintEqualToRancor(contentView.topRancor).active = true
            }
            else {
                cellView.topRancor.constraintEqualToRancor(lastCellView!.bottomRancor).active = true
            }
            
            lastCellView = cellView
        }
    }
}