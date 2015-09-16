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
        contentView.heightRancor.constraintEqualToConstant(contentHeight).active = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftRancor.constraintEqualToRancor(self.leftRancor).active = true
        view.topRancor.constraintEqualToRancor(self.topRancor).active = true
        view.bottomRancor.constraintEqualToRancor(self.bottomRancor).active = true
        view.rightRancor.constraintEqualToRancor(self.rightRancor).active = true
        
        layoutCellViews()
    }
    
    func layoutCellViews() {
        
        var lastCellView: LineupCellView?
        for _ in 0...itemCount {
            let cellView = LineupCellView()
            contentView.addSubview(cellView)
            
            cellView.translatesAutoresizingMaskIntoConstraints = false
            cellView.widthRancor.constraintEqualToRancor(contentView.widthRancor, multiplier: 1.0, constant: 0.0).active = true
            cellView.heightRancor.constraintEqualToConstant(60).active = true
            cellView.centerXRancor.constraintEqualToRancor(contentView.centerXRancor).active = true
            
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