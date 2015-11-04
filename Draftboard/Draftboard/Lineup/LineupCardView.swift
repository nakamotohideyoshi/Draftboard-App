//
//  LineupCard.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

protocol LineupCardViewDelegate {
    func didTap(buttonType: TabBarButtonType)
}

class LineupCardView: DraftboardNibView {
    
    @IBOutlet weak var editButton: DraftboardButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIScrollView!
    @IBOutlet weak var contentViewContainer: UIView!
    @IBOutlet weak var dividerHeight: NSLayoutConstraint!
    @IBOutlet weak var containerDividerHeight: NSLayoutConstraint!
    @IBOutlet weak var pmrGraph: UIView!
    
//    let itemCount = Int(arc4random_uniform(12)) + 1
    let itemCount = 12
    var contentHeight: CGFloat!
    var totalHeight: CGFloat!
    
    override func willAwakeFromNib() {
        contentView.indicatorStyle = .White
        contentView.alwaysBounceVertical = true

        contentViewContainer.clipsToBounds = true
        contentView.clipsToBounds = false
        
        // set dividers to real 1px height
        let onePixel = 1 / UIScreen.mainScreen().scale
        dividerHeight.constant = onePixel
        containerDividerHeight.constant = onePixel
        
//        UIGraphicsBeginImageContextWithOptions(contentView.bounds.size, true, 1)
//        drawViewHierarchyInRect(contentView.bounds, afterScreenUpdates: true)
//        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        blurImageOverlay.image = screenshot
        
//        layoutCellViews()
    }
    
    var lineup: [Player]? {
        didSet {
            layoutCellViews()
        }
    }
    
    func layoutCellViews() {
        var previousCell: LineupCellView?
        
        for (i, player) in (lineup?.enumerate())! {
            let cellView = LineupCellView()
            cellView.player = player
            contentView.addSubview(cellView)
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.leftRancor.constraintEqualToRancor(contentView.leftRancor).active = true
            cellView.rightRancor.constraintEqualToRancor(contentView.rightRancor).active = true
            cellView.heightRancor.constraintEqualToRancor(contentView.heightRancor, multiplier: 1.0 / 8.0).active = true
            cellView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor).active = true
            
            // this is the constraint for the first cell
            // will need to be set to bottom of toggle
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