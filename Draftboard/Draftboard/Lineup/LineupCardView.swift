//
//  LineupCard.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/10/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit
import Restraint

class LineupCardView: UIView {
    
    let cellReuseId = "lineup-card-cell"
    
    @IBOutlet weak var contentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var view: UIView!
    
    let itemCount = Int(arc4random_uniform(12)) + 1
    var contentHeight: CGFloat!
    var totalHeight: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "LineupCardView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        addSubview(view)
        
        contentHeight = (CGFloat(itemCount + 1) * 60.0)
        totalHeight = 66.0 + contentHeight + 48.0
        
        contentHeightConstraint.active = false
        contentView.height.constraintEqualTo(contentHeight).active = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.left.constraintEqualTo(self.left).active = true
        view.top.constraintEqualTo(self.top).active = true
        view.bottom.constraintEqualTo(self.bottom).active = true
        view.right.constraintEqualTo(self.right).active = true
        
        layoutCellViews()
    }
    
    func layoutCellViews() {
        
        var lastCellView: LineupCellView?
        for _ in 0...itemCount {
            let cellView = LineupCellView()
            contentView.addSubview(cellView)
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.width.constraintEqualTo(contentView.width, multiplier: 1.0, constant: 0.0).active = true
            cellView.height.constraintEqualTo(60).active = true
            cellView.centerX.constraintEqualTo(contentView.centerX).active = true
            
            if (lastCellView == nil) {
                cellView.top.constraintEqualTo(contentView.top).active = true
            }
            else {
                cellView.top.constraintEqualTo(lastCellView!.bottom).active = true
            }
            
            lastCellView = cellView
        }
    }
}