//
//  LineupCell.swift
//  Draftboard
//
//  Created by Wes Pearce on 9/14/15.
//  Copyright © 2015 Rally Interactive. All rights reserved.
//

import UIKit

class LineupCellView: UIView {
    
    @IBOutlet weak var topBorderView: UIView!
    @IBOutlet weak var bottomBorderView: UIView!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var avgValueLabel: UILabel!
    
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
        let nib = UINib(nibName: "LineupCellView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        addSubview(view)

        view.translatesAutoresizingMaskIntoConstraints = false
        view.left.constraintEqualTo(self.left).active = true
        view.top.constraintEqualTo(self.top).active = true
        view.bottom.constraintEqualTo(self.bottom).active = true
        view.right.constraintEqualTo(self.right).active = true
        
        bottomBorderView.hidden = true
    }
}
